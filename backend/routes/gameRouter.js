const express = require('express');
const gameController = require('../controllers/gameController');
const authMiddleware = require('../middleware/auth')
const { AdminRole } = require('../middleware/role')
const router = express.Router();


router.post('/games/addBySearchAPI', AdminRole, gameController.AddGameBySearchAPI);
router.post('/games/addTopGame', AdminRole, gameController.AddTopRated);
router.post('/games/addGameByUser', AdminRole, gameController.AddGameByUser);
router.get('/games/slides', gameController.GetSlides);
router.post('/games/slider-mode', AdminRole, gameController.ChangeSliderMode);
router.post('/games/requestAdd', authMiddleware, gameController.RequestAddGame);
router.get('/games/getFilterData', gameController.GetFilterData)


module.exports = router;