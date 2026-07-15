const db = require('../config/db')
const { getPublicMinioUrl } = require('../helpers/minioUrl')

class friendService {
    static async searchUsers(nickname, user_id) {
        const [users] = await db.execute(
            `SELECT DISTINCT u.idUser, u.nickname, u.avatar
            FROM Users u
            LEFT JOIN Friends f ON (
                (f.friend_id = u.idUser AND f.user_id = ?) OR 
                (f.user_id = u.idUser AND f.friend_id = ?)
            )
            WHERE u.nickname LIKE ?
            AND f.id IS NULL  -- Ни одного направления!
            AND u.idUser != ?
            LIMIT 10`, 
            [user_id, user_id, `%${nickname}%`, user_id]
        );
         return users.map(row => ({
            ...row,
            avatar: row.avatar ? getPublicMinioUrl(row.avatar) : null,
        }))
    }

    static async addFriend(idUser, user_id) {
        const [existing] = await db.execute(
            'SELECT id FROM Friends WHERE user_id = ? AND friend_id = ? OR user_id = ? AND friend_id = ?', 
            [user_id, idUser, idUser, user_id]
        );

        if (existing.length > 0) {
            throw { 
                status: 409, 
                message: 'Пользователь уже в друзьях' 
            };
        }

        const [[userExists], [friendExists]] = await Promise.all([
            db.execute('SELECT idUser FROM Users WHERE idUser = ?', [user_id]),
            db.execute('SELECT idUser FROM Users WHERE idUser = ?', [idUser])
        ])

        if (userExists.length === 0) {
            throw { status: 404, message: 'Пользователь не найден' };
        }
        if (friendExists.length === 0) {
            throw { status: 404, message: 'Друг не найден' };
        }
        
        const [result] = await db.execute(
            'INSERT INTO Friends (user_id, friend_id) VALUES(?,?)', 
            [user_id, idUser]
        )

        if (result.affectedRows === 0) {
            throw { status: 500, message: 'Не удалось добавить в друзья' };
        }

        return { 
            success: true,
            message: 'Заявка в друзья отправлена'
         }
    }

    static async removeFriend(idUser, user_id) {
        const[[result1], [result2]] = await Promise.all([
            db.execute('DELETE FROM Friends WHERE user_id = ? AND friend_id = ?', [user_id, idUser]),
            db.execute('DELETE FROM Friends WHERE user_id = ? AND friend_id = ?', [idUser, user_id])
        ])

        if (result1.affectedRows + result2.affectedRows === 0) {
            throw { status: 404, message: 'Пользователь не в друзьях' };
        }
        
        return { success: true, message: 'Пользователь удалён из друзей'}
    }

    static async getIncomingUsers(my_user_id) {
        const [countQuery, usersQuery] = await Promise.all([
            db.execute(
            `SELECT COUNT(*) as total
            FROM Friends f
            WHERE f.friend_id = ? AND f.status = 'awaiting'`,
            [my_user_id]
            ),
            db.execute(
            `SELECT u.idUser, u.nickname, u.avatar
            FROM Friends f
            INNER JOIN Users u ON f.user_id = u.idUser
            WHERE f.friend_id = ? AND f.status = 'awaiting'`,
            [my_user_id]
            )
        ])

        const totalIncoming = parseInt(countQuery[0][0]?.total || 0)
        const users = usersQuery[0] || []

        return {
            users: users.map(row => ({
                idUser: row.idUser,
                nickname: row.nickname,
                avatar: row.avatar ? getPublicMinioUrl(row.avatar) : null
            })),
            totalIncoming
        }
    }

    static async handleIncoming(action, user_id, friend_id) {
        if(action === 'rejected') {
            const [result] = await db.execute(
                'DELETE FROM Friends WHERE user_id = ? AND friend_id = ? AND status = "awaiting"',
                [user_id, friend_id]
            )
            if(result.affectedRows === 0) {
                throw { status:404, message: 'Запрос не найден'}
            }
            return { success: true, message: 'Запрос успешно отклонён'}
        }
        
        const [result] = await db.execute(
            'UPDATE Friends SET status = "approved" WHERE user_id = ? AND friend_id = ? AND status = "awaiting"',
            [user_id, friend_id]
        )
        if(result.affectedRows === 0) {
            throw { status: 404, message: 'Запрос уже обработан' }
        }
        return { success: true, message: 'Пользователь добавлен в друзья'}
    }

    static async getFriends(user_id) {
        const [rows] = await db.execute(
            `SELECT DISTINCT u.idUser, u.nickname, u.avatar, u.banner
            FROM Friends f
            JOIN Users u ON (u.idUser = f.user_id OR u.idUser = f.friend_id)
            WHERE (f.user_id = ? OR f.friend_id = ?) 
            AND f.status = 'approved'
            AND u.idUser != ?`,
            [user_id, user_id, user_id]
        )

        return rows.map(row => ({
            ...row,
            avatar: row.avatar ? getPublicMinioUrl(row.avatar) : null,
            banner: row.banner ? getPublicMinioUrl(row.banner) : null,
        }))
    }

}

module.exports = friendService