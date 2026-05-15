const moderationService = require('../services/moderationService');

exports.moderateComment = async (req, res) => {
    const { id } = req.params
    const { reason } = req.body
    const moderation_id = req.user.id

    if(!Number(id)) {
        return res.status(400).json({
            success:false,
            error: 'Неверный запрос'
        })
    }
    try {
        await moderationService.deleteComment(id, moderation_id, reason)
        return res.status(204).send()
    } catch(error) {
        return res.status(error.status || 500).json({
            success: false,
            error: error.message || 'Ошибка сервера'
        })
    }
}


exports.moderateQuestion = async (req, res) => {
    const { questionId } = req.params
    const { reason } = req.body
    const moderation_id = req.user.id

    if(!Number(questionId)) {
        return res.status(400).json({
            success:false,
            error: 'Неверный запрос'
        })
    }
    try {
        await moderationService.deleteQuestion(questionId, moderation_id, reason)
        return res.status(204).send()
    } catch(error) {
        return res.status(error.status || 500).json({
            success: false,
            error: error.message || 'Ошибка сервера'
        })
    }
}

exports.moderateReview = async (req, res) => {
    const { reviewId } = req.params
    const { reason } = req.body
    const moderation_id = req.user.id

    if(!Number(reviewId)) {
        return res.status(400).json({
            success:false,
            error: 'Неверный запрос'
        })
    }
    try {
        await moderationService.deleteReview(reviewId, moderation_id, reason)
        return res.status(204).send()
    } catch(error) {
        return res.status(error.status || 500).json({
            success: false,
            error: error.message || 'Ошибка сервера'
        })
    }
}


exports.getRequests = async(req, res) => {
    try {
        const result = await moderationService.getRequests()
        return res.json({
            result
        })
    } catch(error) {
        console.log('Ошибка загрузки запросов', error)
        return res.status(error.status || 500).json({
            success: false,
            error: error.message || 'Ошибка сервера'
        })
    }
}

exports.moderateGameRequest = async(req, res) => {
    const { idRequest, notes, status } = req.body
    const moderator_id = req.user.id
    try {
        await moderationService.moderateGameRequest(idRequest, notes, status, moderator_id)
        return res.json({
            success: true,
            message: 'Запрос обработан'
        })
    } catch(error) {
        console.log('Ошибка модерации запроса', error)
        return res.status(error.status || 500).json({
            success: false,
            error: error.message || 'Ошибка сервера'
        })
    }
}

exports.moderateSiteRequest = async(req, res) => {
    const { idQuestion } = req.params
    const { notes } = req.body
    try {
        await moderationService.moderateSiteRequest(idQuestion, notes)
        return res.json({
            success: true,
            message: 'Запрос обработан'
        })
    } catch(error) {
        console.log('Ошибка модерации запроса', error)
        return res.status(error.status || 500).json({
            success: false,
            error: error.message || 'Ошибка сервера'
        })
    }
}

exports.moderateUserMedia = async(req, res) => {
    const { userId } = req.params
    const { type } = req.body

    if(type !== 'banner' && type !== 'avatar') {
        return res.status(404).json({
            success: false,
            error: 'Неверный запрос'
        })
    }

    try {
        await moderationService.moderateUserMedia(userId, type)
        return res.status(204).send()
    } catch(error) {
        console.log('Ошибка модерации профиля', error)
        return res.status(error.status || 500).json({
            success: false,
            error: error.message || 'Ошибка сервера'
        })
    }
}


exports.moderateUnblock = async(req, res) => {
    const { userId } = req.params
    const { category } = req.body

    if(category !== 'profile' && category !== 'comment' && category !== 'question' && category !== 'review') {
        return res.status(404).json({
            success: false,
            error: 'Неверный запрос'
        })
    }

    try {
        await moderationService.moderateUnblockUser(userId, category)
        return res.status(204).send()
    } catch(error) {
        console.log('Ошибка разблокировки пользователя', error)
        return res.status(error.status || 500).json({
            success: false,
            error: error.message || 'Ошибка сервера'
        })
    }
}

exports.moderateRole = async(req, res) => {
    const { userId } = req.params
    const { role } = req.body

    if(role > 4 || role < 1) {
        return res.status(404).json({
            success: false,
            error: 'Неверный запрос'
        })
    }

    try {
        const result = await moderationService.moderateRole(userId, role)
        return res.json({
            success: true,
            result
        })
    } catch(error) {
        console.log('Ошибка изменения роли', error)
        return res.status(error.status || 500).json({
            success: false,
            error: error.message || 'Ошибка сервера'
        })
    }
}