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
        if(error.message = 'Пользователь не найден') {
            return res.status(404).json({
                success: false,
                error: 'Пользователь не найден'
            })
        }
        return res.status(500).json({
            success: false,
            error: 'Ошибка сервера'
        })
    }
}

exports.editUserData = async (req, res) => {
    const { nickname: newNickname, avatar, banner, password } = req.body
    const { nickname } = req.params
    const user_id = req.user.id
    try {
        const result = await userService.editUserData(newNickname, avatar, banner, password, user_id, nickname)

        return res.json({
            success: true,
            result
        })

    } catch(error) {
        return res.status(error.status || 500).json({
            success: false,
            error: error.message
        })
    }
}
