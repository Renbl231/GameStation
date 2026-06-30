<script setup>
    import { computed, onMounted, ref, onUnmounted } from 'vue'
    import api from '../utils/axios'
    import { storeToRefs } from 'pinia'
    import { useAuthStore } from '../stores/authStore'

    import { useRoute } from 'vue-router'
    const route = useRoute()

    import { useNotifications } from '../stores/notifications'
    import { useApiNotifications } from '../composables/useApi'

    const { apiCall } = useApiNotifications()
    const notification = useNotifications()

    const authStore = useAuthStore()
    const { isAuthenticated, user } = storeToRefs(authStore)

    const isAuthorized = computed(() => 
        isAuthenticated.value && [4].includes(user.value?.role)
    )

    const isLoading = ref(false)

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
    );

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

    // работа со скриншотами


    const toDateInputValue = (dateString) => {
        if (!dateString) return ''
        return new Date(dateString).toISOString().slice(0, 10)
    }

   
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
        sort_order: 0,
    })

    const newCover = ref(null)
    const newBanner = ref(null)
    const oldScreenshots = ref([])
    const newScreenshots = ref([])

    // временные url
    const coverPreview = ref(null)
    const bannerPreview = ref(null)
    const newScreenshotPreviews = ref([])


    const MAX_FILE_SIZE = 3 * 1024 * 1024

    const validateImageFile = (file) => {
        if (!file) return false
        
        if (!file.type?.startsWith('image/')) {
            notification.warning('Только изображения')
            return false
        }
        
        if (file.size > MAX_FILE_SIZE) {
            notification.warning('Файл слишком большой — максимум 3 МБ')
            return false
        }
        
        return true
    }



    const onCoverNewChange = (e) => {
        const file = e.target.files[0] || null

        if (file && !validateImageFile(file)) {
            e.target.value = '' // очищаем input
            return
        }

        newCover.value = file
        
        if (file) {
            coverPreview.value = URL.createObjectURL(file)
        } else {
            coverPreview.value = null
        }
    }

    const onBannerNewChange = (e) => {
        const file = e.target.files[0] || null

        if (file && !validateImageFile(file)) {
            e.target.value = ''
            return
        }

        newBanner.value = file
        
        if (file) {
            bannerPreview.value = URL.createObjectURL(file)
        } else {
            bannerPreview.value = null
        }
    }

    const addNewScreenshot = (e) => {
        const total = oldScreenshots.value.length + newScreenshots.value.filter(f => f).length
        
        if (total >= 5) {
            notification.warning('Максимум 5 скриншотов!')
            return
        }
        
        const file = e.target.files[0]

        if (file && !validateImageFile(file)) {
            e.target.value = ''
            return
        }

        if (file) {
            newScreenshots.value.push(file)
            newScreenshotPreviews.value.push(URL.createObjectURL(file))
        }
        e.target.value = '' 
    }

    const removeNewScreenshot = (index) => {
        // Очищаем временную ссылку
        if (newScreenshotPreviews.value[index]) {
            URL.revokeObjectURL(newScreenshotPreviews.value[index])
        }
        newScreenshotPreviews.value.splice(index, 1)
        newScreenshots.value.splice(index, 1)
    }

    const removeOldScreenshot = (index) => {
        oldScreenshots.value.splice(index, 1)
    }

    onUnmounted(() => {
        if (coverPreview.value) URL.revokeObjectURL(coverPreview.value)
        if (bannerPreview.value) URL.revokeObjectURL(bannerPreview.value)
        newScreenshotPreviews.value.forEach(preview => {
            if (preview) URL.revokeObjectURL(preview)
        })
    })

    const editGame = async () => {
        const fd = new FormData()

        const textFields = ['name', 'summary', 'developer', 'publisher', 'status', 'release_date', 'trailer_url', 'sort_order']
        textFields.forEach(field => {
            if (form.value[field]) {
            fd.append(field, form.value[field])
            }
        })

        const jsonFields = ['genres', 'platforms', 'modes', 'themes', 'perspectives']
        jsonFields.forEach(field => {
            fd.append(field, JSON.stringify(form.value[field]))
        })

        if(newCover.value) fd.append('cover_new', newCover.value)
        if(newBanner.value) fd.append('banner_new', newBanner.value)
        
        fd.append('screenshots_old', JSON.stringify(
            oldScreenshots.value.map(s => s.id)
        ))

        newScreenshots.value
            .filter(file => file)
            .forEach(file => {
                fd.append('screenshots_new', file)
        })
    
        isLoading.value = true
        try {
            const data = await apiCall(
                () => api.post(`/game/${route.params.id}/edit`, fd), 
                'Игра успешно изменена'
            )
        } catch (error) {
            console.error(error)
        } finally {
            isLoading.value = false
        }
    }


