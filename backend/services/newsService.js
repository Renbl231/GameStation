const db = require('../config/db')
const { getPublicMinioUrl } = require('../helpers/minioUrl')
const StorageService = require('../services/storageService')

class NewsService {
  static async createNews(title, category, short_content, content, coverImage, authorId) {
      if (!coverImage) {
          throw { status: 400, message: 'Обложка обязательна' }
      }
      if (!title?.trim() || !short_content?.trim()) {
          throw { status: 400, message: 'Все поля обязательны' }
      }

      // Обложка
      const uploadedCover = await StorageService.uploadFileToBucket(coverImage, 'news/covers')

      // 1. Ищем ВСЕ temp картинки в HTML content
      const tempMatches = content.matchAll(/data-minio-key="temp\/news\/content\/([^"]+)"/g)
      const tempImgKeys = Array.from(tempMatches).map(match => `temp/news/content/${match[1]}`)

      // 2. Перемещаем каждую temp → реальную папку
      const finalImgKeys = []
      for (const tempKey of tempImgKeys) {
          const realKey = tempKey.replace('temp/news/content/', 'news/content/')
          
          await StorageService.copyFile(tempKey, realKey)
          await StorageService.deleteFileFromBucket(tempKey)
          
          finalImgKeys.push(realKey)
          console.log(`Перемещено: ${tempKey} → ${realKey}`)
      }

      // 3. Заменяем ВСЕ temp ключи на реальные в HTML
      let finalContent = content
      for (let i = 0; i < tempImgKeys.length; i++) {
          finalContent = finalContent.replaceAll(tempImgKeys[i], finalImgKeys[i])
      }

      // 4. Сохраняем в БД
      const [result] = await db.execute(
          `INSERT INTO News (title, short_content, content, category_id, cover, author_id, created_at)
          VALUES (?, ?, ?, ?, ?, ?, NOW())`,
          [title.trim(), short_content.trim(), finalContent, category, uploadedCover.key, authorId]
      )

      if (result.affectedRows === 0) {
          throw { status: 500, message: 'Ошибка сохранения' }
      }

      return {
          success: true,
      }
    }


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
      } else if(sliderMode === 'popular') {
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
          n.*, u.nickname, u.avatar_url           
          FROM News n 
          LEFT JOIN Users u ON n.publisher_id = u.idUser
          WHERE n.idNew = ?`, 
          [id]
      )
      
      if (!newsRows[0]) return null
      
      const news = {
          ...newsRows[0],
          avatar_url: newsRows[0].avatar_url ? getPublicMinioUrl(newsRows[0].avatar_url) : null,
          image: newsRows[0].image ? getPublicMinioUrl(newsRows[0].image) : null
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

    static async deleteNews(idNew) {
    const [news] = await db.execute(
      `SELECT image, content FROM News WHERE idNew = ?`,
      [idNew]
    )

    if (news.length === 0) {
      throw { status: 404, message: 'Новость не найдена' }
    }

    const { image: coverKey, content } = news[0]

    // Обложка (проверяем)
    if (coverKey) {
        await StorageService.deleteFileFromBucket(coverKey)
    }

    // Контент картинки (валидные ключи ТОЛЬКО!)
    if (content) {
      const imgKeys = [...content.matchAll(/data-minio-key="([^"]+)"/g)]
        .map(match => match[1]?.trim())  // ← trim() + optional chaining
        .filter(key => key && key.length > 0 && !key.startsWith('http'))  // ← только ключи!

      for (const key of imgKeys) {
          await StorageService.deleteFileFromBucket(key)
      }
    }

    // БД
    const [result] = await db.execute(
      `DELETE FROM News WHERE idNew = ?`,
      [idNew]
    )

    await db.execute(
        'DELETE FROM Comments WHERE entity_id = ? AND entity_type = ?',
        [idNew, 'news']
    )

    return true
  }
    static async updateNews(title, short_content, category, imageKey, content, idNew, newCoverImage = null) {
  const [currentNews] = await db.execute(
    'SELECT image, content FROM News WHERE idNew = ?',
    [idNew]
  )

  if (currentNews.length === 0) {
    throw { status: 404, message: 'Новость не найдена' }
  }

  const oldContent = currentNews[0].content
  let coverKey = currentNews[0].image || imageKey

  // Обложка
  if (newCoverImage) {
    if (coverKey) await StorageService.deleteFileFromBucket(coverKey)
    const uploadedCover = await StorageService.uploadFileToBucket(newCoverImage, 'news/covers')
    coverKey = uploadedCover.key
  }

  // 1. Temp → real (новые картинки)
  let finalContent = content.trim()
  const tempMatches = [...finalContent.matchAll(/data-minio-key="temp\/news\/content\/([^"]+)"/g)]
  const tempImgKeys = Array.from(tempMatches).map(m => `temp/news/content/${m[1]}`)

  for (const tempKey of tempImgKeys) {
    const realKey = tempKey.replace('temp/news/content/', 'news/content/')
    const success = await StorageService.copyFile(tempKey, realKey)
    if (success) {
      await StorageService.deleteFileFromBucket(tempKey)
      finalContent = finalContent.replaceAll(tempKey, realKey)
    }
  }

  // 2. ❌ УДАЛЯЕМ СТАРЫЕ картинки (мусор!)
  const oldImgKeys = [...oldContent.matchAll(/data-minio-key="([^"]+)"/g)].map(m => m[1]).filter(k => k.startsWith('news/content/'))
  const newImgKeys = [...finalContent.matchAll(/data-minio-key="([^"]+)"/g)].map(m => m[1]).filter(k => k.startsWith('news/content/'))
  
  const deletedImgKeys = oldImgKeys.filter(oldKey => !newImgKeys.includes(oldKey))
  
  for (const deletedKey of deletedImgKeys) {
    await StorageService.deleteFileFromBucket(deletedKey)
    console.log(`🗑️ Удалён мусор: ${deletedKey}`)
  }

  // 3. БД
  const [result] = await db.execute(
    `UPDATE News SET title = ?, short_content = ?, category = ?, image = ?, content = ? WHERE idNew = ?`,
    [title.trim(), short_content.trim(), category.trim(), coverKey, finalContent, idNew]
  )

  if (result.affectedRows === 0) {
    throw { status: 404, message: 'Новость не найдена' }
  }

  return { success: true, coverKey }
}








    static async changeSliderMode(mode) {
        const [result] = await db.execute(
            `UPDATE AppSettings SET slider_news_mode = ? WHERE id = 1`, [mode]
        )

        if(result.affectedRows === 0) {
            throw { status: 404, message: 'Настройка не найдена' }
        }

        return true
    }
}

module.exports = NewsService
