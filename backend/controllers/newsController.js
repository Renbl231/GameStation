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

exports.getNewsPaginated = async (req, res) => {
  try {
    const page = Math.max(1, parseInt(req.query.page) || 1);
    const limit = Math.max(1, Math.min(20, parseInt(req.query.limit) || 20));
    const sort = req.query.sort || null;
    const category = req.query.category || null;
    const result = await NewsService.getNewsByPage(page, limit, sort, category);
    return res.json(result);
  } catch (error) {
    console.error('Backend ERROR:', error);
    return res.status(500).json({ 
      success: false, 
      error: 'Ошибка загрузки новостей' 
    });
  }
};

exports.getNewsById = async (req, res) => {
  try {
    const { id } = req.params
    const news = await NewsService.getNewsById(id)

    if(!news) {
      return res.status(404).json({
        error: 'Ошибка: новость не найдена'
      })
    }

    return res.json(news)

  } catch (error) {
    return res.status(500).json({
      error: 'Ошибка сервера'
    })
  }
}

exports.likeNews = async (req, res) => {
  try {
    const { news_id } = req.body
    const user_id = req.user.id

    const result = await NewsService.likeNews(user_id, news_id);

    return res.json(result)
    
  } catch(error) {
    return res.status(500).json({
      error: 'Ошибка сервера'
    })
  }
}

exports.commentNews = async (req, res) => {
  const { content, news_id } = req.body
  const user_id = req.user.id

  try {
    if(!content) {
      return res.status(404).json({
        success: false,
        error: 'Некорректные данные'
      })
    }

    const result = await NewsService.createComment(content, user_id, news_id)

    return res.json({
      success: true
    })

  } catch(error) {
    console.log(error)
    return res.status(500).json({
      success: false,
      error: 'Ошибка сервера'
    })
  }
}

exports.getComments = async (req, res) => {
  const { idNew } = req.params

  try {
    const comments = await NewsService.getComments(idNew)

    if(!comments) {
      return res.status(400).json({
        error: 'Ошибка загрузки данных'
      })
    }

    return res.json(comments)

  } catch (error) {
    console.log(error)
    return res.status(500).json({
      error: 'Ошибка сервера'
    })
  }
}



