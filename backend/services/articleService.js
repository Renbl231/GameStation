    
const db = require('../config/db')
const { getPublicMinioUrl } = require('../helpers/minioUrl')
const { transliterate } = require('../utils/transliterate')
const { moveTempImages, deleteUnusedImages, deleteAllImagesFromContent } = require('../utils/storage/helpers')
const StorageService = require('../services/storageService')

const prefix_cover = 'articles/covers'
const prefix_content = 'articles/content'

class articleService {    

    static async createArticle(title, category_id, content, newCoverImage = null, score = null, authorId) {

        const [result] = await db.execute(
            `
            INSERT INTO Articles (title, content, score, category_id, author_id)
            VALUES (?, ?, ?, ?, ?)
            `, [title, content, score, category_id, authorId]
        )

        const articleId = result.insertId

        let coverKey = null

        if (newCoverImage) {
            const { key } = await StorageService.uploadFileToBucket(
                newCoverImage,
                'articles/covers',
                transliterate(title),
                articleId
            );

            coverKey = key
        }

        const updatedContent = await moveTempImages(
            content,
            'temp/articles/content/',
            'articles/content/'
        );

        await db.execute(
            `UPDATE Articles SET content = ?, cover = ? WHERE idArticle = ?`,
            [updatedContent, coverKey, articleId]
        );

        return result.affectedRows > 0
    }


    static async getArticlesByPage(page = 1, limit = 20, category_id = null) {
        const safePage = Math.max(1, parseInt(page))
        const safeLimit = Math.min(20, Math.max(1, parseInt(limit)))
        const offset = (safePage - 1) * safeLimit
        
        let params = []
        let whereClause = `WHERE s.name = 'published'`
        
        if (category_id) {
            whereClause += ' AND category_id = ?'
            params = [category_id]
        }
        
        const [[{total}]] = await db.execute(
            `SELECT COUNT(*) as total FROM Articles a
            LEFT JOIN statuses s ON a.status_id = s.idStatus
            ${whereClause}`,
            params
        )
        
        const [articles] = await db.execute(`
            SELECT
                a.idArticle,
                a.title,
                a.cover,
                a.score,
                a.comments,
                a.created_at,
                u.idUser, u.nickname as author_nickname, 
                u.role_id as author_role, u.avatar as author_avatar,
                ac.name as category
            FROM articles a
            JOIN users u ON a.author_id = u.idUser
            JOIN article_categories ac ON a.category_id = ac.idCategory
            LEFT JOIN statuses s ON a.status_id = s.idStatus
            ${whereClause}
            ORDER BY a.created_at DESC
            LIMIT ${safeLimit} OFFSET ${offset}
        `, params)
        
        return {
            articles: articles.map(row => ({
                ...row,
                cover: row.cover ? getPublicMinioUrl(row.cover) : null,
                author: {
                    name: row.author_nickname,
                    avatar: row.author_avatar ? getPublicMinioUrl(row.author_avatar) : null,
                    role: row.author_role
                }
            })),
            totalPages: Math.ceil(total / safeLimit),
            currentPage: safePage,
            perPage: safeLimit
        }
    }

    static async getArticleById(idArticle, incrementView = false) {
        if (incrementView) {
            await db.execute(
                'UPDATE articles SET views = views + 1 WHERE idArticle = ?', 
                [idArticle]
            )
        }
        
        const [row] = await db.execute(
            `SELECT 
                a.*, 
                u.nickname as author_name, u.avatar as author_avatar, u.role_id as author_role,
                ac.name as category
            FROM articles a 
            LEFT JOIN users u ON a.author_id = u.idUser
            LEFT JOIN article_categories ac ON a.category_id = ac.idCategory
            WHERE a.idArticle = ?
            `, 
            [idArticle]
        )

        const article = row[0]
        article.author_avatar = article.author_avatar ? getPublicMinioUrl(article.author_avatar) : null
        article.cover = article.cover ? getPublicMinioUrl(article.cover) : null
        
        return article
    }

    static async getArticlesHome() {
        const [result] = await db.execute(
            `SELECT 
            a.idArticle,
            a.title,
            a.cover,
            a.score, 
            a.views, 
            a.comments, 
            a.created_at,
            u.idUser, u.nickname as author_nickname, 
            u.role_id as author_role, u.avatar as author_avatar,
            ac.name as category, ac.idCategory as category_id
            FROM Articles a
            JOIN users u ON a.author_id = u.idUser
            JOIN statuses s ON a.status_id = s.idStatus
            JOIN article_categories ac ON a.category_id = ac.idCategory
            WHERE s.name = 'published'
            ORDER BY created_at DESC
            LIMIT 8`
        )
        
        if(result.length === 0) {
            return []
        }

        return result.map(article => ({
            ...article,
            author: {
                name: article.author_nickname,
                avatar: article.author_avatar ? getPublicMinioUrl(article.author_avatar) : null,
                role: article.author_role
            },
            cover: article.cover ? getPublicMinioUrl(article.cover) : null
        }))
    }

    static async deleteArticle(idArticle) {
        const [articles] = await db.execute(
            `SELECT cover, content FROM Articles WHERE idArticle = ?`,
            [idArticle]
        )

        if (articles.length === 0) {
            throw { status: 404, message: 'Статья не найдена' }
        }

        const { cover: coverKey, content } = articles[0]

        if (coverKey) {
            await StorageService.deleteFileFromBucket(coverKey)
        }

        await deleteAllImagesFromContent(content, 'articles/content/')

        const [result] = await Promise.all([
            db.execute(`DELETE FROM Articles WHERE idArticle = ?`, [idArticle]),
            db.execute(`DELETE FROM Comments WHERE entity_id = ? AND entity_type = ?`, [idArticle, 'article'])
        ])

        return result[0].affectedRows > 0
    }

    static async updateArticle(title, category_id, content, idArticle, newCoverImage = null, score = null) {
        const [currentArticle] = await db.execute(
            'SELECT cover, content FROM Articles WHERE idArticle = ?',
            [idArticle]
        )

        if (currentArticle.length === 0) {
            throw { status: 404, message: 'Статья не найдена' }
        }

        const oldContent = currentArticle[0].content
        let coverKey = currentArticle[0].cover

        if (newCoverImage) {
            if (coverKey) await StorageService.deleteFileFromBucket(coverKey)

            const slug = transliterate(title)
            const { key } = await StorageService.uploadFileToBucket(
                newCoverImage,
                prefix_cover,
                slug,
                idArticle,
            )

            coverKey = key
        }

        const updatedContent = await moveTempImages(
            content,
            'temp/articles/content/',
            'articles/content/'
        )

        let finalContent = updatedContent

        await deleteUnusedImages(oldContent, finalContent, 'articles/content/')
        
        const [result] = await db.execute(
            `UPDATE Articles 
            SET category_id = ?, title = ?, content = ?, cover = ?, score = ? 
            WHERE idArticle = ?`,
            [category_id.trim(), title.trim(), finalContent, coverKey, score, idArticle]
        )

        return { success: true, coverKey }

    }

    

}

module.exports = articleService