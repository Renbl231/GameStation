const GameService = require('../services/gameService');
const { HandleError } = require('../utils/errorHandler')

exports.AddGameBySearchAPI = async (req, res) => {
    try {
        const { name } = req.body;
    
        if(!name) {
            return res.status(400).json({
                success: false,
                error: 'Название игры обязательно'
            })
        }
    
        const result = await GameService.searchAndAddGame(name);
    
        return res.json({
            success: true,
            result,
            message: 'Игра успешно добавлена'
        });

    } catch (error) {
        HandleError(res, error, '', false)
    }
}

exports.AddTopRated = async (req, res) => {
    try {
        const { limit = 5 } = req.body;
        
        const results = await GameService.addTopRatedGames(limit);
        
        return res.status(200).json({
            success: true,
            data: {
                results
            },
            message: 'Игры успешно добавлены'
        });

    } catch (error) {
        console.error('Ошибка добавления игр', error);
        return res.status(500).json({
            success: false,
            error: error.message || 'Ошибка при добавлении игр'
        });
    }
};

exports.AddGameByUser = async(req, res) => {
    try {
        const { 
            name, summary, developer, publisher, status, 
            release_date, trailer_url, genres, platforms, 
            modes, themes, perspectives, sort_order 
        } = req.body


        const coverFile = req.files.cover_url?.[0]
        const bannerFile = req.files.banner?.[0]
        const screenshots = req.files.screenshots || []

        if (!name?.trim() || !summary?.trim() || !developer?.trim() || 
            !publisher?.trim() || !status?.trim() || !coverFile) {
            return res.status(400).json({ error: 'Заполните основные поля' })
        }

        const validateReleaseDate = (dateStr) => {
        if (!dateStr?.trim()) return true  // ← пустая OK!
            const date = new Date(dateStr)
            return !isNaN(date.getTime()) && date.getFullYear() >= 1950
        }

        if (release_date && !validateReleaseDate(release_date)) {
            return res.status(400).json({ error: 'Некорректная дата релиза' })
        }

        const result = await GameService.addGameByUser({
            name, summary, developer, publisher, status,
            release_date, trailer_url, sort_order,
            genres: JSON.parse(genres || '[]'),
            platforms: JSON.parse(platforms || '[]'),
            modes: JSON.parse(modes || '[]'),
            themes: JSON.parse(themes || '[]'),
            perspectives: JSON.parse(perspectives || '[]'),
            coverFile, bannerFile, screenshots
        })

        return res.status(201).json({
            success: true,
            message: 'Игра успешно добавлена',
            result
        });
    } catch(error) {
        console.error('Ошибка добавления игр', error);
        return res.status(error.status || 500).json({
            success: false,
            error: error.message || 'Ошибка при добавлении игр'
        });
    }
}

exports.GetSlides = async (req, res) => {
    try {
        const slides = await GameService.getSlides();
        return res.json({
            success: true,
            slides
        })
    } catch(error) {
        HandleError(res, error, 'Ошибка загрузки слайдера', false)
    }
}

exports.ChangeSliderMode = async(req, res) => {
    const { sliderMode } = req.body
    if(sliderMode.trim() !== "best" && sliderMode.trim() !== "expected") {
        return res.status(400).json({
            success: false,
            message: 'Ошибка запроса'
        })
    }
    try {
        await GameService.changeSliderMode(sliderMode)
        return res.json({
            success: true,
            message: 'Слайдер успешно изменён'
        })
    } catch(error) {
        HandleError(res, error, 'Ошибка изменения слайдера', false)
    }
}

exports.RequestAddGame = async (req, res) => {
    const { nameGame, store_url } = req.body
    const user_id = req.user.id

    if (!nameGame.trim()) {
        return res.status(400).json({
            success: false,
            message: 'Ошибка запроса'
        })
    }

    try {
        await GameService.RequestAddGame({ nameGame, store_url }, user_id)
        return res.json({
            success: true,
            message: 'Запрос отправлен'
        })
    } catch (error) {
        HandleError(res, error, 'Ошибка отправки запроса', false)
    }
}

exports.GetCatalog = async(req, res) => {
    const { page = 1, limit = 40, sort = 'recently' } = req.query
    const platforms = req.query.platforms ? req.query.platforms.split(',').map(Number) : []
    const brands = req.query.brands ? req.query.brands.split(',').map(Number) : []

    const ratingMin = req.query.ratingMin ? Number(req.query.ratingMin) : 0
    const ratingMax = req.query.ratingMax ? Number(req.query.ratingMax) : 10

    const genres = req.query.genres ? req.query.genres.split(',').map(Number) : []
    const modes = req.query.modes ? req.query.modes.split(',').map(Number) : []
    const perspectives = req.query.perspectives ? req.query.perspectives.split(',').map(Number) : []
    const themes = req.query.themes ? req.query.themes.split(',').map(Number) : []
    const releaseDate = req.query.release_date || null
    const user_id = req.query.user_id || null

    try {
        const result = await GameService.GetGameCatalog(
            page, limit, sort, platforms, brands, ratingMin, ratingMax, modes, perspectives, themes, releaseDate,
            genres, user_id
        )
        return res.json({
            success: true,
            result
        })
    } catch(error) {
        HandleError(res, error, 'Ошибка загрузки каталога', false)
    }
}

exports.GetMyRating = async (req, res) => {
    const { id } = req.params
    const user_id = req.user.id

    try {
        const result = await GameService.GetMyRating(id, user_id)
        return res.json({
            success: true,
            result
        })
    } catch (error) {
        console.log('Ошибка', error)
        return res.status(500).json({
            success: false,
            error: error.message || 'Ошибка сервера'
        })
    }
}


