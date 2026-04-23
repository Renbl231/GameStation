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