const db = require('../config/db')
const { getPublicMinioUrl } = require('../helpers/minioUrl')
const { transliterate } = require('../utils/transliterate')
const { moveTempImages, deleteUnusedImages, deleteAllImagesFromContent } = require('../utils/storage/helpers')
const StorageService = require('../services/storageService')

const prefix_cover = 'news/covers'
const prefix_content = 'news/content/'

class NewsService {
    
     static async getNewsHome(weekAgoDate, limit = 3) {
        const [settings] = await db.execute(
            `SELECT setting_value as value FROM app_settings WHERE setting_key = 'slider_news'`
        )

        const sliderMode = settings[0]?.value
        let result = []

        if(sliderMode === 'main') {
            const [rows] = await db.execute(
                `SELECT
                n.idNew,
                n.title, 
                n.short_content, 
                n.cover, 
                nc.name as category
                FROM news n
                LEFT JOIN news_categories nc ON n.category_id = nc.idCategory
                WHERE DATE(created_at) >= ? AND n.status_id = 1 
                LIMIT ?
                `,
                [weekAgoDate, limit]
            ) 
            
            result = rows.map(row => ({
                ...row,
                cover: row.cover ? getPublicMinioUrl(row.cover) : null
            }))
        }   else if(sliderMode === 'popular') {
                const [rows] = await db.execute(
                    `SELECT
                    n.idNew,
                    n.title, 
                    n.short_content, 
                    n.cover, 
                    nc.name as category
                    FROM news n
                    LEFT JOIN news_categories nc ON n.category_id = nc.idCategory
                    ORDER BY likes DESC
                    LIMIT ?`,
                    [limit]
                )

                result = rows.map(row => ({
                    ...row,
                    cover: row.cover ? getPublicMinioUrl(row.cover) : null
                }))
        }

        return {
            sliderMode,
            result 
        }
    }

    static async getNewsById(id, incrementView = false) {
        if (incrementView) {
            await db.execute('UPDATE News SET views = views + 1 WHERE idNew = ?', [id])
        }
        
        const [newsRows] = await db.execute(
            `SELECT 
            n.*, 
            nc.name as category,
            u.nickname as author_name, u.avatar as author_avatar, u.role_id as author_role 
            FROM News n 
            LEFT JOIN Users u ON n.author_id = u.idUser
            LEFT JOIN news_categories nc ON n.category_id = nc.idCategory
            WHERE n.idNew = ?`, 
            [id]
        )
        
        if (!newsRows[0]) return null
        
        const news = {
            ...newsRows[0],
            author_avatar: newsRows[0].author_avatar ? getPublicMinioUrl(newsRows[0].author_avatar) : null,
            cover: newsRows[0].cover ? getPublicMinioUrl(newsRows[0].cover) : null
        }
        
        return news
    }

    static async getNewsByPage(page = 1, limit = 21, sort = null, category = null) {
        const safePage = Math.max(1, parseInt(page))
        const safeLimit = Math.min(21, Math.max(1, parseInt(limit)))
        const offset = (safePage - 1) * safeLimit
            
        const orderBy = sort === 'popular' ? 'likes DESC' : 'created_at DESC'
      
        let params = []
        let whereClause = `WHERE s.name = 'published'`

        if (category && category !== 'all') {
            whereClause += ' AND n.category_id = ?'
            params = [category]
        }

        const [[{total}]] = await db.execute(
            `SELECT COUNT(*) as total FROM News n
            LEFT JOIN statuses s ON n.status_id = s.idStatus
            ${whereClause}`,
            params
        )
            
        const [news] = await db.execute(`
            SELECT 
                n.idNew,
                n.title,
                n.cover,
                n.likes,
                n.comments,
                n.created_at,
                nc.name as category,
                s.name as status
            FROM News n
            LEFT JOIN news_categories nc ON n.category_id = nc.idCategory
            LEFT JOIN statuses s ON n.status_id = s.idStatus
            ${whereClause}
            ORDER BY ${orderBy}
            LIMIT ${safeLimit} OFFSET ${offset}
        `, params)
      
        return {
            news: news.map(row => ({
                ...row,
                cover: row.cover ? getPublicMinioUrl(row.cover) : null,
            })),
            totalPages: Math.ceil(total / safeLimit),
            currentPage: safePage,
            perPage: safeLimit
        }
    }


