const NewsService = require('../services/newsService');
const { HandleError } = require ('../utils/errorHandler.js')
const { validateNews } = require('../validators/entityValidator.js')

const errText = "Ошибка получения новостей"


exports.getNewsPaginated = async (req, res) => {
  const { page = 1, limit = 20, sort, category_id } = req.query
  try {
    const result = await NewsService.getNewsByPage(page, limit, sort, category_id)
    return res.json(result)
  } catch (error) {
    HandleError(res, error, errText)
  }
}

exports.getNewsById = async (req, res) => {
  const { id } = req.params
  const incrementView = req.query.incrementView === 'true'
  
  try {
    const news = await NewsService.getNewsById(id, incrementView)
    return res.json(news)
  } catch (error) {
    HandleError(res, error, errText)
  }
}

exports.getNewsHome = async (req, res) => {
  const { limit } = req.query
  
  try {
    const weekAgo = new Date()
    weekAgo.setDate(weekAgo.getDate() - 7) 
    const weekAgoStr = weekAgo.toISOString().split('T')[0]
    
    const news = await NewsService.getNewsHome(weekAgoStr, limit)
    return res.json({
      news
    })
  } catch(error) {
    HandleError(res, error, 'Ошибка загрузки слайдера')
  }
}
exports.createNews = async (req, res) => {
  try {
    const authorId = req.user.id
    const { title, category_id, short_content, content } = req.body
    const coverImage = req.files?.cover?.[0] 
    
    const checkData = {
      title,
      category_id,
      short_content,
      content,
      coverImage,
    }

    const { isValid, error } = await validateNews(checkData)
    if (!isValid) {
        return res.status(400).json({
            success: false,
            error
        })
    }
    
    await NewsService.createNews(
      title.trim(), 
      Number(category_id), 
      short_content.trim(), 
      content.trim(), 
      coverImage,
      authorId
    )

    return res.status(201).json({
        success: true,
        message: 'Новость опубликована'
    })

  } catch (error) {
    HandleError(res, error, 'Ошибка создания новости', false)
  }
}

exports.updateNews = async (req, res) => {
  const { id } = req.params
  const { title, category_id, short_content, content } = req.body
  const coverImage = req.files?.cover?.[0]
  const authorId = req.user.id
  
  if (!id || isNaN(id)) {
    return res.status(400).json({
      success: false,
      error: 'Неверный ID новости'
    })
  }

  const checkData = {
      title,
      category_id,
      short_content,
      content,
  }

  const { isValid, error } = await validateNews(checkData)
  if (!isValid) {
      return res.status(400).json({
          success: false,
          error
      })
  }

  try {
    await NewsService.updateNews(
      title.trim(),
      short_content.trim(),
      Number(category_id),
      content.trim(),
      Number(id),
      coverImage,
      authorId
    )
    return res.json({
      success: true,
    })
  } catch (error) {
    HandleError(res, error, 'Ошибка редактирования новости', false)
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
      HandleError(res, error, 'Ошибка удаления новости')
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
        HandleError(res, error, 'Ошибка редакатирования слайдера', false)
    }
}
