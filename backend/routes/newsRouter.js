const express = require('express');
const newsController = require('../controllers/newsController');
const { News_AdminRole } = require('../middleware/role')
const router = express.Router();

router.post('/news/createNews', News_AdminRole, newsController.CreateNews);

router.get('/news', newsController.getNewsPaginated);

module.exports = router;
