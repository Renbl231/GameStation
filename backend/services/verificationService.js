class VerificationService {
    constructor() {
        this.cache = new Map();
    }

    saveVerificationData(email, hashedPassword) {
        this.cache.set(email, {
            hashedPassword,
            expiresAt: Date.now() + 60 * 60 * 1000
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

    deleteVerificationData(email) {
        this.cache.delete(email);
    }
}

module.exports = new VerificationService();
