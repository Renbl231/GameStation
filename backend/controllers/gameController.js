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
    
        const gameId = await GameService.searchAndAddGame(name);
    
        return res.status(201).json({
            success: true
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
            data: results
        });

    } catch (error) {
        console.error('Ошибка добавления игр', error);
        return res.status(500).json({
            success: false,
            error: error.message || 'Ошибка при добавлении игр'
        });
    }
};

