const express = require('express')
const articleController = require('../controllers/articleController')
const authMiddleware = require('../middleware/auth');
const { News_AdminRole } = require('../middleware/role')
const router = express.Router();

router.get('/articles', articleController.getArticlesPaginated)
router.get('/articles/home', articleController.getArticlesHome);
router.get('/article/:id', articleController.getArticleById)
router.post('/article/createArticle', News_AdminRole, articleController.createArticle);
router.delete('/article/:id/delete', News_AdminRole, articleController.deleteArticle)
router.put('/article/:id/edit', News_AdminRole, articleController.updateArticle)

module.exports = router;