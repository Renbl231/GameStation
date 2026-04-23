<script setup>
    import { ref, onMounted, onUnmounted, computed } from 'vue'
    import api from '../utils/axios'
    import { storeToRefs } from 'pinia'
    import { useAuthStore } from '../stores/authStore'
    import { useRouter } from 'vue-router'

    import { useNotifications } from '../stores/notifications'
    import { useApiNotifications } from '../composables/useApi'

    const { apiCall } = useApiNotifications()
    const notification = useNotifications()

    const router = useRouter()

    const authStore = useAuthStore()
    const { isAuthenticated, user } = storeToRefs(authStore)

    // Загрузка слайдов

    const slides = ref([]) 

    const sliderMode = ref("")

    const isLoading = ref(false)

    const loadSlides = async () => {
        isLoading.value = true
        try {
            const { data } = await api.get('/games/slides')
            if(data.success) {
                slides.value = data.slides.result || []
                sliderMode.value = data.slides.sliderMode
            }
        } catch(error) {
            console.log('Ошибка', error.response?.data?.error)
        } finally {
            isLoading.value = false
        }
    }

    const formatDate = (date) => {
        if (!date) return ''
        const d = new Date(date)
        if (isNaN(d.getTime())) return ''
        return d.toISOString().slice(0, 10)
    }

    // Работа со слайдером

    const currentSlide = ref(0)
    const direction = ref('next')
    let autoSlideInterval = null;

    const startX = ref(0)
    const endX = ref(0)

    const touchStart = (e) => {
        startX.value = e.touches[0].clientX
    }

    const touchEnd = (e) => {
        endX.value = e.changedTouches[0].clientX
        const diff = endX.value - startX.value
        
        if (Math.abs(diff) > 50) {
            if (diff > 0) {
            prevSlide()
            } else {
            nextSlide()
            }
        }
    }

    const goToSlide = (index) => {
        direction.value = index > currentSlide.value ? 'next' : 'prev'
        currentSlide.value = index
        resetAutoSlide()
    }

    const nextSlide = () => {
        direction.value = 'next'
        currentSlide.value = (currentSlide.value + 1) % slides.value.length
        resetAutoSlide()
    }

    const prevSlide = () => {
        direction.value = 'prev'
        currentSlide.value = currentSlide.value === 0 ? slides.value.length - 1 : currentSlide.value - 1
        resetAutoSlide()
    }

    const startAutoSlide = () => {
        autoSlideInterval = setInterval(() => {
            nextSlide()
        }, 10000)
    }

    const resetAutoSlide = () => {
        clearInterval(autoSlideInterval)
        startAutoSlide()
    }

    // Редак мода слайдера

    const saveSliderMode = async () => {
        try {
            const { data } = await api.post('/games/slider-mode', { sliderMode: sliderMode.value })
            if(data.success) {
                window.location.reload()
            }
        } catch(error) {
            console.log('Ошибка изменения слайдера', error)
        }
    }

    const isEditModeSlider = ref(false)

    const toggleEditModeSlider = () => {
        if(isAuthenticated && user.value?.role === 4) {
            isEditModeSlider.value = !isEditModeSlider.value
        }
    }

    const closeMenu = (event) => {
        if (!event.target.closest('.slider-options')) {
            isEditModeSlider.value = false
        }
    }

    // Блок с играми

    const currentFormat = ref('grid')

    const setFormat = (format) => currentFormat.value = format

    // Попап с формой добавления игры

    const isRequestForm = ref(false)
    
    const showRequestForm = () => {
        if(user.value?.role === 4) {
            router.push('/addGame')
        } else {
            isRequestForm.value = !isRequestForm.value      
        }
    }

    const requestForm = ref({
        nameGame: '',
        store_url: '',
        cover_url: '',
        baner_url: null
    })

    const validateRequestForm = () => {
        if(!requestForm.value.nameGame.trim() || requestForm.value.nameGame.trim().length < 3) {
            notification.warning('Не указано название игры')
            return false
        }
        if(!requestForm.value.store_url.trim() || requestForm.value.store_url.trim().length < 5) {
            notification.warning('Не указана ссылка на магазин')
            return false
        }
        if(!requestForm.value.cover_url.trim() || requestForm.value.cover_url.trim().length < 5) {
            notification.warning('Не указана ссылка на обложку')
            return false
        }
        return true
    }

    const sendRequestGame = async () => {
        if(!validateRequestForm()) return
        const data = await apiCall(() => api.post('/games/requestAdd', requestForm.value), 'Запрос отправлен')
        if(data.success) {
            showRequestForm()
            requestForm.value.nameGame = ''
            requestForm.value.store_url = ''
            requestForm.value.cover_url = ''
            requestForm.value.baner_url = null
        }
    }

    // массивы всех данных фильтров

    const platforms = ref([])
    const genres = [
        { idGenre: 36, name: 'MOBA' },
        { idGenre: 33, name: 'Аркада' },
        { idGenre: 11, name: 'В реальном времени' },
        { idGenre: 34, name: 'Визуальная новелла' },
        { idGenre: 26, name: 'Викторина' },
        { idGenre: 9, name: 'Головоломка' },
        { idGenre: 10, name: 'Гонки' },
        { idGenre: 32, name: 'Инди' },
        { idGenre: 35, name: 'Карточная' },
        { idGenre: 2, name: 'Квест' },
        { idGenre: 7, name: 'Музыка' },
        { idGenre: 30, name: 'Пинбол' },
        { idGenre: 8, name: 'Платформер' },
        { idGenre: 16, name: 'Пошаговая' },
        { idGenre: 31, name: 'Приключение' },
        { idGenre: 12, name: 'Ролевая' },
        { idGenre: 13, name: 'Симулятор' },
        { idGenre: 25, name: 'Слэшер' },
        { idGenre: 14, name: 'Спортивная' },
        { idGenre: 15, name: 'Стратегия' },
        { idGenre: 24, name: 'Тактика' },
        { idGenre: 4, name: 'Файтинг' },
        { idGenre: 5, name: 'Шутер' }
    ]

    const brands = [
        { idBrand: 5, name: 'Apple' },
        { idBrand: 6, name: 'Atari' },
        { idBrand: 7, name: 'Commodore' },
        { idBrand: 2, name: 'Microsoft' },
        { idBrand: 3, name: 'Nintendo' },
        { idBrand: 4, name: 'Sega' },
        { idBrand: 1, name: 'Sony' }
    ]

    const themes = [
        { idTheme: 41, name: '4X стратегия' },
        { idTheme: 28, name: 'Бизнес' },
        { idTheme: 39, name: 'Война' },
        { idTheme: 21, name: 'Выживание' },
        { idTheme: 43, name: 'Детектив/Тайна' },
        { idTheme: 40, name: 'Для вечеринки' },
        { idTheme: 42, name: 'Для взрослых (18+)' },
        { idTheme: 35, name: 'Для детей (6+)' },
        { idTheme: 32, name: 'Документальный' },
        { idTheme: 31, name: 'Драма' },
        { idTheme: 22, name: 'Историческая' },
        { idTheme: 27, name: 'Комедия' },
        { idTheme: 18, name: 'Научная фантастика' },
        { idTheme: 34, name: 'Обучающая' },
        { idTheme: 38, name: 'Открытый мир' },
        { idTheme: 33, name: 'Песочница' },
        { idTheme: 44, name: 'Романтика' },
        { idTheme: 23, name: 'Стелс' },
        { idTheme: 20, name: 'Триллер' },
        { idTheme: 17, name: 'Фэнтези' },
        { idTheme: 19, name: 'Хоррор' },
        { idTheme: 1, name: 'Экшн' }
    ]

    const modes = [
        { idMode: 5, name: 'MMO' },
        { idMode: 6, name: 'Баттл Рояль' },
        { idMode: 3, name: 'Кооперативная' },
        { idMode: 2, name: 'Мультиплеер' },
        { idMode: 1, name: 'Одиночная' },
        { idMode: 4, name: 'Разделённый экран' }
    ]

    const perspectives = [
        { idPerspective: 1, name: 'От первого лица' },
        { idPerspective: 2, name: 'От третьего лица' },
        { idPerspective: 3, name: 'Сверху/Изометрия' },
        { idPerspective: 4, name: 'Вид сбоку' },
        { idPerspective: 5, name: 'Текст' },
        { idPerspective: 6, name: 'Аудио' },
        { idPerspective: 7, name: 'VR' }
    ]

    
    // Получение всех фильтров

    const isCompanyPlatform = ref(false)
    const isDateRange = ref(false)

    const getFilterData = async () => {
        isLoading.value = true
        try {
            const { data } = await api.get('/games/getFilterData')
            if(data.success) {
                platforms.value = data.filterData.platforms
            }
        } catch(error) {}
        finally {
            isLoading.value = false
        }
    }
    
    // Выбранные фильтры

    const selectedThemes = ref([])
    const selectedModes = ref([])
    const selectedPerspectives = ref([])
    const selectedPlatforms = ref([])
    const selectedBrands = ref([])
    const activeSelected = computed(() =>
        isCompanyPlatform.value ? selectedBrands.value : selectedPlatforms.value
    )
    
    const selectedGenres = ref([])
    const ratingMin = ref(0)
    const ratingMax = ref(10)
    const ratingRange = computed(() => ({
        min: Math.min(ratingMin.value, ratingMax.value),
        max: Math.max(ratingMin.value, ratingMax.value)
    }))

    const selectedYear = ref('')
    const yearOptions = [
        { value: '2026' },
        { value: '2025' },
        { value: '2024' },
        { value: '2023' },
        { value: '2022' },
        { value: '2021' },
        { value: '2020' },
        { value: '2019' },
        { value: '2018' },
        { value: '2017' },
        { value: '2016' },
        { value: '2015' },
        { value: '2014' },
        { value: '2013' },
        { value: '2012' },
        { value: '2011' },
        { value: '2010' },
        { value: '2009' },
        { value: '2008' },
        { value: '2007' },
        { value: '2006' },
        { value: '2005' },
        { value: '2004' },
        { value: '2003' },
        { value: '2002' },
        { value: '2001' },
        { value: '2000' },
        { value: '1995-2000' },
        { value: '1990-1995' }
    ]

    // Сбросить фильтр

    const resetFilters = () => {
        isCompanyPlatform.value = false
        selectedThemes.value = []
        selectedModes.value = []
        selectedPerspectives.value = []
        selectedPlatforms.value = []
        selectedBrands.value = []
        selectedGenres.value = []
        selectedYear.value = ''
        ratingMin.value = 0
        ratingMax.value = 10
    }


    // 

    onMounted(async () => {
        await Promise.all([
            loadSlides(),
            getFilterData()
        ])
        document.addEventListener('click', closeMenu)
        
        startAutoSlide()
    })

    onUnmounted(() => {
        document.removeEventListener('click', closeMenu)
    })




