const ReviewService = require('../services/reviewService')

exports.GetReviewById = async (req, res) => {
    const { reviewId } = req.params
    const incrementView = req.query.incrementView === 'true'

    if (!reviewId || isNaN(reviewId)) {
        return res.status(400).json({
            success: false,
            error: 'Неверный ID рецензии'
        })
    }

    try {
        const result = await ReviewService.GetReviewById(reviewId, incrementView)
        return res.json({
            success: true,
            result
        })
    } catch (error) {
        console.log('Ошибка загрузки рецензии', error)
        return res.status(error.status || 500).json({
            success: false,
            error: error.message || 'Ошибка сервера'
        })
    }
}


exports.GetReviews = async(req, res) => {
    const { page = 1, limit = 20 } = req.query
    try {
        const result = await ReviewService.GetReviewsByPage(page, limit)
        return res.json({
            success: true,
            result
        })
    } catch (error) {
        console.log('Ошибка загрузки рецензий', error)
        return res.status(error.status || 500).json({
            success: false,
            error: error.message || 'Ошибка сервера'
        })
    }
}
