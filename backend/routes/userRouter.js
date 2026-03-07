const express = require('express')
const authMiddleware = require('../middleware/auth')
const userController = require('../controllers/userController')
const router = express.Router()

router.get('/user/:nickname', userController.getUserByNickname)
router.put('/user/:nickname/edit', authMiddleware, userController.editUserData)

module.exports = router