</script>

<template>
    <div v-if="!isLoading" class="container-wrapper flex-column">

        <!-- ПопАп -->
        <Transition name="popup-request">
            <div v-if="isRequestForm" class="popUp-request flex-center">
                <div class="popUp-request-wrapper flex-column">
                    <div class="request-wrapper-header flex align-c justify-sb">
                        <span class="request-wrapper__label">Добавление игры</span>
                        <button @click="showRequestForm" type="button" class="no-border request-wrapper__closeBtn"></button>
                    </div>
                    <div class="request-wrapper-block">
                        <input v-model="requestForm.nameGame" :class="{'active': requestForm.nameGame.length >= 3 }" type="text" class="no-border field" placeholder="Название игры"> 
                    </div>
                    <div class="request-wrapper-block">
                        <input v-model="requestForm.store_url" :class="{'active': requestForm.store_url.length >= 5 }" type="text" class="no-border field" placeholder="Ссылка на страницу в магазине (STEAM, GOG, и т.п)"> 
                    </div>
                    <div class="request-wrapper-block">
                        <input v-model="requestForm.cover_url" :class="{'active': requestForm.cover_url.length >= 5 }" type="text" class="no-border field" placeholder="Ссылка на обложку игры в формате 3x4"> 
                    </div>
                    <div class="request-wrapper-block">
                        <input type="text" class="no-border field active" placeholder="Ссылка на банер игры в формате 11x3"> 
                    </div>
                    <div class="request-wrapper-block flex">
                        <button @click="sendRequestGame" type="button" class="no-border request-wrapper__btn">Предложить игру</button> 
                    </div>
                </div>
            </div>
        </Transition>

        <div class="slider-wrapper">
            <span class="slider-wrapper__label">{{ sliderMode === "best" ? 'Лучшие игры' : 'Самые ожидаемые' }}</span>
            <Transition :name="`slide-${direction}`">
                <div
                    :key="currentSlide"
                    @touchstart="touchStart"
                    @touchend="touchEnd"
                    class="slider">
                    <picture>
                        <img class="slider__img" :src="slides[currentSlide]?.banner">
                    </picture>
                    <span class="top-side__info">{{ formatDate(slides[currentSlide]?.release_date) }}</span>
                    <div class="slider__middle-side flex-column">
                        <span class="middle-side__name">{{ slides[currentSlide]?.name }}</span>
                        <div class="middle-side-platforms flex">
                            <span 
                                v-for="platform in slides[currentSlide]?.platforms"
                                class="middle-side-platforms__text"
                                :key="platform">
                                {{ platform }}
                            </span>
                        </div>
                    </div>
                </div>
            </Transition>

            <div class="slider-dots flex flex-center">
                <span 
                    v-for="(slide, index) in slides"
                    :key="index"
                    class="dot"
                    :class="{active: index === currentSlide}"
                    @click="goToSlide(index)"
                    data-slide="index">
                </span>
            </div> 

            <div v-if="user?.role === 4" class="slider-options">
                <button @click="toggleEditModeSlider" type="button" class="no-border slider-options__showBtn">
                    ...
                </button>
                <div v-if="isEditModeSlider" class="slider-options-wrapper flex-column flex-center">
                    <div class="slider-options-inputs flex-column">
                        <div class="options-inputs__block flex align-c">
                            <input v-model="sliderMode" type="radio" class="custom-radio" id="sliderMode1" name="sliderMode" value="best" :checked="sliderMode === 'best'"/>
                            <label for="sliderMode1">Лучшие</label>
                        </div>
                        <div class="options-inputs__block flex align-c">
                            <input v-model="sliderMode" type="radio" class="custom-radio" id="sliderMode2" name="sliderMode" value="expected" :checked="sliderMode === 'expected'"/>
                            <label for="sliderMode2">Ожидаемые</label>
                        </div>
                    </div>
                    <div class="slider-options-btns flex-center">
                        <button @click="saveSliderMode" type="button" class="no-border">Сохранить</button>
                    </div>
                </div>
            </div>
        </div>
 
        <div class="content-block flex-column">
            <div class="nav-block flex align-c">
                <RouterLink to="/games" class="nav-block__link" :class="{'active': $route.path === '/games'}">Каталог</RouterLink>
                <RouterLink to="/games/selections" class="nav-block__link">Подборки</RouterLink>
                <RouterLink to="/games/reviews" class="nav-block__link">Рецензии</RouterLink>
            </div>

            <div class="filter-container flex align-c justify-sb">
                <div class="filter-block-wrapper flex align-c">
                    <div class="filter-block flex">
                        <button type="button" class="no-border filter-block__btnFilter flex align-c">Платформы
                            <span v-if="activeSelected.length" class="filter-block__counter align-c">
                            <span>|</span>
                                {{ activeSelected.length }}
                            </span>
                            <svg class="btnFilter__icon"><use href="#icon-arrow"></use></svg>
                        </button>
                        <div class="filter-dropdown-block flex-column">
                            <div class="filter-dropdown-header flex align-c">
                                <button @click="isCompanyPlatform = false" :class="{'active': isCompanyPlatform === false}" type="button" class="no-border dropdown-header__label">Выберите платформу</button>
                                <span>|</span>
                                <button @click="isCompanyPlatform = true" :class="{'active': isCompanyPlatform === true}" type="button" class="no-border dropdown-header__label">Компании</button>
                            </div>
                            <div class="filter-dropdown-block__scroll">
                                <div v-if="platforms.length && !isCompanyPlatform" class="choose-block-wrapper flex-column">
                                    <label v-for="platform in platforms" :key="platform.idPlatform"  class="custom-checkbox flex align-c">
                                        <input 
                                            type="checkbox"
                                            class="customCheckBox"
                                            :value="platform.idPlatform"
                                            v-model="selectedPlatforms"
                                        >
                                        <span class="checkmark"></span>
                                        <span class="checkbox-text">{{ platform.name }}</span>
                                    </label>
                                </div>
                                <div v-if="brands.length && isCompanyPlatform" class="choose-block-wrapper flex-column">
                                    <label v-for="brand in brands" :key="brand.idBrand" class="custom-checkbox flex align-c">
                                        <input 
                                            type="checkbox"
                                            class="customCheckBox"
                                            v-model="selectedBrands"
                                            :value="brand.idBrand"
                                        >
                                        <span class="checkmark"></span>
                                        <span class="checkbox-text">{{ brand.name }}</span>
                                    </label>
                                </div>
                            </div>
                        </div>
                    </div>
                    
                    <div class="filter-block flex align-c">
                        <button type="button" class="no-border filter-block__btnFilter flex align-c">Жанры
                            <span v-if="selectedGenres.length" class="filter-block__counter align-c">
                                <span>|</span>
                                {{ selectedGenres.length }}
                            </span>
                            <svg class="btnFilter__icon"><use href="#icon-arrow"></use></svg>
                        </button>
                        <div class="filter-dropdown-block flex-column">
                            <div class="filter-dropdown-block__scroll">
                                <div v-if="genres.length" class="choose-block-wrapper flex-column">
                                    <label v-for="genre in genres" :key="genre.idGenre"  class="custom-checkbox flex align-c">
                                        <input 
                                            type="checkbox"
                                            class="customCheckBox"
                                            :value="genre.idGenre"
                                            v-model="selectedGenres"
                                        >
                                        <span class="checkmark"></span>
                                        <span class="checkbox-text">{{ genre.name }}</span>
                                    </label>
                                </div>
                            </div>
                        </div>
                    </div>

                    <div class="filter-block flex align-c">
                        <button type="button" class="no-border filter-block__btnFilter flex align-c">Рейтинг
                            <svg class="btnFilter__icon"><use href="#icon-arrow"></use></svg>
                        </button>
                        
                        <div class="filter-dropdown-block filter-dropdown-block-range flex-column">
                            <div class="range-wrap">
                                <div class="range-track"></div>
                                <div class="range-labels flex justify-sb">
                                    <span>0</span>
                                    <span>1</span>
                                    <span>2</span>
                                    <span>3</span>
                                    <span>4</span>
                                    <span>5</span>
                                    <span>6</span>
                                    <span>7</span>
                                    <span>8</span>
                                    <span>9</span>
                                    <span>10</span>
                                </div>
                                <input
                                    class="range-input range-min"
                                    type="range"
                                    min="0"
                                    max="10"
                                    step="1"
                                    v-model="ratingMax"
                                >
                                <input
                                    class="range-input range-max"
                                    type="range"
                                    min="0"
                                    max="10"
                                    step="1"
                                    v-model="ratingMin"
                                >
                            </div>
                        </div>
                    </div>

                    <div class="filter-block flex align-c">
                        <button type="button" class="no-border filter-block__btnFilter flex align-c">Режимы
                            <span v-if="selectedModes.length" class="filter-block__counter align-c">
                                <span>|</span>
                                {{ selectedModes.length }}
                            </span>
                            <svg class="btnFilter__icon"><use href="#icon-arrow"></use></svg>
                        </button>
                        <div class="filter-dropdown-block flex-column">
                            <div class="filter-dropdown-block__scroll">
                                <div v-if="modes.length" class="choose-block-wrapper flex-column">
                                    <label v-for="mode in modes" :key="mode.idMode"  class="custom-checkbox flex align-c">
                                        <input 
                                            type="checkbox"
                                            class="customCheckBox"
                                            :value="mode.idMode"
                                            v-model="selectedModes"
                                        >
                                        <span class="checkmark"></span>
                                        <span class="checkbox-text">{{ mode.name }}</span>
                                    </label>
                                </div>
                            </div>
                        </div>
                    </div>

                    <div class="filter-block flex align-c">
                        <button type="button" class="no-border filter-block__btnFilter flex align-c">Перспективы
                            <span v-if="selectedPerspectives.length" class="filter-block__counter align-c">
                                <span>|</span>
                                {{ selectedPerspectives.length }}
                            </span>
                            <svg class="btnFilter__icon"><use href="#icon-arrow"></use></svg>
                        </button>
                        <div class="filter-dropdown-block flex-column">
                            <div class="filter-dropdown-block__scroll">
                                <div v-if="perspectives.length" class="choose-block-wrapper flex-column">
                                    <label v-for="perspective in perspectives" :key="perspective.idPerspective" class="custom-checkbox flex align-c">
                                        <input 
                                            type="checkbox"
                                            class="customCheckBox"
                                            :value="perspective.idPerspective"
                                            v-model="selectedPerspectives"
                                        >
                                        <span class="checkmark"></span>
                                        <span class="checkbox-text">{{ perspective.name }}</span>
                                    </label>
                                </div>
                            </div>
                        </div>
                    </div>

                    <div class="filter-block flex align-c">
                        <button type="button" class="no-border filter-block__btnFilter flex align-c">Темы
                            <span v-if="selectedThemes.length" class="filter-block__counter align-c">
                                <span>|</span>
                                {{ selectedThemes.length }}
                            </span>
                            <svg class="btnFilter__icon"><use href="#icon-arrow"></use></svg>
                        </button>
                        <div class="filter-dropdown-block flex-column">
                            <div class="filter-dropdown-block__scroll">
                                <div v-if="themes.length" class="choose-block-wrapper flex-column">
                                    <label v-for="theme in themes" :key="theme.idTheme" class="custom-checkbox flex align-c">
                                        <input 
                                            type="checkbox"
                                            class="customCheckBox"
                                            :value="theme.idTheme"
                                            v-model="selectedThemes"
                                        >
                                        <span class="checkmark"></span>
                                        <span class="checkbox-text">{{ theme.name }}</span>
                                    </label>
                                </div>
                            </div>
                        </div>
                    </div>

                    <div class="filter-block flex align-c">
                        <button type="button" class="no-border filter-block__btnFilter">Дата</button>
                        <div class="filter-dropdown-block flex-column">
                            <div class="filter-dropdown-block__scroll">
                                <div class="choose-block-wrapper flex-column">
                                    <label v-for="item in yearOptions" :class="{ active: selectedYear === item.value }" :key="item.value" class="radio-label">
                                        <input
                                            type="radio"
                                            name="year"
                                            :value="item.value"
                                            v-model="selectedYear"
                                            class="radio-input"
                                        >
                                        <span>{{ item.value }}</span>
                                    </label>
                                </div>
                            </div>
                        </div>
                    </div>
                    
                </div>
                <div class="filter-btns-wrapper flex align-c">
                    <button type="button" class="no-border filter-btns__btn filter-btns__btn-v1">Применить</button>
                    <button @click="resetFilters" type="button" class="no-border filter-btns__btn filter-btns__btn-v2">Сбросить</button>
                </div>
            </div>

            <div class="games-block flex-column">
                <div class="games-block-header flex-column">
                    <span class="games-header__label">Каталог игр</span>
                    <div class="sort-row flex">
                        <div class="sort-row__filter flex">
                            <select class="filter__select no-border">
                                <option value="" selected>
                                    Недавно добавленные
                                </option>
                                <option value="">
                                    По рейтингу
                                </option>
                                <option value="">
                                    По популярности
                                </option>
                                <option value="">
                                    По оценке редакции
                                </option>
                                <option value="">
                                    Недавно добавленные
                                </option>
                                <option value="">
                                    Самые ожидаемые
                                </option>
                                 <option value="">
                                    По алфавиту
                                </option>
                            </select>
                        </div>
                        <div class="filter__request-list flex align-c">
                            <div v-if="isAuthenticated" class="filter__request-block flex">
                                <button @click="showRequestForm" type="button" class="request-block__btn no-border flex align-c">
                                    <svg class="request-block__icon">
                                        <use href="#icon-plus"></use>
                                    </svg>
                                    Добавить игру
                                </button>
                            </div>
                            <div class="sort-row-list flex align-c">
                                <button :class="{'active': currentFormat === 'grid'}" @click="setFormat('grid')" type="button" class="no-border sort-row-list__btn sort-row-list__btn-grid flex-center"><svg><use href="#grid-block"></use></svg></button>
                                <button :class="{'active': currentFormat === 'list'}" @click="setFormat('list')" type="button" class="no-border sort-row-list__btn sort-row-list__btn-list flex-center"><svg><use href="#list-block"></use></svg></button>
                            </div>
                        </div>
                    </div>


                </div>
            </div>
        </div>

    </div>
