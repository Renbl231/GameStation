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

    static async likeNews(user_id, news_id) {
      const [existing] = await db.execute(
        'SELECT * FROM NewsLikes WHERE user_id = ? AND news_id = ?', [user_id, news_id]
      )

      if(existing.length > 0) {
        await db.execute(
          'DELETE FROM NewsLikes WHERE user_id = ? AND news_id = ?', [user_id, news_id]
        )
        await db.execute(
          'UPDATE News SET likes_count = likes_count - 1 WHERE idNew = ?', [news_id]
        )
        return { success: 'already' };
      } else {
        await db.execute(
          'INSERT INTO NewsLikes (user_id, news_id) VALUES(?,?)', [user_id, news_id]
        )
        await db.execute(
          'UPDATE News SET likes_count = likes_count + 1 WHERE idNew = ?', [news_id]
        )
        return { success: 'true' };
      }
    }

    static async getNewsByPage(page = 1, limit = 20, sort = null, category = null) {
      
      const safePage = Math.max(1, parseInt(page) || 1);
      const safeLimit = Math.max(1, Math.min(20, parseInt(limit)));
      const offset = (safePage - 1) * safeLimit;
      
      let orderBy = 'created_at DESC' // сортировка
      if(sort === 'likes') {
        orderBy = 'likes_count DESC'
      }

      let whereClause = '1=1'
      let params = []

      if (category && category !== 'all') {
        whereClause += ' AND category = ?';
        params.push(category); 
      }

      const [[{ total }]] = await db.execute(
        `SELECT COUNT(*) as total FROM News WHERE ${whereClause}`, 
        params
      );
      const totalPages = Math.ceil(total / safeLimit);
      
      const [news] = await db.query(`
        SELECT idNew, title, category, image, likes_count, comments_count, created_at 
        FROM News 
        WHERE ${whereClause}
        ORDER BY ${orderBy}
        LIMIT ${safeLimit} OFFSET ${offset}
      `, params);

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
        totalPages,
        currentPage: safePage,
        perPage: safeLimit
      };
    }

    static async createComment(content, user_id, news_id) {
        const [record] = await db.execute(
          'INSERT INTO Comments (content, user_id, entity_type, entity_id) VALUES(?,?,?,?)',[content, user_id, 'news', news_id]
        )

        if(record.affectedRow) {
          throw new Error('Ошибка базы данных')
        }

        return {
          success: true
        }
    }

    static async getComments(news_id) {
        const [comments] = await db.execute(
          `SELECT c.*, u.nickname, u.avatar_url FROM Comments c 
           LEFT JOIN Users u ON c.user_id = u.idUser
           WHERE c.entity_type = ? AND c .entity_id = ?
           ORDER BY c.created_at ASC`, ['news', news_id]
        )

        if(comments.length === 0) {
          return null
        }

        return comments

    }


}

module.exports = NewsService
