const express = require('express')
const articleController = require('../controllers/articleController')
const { News_AdminRole } = require('../middleware/role')
const upload = require('../middleware/upload')
const router = express.Router();

router.get('/articles', articleController.getArticlesPaginated)
router.get('/articles/home', articleController.getArticlesHome);
router.get('/article/:id', articleController.getArticleById)


router.post('/article/createArticle', News_AdminRole, upload.single('image'), articleController.createArticle);


router.delete('/article/:id/delete', News_AdminRole, articleController.deleteArticle)
router.put('/article/:id/edit', News_AdminRole, upload.single('image'), articleController.updateArticle)

module.exports = router;