</template>

<style scoped>
    .container-wrapper {
        width: 100%;
        position: relative;
        background-color: var(--bg-secondary-25);
        border-radius: 8px 8px 0px 0px;
        overflow: hidden;
        gap: var(--gp-32);
    }

    .slider-wrapper {
        width: 100%;
        min-height: 360px;
        max-height: 360px;
        position: relative;
    }

    .slider-wrapper__label {
        position: absolute;
        top: 16px;
        left: 32px;
        font-family: Roboto_CondensedBold;
        font-size: 40px;
        z-index: 100;
    }

    /* Сам слайдер */


    .slider {
        position: absolute;
        width: 100%;
        min-height: 360px;
        overflow: hidden;
    }

    .slider__img {
        width: 100%;
        min-height: 360px;
        max-height: 360px;
    }

    .slider::after {
        content: "";
        position: absolute;
        inset: 0;
        box-shadow: inset 64px 64px 250px 0px rgba(0, 0, 0, 0.75);
        pointer-events: none;
        z-index: 1;
    }

    .top-side__info {
        position: absolute;
        top: 32px;
        right: 32px;
        z-index: 100;
        font-family: Roboto_CondensedSemiBold;
        font-size: 24px;
    }

    .slider__middle-side {
        width: fit-content;
        position: absolute;
        left: 32px;
        bottom: 32px;
        gap: var(--gp-12);
        z-index: 100;
    }

    .middle-side__name {
        font-family: Roboto_CondensedSemiBold;
        font-size: 32px;
    }

    .middle-side-platforms {
        width: fit-content;
        font-family: Roboto_Medium;
        font-size: 20px;
        background-color: var(--btn-color-3);
        padding: 4px 8px;
        color: var(--font-primary-50);
        gap: var(--gp-8);
        border-radius: 4px;
    }

    /* Кнопки слайдера */

    .slider-dots {
        width: fit-content;
        position: absolute;
        bottom: 32px;
        left: 50%;
        transform: translate(-50%, 0%);
        gap: var(--gp-32);
        z-index: 50;
    }

    .dot {
        width: 24px;
        height: 24px;
        border-radius: 50%;
        border: 2px solid var(--font-primary-50);
        cursor: pointer;
        transition: 0.3s;
    }

    .dot.active, .dot:hover {
        background-color: var(--font-secondary);
        border-color: var(--font-secondary);
    }

    /* Опция слайдера */

    .slider-options {
        position: absolute;
        bottom: 0;
        right: 0px;
        padding: 32px;
        z-index: 100;
    }

    /* Выпадающий блок слайдера */

    .slider-options-wrapper {
        width: fit-content;
        position: absolute;
        bottom: 50%;
        right: 32px;
        background-color: var(--color-1);
        border-radius: 4px;
        opacity: 0;
        animation: slideDown 0.3s ease forwards;
        z-index: 50;
        padding: 8px;
        gap: var(--gp-8);
    }

    @keyframes slideDown {
        to {
            opacity: 1;
            transform: translateX(-48px);
        }
    }

    .slider-options-inputs {
        width: 100%;
        font-family: Roboto_Regular;
        font-size: 14px;
        gap: var(--gp-8);
    }

    .options-inputs__block {
        width: 100%;
        gap: var(--gp-4);
    }

    .slider-options-btns {
        width: 100%;
        background-color: var(--font-secondary);
        border-radius: 2px;
        font-family: Roboto_Regular;
        font-size: 14px;
        padding-block: 2px;
    }

    .slider-options-btns:hover {
        background-color: var(--btn-color-5);
    }

    .slider-options__showBtn {
        position: absolute;
        top: 0%;
        right: 32px;
        z-index: 90;
        width: 32px;
        height: 32px;
        background-color: var(--color-1);
        border-radius:4px;
        font-family: Roboto_Medium;
    }

    .slider-options__showBtn:hover {
        filter: brightness(1.25);
    }

    /* Кастом радио */

    .custom-radio {
        appearance: none;
        -webkit-appearance: none;
        width: 18px;
        height: 18px;
        border: 2px solid #888;
        border-radius: 50%;
        display: inline-block;
        position: relative;
        cursor: pointer;
        transition: border-color 0.2s ease;
        vertical-align: middle;
        margin: 0;
        flex-shrink: 0;
    }

    .custom-radio::after {
        content: "";
        position: absolute;
        inset: 3px;
        border-radius: 50%;
        background: #4f46e5;
        transform: scale(0);
        transition: transform 0.2s ease;
    }

    .custom-radio:checked {
        border-color: #4f46e5;
    }

    .custom-radio:checked::after {
        transform: scale(1);
    }

    .custom-radio:hover {
        border-color: #4f46e5;
    }

    /* Анимация для слайдера */

    .slide-next-enter-active, .slide-next-leave-active,
    .slide-prev-enter-active, .slide-prev-leave-active {
    transition: all 0.5s;
    }

    .slide-next-enter-from {
    transform: translateX(-100%);
    }

    .slide-next-leave-to {
    transform: translateX(100%);
    }

    .slide-prev-enter-from {
    transform: translateX(-100%);
    }

    .slide-prev-leave-to {
    transform: translateX(100%);
    }

    .slide-next-enter-to, .slide-prev-enter-to,
    .slide-next-leave-from, .slide-prev-leave-from {
    transform: translateX(0);
    }


    /* Контент блок */

    .content-block {
        width: 100%;
        padding-inline: 32px;
        padding-bottom: 32px;
        gap: var(--gp-32);
    }

    .nav-block {
        width: 100%;
        gap: var(--gp-24);
    }

    .nav-block__link {
        width: fit-content;
        background-color: var(--bg-secondary-25);
        border-radius: 4px;
        padding: 8px 24px;
        color: var(--font-primary-35);
        font-family: Roboto_SemiBold;
        font-size: 24px;
    }

    .nav-block__link:hover {
        background-color: var(--font-primary-25);
        color: var(--font-primary);
    }

    .nav-block__link.active {
        background-color: var(--font-primary-25);
        color: var(--font-primary);
    }


    /* Блок игр */

    .games-block {
        width: 100%;
    }

    .games-block-header {
        width: 100%;
        gap: var(--gp-24);
    }

    .games-header__label {
        font-family: Roboto_SemiBold;
        font-size: 32px;
    }
    
    .sort-row {
        width: 100%;
        gap: var(--gp-32);
    }

    .sort-row__filter {
        width: fit-content;
        gap: var(--gp-32);
    }

    .filter__select {
        width: fit-content;
        overflow: hidden;
        text-overflow: ellipsis;
        white-space: nowrap;
        cursor: pointer;
        appearance: none;
        background: url('../assets/icons/arrow.svg') no-repeat right 16px center;
        background-size: 12px;
        padding-right: 36px !important; 
        border-radius: 4px;
        border: 1px solid var(--font-primary-25);
        padding: 8px 12px;
        font-size: 16px;
        color: var(--font-primary-75);
        font-family: Roboto_Medium;
    }

    .filter__select option {
        color: #fff;
        background: #1B1C21;
        font-size: 16px;
        font-family: Roboto_Regular;
    }

    /* Кнопка + сортировка */
    
    .filter__request-list {
        width: 100%;
        gap: var(--gp-16);
    }

    .filter__request-block {
        width: 100%;
    }

    .request-block__btn {
        width: fit-content;
        font-family: Roboto_Medium;
        gap: var(--gp-8);
        color: var(--font-primary-75);
    }

    .request-block__btn:hover {
        color: var(--font-primary);
    }

    .request-block__icon {
        width: 12px;
        height: 12px;
        color: currentColor;
    }

    /* Правая часть сорта */

    .sort-row-list {
        margin-left: auto;
        gap: var(--gp-12)
    }

    .sort-row-list .sort-row-list__btn {
        width: 36px;
        height: 36px;
        background-color: var(--btn-color-6-25);
        border-radius: 4px;
        transition: 0.3s;
    }

    .sort-row-list .sort-row-list__btn:hover {
        background-color: var(--btn-color-6-50);
    }

    .sort-row-list .sort-row-list__btn.active {
        background-color: var(--font-secondary);
    }

    .sort-row-list__btn svg {
        width: 20px;
        height: 20px;
        stroke-opacity: 0.25;
    }

    .sort-row-list .sort-row-list__btn.active svg { 
        stroke-opacity: 1;
    }

    /* ПопАп запроса на добавление игр */

    .popUp-request {
        position: fixed;
        top: 0;
        bottom: 0;
        left: 0;
        right: 0;
        width: 100%;
        height: 100%;
        background-color: #00000075;
        z-index: 1000;
    }

    .popUp-request-wrapper {
        position: absolute;
        max-width: 600px;
        width: 100%;
        padding: 32px;
        background-color: #181B1D;
        border-radius: 8px;
        gap: var(--gp-32);
        border: 1px solid var(--bg-secondary-50);
        top: 20%;
    }

    .request-wrapper-header {
        width: 100%;
    }

    .request-wrapper__label {
        font-family: Roboto_SemiBold;
        font-size: 20px;
    }

    .request-wrapper__closeBtn {
        position: relative;
        width: 32px;
        height: 32px;
        cursor: pointer;
    }

    .request-wrapper__closeBtn::before,
    .request-wrapper__closeBtn::after {
        content: '';
        position: absolute;
        top: 16px;
        left: 50%;
        width: 20px;
        height: 2px;
        background-color: var(--font-primary-50);
        transform: translate(-50%, -50%) rotate(45deg);
    }

    .request-wrapper__closeBtn::after {
        transform: translate(-50%, -50%) rotate(-45deg);
    }

    .request-wrapper__closeBtn:hover::before,
    .request-wrapper__closeBtn:hover::after {
        background-color: var(--font-primary);
    }

    /* Анимация попАпа */

    .popup-request-enter-active,
    .popup-request-leave-active {
        transition: all 0.3s ease
    }

    .popup-request-enter-from,
    .popup-request-leave-to {
        opacity: 0;
        transform: translateY(80px);
    }

    .popup-request-enter-to,
    .popup-request-leave-from {
        opacity: 1;
        transform: translateY(0);
    }

    .request-wrapper-block {
        width: 100%;
    }
    
    .request-wrapper__btn {
        background-color: var(--font-secondary);
        border-radius: 4px;
        padding: 8px 24px;
        font-family: Roboto_Medium;
    }

    /* Кастомное инпут поле */

    .field {
        width: 100%;
        background-color: var(--bg-secondary-25);
        padding: 10px 16px;
        border-radius: 8px;
        border-left: 3px solid var(--btn-color-2);
        color: var(--font-primary-75);
        font-family: Roboto_Medium;
    }

    .field.active {
        border-left: 3px solid var(--font-secondary);
    }

    .field::placeholder {
        color: var(--font-primary-25);
    }

    /* Фильтр для игр */

    .filter-container {
        width: 100%;
        border-radius: 16px;
        background-color: rgba(0, 0, 0, 0.25);
        padding-block: 16px;
        gap: var(--gp-20);
        flex-wrap: wrap;
        padding-inline: 16px;
    }

    .filter-block-wrapper {
        gap: var(--gp-24);
    }

    .filter-block {
        width: fit-content;
        font-family: Roboto_Medium;
        position: relative;
    }

    .filter-block__btnFilter {
        width: fit-content;
        gap: var(--gp-8);
        font-size: 18px;
    }
    
    .filter-block:hover .filter-block__btnFilter,
    .filter-block:hover .filter-block__btnFilter .btnFilter__icon,
    .filter-block:hover .filter-block__counter span {
        color: var(--font-secondary);
        stroke: var(--font-secondary);
    }

    .btnFilter__icon {
        width: 12px;
        height: 10px;
        stroke: var(--font-primary-50);
    }


    .filter-btns-wrapper {
        gap: var(--gp-16);
    }

    .filter-btns__btn {
        width: fit-content;
        font-family: Roboto_Medium;
        padding: 8px 12px;
        border-radius: 8px;
    }

    .filter-btns__btn-v1 {
        background-color: var(--font-secondary);
    }

    .filter-btns__btn-v2 {
        background-color: var(--bg-third-100);
    }

    .filter-block__counter {
        font-size: 18px;
        color: var(--font-secondary);
    }

    .filter-block__counter span {
        color: var(--font-primary);
    }

    /* Выпад блок фильтров */

    .filter-dropdown-block {
        position: absolute;
        top: 100%;
        margin-top: 28px;
        left: 0%;
        width: max-content;
        height: fit-content;
        z-index: 100;
        background-color: rgb(18, 18, 18);
        border-radius: 16px;
        padding-left: 16px;
        padding-block: 16px;
        opacity: 0;
        visibility: hidden;
        gap: var(--gp-16);
    }

    .filter-block:hover::after {
        position: absolute;
        top: 100%;
        content: '';
        width: 100%;
        height: 28px;
        cursor: pointer;
        background: transparent;
        z-index: 50;
    }

    .filter-block:hover .filter-dropdown-block {
        opacity: 1;
        visibility: visible;
    }


    .filter-dropdown-header {
        width: 100%;
        gap: var(--gp-8);
        font-family: Roboto_Medium;
        color: var(--font-primary);
        padding-right: 16px;
    }

    .dropdown-header__label{
        color: var(--font-primary-25)
    }

    .dropdown-header__label:hover {
        color: var(--font-primary-75);
    }

    .dropdown-header__label.active {
        color: var(--font-primary)
    }


    /* Кастом чекбокс */
    
    .custom-checkbox {
        cursor: pointer;
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
        width: 20px;    
        height: 20px;
        border-radius: 4px;
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
        width: 5px;
        height: 10px;
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

    /* Скролл бар */

    .filter-dropdown-block__scroll {
        max-height: 300px;
        overflow-y: auto;
        overflow-x: hidden;
    }

    .choose-block-wrapper {
        width: 100%;
        gap: var(--gp-10);
        max-height: 300px;
        overflow-y: auto;
        padding-right: 16px;
        scrollbar-width: auto;
        scrollbar-color: var(--btn-color-6-25) transparent;
    }
    /* e,fhfndsfsdf */
    .games-block {
        height: 10000px;
    }
    /* fsdfsdfsdf */

    .filter-dropdown-block-range {
        width: 350px;
        padding-right: 16px;
    }

    .range-wrap {
        position: relative;
        width: 100%;
        height: 64px;
    }

    .range-track {
        position: absolute;
        top: 16px;
        left: 0;
        right: 0;
        height: 8px;
        background: var(--btn-color-6-25);
        border-radius: 256px;
    }

    .range-labels {
        width: 100%;
        position: absolute;
        left: 6px;
        right: 0px;
        top: 50%;
        font-family: Roboto_Regular;
    }

    .range-input {
        position: absolute;
        left: 0;
        top: 15%;
        width: 100%;
        background: transparent;
        pointer-events: none;
        appearance: none;
        -webkit-appearance: none;
    }

    .range-input::-webkit-slider-thumb {
        pointer-events: auto;
        -webkit-appearance: none;
        appearance: none;
        width: 12px;
        height: 16px;
        border-radius: 2px;
        background: var(--font-secondary);
        cursor: pointer;
    }

    /* Дата фильтр */
    
    .radio-input {
        position: absolute;
        opacity: 0;
        visibility: hidden;
        pointer-events: none;
    }

    .radio-label {
        color: var(--font-primary-75);
    }

    .radio-label.active {
        color: var(--font-secondary);
    }

    /* Адаптив */

    @media (max-width:1160px) {
        .container-wrapper {
            border-radius: 0px;
        }
    }

    @media (max-width:1024px) {
        .slider-dots {
            display: none;
        }

        .middle-side__name {
            font-size: 30px;
        }

        .middle-side-platforms {
            font-size: 18px;
        }

        .slider-wrapper__label {
            font-size: 36px;
        }

        /*  */

        .nav-block__link {
            font-size: 20px;
        }
    }

    @media (max-width:767px) {

        /* Отступы у слайдера*/

        .slider__middle-side {
            left: 24px;
            bottom: 24px;
            gap: var(--gp-8)
        }

        .slider-wrapper__label {
            left: 24px;
        }

        .top-side__info {
            right: 24px;
        }

        .slider-wrapper, .slider, .slider__img {
            min-height: 300px;
            max-height: 300px;
        }

        .slider-wrapper__label {
            font-size: 32px;
        }

        .top-side__info {
            font-size: 20px;
        }

        .middle-side__name {
            font-size: 24px;
        }

        .middle-side-platforms {
            font-size: 14px;
        }

        /* Контент блок */

        .content-block {
            padding-inline: 24px;
        }

    }

    @media (max-width:600px) {
        .container-wrapper {
            gap: var(--gp-24);
        }

        .slider__middle-side {
            left: 16px;
            bottom: 16px;
            gap: var(--gp-4);
        }

        .slider-wrapper__label {
            left: 16px;
        }

        .content-block {
            padding-inline: 16px;
        }

        .slider-wrapper, .slider, .slider__img {
            min-height: 250px;
            max-height: 250px;
        }

        .slider-wrapper__label {
            font-size: 24px;
        }

        .top-side__info {
            font-size: 16px;
            right: 16px;
            top: 24px;
        }

        .middle-side__name {
            font-size: 20px;
        }

        .middle-side-platforms {
            font-size: 12px;
        }

        /* Навигационный блок */

        .nav-block {
            gap: var(--gp-16);
        }

        .nav-block__link {
            font-size: 18px;
            padding-inline: 16px;
        }

        /* Строка фильтров */

        .games-block-header {
            gap: var(--gp-16);
        }

        .sort-row {
            gap: var(--gp-16);
            flex-direction: column;
        }

        .filter__select {
            font-size: 16px;
        }
                
    }

    @media (max-width:425px) {
        .nav-block__link {
            font-size: 16px;
        }

        .sort-row-list .sort-row-list__btn {
            width: 32px;
            height: 32px;
        }

        .slider-wrapper, .slider, .slider__img {
            min-height: 200px;
            max-height: 200px;
        }

        .slider-wrapper__label {
            font-size: 20px;
        }

        .middle-side__name {
            font-size: 16px;
        }

        .top-side__info {
            font-size: 14px;
        }

        /* ФИЛЬТР */

        .sort-row__filter {
            width: 100%;
        }

        .filter__select {
            width: 100%;
        }

    }

    @media (max-width:375px) {

        .middle-side-platforms {
            font-size: 12px;
        }

        .nav-block__link {
            font-size: 14px;
            padding-inline: 12px;
        }
    }


</style>