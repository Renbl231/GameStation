const db = require('../config/db')
const bcrypt = require('bcryptjs')

const VerificationService = require('./verificationService');
const { getPublicMinioUrl } = require('../helpers/minioUrl')

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

        const generateRandomNickname = async () => {
            const chars = 'abcdefghijklmnopqrstuvwxyz0123456789';
            const length = 6 + Math.floor(Math.random() * 5);

            for (let attempt = 0; attempt < 3; attempt++) {
                let nickname = '';
                for (let i = 0; i < length; i++) {
                    nickname += chars[Math.floor(Math.random() * chars.length)];
                }
                
                const [existing] = await db.execute(
                    'SELECT idUser FROM Users WHERE nickname = ?', 
                    [nickname]
                );
                
                if (existing.length === 0) {
                    return nickname;
                }
            }
            
            throw new Error('Не удалось сгенерировать никнейм');
        };

        const nickname = await generateRandomNickname();

        const [result] = await db.execute(
            'INSERT INTO Users (email, password, nickname) VALUES (?, ?, ?)', 
            [email, data.hashedPassword, nickname]
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


    // Проверка авторизации
    static async getUserById(userId) {
        try {        
            const [users] = await db.execute(
                'SELECT idUser, nickname, role_id, avatar FROM Users WHERE idUser = ?', [userId]
            );
            
            if(users.length === 0) {
                return null;
            }

            let avatar = null
            
            if(users[0].avatar) {
                avatar = getPublicMinioUrl(users[0].avatar)
            }

            return {
                idUser: users[0].idUser,
                nickname: users[0].nickname,
                role_id: users[0].role_id,
                avatar: avatar,
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

    static async createPasswordResetToken(email) {
        const crypto = require('crypto');
        const token = crypto.randomBytes(32).toString('hex');
        
        const resetTokens = global.resetTokens || new Map();
        resetTokens.set(token, { 
            email, 
            expires: Date.now() + 30 * 60 * 1000 // 30 минут
        });
        global.resetTokens = resetTokens;
        
        return token;
    }

    static async verifyPasswordResetToken(token) {
        const resetTokens = global.resetTokens || new Map();
        const data = resetTokens.get(token);
        
        if (!data || Date.now() > data.expires) {
            if (data) resetTokens.delete(token);
            global.resetTokens = resetTokens;
            return null;
        }
        
        return data.email;
    }

    static async deletePasswordResetToken(token) {
        const resetTokens = global.resetTokens || new Map();
        resetTokens.delete(token);
        global.resetTokens = resetTokens;
    }
            
}

module.exports = AuthService;