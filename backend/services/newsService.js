const db = require('../config/db')
const { getPublicMinioUrl } = require('../helpers/minioUrl')
const StorageService = require('../services/storageService')

class NewsService {
  static async createNews(title, category, short_content, content, coverImage, authorId) {
      if (!coverImage) {
          throw { status: 400, message: 'Обложка обязательна' }
      }
      if (!title?.trim() || !category?.trim() || !short_content?.trim()) {
          throw { status: 400, message: 'Все поля обязательны' }
      }

      // Обложка
      const uploadedCover = await StorageService.uploadFileToBucket(coverImage, 'news/covers')

      // 1. Ищем ВСЕ temp картинки в HTML content
      const tempMatches = content.matchAll(/data-minio-key="temp\/news\/content\/([^"]+)"/g)
      const tempImgKeys = Array.from(tempMatches).map(match => `temp/news/content/${match[1]}`)

      console.log('Temp изображения:', tempImgKeys)

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
          `INSERT INTO News (title, short_content, content, category, image, publisher_id, created_at)
          VALUES (?, ?, ?, ?, ?, ?, NOW())`,
          [title.trim(), short_content.trim(), finalContent, category.trim(), uploadedCover.key, authorId]
      )

      if (result.affectedRows === 0) {
          throw { status: 500, message: 'Ошибка сохранения' }
      }

      return {
          success: true,
      }
    }


  static async getNewsSlides(weekAgoDate) {
      const [settings] = await db.execute(
          'SELECT slider_news_mode FROM AppSettings WHERE id = 1'
      )

      const sliderMode = settings[0]?.slider_news_mode
      let result = []

      if(sliderMode === 'main') {
          const [rows] = await db.execute(
              `SELECT idNew, title, short_content, image, likes_count, category, created_at
              FROM news 
              WHERE DATE(created_at) >= ? 
              ORDER BY likes_count DESC
              LIMIT 4`,
              [weekAgoDate]
          ) 
          result = rows.map(row => ({
              ...row,
              image: row.image ? getPublicMinioUrl(row.image) : null
          }))
      } else if(sliderMode === 'popular') {
          const [rows] = await db.execute(
              `SELECT idNew, title, short_content, image, likes_count, category, created_at
              FROM news 
              ORDER BY likes_count DESC
              LIMIT 4`     
          )
          result = rows.map(row => ({
              ...row,
              image: row.image ? getPublicMinioUrl(row.image) : null
          }))
      }

      return {
          sliderMode,
          result 
      }
  }



  static async getNewsById(id, incrementView = false) {
      if (incrementView) {
          await db.execute('UPDATE News SET views_count = views_count + 1 WHERE idNew = ?', [id])
      }
      
      const [newsRows] = await db.execute(
          `SELECT n.*, u.nickname, u.avatar_url 
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


  static async getNewsByPage(page = 1, limit = 20, sort = null, category = null) {
    const safePage = Math.max(1, parseInt(page))
    const safeLimit = Math.min(20, Math.max(1, parseInt(limit)))
    const offset = (safePage - 1) * safeLimit
    
    const orderBy = sort === 'likes' ? 'COALESCE(likes_count, 0) DESC' : 'created_at DESC'
    
    let params = []
    let whereClause = ''
    
    if (category && category !== 'all') {
        whereClause = 'WHERE category = ?'
        params = [category]
    }
    
    const [[{total}], [news]] = await Promise.all([
      db.execute(`SELECT COUNT(*) as total FROM News ${whereClause}`, params),
      db.execute(`
          SELECT idNew, title, category, image,
            COALESCE(likes_count, 0) as likes_count,
            COALESCE(comments_count, 0) as comments_count,
            created_at 
          FROM News 
          ${whereClause}
          ORDER BY ${orderBy}
          LIMIT ? OFFSET ?
      `, [...params, safeLimit, offset])
    ])
    
    return {
      news: news.map(row => ({
          id: row.idNew,
          title: row.title,
          category: row.category,
          image: row.image ? getPublicMinioUrl(row.image) : null,
          likes: Number(row.likes_count),
          comments: Number(row.comments_count),
          created_at: row.created_at
      })),
      totalPages: Math.ceil(total / safeLimit),
      currentPage: safePage,
      perPage: safeLimit
    }
  }
  
  static async getNewsByPage(page = 1, limit = 20, sort = null, category = null) {
      const safePage = Math.max(1, parseInt(page))
      const safeLimit = Math.min(20, Math.max(1, parseInt(limit)))
      const offset = (safePage - 1) * safeLimit
      
      const orderBy = sort === 'likes' ? 'COALESCE(likes_count, 0) DESC' : 'created_at DESC'
      
      let params = []
      let whereClause = ''
      
      if (category && category !== 'all') {
          console.log('Ищем категорию:', category)
          whereClause = 'WHERE category = ?'
          params = [category]
      }

      const [[{total}]] = await db.execute(
          `SELECT COUNT(*) as total FROM News ${whereClause}`, 
          params
      )
      console.log('Найдено новостей:', total) 
            
      const [news] = await db.execute(`
          SELECT idNew, title, category, image,
              COALESCE(likes_count, 0) as likes_count,
              COALESCE(comments_count, 0) as comments_count,
              created_at 
          FROM News 
          ${whereClause}
          ORDER BY ${orderBy}
          LIMIT ${safeLimit} OFFSET ${offset}
      `, params)
      
      return {
          news: news.map(row => ({
              id: row.idNew,
              title: row.title,
              category: row.category,
              image: row.image ? getPublicMinioUrl(row.image) : null,
              likes: Number(row.likes_count),
              comments: Number(row.comments_count),
              created_at: row.created_at
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
      try {
        await StorageService.deleteFileFromBucket(coverKey)
        console.log('🗑️ Обложка удалена:', coverKey)
      } catch (error) {
        console.warn('⚠️ Обложка не удалена:', error.message)
      }
    }

    // Контент картинки (валидные ключи ТОЛЬКО!)
    if (content) {
      const imgKeys = [...content.matchAll(/data-minio-key="([^"]+)"/g)]
        .map(match => match[1]?.trim())  // ← trim() + optional chaining
        .filter(key => key && key.length > 0 && !key.startsWith('http'))  // ← только ключи!

      console.log('Найдено картинок для удаления:', imgKeys.length)

      for (const key of imgKeys) {
        try {
          await StorageService.deleteFileFromBucket(key)
          console.log('🗑️ Контент удалён:', key)
        } catch (error) {
          console.warn('⚠️ Контент не удалён:', key, error.message)
        }
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
