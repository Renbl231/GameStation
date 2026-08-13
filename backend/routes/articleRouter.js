const express = require('express')
const articleController = require('../controllers/articleController')
const { News_AdminRole } = require('../middleware/role')
const upload = require('../middleware/upload')
const router = express.Router();

router.get('/articles', articleController.getArticles)
router.get('/articles/home', articleController.getArticlesHome);
router.post('/article/createArticle', News_AdminRole, upload.single('image'), articleController.createArticle);
router.get('/article/:id', articleController.getArticleById)
router.delete('/article/:id/delete', News_AdminRole, articleController.deleteArticle)
router.put('/article/:id/edit', News_AdminRole, upload.single('image'), articleController.updateArticle)

module.exports = router;