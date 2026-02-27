const NewsService = require('../services/newsService');
const { ValidateNews } = require('../validators/newsValidator')

exports.CreateNews = async (req, res) => {
    try {
        const { title, category, content, image } = req.body;
        
        const authorId = req.user.id;

        const validation = ValidateNews({title, category, content, image, authorId});
        if(!validation.isValid) {
            return res.status(400).json({
                error: validation.error
            })
        }

        await NewsService.createNews(title, category, content, image, authorId)

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


// exports.getAllNews = async (req, res) => {
//     try {
//         const news = await NewsService.getAllNews();
//         return res.json({
//             success: true,
//             news
//         })   
//     } catch (error) {
//         return res.status(500).json({
//             success: false,
//             error: 'Ошибка загрузки новостей'
//         })
//     }
// }

exports.getNewsPaginated = async (req, res) => {
  try {
    const page = Math.max(1, parseInt(req.query.page) || 1);
    const limit = Math.max(1, Math.min(20, parseInt(req.query.limit) || 2));
    const result = await NewsService.getNewsByPage(page, limit);
    res.json(result);
  } catch (error) {
    res.status(500).json({ 
      success: false, 
      error: 'Ошибка загрузки новостей' 
    });
  }
};


