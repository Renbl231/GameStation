const express = require('express')
const authMiddleware = require('../middleware/auth')
const { Moder_AdminRole } = require('../middleware/role')
const upload = require('../middleware/upload')
const userController = require('../controllers/userController')
const router = express.Router()

router.get('/user/requests', authMiddleware, userController.getUserRequests)
router.put('/user/me', authMiddleware, userController.editUserData)
router.put('/user/me/media', authMiddleware, upload.single('media'), userController.editUserMedia)

router.get('/user/:nickname', userController.getUserByNickname)
router.get('/user/:userId/games', userController.getUserGames)
router.get('/user/:userId/reviews', userController.getUserReviews)
router.get('/user/:userId/comments', userController.getUserComments)


module.exports = router