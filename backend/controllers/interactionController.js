const InteractionService = require('../services/interactionService')

exports.getComments = async (req, res) => {
    try {
        const { entityType, entityId } = req.params
        console.log(entityType, entityId)
        const comments = await InteractionService.getComments(entityType, entityId)

        if(!comments) {
            return res.status(400).json({
                error: 'Ошибка загрузки комментариев'
            })
        }
        return res.json(comments)
    } catch(error) {
        console.log(error)
        return res.status(500).json({
            error: 'Ошибка сервера'
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
        const result = await InteractionService.createComment(
            content.trim(), user_id, entity_type, entity_id, parent_comment_id || null
        )
    
        if(!result) {
            return res.status(400).json({
                success: false,
                error: 'Некорректные данные'
            })
        }
    
        return res.json({
            success: true
        })
    } catch(error) {
        return res.status(500).json({
            success: false,
            error: 'Ошибка сервера'
        })
    }
}

// Взаимодействие с лайком

exports.like = async (req, res) => {
    try {
        const { entity_type, entity_id  } = req.body
        const user_id = req.user.id
        
        const result = await InteractionService.like(user_id, entity_id, entity_type)

        return res.json(result)

    } catch(error) {
        console.log(error)
        return res.status(500).json({
            error: 'Ошибка сервера'
        })
    }
}


exports.deleteComment = async (req,res) => {
    const { commentId } = req.params
    const user_id = req.user.id
    try {
        const result = await InteractionService.deleteComment(commentId, user_id)
        
        return res.json({
            success: true
        })

    } catch(error) {
        console.log(error)
        return res.status(500).json({
            success: false,
            error: 'Ошибка сервера'
        })
    }
}

