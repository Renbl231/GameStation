const db = require('../config/db')
const { getPublicMinioUrl } = require('../helpers/minioUrl')
const StorageService = require('./storageService')

class ModerationService {
    static async deleteComment(commentId, moderation_id, reason) {
        const [result] = await db.execute(
            'UPDATE Comments SET moderated_status = ?, moderated_by = ?, moderation_reason = ? WHERE idComment = ?',
            ['hidden', moderation_id, reason, commentId]
        )

        if (result.affectedRows === 0) {
            throw { status: 404, message: 'Комментарий не найден' }
        }

        return true
    }

    static async deleteQuestion(questionId, moderation_id, reason) {
        const [result] = await db.execute(
            'UPDATE Questions SET moderated_status = ?, moderated_by = ?, moderation_reason = ? WHERE idQuestion = ?',
            ['hidden', moderation_id, reason, questionId]
        )

        if (result.affectedRows === 0) {
            throw { status: 404, message: 'Вопрос не найден' }
        }

        return true
    }

    static async deleteReview(reviewId, moderation_id, reason) {
        const [result] = await db.execute(
            'UPDATE Reviews SET moderated_status = ?, moderated_by = ?, moderation_reason = ? WHERE idReview = ?',
            ['hidden', moderation_id, reason, reviewId]
        )

        if (result.affectedRows === 0) {
            throw { status: 404, message: 'Рецензия не найдена' }
        }

        return true
    }


    // Получение запросов

    static async getRequests() {
        const [siteResult, gameResult] = await Promise.all([
            db.execute(`
                SELECT q.idQuestion, q.title, q.description, q.status, q.notes, q.created_at, 
                    qs.name AS section_name,
                    u.nickname AS user,
                    u.avatar_url as user_avatar
                FROM Questions q
                LEFT JOIN Users u on u.idUser = q.user_id
                LEFT JOIN QuestionSections qs ON qs.idSection = q.section_id
                WHERE q.section_id IN (1, 2, 3, 5) AND q.status = 'open'
                ORDER BY q.created_at DESC
            `),

            db.execute(`
                SELECT gr.*, u.nickname AS user, u.avatar_url AS user_avatar 
                FROM GameRequests gr
                LEFT JOIN Users u ON u.idUser = gr.user_id
                WHERE gr.status = 'pending'
                ORDER BY gr.created_at DESC
            `)
        ])

        const siteRequestRaw = siteResult[0]  
        const gameRequestsRaw = gameResult[0]

        const gameRequests = gameRequestsRaw.map(req => ({
            ...req,
            user_avatar: req.user_avatar 
                ? getPublicMinioUrl(req.user_avatar) 
                : null
        }))

        const siteRequests = siteRequestRaw.map(req => ({
            ...req,
            user_avatar: req.user_avatar 
                ? getPublicMinioUrl(req.user_avatar) 
                : null
        }))

        return {
            gameRequests,
            siteRequests
        }
    }


    // Модерация запросов

    static async moderateGameRequest(idRequest, notes, status, moderator_id) {
        const [result] = await db.execute(`
            UPDATE GameRequests 
            SET status = ?, notes = ?, moderator_id = ?
            WHERE idRequest = ?
        `, [status, notes, moderator_id, idRequest])
        
        return result.affectedRows > 0 || false
    }

    static async moderateSiteRequest(idQuestion, notes) {
        const [result] = await db.execute(`
            UPDATE Questions 
            SET status = 'closed', notes = ?
            WHERE idQuestion = ?
        `, [notes, idQuestion])
        
        return result.affectedRows > 0 || false
    }




    static async moderateUserMedia(userId, type) {
        if(type === 'banner') {
            const [exist] = await db.execute(
                'SELECT banner FROM Users WHERE idUser = ?',
                [userId]
            )
            if(exist[0].banner) {
                await StorageService.deleteFileFromBucket(exist[0].banner)
                const [result] = await db.execute(
                    `UPDATE Users SET banner = null WHERE idUser = ?`,
                    [userId]
                )
                return result.affectedRows > 0
            }
            
            throw { status: 404, message: 'Банер отсутствует' }
        } 

        const [exist] = await db.execute(
            'SELECT avatar FROM Users WHERE idUser = ?',
            [userId]
        )

        if(exist[0].avatar) {
            await StorageService.deleteFileFromBucket(exist[0].avatar)
            const [result] = await db.execute(
                `UPDATE Users SET avatar = null WHERE idUser = ?`,
                [userId]
            )
            return result.affectedRows > 0
        }

        throw { status: 404, message: 'Аватар отсутствует' }
    }

    static async moderateBlockUser(type, user_id, banDays, reason, moderator_id, entity_id = null) {
        const [active] = await db.execute(
            `SELECT id
            FROM user_restrictions
            WHERE user_id = ?
            AND restriction_type = ?
            AND banned_until > NOW()
            LIMIT 1`,
            [user_id, type]
        )

        if (active.length) {
            throw { success: false, message: 'Пользователь уже заблокирован' }
        }

        const bannedUntil = new Date()
        bannedUntil.setDate(bannedUntil.getDate() + Number(banDays))

        const [existing] = await db.execute(
            `SELECT id FROM user_restrictions WHERE user_id = ? AND restriction_type = ?`,
            [user_id, type]
        )

        if (existing.length) {
            await db.execute(
                `UPDATE user_restrictions
                SET banned_until = ?, moderation_reason = ?, moderated_by = ?
                WHERE user_id = ? AND restriction_type = ?`,
                [bannedUntil, reason, moderator_id, user_id, type]
            )
        } else {
            await db.execute(
                `INSERT INTO user_restrictions
                (user_id, restriction_type, banned_until, moderation_reason, moderated_by)
                VALUES (?, ?, ?, ?, ?)`,
                [user_id, type, bannedUntil, reason, moderator_id]
            )
        }

        if(type === 'review') {
            await db.execute(
                `UPDATE reviews SET moderated_status = 'hidden', moderation_reason = ?
                WHERE idReview = ?`,
                [reason, entity_id]
            )
        } else if(type === 'comment') {
            await db.execute(
                `UPDATE comments SET moderated_status = 'hidden' , moderation_reason = ?
                WHERE idComment = ?`,
                [reason, entity_id]
            )
        } else if(type === 'question') {
            await db.execute(
                `UPDATE questions SET moderated_status = 'hidden' , moderation_reason = ?
                WHERE idQuestion = ?`,
                [reason, entity_id]
            )
        }

        return { success: true, message: 'Пользователь заблокирован' }
    }

    static async moderateUnblockUser(userId, category) {
        const [result] = await db.execute(
            `UPDATE user_restrictions SET banned_until = null 
            WHERE user_id = ? AND restriction_type = ? AND banned_until > NOW()`,
            [userId, category]
        )

        if (result.affectedRows === 0) {
            throw { status: 404, message: 'Ограничение не найдено' }
        }

        return result.affectedRows > 0
    }

    static async moderateRole(userId, role) {
        const [result] = await db.execute(
            `UPDATE users SET role_id = ? WHERE idUser = ?`,
            [role, userId]
        )

        if (result.affectedRows === 0) {
            throw { status: 404, message: 'Пользователь не найден' }
        }

        return Number(role)
    }


}

module.exports = ModerationService