    static async createNews(title, category, short_content, content, coverImage, authorId) {
        if (!coverImage) {
            throw { status: 400, message: 'Обложка обязательна' }
        }
        if (!title?.trim() || !short_content?.trim()) {
            throw { status: 400, message: 'Все поля обязательны' }
        }

        const [result] = await db.execute(
            `INSERT INTO News (title, short_content, content, category_id, author_id)
            VALUES (?, ?, ?, ?, ?)`,
            [title.trim(), short_content.trim(), content, category, authorId]
        )

        const newsId = result.insertId

        let coverKey = null
        if (coverImage) {
            const { key } = await StorageService.uploadFileToBucket(
                coverImage,
                prefix_cover,
                transliterate(title),
                newsId,
                'cover'
            )
            coverKey = key
        }

        const updatedContent = await moveTempImages(
            content,
            'temp/news/content/',
            prefix_content
        )

        await db.execute(
            `UPDATE News SET content = ?, cover = ? WHERE idNew = ?`,
            [updatedContent, coverKey, newsId]
        )

        return {
            success: true,
        }
    }

    static async deleteNews(idNew) {
        const [news] = await db.execute(
            `SELECT cover, content FROM News WHERE idNew = ?`,
            [idNew]
        )

        if (news.length === 0) {
            throw { status: 404, message: 'Новость не найдена' }
        }

        const { cover: coverKey, content } = news[0]

        if (coverKey) {
            await StorageService.deleteFileFromBucket(coverKey)
        }

        await deleteAllImagesFromContent(content, 'news/content/')

        const [result] = await Promise.all([
            db.execute(`DELETE FROM News WHERE idNew = ?`, [idNew]),
            db.execute(`DELETE FROM Comments WHERE entity_id = ? AND entity_type = ?`, [idNew, 'news'])
        ])

        return result[0].affectedRows > 0
    }

    static async updateNews(title, short_content, category, content, idNew, newCoverImage = null) {
        const [currentNews] = await db.execute(
            'SELECT cover, content FROM News WHERE idNew = ?',
            [idNew]
        )

        if (currentNews.length === 0) {
            throw { status: 404, message: 'Новость не найдена' }
        }

        const oldContent = currentNews[0].content
        let coverKey = currentNews[0].cover

        if (newCoverImage) {
            if (coverKey) {
                await StorageService.deleteFileFromBucket(coverKey)
            }
            const slug = transliterate(title)
            const { key } = await StorageService.uploadFileToBucket(
                newCoverImage,
                prefix_cover,
                slug,
                idNew,
                'cover'
            )
            coverKey = key
        }

        const updatedContent = await moveTempImages(
            content,
            'temp/news/content/',
            prefix_content
        )

        await deleteUnusedImages(oldContent, updatedContent, prefix_content)

        const [result] = await db.execute(
            `UPDATE News SET title = ?, short_content = ?, category_id = ?, cover = ?, content = ? WHERE idNew = ?`,
            [title.trim(), short_content.trim(), category, coverKey, updatedContent, idNew]
        )

        if (result.affectedRows === 0) {
            throw { status: 404, message: 'Новость не найдена' }
        }

        return { success: true, coverKey }
    }

    static async changeSliderMode(mode) {
        const [result] = await db.execute(
            `UPDATE app_settings SET setting_value = ? WHERE setting_key = 'slider_news'`,
            [mode]
        )

        if(result.affectedRows === 0) {
            throw { status: 404, message: 'Настройка не найдена' }
        }

            return true
        }
    }

module.exports = NewsService
