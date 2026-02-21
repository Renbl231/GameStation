
const GameService = require('./services/gameService');

async function test() {
    const TEST_GAME = "Cyberpunk 2077";
    
    try {
        const gameId = await GameService.searchAndAddGame(TEST_GAME);
        console.log('Успех');
    } catch (error) {
        console.error('Ошибка:', error.message);
    }
}

test();
