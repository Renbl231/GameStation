const db = require('../config/db')
const bcrypt = require('bcryptjs')

class UserService {
    static async getUserByNickname(nickname) {
        const [result] = await db.execute(
            'SELECT idUser, nickname, avatar_url, banner_url FROM Users WHERE nickname = ?', [nickname]
        )
        if(result.length === 0) {
            throw {message: 'Пользователь не найден', status: 404}
        }
        return result[0]
    }

    static async editUserData(newNickname, avatar, banner, password, user_id, nickname) {
        const [existUser] = await db.execute(
            'SELECT idUser FROM Users WHERE nickname = ?', [nickname]
        )
        if(existUser.length === 0) {
            throw {status: 404, message:'Пользователь не найден'}
        }
        if(existUser[0].idUser !== user_id) {
            throw {status: 403, message:'Ошибка доступа'}
        }

        const setFields = []
        const values = []

        if(newNickname && newNickname.length >= 5) {
            setFields.push('nickname = ?')
            values.push(newNickname)
        }
        
        if (avatar && avatar.length > 0) {
            setFields.push('avatar_url = ?')
            values.push(avatar)
        }
        
        if (banner && banner.length > 0) {
            setFields.push('banner_url = ?')
            values.push(banner)
        }

        if (password && password.length >= 6) {
            const hashPassword = await bcrypt.hash(password, 10)
            setFields.push('password = ?')
            values.push(hashPassword)
        } 

        if (setFields.length === 0) {
            throw {status: 400, message: 'Нет данных для обновления'}
        }

        values.push(user_id)

        const [result] = await db.execute(
            `UPDATE Users SET ${setFields.join(', ')} WHERE idUser = ?`,
            values
        )
        
        if (result.affectedRows === 0) {
            throw new Error('Ошибка обновлении данных')
        }
    
        const [updatedUser] = await db.execute(
            'SELECT idUser, nickname, avatar_url, banner_url FROM Users WHERE idUser = ?',
            [user_id]
        )
        
        return {
            user: updatedUser[0],
            message: 'Данные успешно отредактированы'
        }
    }
}


module.exports = UserService