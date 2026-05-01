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
            const coverUrl = game.cover?.image_id 
            ? `https://images.igdb.com/igdb/image/upload/t_cover_big_2x/${game.cover.image_id}.jpg`
            : null;
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

            return [{
                name: game.name,
                gameId: gameId,
                cover: coverUrl
            }];
            
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

        const statusMap = {
            0: 'tbc',
            1: 'Вышла',
            2: 'Анонсирована',
            3: 'В разработке',
            4: 'Альфа',
            5: 'Бета'
        }

        const releaseStatus = Number(game.release_dates?.[0]?.status)
        let gameStatus = statusMap[releaseStatus] || 'Вышла'

        console.log('release date object:', game.release_dates?.[0])
        console.log('release status:', releaseStatus)
        console.log('gameStatus:', gameStatus)
                    
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
        console.log(`\nДобавляем топ-${limit} игр по рейтингу...`);
        
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
                            const fullGame = fullRes.data[0];
                            const gameId = await this.saveGameData(fullRes.data[0]);
                            const coverUrl = fullGame.cover?.image_id 
                            ? `https://images.igdb.com/igdb/image/upload/t_cover_big_2x/${fullGame.cover.image_id}.jpg`
                            : null;
                            
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
                                cover: coverUrl,
                                gameId: gameId
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

    static async addGameByUser(formData) {

        const exists = await this.checkGame(formData.name?.trim())
        if(exists) {
            throw new Error(`Игра "${formData.name}" уже существует в базе`)
        }

        const [gameResult] = await db.execute(`
            INSERT INTO Games (
                name, summary, developer, publisher, status,
                release_date, trailer_url, cover_url, banner
            ) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)
        `, [
            formData.name?.trim() || null,
            formData.summary?.trim() || null,
            formData.developer?.trim() || null,
            formData.publisher?.trim() || null,
            formData.status?.trim() || null,
            formData.release_date || null,
            formData.trailer_url?.trim() || null,
            formData.cover_url?.trim() || null,
            formData.baner?.trim() || null
        ]);

        const gameId = gameResult.insertId;

        const promises = [];

        if (formData.genres?.length > 0) {
            const genresValues = formData.genres.map(g => [gameId, g]).flat();
            promises.push(
                db.execute(`
                    INSERT IGNORE INTO GameGenres (game_id, genre_id) 
                    VALUES ${formData.genres.map(() => '(?, ?)').join(',')}
                `, genresValues)
            );
        }

        if (formData.platforms?.length > 0) {
            const platformsValues = formData.platforms.map(p => [gameId, p]).flat();
            promises.push(
                db.execute(`
                    INSERT IGNORE INTO GamePlatforms (game_id, platform_id) 
                    VALUES ${formData.platforms.map(() => '(?, ?)').join(',')}
                `, platformsValues)
            );
        }

        if (formData.modes?.length > 0) {
            const modesValues = formData.modes.map(m => [gameId, m]).flat();
            promises.push(
                db.execute(`
                    INSERT IGNORE INTO GameModes (game_id, mode_id) 
                    VALUES ${formData.modes.map(() => '(?, ?)').join(',')}
                `, modesValues)
            );
        }

        if (formData.themes?.length > 0) {
            const themesValues = formData.themes.map(t => [gameId, t]).flat();
            promises.push(
                db.execute(`
                    INSERT IGNORE INTO GameThemes (game_id, theme_id) 
                    VALUES ${formData.themes.map(() => '(?, ?)').join(',')}
                `, themesValues)
            );
        }

        if (formData.perspectives?.length > 0) {
            const perspectivesValues = formData.perspectives.map(p => [gameId, p]).flat();
            promises.push(
                db.execute(`
                    INSERT IGNORE INTO GamePerspectives (game_id, perspective_id) 
                    VALUES ${formData.perspectives.map(() => '(?, ?)').join(',')}
                `, perspectivesValues)
            );
        }

        const screenshots = (formData.screenshots || []).filter(url => url?.trim());        
        if (screenshots.length > 0) {
            const screenshotInserts = screenshots.map(url => [gameId, url.trim()]);
            promises.push(
                db.execute(`
                    INSERT IGNORE INTO Screenshots (game_id, image_url) 
                    VALUES ${screenshots.map(() => '(?, ?)').join(',')}
                `, screenshotInserts.flat())
            );
        }

        await Promise.all(promises);

        return {
            name: formData.name?.trim() || '',
            cover: formData.cover_url?.trim() || null,
            gameId: gameId
        };
    }
    
    static async getSlides() {
        const [settings] = await db.execute(
            'SELECT slider_mode FROM AppSettings WHERE id = 1'
        )

        const sliderMode = settings[0]?.slider_mode
        let result = []

        if (sliderMode === 'best') {
            const [rows] = await db.execute(
            `SELECT idGame, name, release_date, banner
            FROM Games
            WHERE banner IS NOT NULL AND rating_overall > 8
            ORDER BY RAND()
            LIMIT 3`
            )
            result = rows
        } else if (sliderMode === 'expected') {
            const [rows] = await db.execute(
            `SELECT idGame, name, release_date, banner
            FROM Games
            WHERE banner IS NOT NULL AND status = 'Анонсирована'
            ORDER BY sort_order DESC, release_date ASC
            LIMIT 3`
            )
            result = rows
        }

        const gameIds = result.map(game => game.idGame)

        if(gameIds.length) {
            const [platformsRows] = await db.execute(
                `SELECT gp.game_id, p.name AS platform
                 FROM GamePlatforms gp
                 LEFT JOIN Platforms p ON p.idPlatform = gp.platform_id
                 WHERE gp.game_id IN (${gameIds.map(() => '?').join(',')})`,
                 gameIds
            )

            const grouped = {}

            const excludePlatforms = ["Mac", "64", "Linux", "PlayStation"]

            for (const row of platformsRows) {
                if (!grouped[row.game_id]) grouped[row.game_id] = []
                if (grouped[row.game_id].length < 3 && !excludePlatforms.includes(row.platform)) {
                    grouped[row.game_id].push(row.platform)
                }
            }

            result = result.map(game => ({
                ...game,
                platforms: grouped[game.idGame] || []
            }))
        }

        else {
            result = result.map(game => ({
                ...game,
                platforms: []
            }))
        }

        return {
            sliderMode,
            result
        }
    }

    static async changeSliderMode(mode) {
        const [result] = await db.execute(
            `UPDATE AppSettings SET slider_mode = ? WHERE id = 1`, [mode]
        )

        if(result.affectedRows === 0) {
            throw { status: 404, message: 'Настройка не найдена' }
        }

        return true
    }
    
    static async RequestAddGame(form, user_id) {
        const [result] = await db.execute(
            `INSERT INTO GameRequests (nameGame, store_url, cover_url, baner_url, user_id)
            VALUES (?, ?, ?, ?, ?)`,
            [
                form.nameGame.trim(), form.store_url.trim(), form.cover_url.trim(), 
                form.baner_url ? form.baner_url.trim() : null, user_id
            ]
        )

        return result
    }

    static async GetFilterData() {
        const [platforms] = await db.execute('SELECT idPlatform, name FROM Platforms')
        return {
            platforms
        }
    } 

    // Игровой каталог

    static async GetGameCatalog(
        page = 1, limit = 40, sort = null, platforms = [], brands = [], ratingMin = 0, 
        ratingMax = 10, modes = [], perspectives = [], themes = [], releaseDate = null
    ) {
        const safePage = Math.max(1, parseInt(page) || 1)
        const safeLimit = Math.min(40, Math.max(1, parseInt(limit) || 40))
        const offset = (safePage - 1) * safeLimit

        let orderBy = 'g.release_date DESC'
        if (sort === 'rating') orderBy = 'g.rating_overall DESC'
        else if (sort === 'popularity') orderBy = 'g.rating_counter DESC'
        else if (sort === 'alphabet') orderBy = 'g.name ASC'
        else if (sort === 'expected') orderBy = 'g.release_date ASC'
        else if (sort === 'recently') orderBy = 'g.idGame DESC'
        else if (sort === 'editors-estimate') orderBy = 'g.rating_overall DESC'

        const hasPlatformFilter = Array.isArray(platforms) && platforms.length > 0
        const hasBrandFilter = Array.isArray(brands) && brands.length > 0 
        const hasModeFilter = Array.isArray(modes) &&  modes.length > 0
        const hasPerspectiveFilter = Array.isArray(perspectives) && perspectives.length > 0
        const hasThemeFilter = Array.isArray(themes) && themes.length > 0

        const platformPlaceholders = hasPlatformFilter ? platforms.map(() => '?').join(',') : ''
        const brandPlaceholders = hasBrandFilter ? brands.map(() => '?').join(',') : ''
        const modePlaceholders = hasModeFilter ? modes.map(() => '?').join(',') : ''
        const perspectivePlaceholders = hasPerspectiveFilter ? perspectives.map(() => '?').join(',') : ''
        const themePlaceholders = hasThemeFilter ? themes.map(() => '?').join(',') : ''

        const whereParts = []
            const params = [
            ...(hasPlatformFilter ? platforms : []),
            ...(hasBrandFilter ? brands : []),
            ...(hasModeFilter ? modes : []), 
            ...(hasPerspectiveFilter ? perspectives : []),
            ...(hasThemeFilter ? themes : []),
        ]


        if (hasPlatformFilter) {
            whereParts.push(`
            EXISTS (
                SELECT 1
                FROM GamePlatforms gp_filter
                WHERE gp_filter.game_id = g.idGame
                AND gp_filter.platform_id IN (${platformPlaceholders})
            )
            `)
        }

        if (hasBrandFilter) {
            whereParts.push(`
            EXISTS (
                SELECT 1
                FROM GamePlatforms gp_filter
                JOIN Platforms p_filter ON p_filter.idPlatform = gp_filter.platform_id
                WHERE gp_filter.game_id = g.idGame
                AND p_filter.brand_id IN (${brandPlaceholders})
            )
            `)
        }

        if (hasModeFilter) {
            whereParts.push(`
                EXISTS (
                SELECT 1
                FROM GameModes gm_mode
                WHERE gm_mode.game_id = g.idGame
                AND gm_mode.mode_id IN (${modePlaceholders})
                )
            `)
        }

        if (hasPerspectiveFilter) {
            whereParts.push(`
                EXISTS (
                SELECT 1
                FROM GamePerspectives gp_perspective
                WHERE gp_perspective.game_id = g.idGame
                    AND gp_perspective.perspective_id IN (${perspectivePlaceholders})
                )
            `)
        }

        if(hasThemeFilter) {
            whereParts.push(`
                EXISTS (
                    SELECT 1
                    FROM GameThemes gt_theme
                    WHERE gt_theme.game_id = g.idGame
                    AND gt_theme.theme_id IN (${themePlaceholders})
                )    
            `)
        }

        

        if (ratingMin > 0 && ratingMax < 10) {
            whereParts.push(`g.rating_overall BETWEEN ? AND ?`)
            params.push(ratingMin, ratingMax)
            } else if (ratingMin > 0) {
            whereParts.push(`g.rating_overall >= ?`)
            params.push(ratingMin)
            } else if (ratingMax < 10) {
            whereParts.push(`g.rating_overall <= ?`)
            params.push(ratingMax)
        }

        if (releaseDate) {
            if (releaseDate.includes('-')) {
                const [fromYear, toYear] = releaseDate.split('-').map(Number)
                whereParts.push(`YEAR(g.release_date) BETWEEN ? AND ?`)
                params.push(fromYear, toYear)
            } else {
                whereParts.push(`YEAR(g.release_date) = ?`)
                params.push(Number(releaseDate))
            }
        }


        const whereClause = whereParts.length ? `WHERE ${whereParts.join(' AND ')}` : ''

        const countSql = `
            SELECT COUNT(DISTINCT g.idGame) AS total
            FROM Games g
            ${whereClause}
        `

        const listSql = `
            SELECT
            g.idGame,
            g.name,
            g.rating_overall,
            g.rating_counter,
            g.release_date,
            g.cover_url,
            gen.genres,
            modes_tbl.modes,
            per.perspectives,
            plat.platforms,
            th.themes
            FROM Games g
            LEFT JOIN (
            SELECT gg.game_id, JSON_ARRAYAGG(g.name) AS genres
            FROM GameGenres gg
            JOIN Genres g ON g.idGenre = gg.genre_id
            GROUP BY gg.game_id
            ) gen ON gen.game_id = g.idGame
            LEFT JOIN (
            SELECT gm.game_id, JSON_ARRAYAGG(m.name) AS modes
            FROM GameModes gm
            JOIN Modes m ON m.idMode = gm.mode_id
            GROUP BY gm.game_id
            ) modes_tbl ON modes_tbl.game_id = g.idGame
            LEFT JOIN (
            SELECT gp.game_id, JSON_ARRAYAGG(p.name) AS perspectives
            FROM GamePerspectives gp
            JOIN Perspectives p ON p.idPerspective = gp.perspective_id
            GROUP BY gp.game_id
            ) per ON per.game_id = g.idGame
            LEFT JOIN (
            SELECT gp.game_id, JSON_ARRAYAGG(p.name) AS platforms
            FROM GamePlatforms gp
            JOIN Platforms p ON p.idPlatform = gp.platform_id
            GROUP BY gp.game_id
            ) plat ON plat.game_id = g.idGame
            LEFT JOIN (
            SELECT gt.game_id, JSON_ARRAYAGG(t.name) AS themes
            FROM GameThemes gt
            JOIN Themes t ON t.idTheme = gt.theme_id
            GROUP BY gt.game_id
            ) th ON th.game_id = g.idGame
            ${whereClause}
            ORDER BY ${orderBy}
            LIMIT ${safeLimit} OFFSET ${offset}
        `

        const [countRows] = await db.execute(countSql, params)
        const total = Number(countRows?.[0]?.total ?? 0)

        const [games] = await db.execute(listSql, params)

        return {
            games: games.map(game => {
            const parseArr = (value) => {
                if (!value) return []
                if (Array.isArray(value)) return value
                try {
                return JSON.parse(value)
                } catch {
                return []
                }
            }

            const tags = [
                ...parseArr(game.genres),
                ...parseArr(game.modes),
                ...parseArr(game.perspectives),
                ...parseArr(game.themes),
            ]

            return {
                ...game,
                rating_overall: Number(game.rating_overall),
                rating_counter: Number(game.rating_counter),
                tags: [...new Set(tags)],
            }
            }),
            totalPages: Math.ceil(total / safeLimit),
            currentPage: safePage,
            perPage: safeLimit
        }
    }

    static async GetMyRating(game_id, user_id) {
        const [[ratingRows], [collectionRows]] = await Promise.all([
            db.execute(
                `SELECT overall_score, gameplay, graphics, story, music, atmosphere, optimization, innovation
                FROM GameRatings
                WHERE game_id = ? AND user_id = ?`,
                [game_id, user_id]
            ),
            db.execute(
                `SELECT collection_type
                FROM UserCollections
                WHERE game_id = ? AND user_id = ?`,
                [game_id, user_id]
            )
        ])

        return {
            rating: ratingRows[0] || null,
            collection_type: collectionRows[0]?.collection_type || null
        }
    }

    static async AddToCollection(collection_type, game_id, user_id) {
        const [existGame, existRating] = await Promise.all([
            db.execute('SELECT idGame FROM Games WHERE idGame = ?', [game_id]),
            db.execute(
                'SELECT idCollection, collection_type FROM UserCollections WHERE user_id = ? AND game_id = ?',
                [user_id, game_id]
            )
        ])

        const gamesRows = existGame[0]
        const ratingRows = existRating[0]

        if (!gamesRows.length) {
            throw { status: 400, message: 'Игра не найдена' }
        }

        if (ratingRows.length > 0 && ratingRows[0].collection_type === collection_type) {
            await db.execute(
                'DELETE FROM UserCollections WHERE user_id = ? AND game_id = ?',
                [user_id, game_id]
            )
            return { action: 'deleted', collection_type: null }
        }

        if (ratingRows.length > 0) {
            await db.execute(
                'UPDATE UserCollections SET collection_type = ? WHERE user_id = ? AND game_id = ?',
                [collection_type, user_id, game_id]
            )
            return { action: 'updated', collection_type }
        }

        await db.execute(
            'INSERT INTO UserCollections (user_id, game_id, collection_type) VALUES (?, ?, ?)',
            [user_id, game_id, collection_type]
        )

        return { action: 'inserted', collection_type }
    }

    static async EstimateGame(type, user_id, game_id, simpleScore, ratings, totalScore) {
        const [existGame, existRating] = await Promise.all([
            db.execute('SELECT idGame FROM Games WHERE idGame = ?', [game_id]),
            db.execute(
                'SELECT idGameRating FROM GameRatings WHERE user_id = ? AND game_id = ?',
                [user_id, game_id]
            )
        ])

        const gamesRows = existGame[0]
        const ratingRows = existRating[0]

        if (!gamesRows.length) {
            throw { status: 400, message: 'Игра не найдена' }
        }

        if (type === 'simple') {
            if (ratingRows.length > 0) {
                await db.execute(
                    `UPDATE GameRatings
                    SET overall_score = ?, gameplay = ?, graphics = ?, story = ?, music = ?, atmosphere = ?, optimization = ?, innovation = ?
                    WHERE user_id = ? AND game_id = ?`,
                    [simpleScore, 0, 0, 0, 0, 0, 0, 0, user_id, game_id]
                )
                return { action: 'updated' }
            }

            await db.execute(
                'INSERT INTO GameRatings (game_id, user_id, overall_score) VALUES (?, ?, ?)',
                [game_id, user_id, simpleScore]
            )
            return { action: 'inserted' }
        }

        if (type === 'detail') {
            const ratingMap = {
                gameplay: ratings.find(item => item.name === 'Геймплей')?.score ?? null,
                graphics: ratings.find(item => item.name === 'Графика')?.score ?? null,
                story: ratings.find(item => item.name === 'Сюжет')?.score ?? null,
                music: ratings.find(item => item.name === 'Музыка')?.score ?? null,
                atmosphere: ratings.find(item => item.name === 'Атмосфера')?.score ?? null,
                optimization: ratings.find(item => item.name === 'Оптимизация')?.score ?? null,
                innovation: ratings.find(item => item.name === 'Инновация')?.score ?? null
            }

            if (ratingRows.length > 0) {
                await db.execute(
                    `UPDATE GameRatings
                    SET overall_score = ?, gameplay = ?, graphics = ?, story = ?, music = ?, atmosphere = ?, optimization = ?, innovation = ?
                    WHERE user_id = ? AND game_id = ?`,
                    [
                        totalScore,
                        ratingMap.gameplay,
                        ratingMap.graphics,
                        ratingMap.story,
                        ratingMap.music,
                        ratingMap.atmosphere,
                        ratingMap.optimization,
                        ratingMap.innovation,
                        user_id,
                        game_id
                    ]
                )
                return true
            }

            await db.execute(
                `INSERT INTO GameRatings
                (game_id, user_id, overall_score, gameplay, graphics, story, music, atmosphere, optimization, innovation)
                VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)`,
                [
                    game_id,
                    user_id,
                    totalScore,
                    ratingMap.gameplay,
                    ratingMap.graphics,
                    ratingMap.story,
                    ratingMap.music,
                    ratingMap.atmosphere,
                    ratingMap.optimization,
                    ratingMap.innovation
                ]
            )
            return true
        }         
    }

    static async DeleteEstimate(game_id, user_id) {
        const [result] = await db.execute(
            `DELETE FROM GameRatings WHERE game_id = ? AND user_id = ?`,
            [game_id, user_id]
        )

        if (result.affectedRows === 0) {
            throw { status: 404, message: 'Оценка не найдена' }
        }

        return true
    }

   static async GetGameById(id) {
        const [rows] = await db.execute(
            `
            SELECT 
            g.idGame,
            g.name,
            g.summary,
            g.rating_overall,
            g.rating_counter,
            g.developer,
            g.publisher,
            g.status,
            g.release_date,
            g.trailer_url,
            g.cover_url,
            g.banner,
            sc.screenshots,
            gen.genres,
            modes_tbl.modes,
            per.perspectives,
            th.themes,
            plat.platforms
            FROM Games g
            LEFT JOIN (
                SELECT s.game_id,
                    JSON_ARRAYAGG(
                        JSON_OBJECT(
                        'idScreenshot', s.idScreenshot,
                        'image_id', s.image_id,
                        'image_url', s.image_url
                        )
                    ) AS screenshots
                FROM Screenshots s
                GROUP BY s.game_id
            ) sc ON sc.game_id = g.idGame
            LEFT JOIN (
                SELECT gg.game_id, JSON_ARRAYAGG(gen.name) AS genres
                FROM GameGenres gg
                JOIN Genres gen ON gen.idGenre = gg.genre_id
                GROUP BY gg.game_id
            ) gen ON gen.game_id = g.idGame
            LEFT JOIN (
                SELECT gm.game_id, JSON_ARRAYAGG(m.name) AS modes
                FROM GameModes gm
                JOIN Modes m ON m.idMode = gm.mode_id
                GROUP BY gm.game_id
            ) modes_tbl ON modes_tbl.game_id = g.idGame
            LEFT JOIN (
                SELECT gp.game_id, JSON_ARRAYAGG(p.name) AS perspectives
                FROM GamePerspectives gp
                JOIN Perspectives p ON p.idPerspective = gp.perspective_id
                GROUP BY gp.game_id
            ) per ON per.game_id = g.idGame
            LEFT JOIN (
                SELECT gt.game_id, JSON_ARRAYAGG(t.name) AS themes
                FROM GameThemes gt
                JOIN Themes t ON t.idTheme = gt.theme_id
                GROUP BY gt.game_id
            ) th ON th.game_id = g.idGame
            LEFT JOIN (
                SELECT gp.game_id, JSON_ARRAYAGG(p.name) AS platforms
                FROM GamePlatforms gp
                JOIN Platforms p ON p.idPlatform = gp.platform_id
                GROUP BY gp.game_id
            ) plat ON plat.game_id = g.idGame
            WHERE g.idGame = ?
            `,
            [id]
        )

        const game = rows[0]
        if (!game) return null

        const parseArr = (value) => {
            if (!value) return []
            if (Array.isArray(value)) return value
            try {
                return JSON.parse(value)
            } catch {
                return []
            }
        }

          const tags = [
            ...parseArr(game.genres),
            ...parseArr(game.modes),
            ...parseArr(game.perspectives),
            ...parseArr(game.themes),
        ]

          return {
            ...game,
            tags: [...new Set(tags)],
        }
    }



    static async GetUserGameInfoById(game_id, user_id) {
        const [[scoreRows], [collectionRows], [reviewRows]] = await Promise.all([
            db.execute(
                'SELECT idGameRating, overall_score FROM GameRatings WHERE game_id = ? AND user_id = ?',
                [game_id, user_id]
            ),
            db.execute(
                'SELECT collection_type FROM UserCollections WHERE user_id = ? AND game_id = ?',
                [user_id, game_id]
            ),
            db.execute(
                'SELECT idReview FROM Reviews WHERE game_id = ? AND user_id = ?',
                [game_id, user_id]
            )
        ])

        return {
            score: scoreRows[0]?.overall_score ?? null,
            collection_type: collectionRows[0]?.collection_type ?? null,
            rating_id: scoreRows[0]?.idGameRating ?? null,
            review_id: reviewRows[0]?.idReview ?? null
        }
    }

    static async DeleteGameById(game_id) {
        const [rows] = await db.execute(
            'DELETE FROM Games WHERE idGame = ?',
            [game_id]
        )

        if(rows.affectedRows === 0) {
            throw {status: 404, message: 'Игра не найдена или нет прав на удаление'}
        }

        return true
    }

    static async SearchGames(query) {
        const [results] = await db.execute(
            `SELECT idGame, name, cover_url
            FROM Games
            WHERE name LIKE ?`,
            [`%${query}%`]
        )

        return results
    }







    static async EditGameById(gameId, formData) {
    const [exists] = await db.execute(
        'SELECT idGame FROM Games WHERE idGame = ?',
        [gameId]
    )

    if (exists.length === 0) {
        throw { status: 404, message: 'Игра не найдена' }
    }

    const [gameResult] = await db.execute(
        `UPDATE Games
        SET
        name = ?,
        summary = ?,
        developer = ?,
        publisher = ?,
        status = ?,
        release_date = ?,
        trailer_url = ?,
        cover_url = ?,
        banner = ?
        WHERE idGame = ?`,
        [
        formData.name?.trim() || null,
        formData.summary?.trim() || null,
        formData.developer?.trim() || null,
        formData.publisher?.trim() || null,
        formData.status?.trim() || null,
        formData.release_date || null,
        formData.trailer_url?.trim() || null,
        formData.cover_url?.trim() || null,
        formData.baner?.trim() || null,
        gameId
        ]
    )

    if (gameResult.affectedRows === 0) {
        throw { status: 404, message: 'Игра не найдена или не обновлена' }
    }

    await db.execute('DELETE FROM GameGenres WHERE game_id = ?', [gameId])
    await db.execute('DELETE FROM GamePlatforms WHERE game_id = ?', [gameId])
    await db.execute('DELETE FROM GameModes WHERE game_id = ?', [gameId])
    await db.execute('DELETE FROM GameThemes WHERE game_id = ?', [gameId])
    await db.execute('DELETE FROM GamePerspectives WHERE game_id = ?', [gameId])
    await db.execute('DELETE FROM Screenshots WHERE game_id = ?', [gameId])

    const promises = []

    if (formData.genres?.length > 0) {
        const values = formData.genres.map(g => [gameId, g]).flat()
        promises.push(
        db.execute(
            `INSERT IGNORE INTO GameGenres (game_id, genre_id)
            VALUES ${formData.genres.map(() => '(?, ?)').join(',')}`,
            values
        )
        )
    }

    if (formData.platforms?.length > 0) {
        const values = formData.platforms.map(p => [gameId, p]).flat()
        promises.push(
        db.execute(
            `INSERT IGNORE INTO GamePlatforms (game_id, platform_id)
            VALUES ${formData.platforms.map(() => '(?, ?)').join(',')}`,
            values
        )
        )
    }

    if (formData.modes?.length > 0) {
        const values = formData.modes.map(m => [gameId, m]).flat()
        promises.push(
        db.execute(
            `INSERT IGNORE INTO GameModes (game_id, mode_id)
            VALUES ${formData.modes.map(() => '(?, ?)').join(',')}`,
            values
        )
        )
    }

    if (formData.themes?.length > 0) {
        const values = formData.themes.map(t => [gameId, t]).flat()
        promises.push(
        db.execute(
            `INSERT IGNORE INTO GameThemes (game_id, theme_id)
            VALUES ${formData.themes.map(() => '(?, ?)').join(',')}`,
            values
        )
        )
    }

    if (formData.perspectives?.length > 0) {
        const values = formData.perspectives.map(p => [gameId, p]).flat()
        promises.push(
        db.execute(
            `INSERT IGNORE INTO GamePerspectives (game_id, perspective_id)
            VALUES ${formData.perspectives.map(() => '(?, ?)').join(',')}`,
            values
        )
        )
    }

    const isUrl = (value) => {
  try {
    const url = new URL(value)
    return url.protocol === 'http:' || url.protocol === 'https:'
  } catch {
    return false
  }
}

const screenshots = (formData.screenshots || [])
  .map(item => {
    if (!item) return null

    if (typeof item === 'string') {
      const value = item.trim()
      if (!value) return null

      if (isUrl(value)) {
        return { image_id: null, image_url: value }
      }

      return { image_id: value, image_url: null }
    }

    const imageId = item.image_id?.trim() || null
    const imageUrl = item.image_url?.trim() || null

    if (imageUrl) {
      return { image_id: null, image_url: imageUrl }
    }

    if (imageId) {
      return { image_id: imageId, image_url: null }
    }

    return null
  })
  .filter(Boolean)

    if (screenshots.length > 0) {
    const screenshotValues = screenshots.flatMap(s => [
        gameId,
        s.image_id,
        s.image_url
    ])

    promises.push(
        db.execute(
        `INSERT IGNORE INTO Screenshots (game_id, image_id, image_url)
        VALUES ${screenshots.map(() => '(?, ?, ?)').join(',')}`,
        screenshotValues
        )
    )
    }

    await Promise.all(promises)

    return {
        gameId
    }
}

    static async ReviewGame(game_id, user_id, rating_id, reviewForm) {
        const [[existRating], [existReview]] = await Promise.all([
            db.execute(
                'SELECT idGameRating FROM GameRatings WHERE game_id = ? AND user_id = ?',
                [game_id, user_id]
            ),
            db.execute(
                'SELECT idReview FROM Reviews WHERE game_id = ? AND user_id = ?',
                [game_id, user_id]
            )
        ])

        if (existRating.length === 0) {
            throw { status: 404, message: 'Отсутствует оценка игры' }
        }

        if (existReview.length > 0) {
            await db.execute(
                `UPDATE Reviews
                SET title = ?, content = ?
                WHERE game_id = ? AND user_id = ? AND rating_id = ?`,
                [reviewForm.title, reviewForm.content, game_id, user_id, rating_id]
            )
            return true
        }

         await db.execute(
            `INSERT INTO Reviews (title, content, game_id, user_id, rating_id)
            VALUES (?, ?, ?, ?, ?)`,
            [reviewForm.title, reviewForm.content, game_id, user_id, rating_id]
        )

        return true
    }

    static async GetReviewGame(review_id) {
        const [rows] = await db.execute(
            'SELECT title, content FROM Reviews WHERE idReview = ?',
            [review_id]
        )

        return rows[0] || null
    }







}



module.exports = GameService;
