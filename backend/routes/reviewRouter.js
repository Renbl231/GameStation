const express = require('express');
const reviewController = require('../controllers/reviewController');
const authMiddleware = require('../middleware/auth')
const { AdminRole } = require('../middleware/role')
const router = express.Router();

router.get('/reviews/:reviewId', reviewController.GetReviewById)
router.get('/reviews', reviewController.GetReviews)

module.exports = router;