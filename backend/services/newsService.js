const db = require('../config/db')

class NewsService {
    static async createNews(title, category, content, authorId) {
        const [result] = await db.execute(
            'INSERT INTO News (title, content, category, publisher_id) VALUES (?, ?, ?, ?)', 
            [title, content, category, authorId]
        )

        if(result.affectedRows === 0) {
            throw new Error('Новость не создана');
        } 
            
        return result.affectedRows > 0;
    }
}

module.exports = NewsService
