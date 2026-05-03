const express = require('express')
const communityController = require('../controllers/communityController')
const authMiddleware = require('../middleware/auth');
const router = express.Router();

router.get('/community', communityController.getDiscussions)
router.get('/community/mine', authMiddleware, communityController.getMyDiscussions)
router.get('/theme/:id', communityController.getTheme)
router.post('/community/createTheme', authMiddleware, communityController.createTheme)
router.delete('/theme/:id/delete', authMiddleware, communityController.deleteTheme)
router.put('/theme/:id/edit', authMiddleware, communityController.updateTheme)

module.exports = router;