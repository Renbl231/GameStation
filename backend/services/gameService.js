// services/simpleGameService.js
const db = require('../config/db');
const { igdbRequest } = require('../config/api');

class SimpleGameService {

    static async checkGame(gameName) {
        const [rows] = await db.execute(
            'SELECT idGame FROM Games WHERE name = ?', [gameName]
        )
        return rows.length > 0
    }

    static async searchAndAddGame(gameName) {

        const exists = await this.checkGame(gameName)
        if(exists) {
            throw new Error(`Игра "${gameName}" уже существует в базе`)
        }
        
        const query = `fields id,name,first_release_date,involved_companies.company.name,cover.image_id,release_dates.status,platforms.id,genres.id,themes.id,game_modes.id,player_perspectives.id,screenshots.*; where name = "${gameName}"; limit 1;`;

        try {
            const igdbRes = await igdbRequest('games', query);
            
            if (!igdbRes.data.length) {
                throw new Error(`Игра "${gameName}" не найдена`);
            }
            
            const game = igdbRes.data[0];
            const gameId = await this.saveGameData(game);
            
             const handlers = {
                platforms: this.saveGamePlatforms,
                genres: this.saveGameGenres,
                themes: this.saveGameThemes,
                game_modes: this.saveGameModes,
                player_perspectives: this.saveGamePerspectives,
                screenshots: this.saveGameScreenshots
            };
            
            for (const [key, handler] of Object.entries(handlers)) {
                if (game[key]?.length) {
                    await handler(gameId, game[key]);
                }
            }
    
            console.log('✅ ДОБАВЛЕНЫ! Game ID:', gameId);
            return gameId;
            
        } catch (error) {
            console.error('💥 ОШИБКА:', error.message);
            if (error.response?.data) {
                console.error('📄 IGDB:', JSON.stringify(error.response.data, null, 2));
            }
            throw error;
        }
    }
    
    static async saveGameData(game) {
        const developer = game.involved_companies?.[0]?.company?.name || null;
        const publisher = game.involved_companies?.[1]?.company?.name || null;
        const coverUrl = game.cover?.image_id ? 
        `https://images.igdb.com/igdb/image/upload/t_cover_big_2x/${game.cover.image_id}.jpg` : null;
        const releaseDate = game.first_release_date ? new Date(game.first_release_date * 1000) : null;

                // https://images.igdb.com/igdb/image/upload/t_720p/coabgu.jpg

        let gameStatus = 'released';
        if (game.release_dates?.[0]) {
            const releaseStatus = game.release_dates[0].status;
            if (releaseStatus === 1) gameStatus = 'Вышла';
            else if (releaseStatus === 2) gameStatus = 'Анонсирована';
            else if (releaseStatus === 0) gameStatus = 'tbc';
            else if (releaseStatus === 3) gameStatus = 'В разработке';
            else if (releaseStatus === 4) gameStatus = 'Альфа';
            else if (releaseStatus === 5) gameStatus = 'Бета';
        }
        
        const [result] = await db.execute(`
            INSERT INTO Games (igdb_id, name, developer, publisher, status, release_date, cover_url)
            VALUES (?, ?, ?, ?, ?, ?, ?)
        `, [game.id, game.name, developer, publisher, gameStatus, releaseDate, coverUrl]);
        
        return result.insertId;
    }
    
    static async saveGamePlatforms(gameId, platforms) {
        if (!platforms?.length) return;
        
        const platformInserts = platforms.map(p => [gameId, p.id]);
        const values = platformInserts.map(() => '(?, ?)').join(', ');
        const params = platformInserts.flat();
        
        await db.execute(`
            INSERT IGNORE INTO GamePlatforms (game_id, platform_id) 
            VALUES ${values}
        `, params);
    }  

    static async saveGameGenres(gameId, genres) {
        if(!genres?.length) return;

        const genresInserts = genres.map(g => [gameId, g.id]);
        const values = genresInserts.map(() => '(?, ?)').join(', '); 
        const params = genresInserts.flat();  

        await db.execute(`
            INSERT IGNORE INTO GameGenres (game_id, genre_id) VALUES ${values}
            `, params);
    }

    static async saveGameThemes(gameId, themes) {
        if(!themes?.length) return

        const themesInserts = themes.map(t => [gameId, t.id]);
        const values = themesInserts.map(() => '(?, ?)').join(', ');
        const params = themesInserts.flat();

        await db.execute(`
            INSERT IGNORE INTO GameThemes (game_id, theme_id) VALUES ${values}
            `, params)
    }

    static async saveGameModes(gameId, gameModes) {
        if(!gameModes?.length) return;

        const modesInserts = gameModes.map(m => [gameId, m.id]);
        const values = modesInserts.map(() => '(?, ?)').join(', ');
        const params = modesInserts.flat();

        await db.execute(`
            INSERT IGNORE INTO GameModes (game_id, mode_id) 
            VALUES ${values}
        `, params);
        
    }

    static async saveGamePerspectives(gameId, perspectives) {
        if(!perspectives?.length) return;

        const perspectivesInserts = perspectives.map(m => [gameId, m.id]);
        const values = perspectivesInserts.map(() => '(?, ?)').join(', ');
        const params = perspectivesInserts.flat();

        await db.execute(`
            INSERT IGNORE INTO GamePerspectives (game_id, perspective_id) 
            VALUES ${values}
        `, params);
        
    }

    static async saveGameScreenshots(gameId, screenshots) {
        if (!screenshots?.length) return;

        // ✅ ИСПРАВЛЕНИЕ: map ДО сохранения!
        const screenshotIds = screenshots.map(s => s.image_id).filter(Boolean);
        const topScreenshots = screenshotIds.slice(0, 5);
        
        const screenshotInserts = topScreenshots.map(id => [gameId, id]);
        const values = screenshotInserts.map(() => '(?, ?)').join(', ');
        const params = screenshotInserts.flat();

        await db.execute(`
            INSERT IGNORE INTO Screenshots (game_id, image_id) 
            VALUES ${values}
        `, params);
        
    }


}

module.exports = SimpleGameService;
