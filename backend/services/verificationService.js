class VerificationService {
    constructor() {
        this.cache = new Map();
    }

    saveVerificationData(email, hashedPassword, code) {
        this.cache.set(email, {
            hashedPassword,
            code,
            expiresAt: Date.now() + 30 * 60 * 1000
        });
    }

    getVerificationData(email) {
        const data = this.cache.get(email);
        
        if (!data || Date.now() > data.expiresAt) {
            this.cache.delete(email);
            return null;
        }
        return data;
    }

    getEmailByCode(code) {
        for (const [email, data] of this.cache.entries()) {
            if (data.code === code && Date.now() < data.expiresAt) {
                return email;
            }
        }
        return null;
    }

    deleteVerificationData(email) {
        this.cache.delete(email);
    }
}

module.exports = new VerificationService();
