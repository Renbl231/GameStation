const db = require('../config/db')
const bcrypt = require('bcryptjs')

class AuthService{
    static async register(email, password) {

        try {
            const [existing] = await db.execute(
                'Select idUser from Users WHERE email = ?', [email]
            )
    
            if(existing.length > 0) {
                throw new Error('EMAIL_EXISTS')
            }
    
            const hashedPassword = await bcrypt.hash(password, 12)
            const [result] = await db.execute(
                'INSERT INTO Users (email, password) Values (?, ?)', [email, hashedPassword]
            )
    
            return { id: result.insertId }

        } catch (error) {
            if(error.message === 'EMAIL_EXISTS') {
                throw error
            } else if (error.message === 'ER_DUP_ENTRY') {
                throw new Error('EMAIL_EXISTS')
            }
            
            throw new Error('Ошибка создания пользователя')
        }
    }
}

module.exports = AuthService;