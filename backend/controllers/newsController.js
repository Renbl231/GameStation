const NewsService = require('../services/newsService');
const StorageService = require('../services/storageService')
const { ValidateNews } = require('../validators/newsValidator')
const { getPublicMinioUrl } = require('../helpers/minioUrl')


exports.createNews = async (req, res) => {
  try {
    const { title, category, short_content, content } = req.body
    const coverImage = req.files?.image?.[0] 

    if (!coverImage) {
      return res.status(400).json({ 
        error: 'Обложка обязательна',
        files: req.files 
      })
    }

    const authorId = req.user.id

    const result = await NewsService.createNews(
      title, 
      category, 
      short_content, 
      content, 
      coverImage,
      authorId
    )

    return res.json({
      success: true,
      result 
    })
  } catch (error) {
    console.log('Ошибка создания новости', error)
    return res.status(error.status || 500).json({
        success: false,
        error: error.message 
    })
  }
}

exports.getNewsPaginated = async (req, res) => {
    const { page = 1, limit = 20, sort, category } = req.query
    try {
      const result = await NewsService.getNewsByPage(page, limit, sort, category)
      return res.json(result)
    } catch (error) {
      console.log('Ошибка получения новостей', error)
      return res.status(500).json({ 
        success: false,
        error: error.message || 'Ошибка сервера'
      })
    }
}

exports.getNewsById = async (req, res) => {
    const { id } = req.params
    const incrementView = req.query.incrementView === 'true'

    try {
        const news = await NewsService.getNewsById(id, incrementView)
        return res.json(news)
    } catch (error) {
          console.log('Ошибка получения новости', error)
          return res.status(500).json({
          error: error.message || 'Ошибка сервера'
        })
    }
}


exports.getNewsSlides = async (req, res) => {
    try {
        const weekAgo = new Date()
        weekAgo.setDate(weekAgo.getDate() - 7) 
        const weekAgoStr = weekAgo.toISOString().split('T')[0]
        
        const news = await NewsService.getNewsSlides(weekAgoStr)
        return res.json({
            success: true,
            news
        })
    } catch(error) {
        console.log('Ошибка загрузки слайдера', error)
        return res.status(500).json({
            success: false,
            error: error.message || 'Ошибка сервера'
        })
    }
}

exports.deleteNews = async (req, res) => {
    const { id } = req.params
    if(!id || isNaN(id)) {
        return res.status(400).json({
            success: false,
            error: 'Неверный ID новости'
        })
    }
    try {
      await NewsService.deleteNews(id)
      return res.status(204).send()
    } catch(error) {
      console.log('Ошибка удаления новости', error)
      return res.status(error.status || 500).json({
        success: false,
        error: error.message || 'Ошибка сервера'
      })
    }
}

exports.updateNews = async (req, res) => {
    const { id } = req.params
    const { title, category, short_content, image, content } = req.body
    if(!id || isNaN(id)) {
        return res.status(400).json({
            success: false,
            error: 'Неверный ID новости'
        })
    }
    if(!title?.trim() || !category?.trim() || !short_content?.trim() || !image?.trim() || !content?.trim()) {
        return res.status(400).json({
            success: false,
            error: 'Все поля обязательны'
        })
    }
    
    try {
      await NewsService.updateNews(title, short_content, category, image, content, id)
      return res.json({
        success: true
      })
    } catch(error) {
      return res.status(error.status || 500).json({
        success: false,
        error: error.message || 'Ошибка сервера'
      })
    }
}


exports.updateNews = async (req, res) => {
  const { id } = req.params
  const { title, category, short_content, content } = req.body
  const newCoverImage = req.files?.image?.[0]
  const authorId = req.user.id
  
  if (!id || isNaN(id)) {
    return res.status(400).json({
      success: false,
      error: 'Неверный ID новости'
    })
  }

  try {
     const result = await NewsService.updateNews(
      title.trim(),
      short_content.trim(),
      category.trim(),
      null,
      content.trim(),
      parseInt(id),
      newCoverImage,
      authorId
    )
    return res.json({
      success: true,
    })
  } catch (error) {
    console.log('Ошибка редактирования новости', error)
    return res.status(error.status || 500).json({
      success: false,
      error: error.message || 'Ошибка сервера'
    })
  }
}

exports.changeSliderMode = async(req, res) => {
    const { sliderMode } = req.body
    if(sliderMode.trim() !== "main" && sliderMode.trim() !== "popular") {
        return res.status(400).json({
            success: false,
            message: 'Ошибка запроса'
        })
    }
    try {
        await NewsService.changeSliderMode(sliderMode)
        return res.json({
            success: true,
            message: 'Слайдер успешно изменён'
        })
    } catch(error) {
        console.log('Ошибка редакатирования слайдера', error)
        return res.status(500).json({
            success: false,
            error: error.message || 'Ошибка сервера'
        })
    }
}
