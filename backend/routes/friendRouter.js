const express = require('express')
const friendController = require('../controllers/friendController')
const authMiddleware = require('../middleware/auth')
const router = express.Router()


router.get('/friends', authMiddleware, friendController.getFriends)
router.get('/friends/searchUsers', authMiddleware, friendController.searchUsers)
router.get('/friends/incoming', authMiddleware, friendController.getIncoming)
router.post('/friends/add', authMiddleware, friendController.addFriend)
router.put('/friends/handleIncoming', authMiddleware, friendController.handleIncoming)
router.delete('/friends/:idUser/delete', authMiddleware, friendController.removeFriend)

module.exports = router
