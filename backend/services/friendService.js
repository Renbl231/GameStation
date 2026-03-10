const db = require('../config/db')

class friendService {
    static async searchUsers(nickname, user_id) {
        const [users] = await db.execute(
            `SELECT u.idUser, u.nickname, u.avatar_url
            FROM Users u
            LEFT JOIN Friends f ON (f.friend_id = u.idUser AND f.user_id = ?)
            WHERE u.nickname LIKE ?
            AND f.friend_id IS NULL
            AND u.idUser != ?
            LIMIT 10`, [user_id, `%${nickname}%`, user_id]
        )
        return users
    }

    static async addFriend(idUser, user_id) {
        const [existing] = await db.execute(
            'SELECT id FROM Friends WHERE user_id = ? AND friend_id = ?', 
            [user_id, idUser]
        )
        
        if(existing.length === 0) {
            const [result] = await db.execute(
                'INSERT INTO Friends (user_id, friend_id) VALUES(?,?)', 
                [user_id, idUser]
            )
            return result.affectedRows > 0 ? { success: true } : { success: false }
        }
        
        return { success: true }
    }

    static async removeFriend(idUser, user_id) {
        const [result] = await db.execute(
            'DELETE FROM Friends WHERE user_id = ? AND friend_id = ?', [user_id, idUser]
        )
        if(result.affectedRows === 0) {
            throw new Error("Пользователь не в друзьях");
        }
        return { success: true }
    }

    // входящие запросы

    static async getIncomingUsers(my_user_id) {
        const [countResult] = await db.execute(
            `SELECT COUNT(*) as total
            FROM Friends f
            INNER JOIN Users u ON f.user_id = u.idUser  -- КТО отправил
            WHERE f.friend_id = ? AND f.status = 'awaiting'`,
            [my_user_id]
        )
        
        const [users] = await db.execute(
            `SELECT u.idUser, u.nickname, u.avatar_url
            FROM Friends f
            INNER JOIN Users u ON f.user_id = u.idUser  -- КТО отправил
            WHERE f.friend_id = ? AND f.status = 'awaiting'`,
            [my_user_id]
        )
    
        
        return { users, total: countResult[0].total }
    }

    static async handleIncoming(action, user_id, friend_id) {
        if(action === 'rejected') {
            const [result] = await db.execute(
                'DELETE FROM Friends WHERE user_id = ? AND friend_id = ? AND status = "awaiting"',
                [user_id, friend_id]
            )
            if(result.affectedRows === 0) {
                throw new Error("Запрос не найден")
            }
        } else {
            const [result] = await db.execute(
                'UPDATE Friends SET status = ? WHERE user_id = ? AND friend_id = ? AND status = "awaiting"',
                [action, user_id, friend_id]
            )
            if(result.affectedRows === 0) {
                throw new Error("Запрос уже обработан")
            }
        }
    }

    static async getFriends(user_id) {
        const [friends] = await db.execute(
            `SELECT DISTINCT u.idUser, u.nickname, u.avatar_url, u.banner_url
            FROM Friends f
            JOIN Users u ON (u.idUser = f.user_id OR u.idUser = f.friend_id)
            WHERE (f.user_id = ? OR f.friend_id = ?) 
            AND f.status = 'approved'
            AND u.idUser != ?`,
            [user_id, user_id, user_id]
        )
        return friends
    }

}

module.exports = friendService