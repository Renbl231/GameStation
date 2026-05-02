const CommunityService = require('../services/communityService')

exports.getDiscussions = async (req, res) => {
    try {
        const { page = 1, limit = 20, sort, section_id } = req.query
        const result = await CommunityService.getDiscussionsByPage(page, limit, sort, section_id) 
        return res.json({
            success: true,
            result
        })
    } catch (error) {
        return res.status(500).json({ 
            success: false, 
            error: error.message || 'Ошибка сервера'
        })
    }
}

exports.createTheme = async (req, res) => {
    const { title, description, section_id} = req.body
    const user_id = req.user.id
    if(!title?.trim() || !description?.trim() || Number(!section_id) || isNaN(section_id)) {
        return res.status(400).json({ 
            success: false, 
            error: 'Заполните все поля' 
        })
    }
    try {
        await CommunityService.createTheme(title, description, section_id, user_id)
        return res.json({
            success: true,
            message: 'Тема опубликована'
        })
    } catch(error) {
        return res.status(error.status || 500).json({
            success: false,
            error: error.message || 'Ошибка сервера'
        })
    }
}

exports.getTheme = async (req, res) => {
    try {
        const { id } = req.params
        const incrementView = req.query.incrementView === 'true'
        
        const themeData = await CommunityService.getTheme(id, incrementView)
        return res.json(themeData)
    } catch (error) {
        return res.status(500).json({
            error: error.message || 'Ошибка сервера'
        })
    }
}


exports.deleteTheme = async (req, res) => {
    const { id } = req.params
    const author_id = req.user.id
    if(!id || isNaN(id)) {
        return res.status(400).json({
            success: false,
            error: 'Неверный ID темы'
        })
    }
    try {
      await CommunityService.deleteTheme(id, author_id)
      return res.status(204).send()
    } catch(error) {
      return res.status(error.status || 500).json({
        success: false,
        error: error.message || 'Ошибка сервера'
      })
    }
}

exports.updateTheme = async (req, res) => {
    const { id } = req.params
    const { title, section_id, description } = req.body
    const user_id = req.user.id
    if(!id || isNaN(id)) {
        return res.status(400).json({
            success: false,
            error: 'Неверный ID новости'
        })
    }
    if(!title?.trim() || !section_id || isNaN(section_id) || !description?.trim()) {
        return res.status(400).json({
            success: false,
            error: 'Все поля обязательны'
        })
    }
    try {
      await CommunityService.updateTheme(id, title, section_id, description, user_id)
      return res.json({
        success: true,
        message: 'Тема отредактирована'
      })
    } catch(error) {
      return res.status(error.status || 500).json({
        success: false,
        error: error.message || 'Ошибка сервера'
      })
    }
}
