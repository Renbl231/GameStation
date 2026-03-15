const CommunityService = require('../services/communityService')

exports.getDiscussions = async (req, res) => {
    try {
        const { page = 1, limit = 20, sort, section_id } = req.query
        console.log('🔍 Backend query:', req.query)  // ← ЧТО ПРИШЛО???
        const result = await CommunityService.getDiscussionsByPage(page, limit, sort, section_id)  // 🔥 getDiscussionsByPage!
        return res.json({
            success: true,
            result
        })
    } catch (error) {
        console.error(error)
        return res.status(500).json({ 
            success: false, 
            error: error.message || 'Ошибка сервера'
        })
    }
}

exports.createTheme = async (req, res) => {
    const { title, description, section_id} = req.body
    const user_id = req.user.id
    if(!title?.trim() || !description?.trim() || !section_id || isNaN(section_id)) {
        return res.status(400).json({ 
            success: false, 
            error: 'Заполните все поля корректно' 
        })
    }
    try {
        await CommunityService.createTheme(title, description, section_id, user_id)
        return res.json({
            success: true
        })
    } catch(error) {
        console.log(error)
        return res.status(500).json({
            success: false,
            error: error.message || 'Ошибка сервера'
        })
    }
}