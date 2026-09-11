const { HandleError } = require ('../utils/errorHandler.js')
const { validateArticle } = require('../validators/entityValidator.js')
const articleService = require('../services/articleService');

const errText = "Ошибка получения статей"

exports.getArticles = async (req, res) => {
    try {
        const { page = 1, limit = 20, category_id } = req.query
        const result = await articleService.getArticlesByPage(page, limit, category_id)
        return res.json(result)
    } catch (error) {
        HandleError(res, error, errText)
    }
}

exports.getArticleById = async (req, res) => {
    try {
        const { id } = req.params
        const incrementView = req.query.incrementView === 'true'
        
        const article = await articleService.getArticleById(id, incrementView)
        return res.json(article)
    } catch (error) {
        HandleError(res, error, errText)
    }
}

exports.getArticlesHome = async (req, res) => {
    try {
        const articles = await articleService.getArticlesHome()
        return res.json({articles})
    } catch(error) {
        HandleError(res, error, errText)
    }
}

exports.createArticle = async (req, res) => {
    const { title, category_id, content, score } = req.body
    const authorId = req.user.id
    const coverImage = req.file

    const checkData = {
      title,
      category_id,
      content,
    }

    const { isValid, error } = await validateArticle(checkData)
    if (!isValid) {
        return res.status(400).json({
            success: false,
            error
        })
    }

    try {
        await articleService.createArticle(
            title.trim(), 
            Number(category_id), 
            content.trim(), 
            coverImage, 
            score, 
            authorId
        )

        return res.status(201).json({
            success: true,
            message: 'Статья опубликована'
        })
    } catch (error) {
        HandleError(res, error, 'Ошибка создания статьи', false)
    }
}

exports.updateArticle = async (req, res) => {
    const { id } = req.params
    const { title, category_id, content, score} = req.body
    const newCoverImage = req.file

    if(!id || isNaN(id)) {
        return res.status(400).json({
            success: false,
            error: 'Неверный ID новости'
        })
    }

    const checkData = {
      title,
      category_id,
      content,
    }

    const { isValid, error } = await validateArticle(checkData)
    if (!isValid) {
        return res.status(400).json({
            success: false,
            error
        })
    }

    try {
        await articleService.updateArticle(
            title.trim(),        
            Number(category_id),   
            content.trim(),         
            Number(id),              
            newCoverImage,  
            score     
        )
        return res.json({ 
            success: true 
        })
    } catch(error) {
        HandleError(res, error, 'Ошибка редактирования статьи', false)
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
        HandleError(res, error, 'Ошибка удаления статьи', false)
    }
}

