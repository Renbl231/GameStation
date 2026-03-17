const friendService = require('../services/friendService')

exports.searchUsers = async (req, res) => {
    const { nickname } = req.query
    const user_id = req.user.id
    try {
        const users = await friendService.searchUsers(nickname, user_id)

        return res.json({
            success: true,
            users
        })

    } catch(error) {
        console.log(error)
        return res.status(500).json({
            success: false
        })
    }
}

exports.addFriend = async (req, res) => {
    const { idUser } = req.body
    const user_id = req.user.id
    if(parseInt(idUser) === parseInt(user_id)) {
        return res.status(422).json({
            success: false,
            error: 'Невозможно добавить себя в друзья'
        })
    }
    try {
        const result = await friendService.addFriend(idUser, user_id)
        return res.json(result)
    } catch (error) {
        const status = error.status || 500
        return res.status(status).json({
            success: false,
            error: error.message || 'Ошибка сервера'
        })
    }
}

exports.removeFriend = async (req, res) => {
    const { idUser } = req.params
    const user_id = req.user.id
    if(parseInt(idUser) === parseInt(user_id)) {
        return res.status(422).json({
            success: false,
            error: 'Невозможно удалить себя из друзей'
        })
    }
    try {
        const result = await friendService.removeFriend(idUser, user_id)
        return res.json(result)
    } catch(error) {
        const status = error.status || 500
        return res.status(status).json({
            success: false,
            error: error.message || 'Ошибка сервера'
        })
    }
}

// входящ запросы

exports.getIncoming = async (req, res) => {
    const user_id = req.user.id
    try {
        const result = await friendService.getIncomingUsers(user_id)
        return res.json({
            success: true,
            result
        })
    } catch(error) {
        return res.status(500).json({
            success: false,
            error: error.message || 'Ошибка сервера'
        })
    }
}

exports.handleIncoming = async(req, res) => {
    const { action, user_id } = req.body
    const friend_id = req.user.id
    if(!user_id || !action || 
       (action !== 'approved' && action !== 'rejected')) {
        return res.status(400).json({
            success: false,
            error: 'Ошибка запроса'
        })
    }
    try {
        const result = await friendService.handleIncoming(action, user_id, friend_id)
        return res.json(result)
    } catch (error) {
        const status = error.status || 500
        return res.status(status).json({
            error: error.message || 'Ошибка сервера'
        })
    }
}

exports.getFriends = async(req, res) => {
    const user_id = req.user.id
    try {
        const friends = await friendService.getFriends(user_id)
        return res.json({
            success: true,
            friends
        })
    } catch(error) {
        return res.status(500).json({
            error: error.message || 'Ошибка сервера'
        })
    }
}