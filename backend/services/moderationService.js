const db = require('../config/db')

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

}

module.exports = ModerationService