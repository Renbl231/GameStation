const express = require('express')
const interactionController = require('../controllers/interactionController')
const authMiddleware = require('../middleware/auth')
const router = express()

router.get('/comments/:entityType/:entityId', interactionController.getComments);
router.post('/comments/:entityType/:entityId', authMiddleware, interactionController.createComment)
router.post('/:entityType/:entityId/like', authMiddleware, interactionController.like)

module.exports = router