const getScreenshotSrc = (screen) => {
    if (!screen) return ''
    
    // Если строка
    if (typeof screen === 'string') {
        if (screen.startsWith('http') || screen.startsWith('games/')) {
            return screen
        }
        return `https://images.igdb.com/igdb/image/upload/t_720p/${screen}.jpg`  // image_id
    }
    
    // Если объект (backend)
    if (screen.image_url) return screen.image_url
    if (screen.image_id) return `https://images.igdb.com/igdb/image/upload/t_720p/${screen.image_id}.jpg`
    
    return ''
}


const getGameData = async () => {
  isLoading.value = true
  try {
    const { data } = await api.get(`/game/${route.params.id}`)
    const game = data.result || data

    if (game) {
      form.value = {
        name: game.name ?? '',
        summary: game.summary ?? '',
        developer: game.developer ?? '',
        publisher: game.publisher ?? '',
        status: game.status ?? '',
        release_date: toDateInputValue(game.release_date) ?? '',
        trailer_url: game.trailer_url ?? '',
        cover_url: game.cover_url ?? '',
        banner: game.banner ?? '',
        sort_order:game.sort_order ?? 0,
        genres: (game.genres ?? [])
          .map(name => genresList.find(item => item.name === name)?.id)
          .filter(Boolean),
        platforms: (game.platforms ?? [])
          .map(name => platformsList.find(item => item.name === name)?.id)
          .filter(Boolean),
        modes: (game.modes ?? [])
          .map(name => modesList.find(item => item.name === name)?.id)
          .filter(Boolean),
        themes: (game.themes ?? [])
          .map(name => themesList.find(item => item.name === name)?.id)
          .filter(Boolean),
        perspectives: (game.perspectives ?? [])
          .map(name => perspectivesList.find(item => item.name === name)?.id)
          .filter(Boolean),
      }
        oldScreenshots.value = game.screenshots?.map(s => ({
            id: s.idScreenshot,
            url: s.image_url || s.image_id 
        })) || []
        console.log(oldScreenshots.value)
    }
  } catch (error) {
    console.log(error)
  } finally {
    isLoading.value = false
  }
}


    onMounted(async () => {
        await getGameData()
    })

</script>

<template>
    <div v-if="isAuthorized" class="container-manual">

        <button v-if="currentForm != 1" :disabled="isLoading" @click="prevForm" type="button" class="no-border container-manual__returnBtn flex align-c">
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
                <input type="file" accept="image/*" @change="onCoverNewChange" class="field"/>
                <img v-if="coverPreview" :src="coverPreview" style="width: 160px;" />
                <img v-else-if="form.cover_url" :src="form.cover_url" style="width: 160px;" />
            </div>
                        
            <div class="container-manual__block flex-column">
                <label class="block__label">Баннер</label>
                <input type="file" accept="image/*" @change="onBannerNewChange" class="field"/>
                <img v-if="bannerPreview" :src="bannerPreview" style="max-height: 237px;" />
                <img v-else-if="form.banner" :src="form.banner" style="max-height: 237px;" />
            </div>      
            
            <div class="container-manual__block flex-column">
                <label class="block__label">Приоритет {{ form.sort_order }}/3</label>
                <input v-model="form.sort_order" type="range" min="0" max="3"/>
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

               <div v-for="(scr, i) in oldScreenshots" :key="'old-'+i" class="flex">
                    <img :src="getScreenshotSrc(scr.url)" style="width: 200px; height: 100px" />
                    <button @click="removeOldScreenshot(i)">✖</button>
                </div>

                <div v-for="(file, i) in newScreenshots" :key="'new-'+i" class="flex">
                    <img :src="newScreenshotPreviews[i]" style="width: 200px; height: 100px;" />
                    <button @click="removeNewScreenshot(i)">✖</button>
                </div>

                <input 
                    v-if="oldScreenshots.length + newScreenshots.length < 5"
                    type="file" 
                    accept="image/*"
                    @change="addNewScreenshot" 
                />
            </div>
        </div>
        
        <div class="btn-block flex align-c justify-sb">
                <button v-if="currentForm > 2" @click="currentForm = 1" type="button" class="no-border container-manual__btn">
                Вернуться к 1 шагу
            </button>
            <button :disabled="isLoading" v-if="currentForm < 7" @click="nextForm" type="button" class="no-border container-manual__nextBtn">
                Дальше
            </button>
            <button @click="editGame" v-if="currentForm === 7" type="button" class="addGame-btn no-border">Редактировать игру</button>
        </div>
    

    </div>
</template>

<style scoped>
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

        .container-manual-wrapper {
        width: 100%;
        gap: var(--gp-16);
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

</style>

