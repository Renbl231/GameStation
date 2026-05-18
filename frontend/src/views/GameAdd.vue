<script setup>
    import { computed, ref, onUnmounted } from 'vue'
    import api from '../utils/axios'
    import { storeToRefs } from 'pinia'
    import { useAuthStore } from '../stores/authStore'

    import { useNotifications } from '../stores/notifications'
    import { useApiNotifications } from '../composables/useApi'

    const { apiCall } = useApiNotifications()
    const notification = useNotifications()

    const authStore = useAuthStore()
    const { isAuthenticated, user } = storeToRefs(authStore)

    const isAuthorized = computed(() => 
        isAuthenticated.value && [4].includes(user.value?.role)
    )

    // Основная шапка
    const isSelected = ref(false);

    const isConApi = ref(false)
    const isConManual = ref(false)

    const toggleShowConApi = () => {
        isConManual.value = false
        isSelected.value = !isSelected.value
        isConApi.value = !isConApi.value
    }

    const toggleShowConManual= () => {
        isConApi.value = false
        isSelected.value = !isSelected.value
        isConManual.value = !isConManual.value
    }

    // Добавление по рейтингу

    const isLoading = ref(false)

    const addedGames = ref([])

    const addTopRated = async () => {
        isLoading.value = true

        try {
            const payload = { limit: 5 }
            
            const data = await apiCall(
                () => api.post('/games/addTopGame', payload),
                'Игры успешно добавлены'
            )    

            if(data.success) {
                addedGames.value = data.data?.results || [];
            }
        } catch(error) {} finally {
            isLoading.value = false
        }
    }

    // Добавление по поиску 

    const gameName = ref('')

    const addBySearch = async () => {
        if(!gameName.value.trim()) {
            notification.warning('Название игры обязательно') 
            return false;
        }
        isLoading.value = true
        try {
            const data = await apiCall(
                () => api.post('/games/addBySearchAPI', { name: gameName.value }),
                'Игра успешно добавлена'
            )
            if(data.success) {
                addedGames.value = data.result || []
                gameName.value = ""
            }
        } catch(error) {}
        finally {
            isLoading.value = false
        }
    }

    // Ручной добавление

    const currentForm = ref(1);

    // Валидация

    const validateReleaseDate = (dateStr) => {
        if (!dateStr || !dateStr.trim()) return false;
        
        const date = new Date(dateStr);
        if (isNaN(date.getTime())) return false;
        
        const year = date.getFullYear();
        if (year < 1950) return false;
        
        const now = new Date();
        const maxFuture = new Date(now.getFullYear() + 4, now.getMonth(), now.getDate());
        if (date > maxFuture) return false;
        
        return true;
    };

    const validateFields = () => (
        form.value.name.trim() &&
        form.value.summary.trim() &&
        form.value.developer.trim() &&
        form.value.publisher.trim() &&
        form.value.status.trim() &&
        form.value.cover_url
    )
    const prevForm = () => {
        if(currentForm.value === 1) {
            toggleShowConManual()
        } else {
            currentForm.value--
        }
    }

    const nextForm = () => {
        if (!validateFields()) {
            notification.warning('Заполните все поля шага 1');
            return;
        }
        
        if (!validateReleaseDate(form.value.release_date)) {
            notification.warning('Выберите корректную дату');
            return;
        }
        
        if (currentForm.value < 8) {
            currentForm.value++;
        }
    };

    const form = ref({
        name: '',
        summary: '',
        developer: '',
        publisher: '',
        status: '',
        release_date: '',
        trailer_url: '',
        cover_url: null,
        banner: null,
        genres: [],
        platforms: [],
        modes: [],
        themes: [],
        perspectives: [],
        screenshots: [],
        sort_order: 0,
    })

    const genresList = [
        { id: 36, name: 'MOBA' },
        { id: 33, name: 'Аркада' },
        { id: 11, name: 'В реальном времени' },
        { id: 34, name: 'Визуальная новелла' },
        { id: 26, name: 'Викторина' },
        { id: 9, name: 'Головоломка' },
        { id: 10, name: 'Гонки' },
        { id: 32, name: 'Инди' },
        { id: 35, name: 'Карточная' },
        { id: 2, name: 'Квест' },
        { id: 7, name: 'Музыка' },
        { id: 30, name: 'Пинбол' },
        { id: 8, name: 'Платформер' },
        { id: 16, name: 'Пошаговая' },
        { id: 31, name: 'Приключение' },
        { id: 12, name: 'Ролевая' },
        { id: 13, name: 'Симулятор' },
        { id: 25, name: 'Слэшер' },
        { id: 14, name: 'Спортивная' },
        { id: 15, name: 'Стратегия' },
        { id: 24, name: 'Тактика' },
        { id: 4, name: 'Файтинг' },
        { id: 5, name: 'Шутер' }
    ]

    const platformsList = [
        { id: 3, name: 'Linux' },
        { id: 4, name: '64' },
        { id: 6, name: 'PC' },
        { id: 7, name: 'PlayStation' },
        { id: 8, name: 'PlayStation 2' },
        { id: 9, name: 'PlayStation 3' },
        { id: 11, name: 'Xbox' },
        { id: 12, name: 'Xbox 360' },
        { id: 14, name: 'Mac' },
        { id: 15, name: '128' },
        { id: 18, name: 'Entertainment System' },
        { id: 19, name: 'Super Nintendo Entertainment System' },
        { id: 20, name: 'DS' },
        { id: 21, name: 'GameCube' },
        { id: 29, name: 'Mega Drive' },
        { id: 30, name: '32X' },
        { id: 32, name: 'Saturn' },
        { id: 35, name: 'Game Gear' },
        { id: 37, name: '3DS' },
        { id: 38, name: 'PlayStation Portable' },
        { id: 39, name: 'iOS' },
        { id: 46, name: 'PlayStation Vita' },
        { id: 48, name: 'PlayStation 4' },
        { id: 49, name: 'Xbox One' },
        { id: 59, name: '2600' },
        { id: 60, name: '7800' },
        { id: 61, name: 'Lynx' },
        { id: 62, name: 'Jaguar' },
        { id: 63, name: 'ST' },
        { id: 64, name: 'Master System' },
        { id: 65, name: '8-bit' },
        { id: 66, name: '5200' },
        { id: 71, name: 'VIC-20' },
        { id: 75, name: 'II' },
        { id: 78, name: 'CD' },
        { id: 90, name: 'PET' },
        { id: 93, name: '16' },
        { id: 94, name: 'Plus/4' },
        { id: 130, name: 'Switch' },
        { id: 158, name: 'CDTV' },
        { id: 159, name: 'DSi' },
        { id: 165, name: 'PlayStation VR' },
        { id: 167, name: 'PlayStation 5' },
        { id: 169, name: 'Xbox Series X|S' },
        { id: 339, name: 'Pico' },
        { id: 390, name: 'PlayStation VR2' },
        { id: 410, name: 'Jaguar CD' },
        { id: 482, name: 'CD 32X' },
        { id: 508, name: 'Switch 2' }
    ]

    const modesList = [
        { id: 1, name: 'Одиночная' },
        { id: 2, name: 'Мультиплеер' },
        { id: 3, name: 'Кооперативная' },
        { id: 4, name: 'Разделённый экран' },
        { id: 5, name: 'MMO' },
        { id: 6, name: 'Баттл Рояль' }
    ]

    const themesList = [
        { id: 1, name: 'Экшн' },
        { id: 17, name: 'Фэнтези' },
        { id: 18, name: 'Научная фантастика' },
        { id: 19, name: 'Хоррор' },
        { id: 20, name: 'Триллер' },
        { id: 21, name: 'Выживание' },
        { id: 22, name: 'Историческая' },
        { id: 23, name: 'Стелс' },
        { id: 27, name: 'Комедия' },
        { id: 28, name: 'Бизнес' },
        { id: 31, name: 'Драма' },
        { id: 32, name: 'Документальный' },
        { id: 33, name: 'Песочница' },
        { id: 34, name: 'Обучающая' },
        { id: 35, name: 'Для детей (6+)' },
        { id: 38, name: 'Открытый мир' },
        { id: 39, name: 'Война' },
        { id: 40, name: 'Для вечеринки' },
        { id: 41, name: '4X стратегия' },
        { id: 42, name: 'Для взрослых (18+)' },
        { id: 43, name: 'Детектив/Тайна' },
        { id: 44, name: 'Романтика' }
    ]

    const perspectivesList = [
        { id: 1, name: 'От первого лица' },
        { id: 2, name: 'От третьего лица' },
        { id: 3, name: 'Сверху/Изометрия' },
        { id: 4, name: 'Вид сбоку' },
        { id: 5, name: 'Текст' },
        { id: 6, name: 'Аудио' },
        { id: 7, name: 'VR' }
    ]

    const coverPreview = ref(null)
    const bannerPreview = ref(null)
    const screenshotPreviews = ref([])

    const onCoverChange = (e) => {
        const file = e.target.files[0] || null
        form.value.cover_url = file
        
        if (file) {
            coverPreview.value = URL.createObjectURL(file)
        } else {
            coverPreview.value = null
        }
    }

    const onBannerChange = (e) => {
        const file = e.target.files[0] || null
        form.value.banner = file
        
        if (file) {
            bannerPreview.value = URL.createObjectURL(file)
        } else {
            bannerPreview.value = null
        }
    }

    const onScreenshotChange = (e, index) => {
        const file = e.target.files[0] || null
        form.value.screenshots[index] = file
        
        if (file) {
            screenshotPreviews.value[index] = URL.createObjectURL(file)
        } else {
            screenshotPreviews.value[index] = null
        }
    }

    const removeScreenshot = (index) => {
        if (screenshotPreviews.value[index]) {
            URL.revokeObjectURL(screenshotPreviews.value[index])
        }
        screenshotPreviews.value.splice(index, 1)
        form.screenshots.splice(index, 1)
    }

    const addScreenshotSlot = () => {
        form.value.screenshots.push(null)
        screenshotPreviews.value.push(null)
    }

    onUnmounted(() => {
        if (coverPreview.value) URL.revokeObjectURL(coverPreview.value)
        if (bannerPreview.value) URL.revokeObjectURL(bannerPreview.value)
        screenshotPreviews.value.forEach(preview => {
            if (preview) URL.revokeObjectURL(preview)
        })
    })

    const resetForm = () => {
        form.value = {
            name: '',
            summary: '',
            developer: '',
            publisher: '',
            status: '',
            release_date: '',
            trailer_url: '',
            cover_url: null,
            banner: null,
            genres: [],
            platforms: [],
            modes: [],
            themes: [],
            perspectives: [],
            screenshots: [],
            sort_order: 0,
        };
    };

    const addGame = async() => {
        const fd = new FormData()

        const textFields = ['name', 'summary', 'developer', 'publisher', 'status', 'release_date', 'trailer_url', 'sort_order']
        textFields.forEach(field => {
            if (form.value[field]) fd.append(field, form.value[field])
        })
        
        const jsonFields = ['genres', 'platforms', 'modes', 'themes', 'perspectives']
        jsonFields.forEach(field => {
            fd.append(field, JSON.stringify(form.value[field]))
        })
        
        if (form.value.cover_url) fd.append('cover_url', form.value.cover_url)
        if (form.value.banner) fd.append('banner', form.value.banner)
        
        form.value.screenshots.forEach((scr) => {
            if (scr) fd.append('screenshots', scr)
        })

        isLoading.value = true
        try {
            const data = await apiCall(() => api.post('/games/addGameByUser', fd), 'Игра успешно добавлена')
            if(data.success) {
                addedGames.value = data.result || []
                resetForm()
                coverPreview.value = null
                bannerPreview.value = null
                screenshotPreviews.value = []
            }
        } catch(error) {}
        finally {
            isLoading.value = false
        }
    }


