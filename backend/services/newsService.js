const db = require('../config/db')

class NewsService {
    static async createNews(title, category, content, image, authorId) {
        const [result] = await db.execute(
            'INSERT INTO News (title, content, category, image, publisher_id) VALUES (?, ?, ?, ?, ?)', 
            [title, content, category, image, authorId]
        )

        if(result.affectedRows === 0) {
            throw new Error('Новость не создана');
        } 
            
        return result.affectedRows > 0;
    }

    static async getNewsById(id) {
      try {
        const [news] = await db.execute(
          `SELECT n.*, u.nickname, u.avatar_url FROM News n 
          LEFT JOIN Users u ON n.publisher_id = u.idUser
          WHERE n.idNew = ?`, [id]
        )

        if(news.length === 0) {
          return null
        }
        
        return news[0]
      } catch(error) {
        throw error
      }
    }


static async getNewsByPage(page = 1, limit = 20, sort = null, category = null) {
    const safePage = Math.max(1, parseInt(page))
    const safeLimit = Math.min(20, Math.max(1, parseInt(limit)))
    const offset = (safePage - 1) * safeLimit
    
    let orderBy = sort === 'likes' ? 'COALESCE(likes_count, 0) DESC' : 'created_at DESC'
    
    let whereClause = ''
    if (category && category !== 'all') {
        whereClause = `WHERE category = '${category.replace(/'/g, "''")}'`
    }
    
    const [[{ total }]] = await db.execute(
        `SELECT COUNT(*) as total FROM News ${whereClause}`
    )

    const [news] = await db.query(`
        SELECT idNew, title, category, image,
               COALESCE(likes_count, 0) as likes_count,
               COALESCE(comments_count, 0) as comments_count,
               created_at 
        FROM News 
        ${whereClause}
        ORDER BY ${orderBy}
        LIMIT ${safeLimit} OFFSET ${offset}
    `)
    
    return {
        news: news.map(row => ({
            id: row.idNew,
            title: row.title,
            category: row.category,
            image: row.image,
            likes: Number(row.likes_count),
            comments: Number(row.comments_count),
            created_at: row.created_at
        })),
        totalPages: Math.ceil(total / safeLimit),
        currentPage: safePage,
        perPage: safeLimit
    }
}


}

module.exports = NewsService
