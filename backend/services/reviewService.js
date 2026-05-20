const db = require('../config/db');
const { igdbRequest } = require('../config/api');
const axios = require('axios');
const { getPublicMinioUrl } = require('../helpers/minioUrl')

const processGameImage = (imageUrl) => {
    if (!imageUrl) return null
    if (imageUrl.startsWith('games/')) {
        return getPublicMinioUrl(imageUrl) 
    }
    return imageUrl
}


class ReviewService {

    static async GetReviewById(review_id, incrementView = false) {

        if (incrementView) {
            const [result] = await db.execute(
            'UPDATE Reviews SET views_count = views_count + 1 WHERE idReview = ?',
            [review_id]
            )
        }

        const [rows] = await db.execute(
            `SELECT 
            r.idReview, 
            r.title, 
            r.content, 
            r.views_count, 
            r.comments_count, 
            r.game_id,
            r.user_id,
            r.rating_id,
            r.created_at,
            gr.overall_score,
            gr.gameplay,
            gr.graphics,
            gr.story,
            gr.music,
            gr.atmosphere,
            gr.optimization,
            gr.innovation,
            gm.idGame,
            gm.name,
            gm.cover_url,
            u.nickname,
            u.avatar_url
            FROM Reviews r
            LEFT JOIN GameRatings gr ON gr.idGameRating = r.rating_id
            LEFT JOIN Games gm ON gm.idGame = r.game_id
            LEFT JOIN Users u ON u.idUser = r.user_id
            WHERE r.idReview = ? AND r.moderated_status = 'active'`,
            [review_id]
        )

        if (!rows[0]) return null

        const review = rows[0]
        
        review.cover_url = processGameImage(review.cover_url)
        review.avatar_url = getPublicMinioUrl(review.avatar_url)

        return review
    }

    static async GetReviewsByPage(page = 1, limit = 20) {
        const safePage = Math.max(1, parseInt(page))
        const safeLimit = Math.min(20, Math.max(1, parseInt(limit)))
        const offset = (safePage - 1) * safeLimit

        const [countRows] = await db.execute(`SELECT COUNT(*) as total FROM Reviews`)
        const total = countRows[0].total

        const [reviews] = await db.query(
            `
            SELECT 
            r.idReview,
            r.title,
            r.content,
            r.created_at,
            COALESCE(r.views_count, 0) AS views_count,
            COALESCE(r.comments_count, 0) AS comments_count,
            r.user_id,
            r.rating_id,
            gr.overall_score,
            gr.gameplay,
            gr.graphics,
            gr.story,
            gr.music,
            gr.atmosphere,
            gr.optimization,
            gr.innovation,
            gm.idGame,
            gm.name,
            gm.cover_url,
            u.nickname,
            u.avatar_url
            FROM Reviews r
            LEFT JOIN GameRatings gr ON gr.idGameRating = r.rating_id
            LEFT JOIN Games gm ON gm.idGame = r.game_id
            LEFT JOIN Users u ON u.idUser = r.user_id
            WHERE r.moderated_status = 'active'
            ORDER BY r.created_at DESC
            LIMIT ${safeLimit} OFFSET ${offset}
            `
        )

        reviews.forEach(review => {
            review.cover_url = processGameImage(review.cover_url)
            review.avatar_url = getPublicMinioUrl(review.avatar_url)
        })

        return {
            reviews,
            totalPages: Math.ceil(total / safeLimit),
            currentPage: safePage,
            perPage: safeLimit
        }
    }

    static async DeleteReviewById(game_id, review_id, user_id) {
        const [result] = await db.execute(
            `DELETE FROM Reviews WHERE game_id = ? AND idReview = ? AND user_id = ?`,
            [game_id, review_id, user_id]
        )

        if(result.affectedRows === 0) {
            throw { status: 404, message: 'Рецензия не найдена' }
        } 

        return true
    }

}

module.exports = ReviewService;
