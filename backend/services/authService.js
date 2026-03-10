const db = require('../config/db')
const bcrypt = require('bcryptjs')

const VerificationService = require('./verificationService');

class AuthService {
    static async saveForVerification(email, password, code) {

        const [[existing], hashedPassword] = await Promise.all([
            db.execute('SELECT idUser FROM Users WHERE email = ?', [email]),
            bcrypt.hash(password, 10)
        ]);

        if(existing.length > 0) {
            throw new Error('EMAIL_EXISTS');
        }

        await VerificationService.saveVerificationData(email, hashedPassword, code);

        return { success: true };
    }

    static async completeRegistration(email, hashedPassword = null) {
        const data = await VerificationService.getVerificationData(email);
                
        if (!data) {
            throw new Error('VERIFICATION_EXPIRED');
        }

        const [result] = await db.execute(
            'INSERT INTO Users (email, password) VALUES (?, ?)', 
            [email, data.hashedPassword]
        );

        await VerificationService.deleteVerificationData(email);
        return { id: result.insertId };
    }

    static async login(email, password) {
        const [users]  = await db.execute(
            'SELECT idUser, password, role_id FROM Users WHERE email = ?', [email]
        )

        if(users.length === 0) {
            return null
        }

        const user = users[0];

        const isValidPassword = await bcrypt.compare(password, user.password)
        
        if(!isValidPassword) {
            return null
        }

        return { 
            id: user.idUser,
            role: user.role_id
        }    
    }

    static async getUserById(userId) {
        try {        
            const [users] = await db.execute(
            'SELECT idUser, nickname, role_id FROM Users WHERE idUser = ?', [userId]
            );
            
            if(users.length === 0) {
                return null;
            }

            return {
                idUser: users[0].idUser,
                nickname: users[0].nickname,
                role_id: users[0].role_id
            };
        } catch (error) {
            console.error('AuthService ERROR:', error.message);
            throw error;
        }
    }

    // восстановление пароля и чек email

    static async checkEmailExists(email) {
        const [rows] = await db.execute('SELECT idUser FROM Users WHERE email = ?', [email]);
        return rows.length > 0;
    }

    static async updatePassword(email, password) {
        const hashedPassword = await bcrypt.hash(password, 10);
        const [result] = await db.execute('UPDATE Users SET password = ? WHERE email = ?', [hashedPassword, email]);
        return result.affectedRows > 0;
    }
        
}

module.exports = AuthService;