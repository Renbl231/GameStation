const userService = require('../services/userService');

exports.getUserByNickname = async (req, res) => {
    try {
        const { nickname } = req.params
        const userData = await userService.getUserByNickname(nickname)
        
        return res.json({
            success: true,
            userData
        })
        
    } catch(error) {
        return res.status(error.stuatus || 500).json({
            success: false,
            error: error.message || 'Ошибка сервера'
        })
    }
}

exports.editUserData = async(req, res) => {
    const { nickname, password } = req.body
    const user_id = req.user.id

    try {
        const result = await userService.editUserData(nickname, password, user_id)
        return res.json({
            success: true,
            message: 'Изменения сохранены',
            result
        })
    } catch (error) {
        console.log('Ошибка редактирования профиля', error)
        return res.status(error.status || 500).json({
            success: false,
            error: error.message
        })
    }
}

exports.editUserImage = async (req, res) => {
    const imageFile = req.file
    const user_id = req.user.id
    const imageType = req.path.includes('avatar') ? 'avatar' : 'banner'
    
    if (!imageFile) {
      return res.status(400).json({
        success: false,
        error: 'Файл не передан'
      })
    }

    try {
        const result = await userService.editUserImage(user_id, imageFile, imageType)
        return res.json({
            success: true,
            message: 'Изменения сохранены',
            result
        })
    } catch (error) {
        return res.status(error.status || 500).json({
            success: false,
            error: error.message || 'Ошибка сервера'
        })
    }
}












exports.getUserGames = async (req, res) => {
    const { page = 1, limit = 20 } = req.query
    const { userId } = req.params
    try {
        const result = await userService.getUserGames(userId, page, limit)
        return res.json({
            result
        })
    } catch (error) {
        console.log('Ошибка получения коллекции игр', error)
        return res.status(error.status || 500).json({
            success: false,
            error: error.message || 'Ошибка сервера'
        })
    }
}

exports.getUserReviews = async (req, res) => {
    const { page = 1, limit = 20 } = req.query
    const { userId } = req.params
    try {
        const result = await userService.getUserReviews(userId, page, limit)
        return res.json({
            result
        })
    } catch (error) {
        console.log('Ошибка получения рецензий', error)
        return res.status(error.status || 500).json({
            success: false,
            error: error.message || 'Ошибка сервера'
        })
    }
}

exports.banUser = async(req, res) => {
    const { type, user_id, banDays, reason, entity_id } = req.body
    const moderator_id = req.user.id
    try {
        const result = await userService.banUser(type, user_id, banDays, reason, moderator_id, entity_id)
        return res.json({
            success: true,
            message: result.message
        })
    } catch (error) {
        console.log('Ошибка блокировки пользователя', error)
        return res.status(error.status || 500).json({
            success: false,
            error: error.message || 'Ошибка сервера'
        })
    }
}



exports.getUserComments = async(req, res) => {
    const { page = 1, limit = 20, status } = req.query
    const { userId } = req.params
    try {   
        const result = await userService.getUserComments(userId, page, limit, status)
        return res.json({
            result
        })
    } catch(error) {
        console.log('Ошибка загрузки комментариев', error)
        return res.status(error.status || 500).json({
            success: false,
            error: error.message || 'Ошибка сервера'
        })
    }
}








exports.getUserRequests = async(req, res) => {
    const user_id = req.user.id
    console.log(user_id)
    try {
        const result = await userService.getUserRequests(user_id)
        return res.json({
            result
        })  
    } catch (error) {
        console.log('Ошибка получения запросов', error)
        return res.status(error.status || 500).json({
            success: false,
            error: error.message || 'Ошибка сервера'
        })
    }
}