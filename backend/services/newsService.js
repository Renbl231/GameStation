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

    // static async getAllNews() {
    //     const [news] = await db.execute(
    //         `SELECT idNew, title, category, image, likes_count, comments_count, created_at FROM News
    //         ORDER BY created_at DESC
    //         LIMIT 2
    //         `
    //     )

    //     return news.map(row => ({
    //         id: row.idNew,
    //         title: row.title,
    //         category: row.category,
    //         image: row.image,
    //         likes: Number(row.likes_count),
    //         comments: Number(row.comments_count),
    //         created_at: row.created_at
    //     }))
    // }

    static async getNewsByPage(page = 1, limit = 2) {
      const safePage = Math.max(1, parseInt(page) || 1);
      const safeLimit = Math.max(1, Math.min(20, parseInt(limit) || 2));
      const offset = (safePage - 1) * safeLimit;
      
      const [[{ total }]] = await db.execute('SELECT COUNT(*) as total FROM News');
      const totalPages = Math.ceil(total / safeLimit);
      
      const [news] = await db.query(
        `SELECT idNew, title, category, image, likes_count, comments_count, created_at 
        FROM News 
        ORDER BY created_at DESC 
        LIMIT ${safeLimit} OFFSET ${offset}`,
      );

      return {
        news: news.map(row => ({
          idNew: row.idNew,
          title: row.title,
          category: row.category,
          image: row.image,
          likes: Number(row.likes_count),
          comments: Number(row.comments_count),
          created_at: row.created_at
        })),
        totalPages,
        currentPage: safePage,
        perPage: safeLimit
      };
    }




}

module.exports = NewsService
