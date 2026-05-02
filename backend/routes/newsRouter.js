const express = require('express');
const newsController = require('../controllers/newsController');
const authMiddleware = require('../middleware/auth');
const { News_AdminRole } = require('../middleware/role')
const router = express.Router();

router.post('/news/createNews', News_AdminRole, newsController.CreateNews);

router.get('/news', newsController.getNewsPaginated);
router.get('/news/slides', newsController.getNewsSlides);
router.get('/newsdata/:id', newsController.getNewsById)
router.delete('/news/:id/delete', News_AdminRole, newsController.deleteNews)
router.put('/news/:id/edit', News_AdminRole, newsController.updateNews)
router.put('/news/slider-mode', News_AdminRole, newsController.changeSliderMode)



module.exports = router;
