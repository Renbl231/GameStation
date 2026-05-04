const db = require('../config/db')
const { getPublicMinioUrl } = require('../helpers/minioUrl')
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


}

module.exports = ModerationService