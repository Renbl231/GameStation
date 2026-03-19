const InteractionService = require('../services/interactionService')

exports.getComments = async (req, res) => {
    try {
        const { entityType, entityId } = req.params
        if(!entityType || !entityId || isNaN(Number(entityId))) {
            return res.status(400).json({ 
                success: false,
                error: 'Неверные параметры' 
            })
        }

        const comments = await InteractionService.getComments(entityType, entityId)
        return res.json(comments)
    } catch(error) {
        return res.status(error.status || 500).json({
            success:false,
            error: error.message || 'Ошибка сервера'
        })
    }
}

exports.createComment = async (req, res) => {
    const { content, entity_type, entity_id, parent_comment_id } = req.body
    const user_id = req.user.id

    if(!content || content.trim().length === 0) {
        return res.status(400).json({
            success: false,
            error: 'Комментарий не может быть пустым'
        })
    } else if(content.length >= 1000) {
        return res.status(400).json({
            success: false,
            error: 'Комментарий слишком длинный'
        })
    } else if(content.length < 3 ) {
        return res.status(400).json({
            success: false,
            error: 'Комментарий должен содержать минимум 3 символа'
        })
    }

    try {
        await InteractionService.createComment(
            content.trim(), user_id, entity_type, entity_id, parent_comment_id || null
        )
        return res.status(201).json({
            success: true,
            message: 'Комментарий опубликован'
        })
    } catch(error) {
        return res.status(500).json({
            success: false,
            error: error.message || 'Ошибка сервера'
        })
    }
}

// Взаимодействие с лайком

exports.like = async (req, res) => {
    try {
        const { entity_type, entity_id  } = req.body
        const user_id = req.user.id

        if(!entity_type || !entity_id || isNaN(Number(entity_id))) {
            return res.status(400).json({ 
                success: false,
                error: 'Неверные параметры' 
            })
        }
        
        const result = await InteractionService.like(user_id, entity_id, entity_type)

        return res.json(result)

    } catch(error) {
        console.log(error)
        return res.status(500).json({
            success: false,
            error: error.message || 'Ошибка сервера'
        })
    }
}

exports.deleteComment = async (req,res) => {
    const { commentId } = req.params
    if(!Number(commentId)) {
        return res.status(400).json({
            success:false,
            error: 'Неверный запрос'
        })
    }
    const user_id = req.user.id
    try {
        await InteractionService.deleteComment(commentId, user_id)
        return res.status(204).send()
    } catch(error) {
        return res.status(error.status || 500).json({
            success: false,
            error: error.message || 'Ошибка сервера'
        })
    }
}

exports.editComment = async (req,res) => {
    const { commentId } = req.params
    const { content } = req.body
    if(!content || content.trim().length === 0) {
        return res.status(400).json({
            success: false,
            error: 'Комментарий не может быть пустым'
        })
    } else if(content.length >= 1000) {
        return res.status(400).json({
            success: false,
            error: 'Комментарий слишком длинный'
        })
    } else if(content.length < 3 ) {
        return res.status(400).json({
            success: false,
            error: 'Комментарий должен содержать минимум 3 символа'
        })
    }
    const user_id = req.user.id
    try {
        await InteractionService.editComment(commentId, user_id, content)
        return res.json({
            success: true,
            message: 'Комментарий изменён'
        })
    } catch(error) {
        return res.status(error.status || 500).json({
            success: false,
            error: error.message || 'Ошибка сервера'
        })
    }
}