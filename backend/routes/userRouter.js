const express = require('express')
const authMiddleware = require('../middleware/auth')
const { Moder_AdminRole } = require('../middleware/role')
const userController = require('../controllers/userController')
const router = express.Router()

router.get('/user/:nickname', userController.getUserByNickname)
router.put('/user/:nickname/edit', authMiddleware, userController.editUserData)

router.get('/user/:userId/games', userController.getUserGames)
router.get('/user/:userId/reviews', userController.getUserReviews)

router.post('/user-restrictions', Moder_AdminRole, userController.banUser)

module.exports = router