</script>

<template>
    <div v-if="isAuthorized" class="container flex-column">

        <div v-if="isLoading" class="loading-overlay flex-center flex-column">
            <div class="loading-spinner"></div>
            <span class="loading-label">Добавление игр...</span>
        </div>

        <div v-if="!isSelected" class="container-wrapper">
            <div class="container-header flex-column">
                <div class="container-headline flex-column ">
                    <span class="container-header__label">Добавление игр</span>
                    <span class="container-header__subtitle">Выберите способ добавления игры в систему</span>
                </div>
                <div class="container-choose flex aling-c">
                    <div @click="toggleShowConManual" class="choose-card choose-card-v2 flex-column">
                        <div class="choose-card__svg flex-center">
                            <svg fill="none" stroke="currentColor" viewBox="0 0 24 24" data-fgid-brm812=":r7l:"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2.5" d="M15.232 5.232l3.536 3.536m-2.036-5.036a2.5 2.5 0 113.536 3.536L6.5 21.036H3v-3.572L16.732 3.732z" data-fg-brm813="1.14:1.4184:/src/app/components/AddGamesPage.tsx:32:17:1308:170:e:path"></path></svg>
                        </div>
                        <div class="choose-card__text flex-column">
                            <span class="choose-card__label">Ручное добавление</span>
                            <span class="choose-card__subtitle">Заполните форму с информацией об игре в ручную</span>
                        </div>
                        <button type="button" class="no-border choose-card__btn">Выбрать <svg class="btn-svg" viewBox="0 0 12 8"><use href="#icon-arrow"></use></svg></button>
                    </div>
                    <div @click="toggleShowConApi" class="choose-card flex-column">
                        <div class="choose-card__svg choose-card__svg-v2 flex-center">
                            <svg fill="none" stroke="currentColor" viewBox="0 0 24 24" data-fg-brm826="1.14:1.4184:/src/app/components/AddGamesPage.tsx:51:15:2488:269:e:svg:e" data-fgid-brm826=":r7t:"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4 16v1a3 3 0 003 3h10a3 3 0 003-3v-1m-4-8l-4-4m0 0L8 8m4-4v12" data-fg-brm827="1.14:1.4184:/src/app/components/AddGamesPage.tsx:52:17:2600:136:e:path"></path></svg>
                        </div>
                        <div class="choose-card__text flex-column">
                            <span class="choose-card__label">Импорт через API</span>
                            <span class="choose-card__subtitle">Загрузите данные об игре из внешних источников автоматически</span>
                        </div>
                        <button type="button" class="no-border choose-card__btn choose-card__btn-v2">Выбрать <svg class="btn-svg" viewBox="0 0 12 8"><use href="#icon-arrow"></use></svg></button>
                    </div>
                </div>
            </div>
        </div>

        <div v-if="isConApi" class="container-api flex-column">
            <button :disabled="isLoading" @click="toggleShowConApi" type="button" class="no-border container-api__closeBtn flex align-c">
                <svg class="" viewBox="0 0 12 8">
                    <use href="#icon-arrow"></use>
                </svg>
                Назад
            </button>

            <div class="api-addWrapper flex-column">
                <div class="container-api-card flex-column">
                    <span class="api__label flex align-c">
                        <svg class="api__iconLabel" fill="none" stroke="var(--font-secondary)" viewBox="0 0 24 24" data-fg-di417="1.15:1.9850:/src/app/components/ApiGameImport.tsx:131:17:4108:252:e:svg:e" data-fgid-di417=":r4m:"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M21 21l-6-6m2-5a7 7 0 11-14 0 7 7 0 0114 0z" data-fg-di418="1.15:1.9850:/src/app/components/ApiGameImport.tsx:132:19:4220:117:e:path"></path></svg>
                        Поиск по названию
                    </span>
                    <span class="api__subtitle">
                        Добавьте конкретную игру по названию
                    </span>
                    <input :class="{ 'active': gameName }"  v-model="gameName" class="field" placeholder="Название игры">
                    <button :disabled="isLoading" @click="addBySearch" type="button" class="no-border api__btn">Добавить</button>
                </div>
    
                <div class="container-api-card flex-column">
                    <span class="api__label flex align-c">
                        <svg class="api__iconLabel" fill="orange" stroke="none" viewBox="0 0 24 24" data-fgid-di430=":r4u:"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M11.049 2.927c.3-.921 1.603-.921 1.902 0l1.519 4.674a1 1 0 00.95.69h4.915c.969 0 1.371 1.24.588 1.81l-3.976 2.888a1 1 0 00-.363 1.118l1.518 4.674c.3.922-.755 1.688-1.538 1.118l-3.976-2.888a1 1 0 00-1.176 0l-3.976 2.888c-.783.57-1.838-.197-1.538-1.118l1.518-4.674a1 1 0 00-.363-1.118l-3.976-2.888c-.784-.57-.38-1.81.588-1.81h4.914a1 1 0 00.951-.69l1.519-4.674z" data-fg-di431="1.15:1.9850:/src/app/components/ApiGameImport.tsx:151:19:5475:433:e:path"></path></svg> 
                        Игры с высоким рейтингом
                    </span>
                    <span class="api__subtitle">
                        Добавляйте игры с высоким рейтингом одной кнопкой
                    </span>
                    <button :disabled="isLoading" @click="addTopRated" type="button" class="no-border api__btn">Добавить</button>
                </div>
            </div>

            <div v-if="addedGames?.length" class="added-games flex-column">
                <hr>
                <span class="added-games__label">Добавленные игры</span>
                <div class="wrapper-addedGames">
                    <div v-for="game in addedGames" :key="game.gameId" class="game flex-center flex-column">
                        <img :src="game.cover" class="game__cover">
                        <span class="game__name">{{ game.name }}</span>
                    </div>
                </div>
            </div>

        </div>


        <div v-if="isConManual" class="container-manual flex-column">

            <button :disabled="isLoading" @click="prevForm" type="button" class="no-border container-manual__returnBtn flex align-c">
                <svg class="" viewBox="0 0 12 8">
                    <use href="#icon-arrow"></use>
                </svg>
                Назад
            </button>

            <div v-if="currentForm === 1" class="container-manual-v1 flex-column">
                <div class="container-manual__block flex-column">
                    <label for="gameName" class="block__label">
                        Название
                    </label>
                    <input :class="{'active': form.name }" id="gameName" v-model="form.name" class="field" placeholder="Название игры">
                </div>

                <div class="container-manual-wrapper flex">
                    <div class="container-manual__block flex-column">
                        <label for="gameDeveloper" class="block__label">
                            Разработчик
                        </label>
                        <input :class="{'active': form.developer }" id="gameDeveloper" class="field" v-model="form.developer" placeholder="Разработчик">
                    </div>
                    <div class="container-manual__block flex-column">
                        <label for="gamePublisher" class="block__label">
                            Издатель
                        </label>
                        <input :class="{'active': form.publisher }" id="gamePublisher" class="field" v-model="form.publisher" placeholder="Издатель">
                    </div>
                </div>

                <div class="container-manual__block flex-column">
                    <label for="gameSummary" class="block__label">
                        Краткое описание
                    </label>
                    <textarea :class="{'active': form.summary }" id="gameSummary" class="field field-textarea no-border" v-model="form.summary" placeholder="Краткое описание"></textarea>
                </div>

                <div class="container-manual__block flex-column">
                    <label for="gameStatus" class="block__label">
                        Статус
                    </label>
                    <select :class="{'active': form.status }" id="gameStatus" v-model="form.status" class="field no-border">
                        <option value="" disabled hidden selected class="empty-option">
                            Статус игры
                        </option>
                        <option value="Вышла">Вышла</option>
                        <option value="Анонсирована">Анонсирована</option>
                        <option value="В разработки">В разработке</option>
                        <option value="Альфа">Альфа</option>
                        <option value="Бета">Бета</option>
                        <option value="tbc">tbc</option>
                    </select>
                </div>

                <div class="container-manual__block flex-column">
                    <label for="gameDate" class="block__label">
                        Дата релиза
                    </label>
                    <input :class="{'active': form.release_date }" id="gameDate" class="field" v-model="form.release_date" type="date" placeholder="Дата релиза">
                </div>

                <div class="container-manual__block flex-column">
                    <label for="gameTrailer" class="block__label">
                        Ссылка на трейлер
                    </label>
                    <input id="gameDate" class="field active" v-model="form.trailer_url" placeholder="Ссылка на трейлер">
                </div>

                <div class="container-manual__block flex-column">
                    <label class="block__label">Обложка</label>
                    <input type="file" accept="image/*" @change="onCoverChange" class="field"/>
                    <img v-if="coverPreview" :src="coverPreview" class="preview-image" />
                </div>
                
                <div class="container-manual__block flex-column">
                    <label class="block__label">Баннер</label>
                    <input type="file" accept="image/*" @change="onBannerChange" class="field"/>
                    <img v-if="bannerPreview" :src="bannerPreview" class="preview-image" />
                </div>   
                
                <div class="container-manual__block flex-column">
                    <label class="block__label">Приоритет {{ form.sort_order }}/3</label>
                    <input v-model="form.sort_order" type="range" min="0" max="3" class="" style="cursor: pointer;"/>
                </div>  
            </div>

            <div v-if="currentForm === 2" class="container-manual-v2 flex-column">
                <span class="container-manual__label">Выберите жанры</span>
                <div class="container-manual__block container-manual__block-grid align-c">       
                    <label v-for="genre in genresList" :key="genre.id" class="custom-checkbox flex align-c">
                        <input 
                            type="checkbox"
                            v-model="form.genres"
                            class="customCheckBox"
                            :value="genre.id"
                        >
                        <span class="checkmark"></span>
                        <span class="checkbox-text">{{ genre.name }}</span>
                    </label>
                </div>
            </div>

            <div v-if="currentForm === 3" class="container-manual-v3 flex-column">
                <span class="container-manual__label">Выберите платформы</span>
                <div class="container-manual__block container-manual__block-grid align-c">       
                    <label v-for="platform in platformsList" :key="platform.id" class="custom-checkbox flex align-c">
                        <input 
                            type="checkbox"
                            v-model="form.platforms"
                            class="customCheckBox"
                            :value="platform.id"
                        >
                        <span class="checkmark"></span>
                        <span class="checkbox-text">{{ platform.name }}</span>
                    </label>
                </div>
            </div>

            <div v-if="currentForm === 4" class="container-manual-v3 flex-column">
                <span class="container-manual__label">Выберите режимы</span>
                <div class="container-manual__block container-manual__block-grid align-c">       
                    <label v-for="mode in modesList" :key="mode.id" class="custom-checkbox flex align-c">
                        <input 
                            type="checkbox"
                            v-model="form.modes" 
                            class="customCheckBox"
                            :value="mode.id"
                        >
                        <span class="checkmark"></span>
                        <span class="checkbox-text">{{ mode.name }}</span>
                    </label>
                </div>
            </div>

            <div v-if="currentForm === 5" class="container-manual-v3 flex-column">
                <span class="container-manual__label">Выберите темы</span>
                <div class="container-manual__block container-manual__block-grid align-c">       
                    <label v-for="theme in themesList" :key="theme.id" class="custom-checkbox flex align-c">
                        <input 
                            type="checkbox"
                            v-model="form.themes" 
                            class="customCheckBox"
                            :value="theme.id"
                        >
                        <span class="checkmark"></span>
                        <span class="checkbox-text">{{ theme.name }}</span>
                    </label>
                </div>
            </div>

            <div v-if="currentForm === 6" class="container-manual-v3 flex-column">
                <span class="container-manual__label">Выберите перспективы</span>
                <div class="container-manual__block container-manual__block-grid align-c">       
                    <label v-for="perspective in perspectivesList" :key="perspective.id" class="custom-checkbox flex align-c">
                        <input 
                            type="checkbox"
                            v-model="form.perspectives" 
                            class="customCheckBox"
                            :value="perspective.id"
                        >
                        <span class="checkmark"></span>
                        <span class="checkbox-text">{{ perspective.name }}</span>
                    </label>
                </div>
            </div>

            <div v-if="currentForm === 7" class="container-manual-v3 flex-column">
                <span class="container-manual__label">Добавьте скриншоты</span>
                <div class="screenshots-wrapper flex-column">
                    <div 
                        v-for="(screenshot, index) in form.screenshots" 
                        :key="`scr-${index}`" 
                        class="screenshot-input flex"
                    >
                        <input 
                            type="file" 
                            accept="image/*" 
                            class="field" 
                            @change="onScreenshotChange($event, index)"
                        />
                        <img v-if="screenshotPreviews[index]" :src="screenshotPreviews[index]" class="preview-thumb" />
                        <button @click="removeScreenshot(index)" class="removeScrBtn">✖</button>
                    </div>
                    
                    <button type="button" @click="addScreenshotSlot()">+ Скриншот</button>
                </div>
            </div>
            
            <div class="btn-block flex align-c justify-sb">
                 <button v-if="currentForm > 2" @click="currentForm = 1" type="button" class="no-border container-manual__btn">
                    Вернуться к 1 шагу
                </button>
                <button :disabled="isLoading" v-if="currentForm < 7" @click="nextForm" type="button" class="no-border container-manual__nextBtn">
                    Дальше
                </button>
                <button @click="addGame" v-if="currentForm === 7" type="button" class="addGame-btn no-border">Добавить игру</button>
            </div>



            <div v-if="addedGames?.length" class="added-games flex-column">
                <hr>
                <span class="added-games__label">Добавленные игры</span>
                <div class="wrapper-addedGames">
                    <div v-for="game in addedGames" :key="game.gameId" class="game flex-center flex-column">
                        <img :src="game.cover" class="game__cover">
                        <span class="game__name">{{ game.name }}</span>
                    </div>
                </div>
            </div>

        </div>

    </div>

    <div v-else>
        Домой идика
    </div>
