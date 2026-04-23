    
const db = require('../config/db')

class articleService {    
    static async createArticle(title, category, content, image, authorId) {
        const [result] = await db.execute(
            'INSERT INTO Articles (type_article, title, content, image, author_id) VALUES (?, ?, ?, ?, ?)', 
            [category, title, content, image, authorId]
        )
        
        return result.affectedRows > 0;
    }


    static async getArticlesByPage(page = 1, limit = 20, category = null) {
        const safePage = Math.max(1, parseInt(page))
        const safeLimit = Math.min(20, Math.max(1, parseInt(limit)))
        const offset = (safePage - 1) * safeLimit
        
        const params = category && category !== 'all' ? [category] : []
        const whereClause = params.length ? 'WHERE type_article = ?' : ''
        
        const [[{total}], [articles]] = await Promise.all([
            db.execute(`SELECT COUNT(*) as total FROM Articles ${whereClause}`, params),
            db.query(`
                SELECT idArticle, title, type_article, image,
                    COALESCE(comments_count, 0) as comments_count,
                    created_at 
                FROM Articles 
                ${whereClause}
                ORDER BY created_at DESC
                LIMIT ${safeLimit} OFFSET ${offset}
            `, params)
        ])
        return {
            articles: articles.map(row => ({
                id: row.idArticle,
                title: row.title,
                type_article: row.type_article,
                image: row.image,
                comments: Number(row.comments_count),
                created_at: row.created_at
            })),
            totalPages: Math.ceil(total / safeLimit),
            currentPage: safePage,
            perPage: safeLimit
        }
    }

    static async getArticleById(id, incrementView = false) {
        if (incrementView) {
            await db.execute(
                'UPDATE Articles SET views_count = views_count + 1 WHERE idArticle = ?', 
                [id]
            )
        }
        
        const [article] = await db.execute(
            `SELECT a.*, u.nickname, u.avatar_url FROM Articles a 
            LEFT JOIN Users u ON a.author_id = u.idUser
            WHERE a.idArticle = ?`, 
            [id]
        )
        
        return article[0]
    }

    static async getArticlesHome() {
        const [result] = await db.execute(
            `SELECT idArticle, type_article, title, image, comments_count, created_at
            FROM Articles 
            WHERE type_article = 'reviews'
            ORDER BY created_at DESC
            LIMIT 6`
        )
        
        if(result.length === 0) {
            return []
        }
        
        return result
    }


    static async deleteArticle(idArticle) {
        const [result] = await db.execute(
            `DELETE FROM Articles 
            WHERE idArticle = ?`,
            [idArticle]
        )
        
        if(result.affectedRows === 0) {
            throw {status: 404, message: 'Статья не найдена или нет прав на удаление'}
        }
        
        return true
    }

    static async updateArticle(title, category, image, content, idArticle) {
        const [result] = await db.execute(
            `UPDATE Articles 
            SET type_article = ?, title = ?, content = ?, image = ? 
            WHERE idArticle = ?`,
            [category, title, content, image, idArticle]
        )
        
        if(result.affectedRows === 0) {
            throw {status: 404, message: 'Статья не найдена или нет прав на редактирование'}
        }
        
        return true
    }

}

module.exports = articleService