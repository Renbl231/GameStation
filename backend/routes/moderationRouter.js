const express = require('express')
const { Moder_AdminRole } = require('../middleware/role')
const moderationController = require('../controllers/moderationController')
const router = express.Router()


router.get('/moderation/requests', Moder_AdminRole, moderationController.getRequests)
router.put('/moderation/gameRequest', Moder_AdminRole, moderationController.moderateGameRequest)
router.put('/moderation/siteRequest/:idQuestion', Moder_AdminRole, moderationController.moderateSiteRequest)

router.delete('/moderation/:id/comment', Moder_AdminRole, moderationController.moderateComment)
router.put('/moderation/:questionId/question', Moder_AdminRole, moderationController.moderateQuestion)
router.put('/moderation/:reviewId/review', Moder_AdminRole, moderationController.moderateReview)


module.exports = router