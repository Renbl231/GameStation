const db = require('../config/db');
const { igdbRequest } = require('../config/api');
const axios = require('axios');

class GameService {

    static async checkGame(gameName) {
        const [rows] = await db.execute(
            'SELECT idGame FROM Games WHERE name = ?', [gameName]
        )
        return rows.length > 0
    }

    static async findSteamId(gameName) {
    try {
        console.log(`\n🔍 Ищем Steam ID для: "${gameName}"`);
        
        const searchVariants = [
            gameName,  // оригинал
            gameName.replace(/:|!/g, '').trim(),  // без двоеточий
            gameName.split(':')[0].trim(),  // только первая часть
            gameName.replace(/\s+/g, ' ')  // нормализация пробелов
        ];
        
        const uniqueVariants = [...new Set(searchVariants)];
        
        for (const variant of uniqueVariants) {
            try {
                const response = await axios.get(
                    'https://store.steampowered.com/api/storesearch',
                    {
                        params: {
                            term: variant,
                            l: 'english',
                            cc: 'US'
                        },
                        timeout: 5000
                    }
                );

                if (response.data?.items?.length > 0) {
                    
                    // Ищем точное совпадение
                    const exactMatch = response.data.items.find(
                        item => item.name.toLowerCase() === gameName.toLowerCase()
                    );
                    
                    if (exactMatch) {
                        console.log(`🎯 Точное совпадение: "${exactMatch.name}" (ID: ${exactMatch.id})`);
                        return exactMatch.id;
                    }
                    
                    // Ищем частичное совпадение
                    const partialMatch = response.data.items.find(
                        item => item.name.toLowerCase().startsWith(gameName.toLowerCase().split(':')[0].toLowerCase())
                    );
                    
                    if (partialMatch) {
                        return partialMatch.id;
                    }
                    
                    const first = response.data.items[0];
                    return first.id;
                }
            } catch (e) {
                continue;
            }
        }
        
        console.log('steam_id игры не найден');
        return null;

    } catch (error) {
        console.error('Ошибка поиска:', error.message);
        return null;
    }
}
    
static async getSteamData(steamId) {
    try {
        
        const response = await axios.get(
            'https://store.steampowered.com/api/appdetails',
            {
                params: {
                    appids: steamId,
                    l: 'russian',
                    cc: 'US'
                },
                timeout: 10000
            }
        );

        const gameData = response.data[steamId];
        
        if (!gameData?.success || !gameData?.data) {
            console.log('Нет данных в steam об игре');
            return null;
        }

        const data = gameData.data;
        
        const description = (data.short_description || data.about_the_game || '')
            .replace(/<[^>]*>/g, '')
            .replace(/\s+/g, ' ')
            .trim();

        const banner = `https://steamcdn-a.akamaihd.net/steam/apps/${steamId}/library_hero.jpg`;

        let trailer = null;
        
        if (data.movies && data.movies.length > 0) {
            
            // Ищем gameplay trailer
            const gameplayVideo = data.movies.find(m => 
                m.name.toLowerCase().includes('gameplay')
            );
            
            // Ищем launch trailer
            const launchVideo = data.movies.find(m => 
                m.name.toLowerCase().includes('launch')
            );
            
            // Показываем что нашли
            if (gameplayVideo) {
                const movieId = gameplayVideo.id;
            } else if (launchVideo) {
                const movieId = launchVideo.id;
            }
                
            // Выбираем приоритетно gameplay, если нет - launch
            const selectedVideo = gameplayVideo || launchVideo;
            
            if (selectedVideo) {
                const movieId = selectedVideo.id;
                
                // Берём лучшее качество
                if (selectedVideo.mp4?.max) {
                    trailer = selectedVideo.mp4.max;
                } else if (selectedVideo.mp4?.high) {
                    trailer = selectedVideo.mp4.high;
                } else if (selectedVideo.mp4?.['720']) {
                    trailer = selectedVideo.mp4['720'];
                } else {
                    trailer = `https://steamcdn-a.akamaihd.net/steam/apps/${movieId}/movie_max.mp4`;
                }
            }
        }

        return {
            steam_id: steamId,
            description: description,
            banner: banner,
            trailer: trailer
        };

    } catch (error) {
        console.error('Ошибка получения Steam данных:', error.message);
        return null;
    }
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
        
            // получ steam_id
            const steamId = await this.findSteamId(game.name);
            
            if (steamId) {
                const steamData = await this.getSteamData(steamId);
                
                if (steamData) {
                    await this.updateGameSteamData(gameId, steamData);
                } else {
                    console.log('Steam данные не получены');
                }
            }
            
            await this.saveGameRelations(gameId, game);

            return gameId;
            
        } catch (error) {
            console.error('ОШИБКА:', error.message);
            if (error.response?.data) {
                console.error('📄 IGDB:', JSON.stringify(error.response.data, null, 2));
            }
            throw error;
        }
    }


    // метод в котором всё есть
    static async saveGameRelations(gameId, game) {
        const promises = [];

        if (game.platforms?.length) {
            const values = game.platforms.map(p => [gameId, p.id]);
            promises.push(
                db.query('INSERT IGNORE INTO GamePlatforms (game_id, platform_id) VALUES ?', [values])
            );
        }

        if (game.genres?.length) {
            const values = game.genres.map(g => [gameId, g.id]);
            promises.push(
                db.query('INSERT IGNORE INTO GameGenres (game_id, genre_id) VALUES ?', [values])
            );
        }

        if (game.themes?.length) {
            const values = game.themes.map(t => [gameId, t.id]);
            promises.push(
                db.query('INSERT IGNORE INTO GameThemes (game_id, theme_id) VALUES ?', [values])
            );
        }

        if (game.game_modes?.length) {
            const values = game.game_modes.map(m => [gameId, m.id]);
            promises.push(
                db.query('INSERT IGNORE INTO GameModes (game_id, mode_id) VALUES ?', [values])
            );
        }

        if (game.player_perspectives?.length) {
            const values = game.player_perspectives.map(p => [gameId, p.id]);
            promises.push(
                db.query('INSERT IGNORE INTO GamePerspectives (game_id, perspective_id) VALUES ?', [values])
            );
        }

        if (game.screenshots?.length) {
            const screenshotIds = game.screenshots
                .map(s => s.image_id)
                .filter(Boolean)
                .slice(0, 5);
            
            if (screenshotIds.length > 0) {
                const values = screenshotIds.map(id => [gameId, id]);
                promises.push(
                    db.query('INSERT IGNORE INTO Screenshots (game_id, image_id) VALUES ?', [values])
                );
            }
        }

        // Выполняем все запросы параллельно
        if (promises.length > 0) {
            await Promise.all(promises);
        }
    }

    static async saveGameData(game) {
        const developer = game.involved_companies?.[0]?.company?.name || null;
        const publisher = game.involved_companies?.[1]?.company?.name || null;
        const coverUrl = game.cover?.image_id ? 
        `https://images.igdb.com/igdb/image/upload/t_cover_big_2x/${game.cover.image_id}.jpg` : null;
        const releaseDate = game.first_release_date ? new Date(game.first_release_date * 1000) : null;

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

    static async updateGameSteamData(gameId, steamData) {
        if (!steamData) return;
        
        await db.execute(
            `UPDATE Games 
            SET steam_id = ?, 
                summary = ?,
                banner = ?,
                trailer_url = ?
            WHERE idGame = ?`,
            [
                steamData.steam_id, 
                steamData.description, 
                steamData.banner, 
                steamData.trailer, 
                gameId
            ]
        );
    }



    static async addTopRatedGames(limit = 5) {
        console.log(`\n🏆 Добавляем топ-${limit} игр по рейтингу...`);
        
        const results = [];
        let added = 0;
        let offset = 0;
        const batchSize = 20;
        
        while (added < limit) {
            const query = `fields id,name,rating; 
                        where rating > 70 & rating_count > 1000; 
                        sort rating desc; 
                        limit ${batchSize}; 
                        offset ${offset};`;
            
            try {
                const igdbRes = await igdbRequest('games', query);
                
                if (!igdbRes.data || igdbRes.data.length === 0) {
                    throw new Error(`В IGDB закончились игры для добавления`);
                }
                
                for (const game of igdbRes.data) {
                    if (added >= limit) break;
                    
                    const exists = await this.checkGame(game.name);
                    
                    if (!exists) {
                        console.log(`\n✅ Новая игра: "${game.name}"`);
                        
                        const fullQuery = `fields id,name,first_release_date,involved_companies.company.name,cover.image_id,release_dates.status,platforms.id,genres.id,themes.id,game_modes.id,player_perspectives.id,screenshots.*; where id = ${game.id};`;
                        
                        const fullRes = await igdbRequest('games', fullQuery);
                        
                        if (fullRes.data.length) {
                            const gameId = await this.saveGameData(fullRes.data[0]);
                            
                            const steamId = await this.findSteamId(game.name);
                            if (steamId) {
                                const steamData = await this.getSteamData(steamId);
                                if (steamData) {
                                    await this.updateGameSteamData(gameId, steamData);
                                }
                            }
                            
                            await this.saveGameRelations(gameId, fullRes.data[0]);
                            added++;
                            
                            results.push({
                                name: game.name,
                                status: 'added',
                                gameId: gameId,
                                rating: game.rating
                            });
                        }
                        
                        await new Promise(r => setTimeout(r, 2000));
                    }
                }
                
                offset += batchSize;
                
            } catch (error) {
                console.error('Ошибка IGDB:', error.response?.data || error.message);
                
                if (error.response?.data) {
                    console.log('📄 Детали:', JSON.stringify(error.response.data, null, 2));
                }
                break;
            }
        }
        
        return results;
    }

    

}



module.exports = GameService;
