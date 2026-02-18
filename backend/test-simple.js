
const SimpleGameService = require('./services/gameService');

async function test() {
    const TEST_GAME = "Dishonored";  // ← Твоя игра!
    
    console.log('🚀 Добавляем в БД:', TEST_GAME);
    console.log('='.repeat(60));
    
    try {
        const gameId = await SimpleGameService.searchAndAddGame(TEST_GAME);
        console.log('\n🎉 УСПЕХ!');
        console.log(`✅ Dishonored 2 добавлена! ID: ${gameId}`);
    } catch (error) {
        console.error('💥 ОШИБКА:', error.message);
    }
}

test();
