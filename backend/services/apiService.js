const axios = require('axios');

class apiService {
    // метод поиска игры в API STEAM
    static async findSteamId(gameName) {
        try {
            console.log(`Ищем Steam ID: "${gameName}"`);
            
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
                        const exactMatch = response.data.items.find(
                            item => item.name.toLowerCase() === gameName.toLowerCase()
                        );
                        
                        if (exactMatch) {
                            console.log(`Найдено точное совпадение: ${exactMatch.name} (id: ${exactMatch.id})`);
                            return exactMatch.id;
                        }
                        
                        const partialMatch = response.data.items.find(
                            item => item.name.toLowerCase().startsWith(gameName.toLowerCase().split(':')[0].toLowerCase())
                        );
                        
                        if (partialMatch) {
                            console.log(`Найдено частичное совпадение (id: ${partialMatch.id})`)
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
            console.error('Ошибка поиска игры:', error.message);
            return null;
        }
    }

    // получение данных игры из steam api по её идентификатору
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


}

module.exports = apiService