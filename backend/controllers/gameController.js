const GameService = require('../services/gameService');

class GameController {
    static async searchAndAdd(req, res) {
        try {
            const { gameName } = req.body;
            
            if (!gameName || gameName.trim().length < 2) {
                return res.status(400).json({ 
                    error: 'Название игры минимум 2 символа' 
                });
            }
            
            const gameId = await SimpleGameService.searchAndAddGame(gameName.trim());
            
            res.status(201).json({ 
                success: true,
                gameId,
                message: `Игра "${gameName}" добавлена! ID: ${gameId}`
            });
            
        } catch (error) {
            console.error('🎮 GameController ERROR:', error.message);
            res.status(400).json({ 
                error: error.message || 'Ошибка добавления игры' 
            });
        }
    }
    
    static async search(req, res) {
        // Позже: поиск без добавления
        res.json({ message: 'Поиск реализован позже' });
    }
}

module.exports = GameController;