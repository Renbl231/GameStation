const articleService = require('../services/articleService');
const { ValidateArticle } = require('../validators/articleValidator')

exports.getArticlesPaginated = async (req, res) => {
    try {
        const { page = 1, limit = 20, category } = req.query
        const result = await articleService.getArticlesByPage(page, limit, category)
        return res.json(result)
    } catch (error) {
        return res.status(500).json({ 
          success: false,
          error: error.message || 'Ошибка сервера'
        })
    }
}

exports.createArticle = async (req, res) => {
    try {
        const { title, category, content, image, score } = req.body;
        const authorId = req.user.id;

        const validation = ValidateArticle({title, category, content, image, score, authorId});
        if(!validation.isValid) {
            return res.status(400).json({
                success: false,
                error: validation.error
            })
        }

        await articleService.createArticle(title, category, content, image, score, authorId)

        return res.status(201).json({
            success: true,
            message: 'Статья опубликована'
        })
        
     } catch (error) {
        return res.status(500).json({
            success: false,
            error: error.message || 'Ошибка сервера'
        })
     }
}

exports.getArticleById = async (req, res) => {
    try {
        const { id } = req.params
        const incrementView = req.query.incrementView === 'true'
        
        const article = await articleService.getArticleById(id, incrementView)
        return res.json(article)
    } catch (error) {
        return res.status(500).json({
            error: error.message || 'Ошибка сервера'
        })
    }
}

exports.getArticlesHome = async (req, res) => {
    try {
        const articles = await articleService.getArticlesHome()
        return res.json({
            success: true,
            articles
        })
    } catch(error) {
        return res.status(500).json({
            success: false,
            error: error.message || 'Ошибка сервера'
        })
    }
}

exports.deleteArticle = async (req, res) => {
    const { id } = req.params
    const author_id = req.user.id
    if(!id || isNaN(id)) {
        return res.status(400).json({
            success: false,
            error: 'Неверный ID новости'
        })
    }
    try {
      await articleService.deleteArticle(id, author_id)
      return res.status(204).send()
    } catch(error) {
      return res.status(error.status || 500).json({
        success: false,
        error: error.message || 'Ошибка сервера'
      })
    }
}

exports.updateArticle = async (req, res) => {
    const { id } = req.params
    const { title, type_article, image, content } = req.body
    if(!id || isNaN(id)) {
        return res.status(400).json({
            success: false,
            error: 'Неверный ID новости'
        })
    }
    if(!title?.trim() || !type_article?.trim() || !image?.trim() || !content?.trim()) {
        return res.status(400).json({
            success: false,
            error: 'Все поля обязательны'
        })
    }
    
    try {
      await articleService.updateArticle(title, type_article, image, content, id)
      return res.json({
        success: true
      })
    } catch(error) {
      return res.status(error.status || 500).json({
        success: false,
        error: error.message || 'Ошибка сервера'
      })
    }
}

