const express = require('express');
const gameController = require('../controllers/gameController');
const authMiddleware = require('../middleware/auth')
const { AdminRole } = require('../middleware/role')
const upload = require('../middleware/upload')
const router = express.Router();


router.post('/games/addBySearchAPI', AdminRole, gameController.AddGameBySearchAPI);
router.post('/games/addTopGame', AdminRole, gameController.AddTopRated);

router.post('/games/addGameByUser', AdminRole, 
    upload.fields([
        { name: 'cover_url', maxCount: 1 },
        { name: 'banner', maxCount: 1 },
        { name: 'screenshots', maxCount: 5 }
    ]),
    gameController.AddGameByUser
)

router.get('/games/slides', gameController.GetSlides);
router.post('/games/slider-mode', AdminRole, gameController.ChangeSliderMode);
router.post('/games/requestAdd', authMiddleware, gameController.RequestAddGame);
router.get('/games/getCatalog', gameController.GetCatalog);
router.get('/games/:id/my-rating', authMiddleware, gameController.GetMyRating);
router.post('/games/addToCollection', authMiddleware, gameController.AddToCollection);
router.post('/games/estimateGame', authMiddleware, gameController.EstimateGame);
router.delete('/games/estimateGame', authMiddleware, gameController.DeleteEstimate);
router.get('/game/:id', gameController.GetGameById)
router.get('/game/:id/info', authMiddleware, gameController.GetUserGameInfoById)
router.delete('/game/:id/delete', AdminRole, gameController.DeleteGameById)
router.get('/games/search', gameController.SearchGames)
router.post('/game/:id/edit', AdminRole,
    upload.fields([
        { name: 'cover_new', maxCount: 1 },
        { name: 'banner_new', maxCount: 1 },
        { name: 'screenshots_new', maxCount: 5 }
    ]),
    gameController.EditGameById
)

// поом перенести

router.post('/game/:id/publishReview', authMiddleware, gameController.ReviewGame)
router.get('/games/getReview', authMiddleware, gameController.GetReviewGame)

module.exports = router;