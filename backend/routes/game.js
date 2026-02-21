const express = require('express');
const gameController = require('../controllers/gameController');
const authMiddleware = require('../middleware/auth');
const router = express.Router();


router.post('/games/addBySearchAPI', authMiddleware, gameController.AddGameBySearchAPI);
router.post('/games/addTopGame', authMiddleware, gameController.AddTopRated);



module.exports = router;