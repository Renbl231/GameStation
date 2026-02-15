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
}

module.exports = AuthService;