</template>


<style scoped>
    .preview-image {
        max-width: 200px;
        max-height: 150px;
        margin-top: 8px;
        border-radius: 4px;
        object-fit: cover;
    }

    .preview-thumb {
        width: 50px;
        height: 50px;
        object-fit: cover;
        border-radius: 4px;
        margin-left: 8px;
    }


    .container {
        width: 100%;
    }

    .container-wrapper {
        width: 100%;
        background-color: var(--bg-third-25);
        border: 1px solid var(--bg-third-100);
        border-radius: 32px;
        padding-inline: 96px;
        padding-block: 64px;
    }

    .container-header {
        width: 100%;
        gap: var(--gp-36);
    }

    .container-headline {
        width: 100%;
        gap: var(--gp-24);
    }

    .container-header__label {
        font-family: Roboto_Bold;
        font-size: 36px;
        line-height: 32px;
    }

    .container-header__subtitle {
        font-family: Roboto_Medium;
        font-size: 24px;
        color: var(--font-primary-75);
    }

    .container-choose {
        width: 100%;
        gap: var(--gp-36);
    }

    .choose-card {
        width: 50%;
        background-color: var(--bg-secondary-25);
        border-radius: 8px;
        padding: 32px;
        gap: var(--gp-24);
        cursor: pointer;
        transition: 0.3s;
    }

    .choose-card__svg {
        max-width: 48px;
        width: 100%;
        height: 48px;
        border-radius: 8px;
        background-color: var(--btn-color-6-25);
    }

    .choose-card__svg svg {
        width: 28px;
        height: 28px;
        color: #0051FF;
        stroke-width: 2.5px;
    }

    .choose-card__svg-v2 svg {
        color: var(--btn-color-2)
    }

    .choose-card__text {
        gap: var(--gp-16);
    }

    .choose-card__label {
        font-family: Roboto_Medium;
        font-size: 24px;
    }

    .choose-card__subtitle {
        font-family: Roboto_Medium;
        font-size: 20px;
        line-height: 28px;
        color: var(--font-primary-50);
    }

    .choose-card__btn {
        font-family: Roboto_Medium;
        width: fit-content;
        color: var(--font-secondary);
        transition: 0.2s;
    }

    .choose-card__btn-v2{
        color: var(--btn-color-2);
    }

    .choose-card__btn-v2 svg {
        stroke: var(--btn-color-2);
    }

    .btn-svg {
        width: 12px;
        height: 10px;
        stroke: var(--font-secondary);
        transform: rotate(270deg);
    }

    /* Hover для карточек */

    .choose-card:hover .choose-card__svg {
        filter: brightness(1.3);
    }

    .choose-card:hover .choose-card__btn {
        margin-left: 4px;
    }

    .choose-card:hover {
        box-shadow: 0px 0px 12px rgba(197, 67, 67, 1);
    }

    .choose-card-v2:hover {
        box-shadow: 0px 0px 12px rgba(0, 111, 255, 1);
    }

    /* Контейнер с API */

    .container-api {
        max-width: 800px;
        width: 100%;
        margin: 0 auto;
        padding: 32px;
        border-radius: 16px;
        background-color: var(--bg-third-25);
        border: 1px solid var(--bg-third-100);
        gap: var(--gp-36);
    }

    .api-addWrapper {
        width: 100%;
        gap: var(--gp-24);
    }

    .container-api__closeBtn {
        width: fit-content;
        font-family: Roboto_Medium;
        font-size: 16px;
        color: var(--font-primary-50);
        gap: var(--gp-8);
    }

    .container-api__closeBtn svg {
        width: 12px;
        height: 10px;
        stroke: var(--font-primary-50);
        transform: rotate(90deg);
    }

    /* Ховер для кнопки закрытия */

    .container-api__closeBtn:hover {
        filter: brightness(1.5);
    }

    .container-api-card {
        width: 100%;
        background-color: var(--bg-secondary-25);
        gap: var(--gp-12);
        padding: 24px;
        border-radius: 8px;
    }

    .api__label {
        font-family: Roboto_Medium;
        font-size: 20px;
    }

    .api__subtitle {
        font-family: Roboto_Regular;
        font-size: 16px;
        color: var(--font-primary-50);
    }

    .api__iconLabel {
        width: 24px;
        height: 24px;
        margin-right: 8px;
    }

    .api__btn {
        padding: 8px;
        background-color: var(--bg-secondary-25);
        border-radius: 4px;
        font-family: Roboto_Regular;
        transition: 0.1s;
    }

    .api__btn:hover {
        background-color: var(--font-secondary);
    }

    /* Поле */

    .field {
        width: 100%;
        background-color: #1B1C21;
        padding: 8px 16px;
        border-radius: 4px;
        border-left: 3px solid var(--btn-color-2);
        color: var(--font-primary-75);
        font-family: Roboto_Regular;
    }

    .field.active {
        border-left: 3px solid var(--font-secondary);
    }

    .field::placeholder {
        color: var(--font-primary-25);
    }
    
    button:disabled {
        opacity: 0.75;
        cursor: not-allowed; 
    }

    /* Добавление игр */

    .loading-overlay {
        position: fixed;
        bottom: 0%;
        left: 0%;
        width: 100%;
        height: fit-content;
        z-index: 9999;
        background-color: var(--bg-third-100);
        padding: 16px;
        border-radius: 16px;
    }

    .loading-spinner {
        width: 64px;
        height: 64px;
        border: 4px solid #e3e3e3;
        border-top: 4px solid #007bff;
        border-radius: 50%;
        margin-bottom: 16px;
        animation: spin 1s linear infinite;
        will-change: transform;
    }

    .loading-label {
        font-size: 20px;
        font-family: Roboto_SemiBold;
    }

    @keyframes spin {
        0% { transform: rotate(0deg); }
        100% { transform: rotate(360deg); }
    }

    /* Добавленные игр блок */

    .added-games {
        width: 100%;
        gap: var(--gp-24);
    }

    .wrapper-addedGames {
        width: 100%;
        display: grid;
        grid-template-columns: repeat(3, 1fr);
        gap: var(--gp-16);
    }

    .added-games__label {
        font-family: Roboto_Medium;
        font-size: 24px;
        text-align: center;
    }

    .game {
        width: 100%;
        gap: var(--gp-8);
    }

    .game__name {
        font-family: Roboto_SemiBold;
        font-size: 16px;
    }

    .game__cover {
        width: 70%;
        border-radius: 8px;
    }

    /* Ручное добавление */

    .container-manual {
        max-width: 800px;
        width: 100%;
        margin: 0 auto;
        padding: 32px;
        border-radius: 16px;
        background-color: var(--bg-third-25);
        border: 1px solid var(--bg-third-100);
        gap: var(--gp-36);
    }

    .container-manual__returnBtn, .container-manual__nextBtn {
        width: fit-content;
        font-family: Roboto_Medium;
        font-size: 16px;
        color: var(--font-primary-50);
        gap: var(--gp-8);
    }

    .container-manual__returnBtn svg {
        width: 12px;
        height: 10px;
        stroke: var(--font-primary-50);
        transform: rotate(90deg);
    }

    /* Ховер для кнопки закрытия */

    .container-manual__returnBtn:hover,
    .container-manual__nextBtn:hover,
    .container-manual__btn:hover {
        filter: brightness(1.5);
    }

    .container-manual-wrapper {
        width: 100%;
        gap: var(--gp-16);
    }

    .container-manual-v1,
    .container-manual-v2,
    .container-manual-v3 {
        width: 100%;
        gap: var(--gp-16);
    }

    .container-manual__block {
        width: 100%;
        gap: var(--gp-8);
    }

    .block__label {
        font-family: Roboto_Regular;
        font-size: 18px;
        color: var(--font-primary-75);
    }

    .field-textarea {
        min-height: 200px;
        resize: vertical;
        overflow: hidden;
        field-sizing: content;
    }

    select {
        width: 100%;
        overflow: hidden;
        text-overflow: ellipsis;
        white-space: nowrap;
        cursor: pointer;
        appearance: none;
        background: url('../assets/icons/arrow.svg') no-repeat right 14px center;
        background-size: 14px;
        padding-right: 36px !important; 
    }

    .field option {
        color: #fff;
        background: #1B1C21;
        font-size: 16px;
    }

    input[type="date"]::-webkit-calendar-picker-indicator {
        filter: invert(1);
    }

    .container-manual__nextBtn {
        margin-top: 8px;
        font-size: 18px;
        margin-left: auto;
    }

    .container-manual__btn {
        font-size: 18px;
        font-family: Roboto_Medium;
        color: var(--font-primary-50);
    }

    /* Формы с чекбоксами */

    .container-manual__block-grid {
        display: grid;
        grid-template-columns: repeat(3, 1fr);
    }

    /* Кастом чекбокс */

    .custom-checkbox {
        cursor: pointer;
        font-size: 18px;
        font-family: Roboto_Medium;
    }

    .customCheckBox {
        appearance: none;
        -webkit-appearance: none;
        position: absolute;
        opacity: 0;
        width: 0;
        height: 0;
    }

    .checkmark {
        width: 24px;    
        height: 24px;
        border-radius: 2px;
        background: var(--btn-color-6-25);
        margin-right: 12px;
        position: relative;
        transition: all 0.2s ease;
        flex-shrink: 0;
    }

    .customCheckBox:checked + .checkmark {
        background-color: var(--font-secondary);
    }

    .customCheckBox:checked + .checkmark::after {
        content: '';
        position: absolute;
        width: 6px;
        height: 12px;
        border: solid white;
        border-width: 0 2px 2px 0;
        transform: translate(-50%, -60%) rotate(45deg);
        left: 50%;
        top: 50%;
    }

    .checkbox-text {
        color: var(--font-primary-50);
    }

    .customCheckBox:checked ~ .checkbox-text {
        color: var(--font-primary);
    }

    .container-manual__label {
        font-family: Roboto_Medium;
        font-size: 24px;
    }

    /* Скриншоты */
    
    .screenshots-wrapper {
        width: 100%;
        gap: var(--gp-16);
    }

    .removeScrBtn {
        background-color: var(--bg-secondary);
        padding-inline: 8px;
    }
    
    .addGame-btn {
        width: fit-content;
        background-color: var(--bg-secondary-50);
        margin-left: auto;
        padding: 5px 10px;
        font-size: 16px;
        font-family: Roboto_Medium;
        border-radius: 4px;
        transition: 0.1s;
    }

    .addGame-btn:hover {
        background-color: var(--font-secondary);
    }

    .field .active {
        border-left: 3px solid var(--font-secondary);
    }

</style>