const db = require('../config/db')

class NewsService {
    static async createNews(title, category, short_content, content, image, authorId) {
        const [result] = await db.execute(
            'INSERT INTO News (title, short_content, content, category, image, publisher_id) VALUES (?, ?, ?, ?, ?, ?)', 
            [title, short_content, content, category, image, authorId]
        )
        
        return result.affectedRows > 0;
    }

    static async getNewsById(id, incrementView = false) {
        if (incrementView) {
            await db.execute('UPDATE News SET views_count = views_count + 1 WHERE idNew = ?', [id])
        }
        
        const [news] = await db.execute(
            `SELECT n.*, u.nickname, u.avatar_url FROM News n 
            LEFT JOIN Users u ON n.publisher_id = u.idUser
            WHERE n.idNew = ?`, 
            [id]
        )
        
        return news[0]
    }


    static async getNewsByPage(page = 1, limit = 20, sort = null, category = null) {
        const safePage = Math.max(1, parseInt(page))
        const safeLimit = Math.min(20, Math.max(1, parseInt(limit)))
        const offset = (safePage - 1) * safeLimit
        
        const orderBy = sort === 'likes' ? 'COALESCE(likes_count, 0) DESC' : 'created_at DESC'
        
        const params = category && category !== 'all' ? [category] : []
        const whereClause = params.length ? 'WHERE category = ?' : ''
        
        const [[{total}], [news]] = await Promise.all([
            db.execute(`SELECT COUNT(*) as total FROM News ${whereClause}`, params),
            db.query(`
                SELECT idNew, title, category, image,
                    COALESCE(likes_count, 0) as likes_count,
                    COALESCE(comments_count, 0) as comments_count,
                    created_at 
                FROM News 
                ${whereClause}
                ORDER BY ${orderBy}
                LIMIT ${safeLimit} OFFSET ${offset}
            `, params)
        ])
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

    static async getNewsSlides(weekAgoDate) {
        const [result] = await db.execute(
            `SELECT idNew, title, short_content, image, likes_count, category, created_at
            FROM news 
            WHERE DATE(created_at) >= ? 
            ORDER BY likes_count DESC
            LIMIT 4`,
            [weekAgoDate]
        )
        
        if(result.length === 0) {
            return []
        }
        
        return result
    }

    static async deleteNews(idNew) {
        const [result] = await db.execute(
            `DELETE FROM News 
            WHERE idNew = ?`,
            [idNew]
        )
        
        if(result.affectedRows === 0) {
            throw {status: 404, message: 'Новость не найдена или нет прав на удаление'}
        }
        
        return true
    }

    static async updateNews(title, short_content, category, image, content, idNew) {
        const [result] = await db.execute(
            `UPDATE News 
            SET title = ?, short_content = ?, category = ?, image = ?, content = ? 
            WHERE idNew = ?`,
            [title, short_content, category, image, content, idNew]
        )
        
        if(result.affectedRows === 0) {
            throw {status: 404, message: 'Новость не найдена или нет прав на редактирование'}
        }
        
        return true
    }
}

module.exports = NewsService
