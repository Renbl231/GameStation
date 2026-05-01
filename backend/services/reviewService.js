const db = require('../config/db');
const { igdbRequest } = require('../config/api');
const axios = require('axios');

class ReviewService {

    static async GetReviewById(review_id, incrementView = false) {
        console.log('review_id:', review_id, 'incrementView:', incrementView)

  if (incrementView) {
    const [result] = await db.execute(
      'UPDATE Reviews SET views_count = views_count + 1 WHERE idReview = ?',
      [review_id]
    )
    console.log('update result:', result)
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
            WHERE r.idReview = ?`,
            [review_id]
        )

        return rows[0] || null
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
            r.game_id,
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
            ORDER BY r.created_at DESC
            LIMIT ${safeLimit} OFFSET ${offset}
            `
        )

        return {
            reviews,
            totalPages: Math.ceil(total / safeLimit),
            currentPage: safePage,
            perPage: safeLimit
        }
    }


}

module.exports = ReviewService;
