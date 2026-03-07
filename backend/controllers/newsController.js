const NewsService = require('../services/newsService');
const { ValidateNews } = require('../validators/newsValidator')

exports.CreateNews = async (req, res) => {
    try {
        const { title, category, content, image } = req.body;
        
        const authorId = req.user.id;

        const validation = ValidateNews({title, category, content, image, authorId});
        if(!validation.isValid) {
            return res.status(400).json({
                error: validation.error
            })
        }

        await NewsService.createNews(title, category, content, image, authorId)

        return res.status(201).json({
            success: true
        })
        
     } catch (error) {
        return res.status(500).json({
            success: false,
            error: error.message || 'Ошибка при добавлении новости'
        })
     }
}

exports.getNewsPaginated = async (req, res) => {
    try {
        const { page = 1, limit = 20, sort, category } = req.query
        const result = await NewsService.getNewsByPage(page, limit, sort, category)
        res.json(result)
    } catch (error) {
        console.error('News API error:', error)
        res.status(500).json({ success: false, error: 'Ошибка сервера' })
    }
}


exports.getNewsById = async (req, res) => {
  try {
    const { id } = req.params
    const news = await NewsService.getNewsById(id)

    if(!news) {
      return res.status(404).json({
        error: 'Ошибка: новость не найдена'
      })
    }

    return res.json(news)

  } catch (error) {
    return res.status(500).json({
      error: 'Ошибка сервера'
    })
  }
}


