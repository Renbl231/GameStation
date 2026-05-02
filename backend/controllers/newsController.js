const NewsService = require('../services/newsService');
const { ValidateNews } = require('../validators/newsValidator')

exports.CreateNews = async (req, res) => {
    try {
        const { title, category, short_content, content, image } = req.body;
        const authorId = req.user.id;

        const validation = ValidateNews({title, category, short_content, content, image, authorId});
        if(!validation.isValid) {
            return res.status(400).json({
                success: false,
                error: validation.error
            })
        }

        await NewsService.createNews(title, category, short_content, content, image, authorId)

        return res.status(201).json({
            success: true,
            message: 'Новость опубликована'
        })
        
     } catch (error) {
        return res.status(500).json({
            success: false,
            error: error.message || 'Ошибка сервера'
        })
     }
}

exports.getNewsPaginated = async (req, res) => {
    try {
        const { page = 1, limit = 20, sort, category } = req.query
        const result = await NewsService.getNewsByPage(page, limit, sort, category)
        return res.json(result)
    } catch (error) {
        return res.status(500).json({ 
          success: false,
          error: error.message || 'Ошибка сервера'
        })
    }
}

exports.getNewsById = async (req, res) => {
    try {
        const { id } = req.params
        const incrementView = req.query.incrementView === 'true'
        
        const news = await NewsService.getNewsById(id, incrementView)
        return res.json(news)
    } catch (error) {
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
        console.log(error)
        return res.status(500).json({
            success: false,
            error: error.message || 'Ошибка сервера'
        })
    }
}
