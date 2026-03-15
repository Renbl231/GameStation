const express = require('express')
const communityController = require('../controllers/communityController')
const authMiddleware = require('../middleware/auth');
const { Moder_AdminRole } = require('../middleware/role')
const router = express.Router();

router.get('/community', communityController.getDiscussions)
router.post('/community/createTheme', authMiddleware, communityController.createTheme)

module.exports = router;