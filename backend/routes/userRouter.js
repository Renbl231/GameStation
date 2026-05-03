const express = require('express')
const authMiddleware = require('../middleware/auth')
const { Moder_AdminRole } = require('../middleware/role')
const upload = require('../middleware/upload')
const userController = require('../controllers/userController')
const router = express.Router()

router.get('/user/:nickname', userController.getUserByNickname)

router.put('/user/me', authMiddleware, userController.editUserData)
router.put('/user/me/avatar', authMiddleware, upload.single('avatar'), userController.editUserAvatar)


router.get('/user/:userId/games', userController.getUserGames)
router.get('/user/:userId/reviews', userController.getUserReviews)

router.post('/user-restrictions', Moder_AdminRole, userController.banUser)


module.exports = router