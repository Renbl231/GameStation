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
            VALUES (?,?,?,?,?)`,[content, user_id, entity_type, entity_id, parent_comment_id]
        )

        return true
    }

    static async deleteComment(commentId, user_id) {
        const [comment] = await db.execute(
            'SELECT user_id FROM Comments WHERE idComment = ?', [commentId]
        )

        if(comment.length === 0 || comment[0].user_id !== user_id) {
            throw {status: 403, message: 'Нет прав на удаление'}
        }

        const [result] = await db.execute(
            'DELETE FROM Comments WHERE idComment = ?', [commentId]
        )

        if(result.affectedRows === 0) {
            throw { status: 404, message: 'Комментарий не найден' }
        }

        return true
    }

    static async editComment(idComment, user_id, content) {
        const [existing] = await db.execute(
            'SELECT user_id FROM Comments WHERE idComment = ?', [idComment]
        )

        if(existing.length === 0 || existing[0].user_id != user_id) {
            throw {status: 403, message: 'Нет прав на удаление'}
        }

        const [result] = await db.execute(
            'UPDATE Comments SET content = ? WHERE idComment = ?', [content, idComment]
        )

        if(result.affectedRows === 0) {
            throw { status: 404, message: 'Комментарий не найден' }
        }

        return true
    }

    // Работа с лайком

    static async like(user_id, entity_id, entity_type) {
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
                if(deleteResult.affectedRows > 0) {
                    return { success: 'removed' }
                }
            } else {
                const [insertResult] = await db.execute(
                    'INSERT INTO Likes (user_id, entity_id, entity_type) VALUES (?,?,?)',
                    [user_id, entity_id, entity_type]
                )
                if(insertResult.affectedRows > 0) {
                    return { success: true }
                }
            }
        } catch(error) {
            throw new Error('Ошибка при обработке лайка')
        }

    }
}

module.exports = InteractionService