const NewsService = require('../services/newsService');
const { ValidateNews } = require('../validators/newsValidator')

exports.CreateNews = async (req, res) => {
    try {
        const { title, category, content } = req.body;
        
        const authorId = req.user.id;

        const validation = ValidateNews({title, category, content, authorId});
        if(!validation.isValid) {
            return res.status(400).json({
                error: validation.error
            })
        }

        await NewsService.createNews(title, category, content, authorId)

        return res.status(201).json({
            success: true
        })
        
     } catch (error) {
        return res.status(500).json({
            success: false,
            error: error.message || 'Ошибка при добавлении новости'
        })
     }
}