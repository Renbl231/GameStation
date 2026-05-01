const GameService = require('../services/gameService');


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
        if(error.message.includes('уже существует')) {
            return res.status(409).json({
                success: false,
                error: error.message
            })
        } else if (error.message.includes('не найдена')) {
            return res.status(404).json({
                success: false,
                error: error.message
            })
        }
        return res.status(500).json({
            success: false,
            error: 'Ошибка сервера'
        })
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
        const { form } = req.body;
        if(!form?.name?.trim() || !form?.summary?.trim() || !form?.developer?.trim() || 
        !form?.publisher?.trim() || !form?.status?.trim() || !form?.cover_url?.trim()) {
            return res.status(400).json({
                success: false,
                error: 'Заполните основные поля'
            });
        }

        const validateReleaseDate = (dateStr) => {
            if (!dateStr?.trim()) return false;
            const date = new Date(dateStr);
            if (isNaN(date.getTime())) return false;
            const year = date.getFullYear();
            if (year < 1950) return false;
            const now = new Date();
            const maxFuture = new Date(now.getFullYear() + 2, now.getMonth(), now.getDate());
            if (date > maxFuture) return false;
            return true;
        };

        if (form.release_date && !validateReleaseDate(form.release_date)) {
            return res.status(400).json({
                success: false,
                error: 'Некорректная дата релиза'
            });
        }

        const result = await GameService.addGameByUser(form);
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
        return res.status(500).json({
            success: false,
            error: error.message || 'Ошибка сервера'
        })
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
        return res.status(500).json({
            success: false,
            error: error.message || 'Ошибка сервера'
        })
    }
}

exports.RequestAddGame = async (req, res) => {
  const { nameGame, store_url, cover_url, baner_url } = req.body
  const user_id = req.user.id

  if (
    !nameGame ||
    !store_url ||
    !cover_url ||
    nameGame.trim().length < 3 ||
    store_url.trim().length < 5 ||
    cover_url.trim().length < 5
  ) {
    return res.status(400).json({
      success: false,
      message: 'Ошибка запроса'
    })
  }

  try {
    await GameService.RequestAddGame({ nameGame, store_url, cover_url, baner_url }, user_id)
    return res.json({
      success: true,
      message: 'Запрос отправлен'
    })
  } catch (error) {
    return res.status(error.status || 500).json({
      success: false,
      error: error.message || 'Ошибка сервера'
    })
  }
}

exports.GetFilterData = async(req, res) => {
    try {
        const filterData = await GameService.GetFilterData()
        return res.json({
            success: true,
            filterData
        })
    } catch(error) {
        return res.status(500).json({
            success: false,
            error: error.message || 'Ошибка сервера'
        })
    }
}

exports.GetCatalog = async(req, res) => {
    const { page = 1, limit = 40, sort = 'recently' } = req.query
    const platforms = req.query.platforms ? req.query.platforms.split(',').map(Number) : []
    const brands = req.query.brands ? req.query.brands.split(',').map(Number) : []

    const ratingMin = req.query.ratingMin ? Number(req.query.ratingMin) : 0
    const ratingMax = req.query.ratingMax ? Number(req.query.ratingMax) : 10

    const modes = req.query.modes ? req.query.modes.split(',').map(Number) : []
    const perspectives = req.query.perspectives ? req.query.perspectives.split(',').map(Number) : []
    const themes = req.query.themes ? req.query.themes.split(',').map(Number) : []
    const releaseDate = req.query.release_date || null

    try {
        const result = await GameService.GetGameCatalog(
            page, limit, sort, platforms, brands, ratingMin, ratingMax, modes, perspectives, themes, releaseDate
        )
        return res.json({
            success: true,
            result
        })
    } catch(error) {
        console.log('Ошибкиии', error)
        return res.status(500).json({
            success: false,
            error: error.message || 'Ошибка сервера'
        })
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

exports.EditGameById = async (req, res) => {
  try {
    const { id } = req.params
    const form = req.body.form || req.body

    if (!id || isNaN(id)) {
      return res.status(400).json({
        success: false,
        error: 'Неверный ID игры'
      })
    }

    if (
      !form?.name?.trim() ||
      !form?.summary?.trim() ||
      !form?.developer?.trim() ||
      !form?.publisher?.trim() ||
      !form?.status?.trim() ||
      !form?.cover_url?.trim()
    ) {
      return res.status(400).json({
        success: false,
        error: 'Заполните основные поля'
      })
    }

    const validateReleaseDate = (dateStr) => {
      if (!dateStr?.trim()) return false
      const date = new Date(dateStr)
      if (isNaN(date.getTime())) return false
      const year = date.getFullYear()
      if (year < 1950) return false
      const now = new Date()
      const maxFuture = new Date(now.getFullYear() + 2, now.getMonth(), now.getDate())
      if (date > maxFuture) return false
      return true
    }

    if (form.release_date && !validateReleaseDate(form.release_date)) {
      return res.status(400).json({
        success: false,
        error: 'Некорректная дата релиза'
      })
    }

    const result = await GameService.EditGameById(id, form)

    return res.json({
      success: true,
      message: 'Игра успешно изменена',
      result
    })
  } catch (error) {
    console.log('Ошибка редактирования игры', error)
    return res.status(error.status || 500).json({
      success: false,
      error: error.message || 'Ошибка при редактировании игры'
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
        await GameService.ReviewGame(id, user_id, rating_id, reviewForm)
        return res.json({
            success: true,
            message: 'Ответ опубликован'
        })
    } catch (error) {
        console.log('Ошибка редактирования игры', error)
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