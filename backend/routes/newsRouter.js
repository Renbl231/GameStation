const express = require('express');
const newsController = require('../controllers/newsController');
const authMiddleware = require('../middleware/auth');
const { News_AdminRole } = require('../middleware/role')
const upload = require('../middleware/upload')
const router = express.Router();

router.post('/news/createNews', News_AdminRole, upload.fields([{ name: 'image', maxCount: 1 }]), newsController.createNews);
router.put('/news/slider-mode', News_AdminRole, newsController.changeSliderMode);
router.get('/news/slides', newsController.getNewsSlides);
router.get('/news', newsController.getNewsPaginated);
router.get('/newsdata/:id', newsController.getNewsById);
router.put('/news/:id/edit', News_AdminRole, upload.fields([{ name: 'image', maxCount: 1 }]), newsController.updateNews);
router.delete('/news/:id/delete', News_AdminRole, newsController.deleteNews);


module.exports = router;
