const express = require('express');
const newsController = require('../controllers/newsController');
const authMiddleware = require('../middleware/auth');
const { News_AdminRole } = require('../middleware/role')
const router = express.Router();

router.post('/news/createNews', News_AdminRole, newsController.CreateNews);

router.get('/news', newsController.getNewsPaginated);
router.get('/newsdata/:id', newsController.getNewsById)


module.exports = router;
