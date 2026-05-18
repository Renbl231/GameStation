    
const db = require('../config/db')
const { getPublicMinioUrl } = require('../helpers/minioUrl')
const StorageService = require('../services/storageService')

class articleService {    

    static async createArticle(title, category, content, newCoverImage = null, score = null, authorId) {
        let coverKey = null
        let finalContent = content.trim()

        if (newCoverImage) {
            coverKey = await StorageService.uploadFileToBucket(newCoverImage, 'articles/covers').then(u => u.key)
        }

        const tempMatches = [...finalContent.matchAll(/data-minio-key="temp\/articles\/content\/([^"]+)"/g)]
        const tempImgKeys = Array.from(tempMatches).map(m => `temp/articles/content/${m[1]}`)

        for (const tempKey of tempImgKeys) {
            const realKey = tempKey.replace('temp/articles/content/', 'articles/content/')
            const success = await StorageService.copyFile(tempKey, realKey)
            if (success) {
                await StorageService.deleteFileFromBucket(tempKey)
                finalContent = finalContent.replaceAll(tempKey, realKey)
            }
        }

        const [result] = await db.execute(
            `INSERT INTO Articles (type_article, title, content, score, image, author_id, created_at) 
            VALUES (?, ?, ?, ?, ?, ?, NOW())`, 
            [category, title, finalContent, score, coverKey, authorId]
        )

        return result.affectedRows > 0
    }


    static async getArticlesByPage(page = 1, limit = 20, category = null) {
        const safePage = Math.max(1, parseInt(page))
        const safeLimit = Math.min(20, Math.max(1, parseInt(limit)))
        const offset = (safePage - 1) * safeLimit
        
        let params = []
        let whereClause = ''
        
        if (category && category !== 'all') {
            whereClause = 'WHERE type_article = ?'
            params = [category]
        }
        
        const [[{total}]] = await db.execute(
            `SELECT COUNT(*) as total FROM Articles ${whereClause}`, 
            params
        )
        
        const [articles] = await db.execute(`
            SELECT idArticle, title, type_article, image,
                COALESCE(comments_count, 0) as comments_count,
                score,
                created_at 
            FROM Articles 
            ${whereClause}
            ORDER BY created_at DESC
            LIMIT ${safeLimit} OFFSET ${offset}
        `, params)
        
        return {
            articles: articles.map(row => ({
                id: row.idArticle,
                title: row.title,
                type_article: row.type_article,
                image: row.image ? getPublicMinioUrl(row.image) : null,
                comments: Number(row.comments_count),
                created_at: row.created_at,
                score: row.score,
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
        
        const [rows] = await db.execute(
            `SELECT a.*, u.nickname, u.avatar_url FROM Articles a 
            LEFT JOIN Users u ON a.author_id = u.idUser
            WHERE a.idArticle = ?`, 
            [id]
        )

        const article = rows[0]
        article.avatar_url = article.avatar_url ? getPublicMinioUrl(article.avatar_url) : null
        article.image = article.image ? getPublicMinioUrl(article.image) : null
        
        return article
        
    }

    static async getArticlesHome() {
        const [result] = await db.execute(
            `SELECT idArticle, type_article, title, score, image, comments_count, created_at
            FROM Articles 
            WHERE type_article = 'reviews'
            ORDER BY created_at DESC
            LIMIT 9`
        )
        
        if(result.length === 0) {
            return []
        }

        return result.map(article => ({
            ...article,
            image: article.image ? getPublicMinioUrl(article.image) : null
        }))
    }

    static async deleteArticle(idArticle) {
        const [articles] = await db.execute(
            `SELECT image, content FROM Articles WHERE idArticle = ?`,
            [idArticle]
        )

        if (articles.length === 0) {
            throw { status: 404, message: 'Статья не найдена' }
        }

        const { image: coverKey, content } = articles[0]

        if (coverKey) await StorageService.deleteFileFromBucket(coverKey)

        if (content) {
            const imgKeys = [...content.matchAll(/data-minio-key="([^"]+)"/g)]
            .map(match => match[1]?.trim())
            .filter(key => key && key.length > 0 && key.startsWith('articles/content/'))

            for (const key of imgKeys) {
                await StorageService.deleteFileFromBucket(key)
            }
        }

        const [result] = await db.execute(
            `DELETE FROM Articles WHERE idArticle = ?`,
            [idArticle]
        )

        return result.affectedRows > 0
    }

    static async updateArticle(title, type_article, content, idArticle, newCoverImage = null, score = null) {
        const [currentArticle] = await db.execute(
            'SELECT image, content FROM Articles WHERE idArticle = ?',
            [idArticle]
        )

        if (currentArticle.length === 0) {
            throw { status: 404, message: 'Статья не найдена' }
        }

        const oldContent = currentArticle[0].content
        let coverKey = currentArticle[0].image

        if (newCoverImage) {
            if (coverKey) await StorageService.deleteFileFromBucket(coverKey)
            const uploadedCover = await StorageService.uploadFileToBucket(newCoverImage, 'articles/covers')
            coverKey = uploadedCover.key
        }

        let finalContent = content.trim()
        const tempMatches = [...finalContent.matchAll(/data-minio-key="temp\/articles\/content\/([^"]+)"/g)]
        const tempImgKeys = Array.from(tempMatches).map(m => `temp/articles/content/${m[1]}`)

        for (const tempKey of tempImgKeys) {
            const realKey = tempKey.replace('temp/articles/content/', 'articles/content/')
            const success = await StorageService.copyFile(tempKey, realKey)
            if (success) {
                await StorageService.deleteFileFromBucket(tempKey)
                finalContent = finalContent.replaceAll(tempKey, realKey)
            }
        }

        // УДАЛЕНИЕ МУСОРА
        const oldImgKeys = [...oldContent.matchAll(/data-minio-key="([^"]+)"/g)].map(m => m[1]).filter(k => k.startsWith('articles/content/'))
        const newImgKeys = [...finalContent.matchAll(/data-minio-key="([^"]+)"/g)].map(m => m[1]).filter(k => k.startsWith('articles/content/'))
        const deletedImgKeys = oldImgKeys.filter(oldKey => !newImgKeys.includes(oldKey))
        
        for (const deletedKey of deletedImgKeys) {
            await StorageService.deleteFileFromBucket(deletedKey)
        }

        const [result] = await db.execute(
            `UPDATE Articles SET type_article = ?, title = ?, content = ?, image = ?, score = ? WHERE idArticle = ?`,
            [type_article.trim(), title.trim(), finalContent, coverKey, score, idArticle]  // ← score, idArticle!
        )

        if (result.affectedRows === 0) {
            throw { status: 404, message: 'Статья не найдена' }
        }

        return { success: true, coverKey }
    }

    

}

module.exports = articleService