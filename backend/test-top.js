// test-add-top.js
require('dotenv').config();
const GameService = require('./services/gameService');

async function test() {
    try {
        const results = await GameService.addTopRatedGames(5);
        
        console.log('\n📋 ДЕТАЛИ:');
        results.forEach(r => {
            if (r.status === 'added') {
                console.log(`   ✅ ${r.name} (ID: ${r.gameId}, рейтинг: ${r.rating?.toFixed(2)})`);
            } else if (r.status === 'skipped') {
                console.log(`   ⏭️ ${r.name} (уже есть)`);
            } else {
                console.log(`   ❌ ${r.name} (ошибка: ${r.error})`);
            }
        });
        
    } catch (error) {
        console.error('❌ Ошибка:', error.message);
    }
}

test();