exports.AddToCollection = async (req, res) => {
    const { collection_type, game_id } = req.body
    const user_id = req.user.id
    if (!collection_type || !String(collection_type).trim() || Number.isNaN(game_id)) {
        return res.status(400).json({
            success: false,
            message: 'Неверный запрос'
        })
    }
    try {
        const result = await GameService.AddToCollection(collection_type, game_id, user_id)
        return res.status(result.action === 'inserted' ? 201 : 200).json({
            success: true,
            result,
            message: result.action === 'deleted' ? 'Игра удалена из коллекции' : 'Игра добавлена в коллекциию'
        })
    } catch (error) {
        console.log('Ошибка', error)
        return res.status(500).json({
            success: false,
            error: error.message || 'Ошибка сервера'
        })
    }
}

// Контроллер алгоритма оценки игр
exports.EstimateGame = async (req, res) => {
    const { type, game_id, simpleScore, ratings, totalScore } = req.body
    const user_id = req.user.id
    if (
        !String(type).trim() ||
        !['simple', 'detail'].includes(type) ||
        Number.isNaN(Number(game_id))
    ) {
        return res.status(400).json({
            success: false,
            message: 'Неверный запрос'
        })
    }
    try {
        await GameService.EstimateGame(type, user_id, game_id, simpleScore, ratings, totalScore)
        return res.status(201).json({
            success: true,
            message: 'Игра оценена' 
        })
    } catch (error) {
        console.log('Ошибка', error)
        return res.status(500).json({
            success: false,
            error: error.message || 'Ошибка сервера'
        })
    }
}

exports.DeleteEstimate = async (req, res) => {
  const { game_id } = req.body
  const user_id = req.user.id

  try {
    await GameService.DeleteEstimate(game_id, user_id)
    return res.status(204).json({
        message: 'Оценка удалена'
    })
  } catch (error) {
    console.log('Ошибка', error)
    return res.status(error.status || 500).json({
      success: false,
      error: error.message || 'Ошибка сервера'
    })
  }
}

exports.GetGameById = async (req, res) => {
    const { id } = req.params
    try {
        const game = await GameService.GetGameById(id)
        return res.json(game)
    } catch (error) {
        console.log('Ошибка', error)
        return res.status(error.status || 500).json({
            success: false,
            error: error.message || 'Ошибка сервера'
        })
    }
}

exports.GetUserGameInfoById = async(req, res) => {
    const { id } = req.params
    const user_id = req.user.id
    
    try {
        const result = await GameService.GetUserGameInfoById(id, user_id)
        return res.json({
            success: true,
            result
        })
    } catch (error) {
        console.log('Ошибка', error)
        return res.status(error.status || 500).json({
            success: false,
            error: error.message || 'Ошибка сервера'
        })
    }
}

exports.DeleteGameById = async(req, res) => {
    const { id } = req.params
    if(!id || isNaN(id)) {
        return res.status(400).json({
            error: 'Неверный ID игры'
        })
    }
    try {
        await GameService.DeleteGameById(id)
        return res.status(204).send()
    } catch (error) {
        console.log('Ошибка', error)
        return res.status(error.status || 500).json({
            success: false,
            error: error.message || 'Ошибка сервера'
        })
    }
}

exports.SearchGames = async (req, res) => {
    const { q } = req.query

    if (!q || q.trim().length < 2) {
        return
    }

    try {
        const result = await GameService.SearchGames(q.trim())
        return res.json({
            success: true,
            result
        })
    } catch (error) {
        console.log('Ошибка', error)
        return res.status(error.status || 500).json({
            success: false,
            error: error.message || 'Ошибка сервера'
        })
    }
}





exports.EditGameById = async(req, res) => {
    const { id } = req.params
    const newCover = req.files?.cover_new?.[0]
    const newBanner = req.files?.banner_new?.[0]
    const newScreenshots =req.files?.screenshots_new || []

        console.log('newBanner:', newBanner) // 👈 проверь, есть ли файл
    console.log('req.files:', req.files) 

    try {
        await GameService.EditGameById(id, {
            ...req.body, 
            cover_new: newCover,
            banner_new: newBanner,
            screenshots_old: req.body.screenshots_old,
            screenshots_new: newScreenshots 
         })
        return res.json({
            success: true,
            message: 'Изменения сохранены'
        })
    }
    catch (error) {
        console.error('Ошибка редактирования', error)
        return res.status(error.status || 500).json({
        success: false,
        error: error.message || 'Ошибка сервера'
        })
    }
}






// Потом убрать 

exports.ReviewGame = async(req,res) => {
    const { id } = req.params
    const { rating_id, reviewForm } = req.body
    const user_id = req.user.id
    if (!id || isNaN(id)) {
      return res.status(400).json({
        success: false,
        error: 'Неверный ID игры'
      })
    }
    try {
        const result = await GameService.ReviewGame(id, user_id, rating_id, reviewForm)
        return res.json({
            success: true,
            message: 'Ответ опубликован',
            result
        })
    } catch (error) {
        console.log('Ошибка публикации рецензии', error)
        return res.status(error.status || 500).json({
            success: false,
            error: error.message || 'Ошибка сервера'
        })
    }
}


// Потом убрать

exports.GetReviewGame = async(req, res) => {
    const { review_id } = req.query
    if (!review_id || isNaN(review_id)) {
      return res.status(400).json({
        success: false,
        error: 'Неверный ID игры'
      })
    }
    try {
        const result = await GameService.GetReviewGame(review_id)
        return res.json({
            success: true,
            result
        })
    } catch (error) {
        console.log('Ошибка редактирования игры', error)
        return res.status(error.status || 500).json({
            success: false,
            error: error.message || 'Ошибка сервера'
        })
    }
}