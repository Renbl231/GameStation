const jwt = require('jsonwebtoken')

class TokenService {
    static generateToken(payload) {
        try {
            if(!payload || typeof payload !== 'object') {
                throw new Error('Некорректный payload');
            }
    
            if(!process.env.JWT_SECRET) {
                throw new Error('JWT_SECRET is not configured')
            }

            return jwt.sign(
            { 
                id: payload.id, 
                role: payload.role
                
            }, 
            process.env.JWT_SECRET, 
            { expiresIn: '24h' }
            );
            
        } catch (error) {
            if (error.name === 'JsonWebTokenError') {
                throw new Error('Ошибка генерации токена')
            }
            throw error
        }
    }

    static generateVerificationToken(payload) {
        return jwt.sign(
            { 
            email: payload.email,
            action: payload.action 
            }, 
            process.env.JWT_SECRET, 
            { expiresIn: '24h' }
        );
    }

    static verifyToken(token) {
        if(!token) {
            throw new Error('Токен отсутствует')
        }

        if(!process.env.JWT_SECRET) {
            throw new Error('JWT_SECRET is not configured')
        }

        try {
            return jwt.verify(token, process.env.JWT_SECRET);

        } catch (error) {
            if (error.name === 'JsonWebTokenError') {
                throw new Error('Некорректный или истёкший токен')
            } else if (error.name === 'TokenExpiredError') {
                throw new Error('Токен истёк')
            }
            throw new Error('Ошибка проверки токена')
        }

    }

    static getCookieOptions() {
        return {
        httpOnly: true,
        secure: process.env.NODE_ENV === 'production',
        sameSite: 'strict',
        maxAge: 7 * 24 * 60 * 60 * 1000
        };
    }
}

module.exports = TokenService;