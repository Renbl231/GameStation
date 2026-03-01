const db = require('../config/db')

class InteractionService {
    static async getComments(entity_type, entity_id) {
        const [results] = await db.execute(
            `SELECT c.*, u.idUser, u.nickname, u.avatar_url AS publisherCom_avatar
             FROM Comments c
             JOIN Users u ON c.user_id = u.idUser
             WHERE c.entity_type = ? AND c.entity_id = ?
             ORDER BY c.created_at DESC`,
             [entity_type, entity_id]
        )

        if(results.length === 0) {
            throw new Error('Ошибка загрузки комментариев')
        }

        const map = {}
        const roots = []

        results.forEach(result => {
            result.replies = [];
            result.parent_nickname = null
            map[result.idComment] = result;
        })

        results.forEach(result => {
            if(result.parent_comment_id && map[result.parent_comment_id]) {
                const parent = map[result.parent_comment_id]
                parent.replies.push(result)
                result.parent_nickname = parent.nickname
            } else {
                roots.push(result)
            }
        })

        return roots
    }

    static async createComment(content, user_id, entity_type, entity_id, parent_comment_id) {
        const [result] = await db.execute(
            `INSERT INTO Comments (content, user_id, entity_type, entity_id, parent_comment_id)
            VALUES (?,?,?,?, ?)`,[content, user_id, entity_type, entity_id, parent_comment_id]
        )

        if(result.affectedRows === 0) {
            throw new Error('Ошибка добавления комментария')
        }

        return {
            success: true
        }
    }

    // Работа с лайком

    static async like(user_id, entity_id, entity_type) {
        console.log('🔍 like params:', { user_id, entity_id, entity_type })
        try {
            const [existing] = await db.execute(
                'SELECT * FROM Likes WHERE (user_id, entity_id, entity_type) = (?, ?, ?)',
                [user_id, entity_id, entity_type]
            )
    
            if(existing.length > 0) {
                const [deleteResult] = await db.execute(
                    'DELETE FROM Likes WHERE (user_id, entity_id, entity_type) = (?, ?, ?)',
                    [user_id, entity_id, entity_type]
                )
                if(deleteResult.affectedRows > 0 && entity_type === 'news') {
                     await db.execute(
                        'UPDATE News SET likes_count = GREATEST(likes_count - 1, 0) WHERE idNew = ?', [entity_id]
                     )   
                }
                return { success: 'removed'}
            } else {
                const [insertResult] = await db.execute(
                    'INSERT INTO Likes (user_id, entity_id, entity_type) VALUES (?,?,?)',
                    [user_id, entity_id, entity_type]
                )
                if(insertResult.affectedRows > 0 && entity_type === 'news') {
                    await db.execute(
                        'UPDATE News SET likes_count = likes_count + 1 WHERE idNew = ?', [entity_id]
                    )
                }
                return { success: true}
            }
        } catch(error) {

            console.log(error)
        throw new Error('Ошибка при обработке лайка')
      }
    }
}

module.exports = InteractionService