<script setup>
    import GamePopUp from '../components/GamePopUp.vue'
    import ConfirmPopUp from '../components/ConfirmPopUp.vue';
    import { ref, onMounted, onUnmounted, computed, watch} from 'vue'
    import api from '../utils/axios'

    import { useFormatDate } from '../composables/useFormatDate'
    const { simpleDate } = useFormatDate()

    import { useNotifications } from '../stores/notifications';
    import { useApiNotifications } from '../composables/useApi';
    const { apiCall } = useApiNotifications()
    const notification = useNotifications()

    import { useRoute, useRouter } from 'vue-router'
    const route = useRoute()
    const router = useRouter()

    import { useGlobal404 } from '../composables/useGlobal404'
    const { set404 } = useGlobal404()

    import { storeToRefs } from 'pinia'
    import { useAuthStore } from '../stores/authStore'
    const authStore = useAuthStore()
    const { isAuthenticated, user } = storeToRefs(authStore)

    const isLoading = ref(true);

    // Загрузка игры

    const game = ref({})
    const platforms = ref([])
    const tags = ref([])
    const screenshots = ref({})

    const preloadImage = (src) =>
  new Promise((resolve) => {
    if (!src) return resolve({ src, ok: false })
    const img = new Image()
    img.onload = () => resolve({ src, ok: true })
    img.onerror = () => resolve({ src, ok: false })
    img.src = src
  })

const preloadImages = async (urls) => {
  const results = await Promise.all(urls.map(preloadImage))
  const failed = results.filter(x => !x.ok).map(x => x.src)
  if (failed.length) console.warn('Не загрузились картинки:', failed)
}

    const loadGame = async() => {
    try {
        const idGame = route.params.id
        const { data } = await api.get(`/game/${idGame}`)

        if (!data) {
        set404()
        return
        }

        game.value = data
        platforms.value = data.platforms
        tags.value = data.tags
        screenshots.value = data.screenshots

        const imageUrls = [
        game.value.banner,
        game.value.cover_url,
        ...(screenshots.value || []).map(s =>
            s.image_url || `https://images.igdb.com/igdb/image/upload/t_720p/${s.image_id}.jpg`
        )
        ]

        await preloadImages(imageUrls)
    } catch (error) {
        game.value = {}
        set404()
    } finally {
        isLoading.value = false
    }
    }

    // Загрузка данных пользователя об игре

    const userScore = ref(null)
    const userCollectionType = ref(null)
    const review_id = ref(null)
    const rating_id = ref(null)

    const loadUserGameData = async() => {
        if(!isAuthenticated.value) return
        const { data } = await api.get(`/game/${route.params.id}/info`)
        if(data.success) {
            userScore.value = data.result.score
            userCollectionType.value = data.result.collection_type
            review_id.value = data.result.review_id || null
            rating_id.value = data.result.rating_id
        }
    }

    // Работа со скринами

    const getScreenshotSrc = (screen) => {
    if (!screen) return ''
    
    if (typeof screen === 'string') {
        if (screen.startsWith('http') || screen.startsWith('games/')) {
            return screen
        }
        return `https://images.igdb.com/igdb/image/upload/t_720p/${screen}.jpg`
    }
    
    if (screen.image_url) return screen.image_url
    if (screen.image_id) return `https://images.igdb.com/igdb/image/upload/t_720p/${screen.image_id}.jpg`
    
    return ''
}

    // Обрезка текста

    const showFullDesc = ref(false)
    const displayText = computed(() => {
    const summary = game.value.summary
        if (!summary) return 'отсутствует'
        if (showFullDesc.value) return summary
        return summary.length > 300 ? summary.slice(0, 300).trimEnd() + '...' : summary
    })
        
    // Popup с игрой

    const popupGameVisible = ref(false)
    const popupGameType = ref('View')
    const selectedGame = ref({})
    const selectedGameInfo = ref({})

    const showPopupGame = async (type) => {
        popupGameType.value = type
        selectedGameInfo.value = {
            id: game.value.idGame,
            name: game.value.name,
            cover: game.value.cover_url
        }
        const { data } = await api.get(`/games/${route.params.id}/my-rating`)
        selectedGame.value = data.result
        popupGameVisible.value = true
    }

    const closePopupGame = async() => {
        await loadUserGameData()
        popupGameVisible.value = false
    }


    // Удаление игры

    const showMenu = ref(false)

    const closeMenu = (event) => {
        if (!event.target.closest('.action-menu')) {
            showMenu.value = false
        }
    }

    const isVisiblePopup = ref(false)

    const handleDelete = async() => {   
        const data = await apiCall(() => api.delete(`/game/${route.params.id}/delete`), 'Игра удалена')
        if(data.status === 204) {
            await router.push('/games')
        }           
    }

    const loadPageData = async (gameId) => {
        const tasks = [loadGame(gameId)]

        if (user.value) {
            tasks.push(loadUserGameData())
        }

        await Promise.all(tasks)
    }

    // Рецензия

    // Объект данных рецензии

    const isReview = ref(false)

    const showReviewGame = async () => {
        if (!userScore.value) {
            notification.error('Поставьте оценку игре')
            return
        }

        if (!review_id.value) {
            isReview.value = true
            return
        }

        try {
            const { data } = await api.get('/games/getReview', {
                params: {
                    review_id: review_id.value
                }
            })

            if (data.success) {
            reviewForm.value = data.result
            isReview.value = true
            }
        } catch (error) {
            console.log(error)
            notification.error('Не удалось загрузить рецензию')
        }
    }

    const reviewForm = ref({
        title: '',
        content: ''
    })

    const handleReview = async() => {
        if(reviewForm.value.title.trim().length > 60) {
            notification.warning('Заголовок слишком длинный')
            return
        }
        if(reviewForm.value.content.trim().length < 15) {
            notification.warning('Контент слишком короткий')
            return
        }
        const data = await apiCall(() => api.post(`/game/${route.params.id}/publishReview`,
            {  
                rating_id: rating_id.value,
                reviewForm: reviewForm.value
            },'Ответ опубликован'))
        if(data.success) {
            review_id.value = data.result
            isReview.value = false
        }
    }


    onUnmounted(() => {
        document.removeEventListener('click', closeMenu)
    })

    onMounted(async () => {
        await loadPageData(route.params.id)
        document.addEventListener('click', closeMenu)
        isLoading.value = false
    })

    watch(
        () => route.params.id,
        async (newId, oldId) => {
            if (newId !== oldId) {
                await loadPageData(newId)
            }
        }
    )

</script>

<template>
    <Transition name="fade">
        <div v-if="!isLoading" class="container flex-column">
            <Transition name="popup-slide">
                <div v-if="isReview" class="reviewPopUp flex-center">
                    <div class="reviewPopUp-container flex-center">
                        <button @click="isReview = false" type="button" class="no-border review-container-closeBtn"></button>
                        <div class="reviewPopUp-wrapper flex-column flex-center">
                            <div class="reviewPopUp-header flex-column align-c">
                                <picture>
                                    <img :src="game.cover_url" class="reviewPopUp__cover">
                                </picture>
                                <span class="reviewPopUp__label">{{ game.name }}</span>
                            </div>
                            <div class="reviewPopUp-score">
                                <span class="reviewPopUp__score">Моя оценка {{ Number(userScore) }}</span>
                            </div>
                            <div class="reviewPopUp-form flex-column">
                                <input v-model="reviewForm.title" class="no-border reviewPopUp__input" placeholder="Заголовок">
                                <input v-model="reviewForm.content" class="no-border reviewPopUp__input" placeholder="Содержание">
                            </div>
                            <button @click="handleReview" type="button" class="no-border">Опубликовать</button>
                        </div>
                    </div>
                </div>
            </Transition>

            <Transition name="popup-slide">
                <GamePopUp
                    v-if="popupGameVisible"
                    :game-status="selectedGame"
                    :game-info="selectedGameInfo"
                    :module-type="popupGameType"
                    @close-popup="closePopupGame"
                />
            </Transition>

            <div v-if="game.trailer_url || game.banner" :class="{'active': game.trailer_url}" class="container-header">
                <video v-if="game.trailer_url" 
                    :key="game.idGame"
                    class="game__trailer"
                    autoplay 
                    muted 
                    loop 
                    playsinline
                    poster="https://picsum.photos/1920/400?random=1"
                    >
                    <source 
                        :src="game.trailer_url" 
                        type="video/mp4"
                    >
                    Ваш браузер не поддерживает видео
                </video>
                <picture v-else-if="game.banner">
                    <img :src="game.banner" alt="Банер" class="game__baner">
                </picture>
            </div>
            <div class="game-container flex">
                <div class="game-leftSide flex-column">
                    <div class="game-imgBlock">
                        <picture>
                            <img :src="game.cover_url" class="game__cover">
                        </picture>
                        <span class="game__rating flex-center">{{ Number(game.rating_overall) }}</span>
                    </div>
                    <div v-if="isAuthenticated" class="game-leftSide-btns flex-column">
                        <button @click="showPopupGame('Estimate')" type="button" class="no-border leftSide__btn">
                            {{ userScore != null ? `Моя оценка ${Number(userScore)}` : 'Поставить оценку' }}
                        </button>
                        <button @click="showReviewGame" type="button" class="no-border leftSide__btn">{{ review_id ? 'Редактировать рецензию' : 'Написать рецензию'}}</button>
                        <button type="button" class="no-border leftSide__btn">Добавить в подборку</button>
                        <div @click="showPopupGame('View')" class="game-status-block flex-center">
                            <button type="button" class="no-border flex-center game__btnShowForm">
                                <svg v-if="!userCollectionType" class="icon">
                                    <use href="#icon-plus"></use>
                                </svg>
                                <svg v-else class="icon">
                                    <use href="#icon-minus"></use>
                                </svg>
                            </button>
                            <span v-if="userCollectionType" class="game__status">
                                {{ userCollectionType }}
                            </span>
                        </div>
                    </div>
                </div>
                <div class="game-rightSide flex-column">
                    <div class="game-content flex-column">
                        <div class="game-name-block flex align-c justify-sb">
                            <span class="game__name">{{ game.name }}</span>
                        <div v-if="authStore.user?.role === 4" class="action-menu">
                            <button type="button" class="no-border news-container-interaction__btn action" @click="showMenu = !showMenu">
                                ...
                            </button>
                            <div v-if="showMenu" class="dropdown-menu">
                                <RouterLink :to="`/editGame/${game.idGame}`">
                                    <button class="menu-item no-border">Редактировать</button>
                                </RouterLink>
                                <button class="menu-item danger no-border" @click="isVisiblePopup = true">Удалить</button>
                            </div>
                            <ConfirmPopUp 
                            v-model="isVisiblePopup"
                            :label="'игру'" 
                            @confirm="handleDelete"/>
                        </div>
                        </div>
                        <dl class="game-info">
                            <dt>Платформы</dt>
                            <dd>  
                                <span v-for="(platform, index) in platforms" :key="platform + index">
                                    {{ platform }}
                                    <span v-if="index < platforms.length - 1">, </span>
                                </span>
                            </dd>
        
                            <dt>Теги</dt>
                            <dd>
                                <span v-for="(tag, index) in tags" :key="tag + index">
                                    {{ tag }}
                                    <span v-if="index < tags.length - 1">, </span>
                                </span>
                            </dd>
        
                            <dt>Разработчик</dt>
                            <dd>
                                <span>{{ game.developer }}</span>
                            </dd>
        
                            <dt>Издатель</dt>
                            <dd>
                                <span>{{ game.publisher }}</span>
                            </dd>
        
                            <dt>Дата выхода</dt>
                            <dd>
                                <span>{{ simpleDate(game.release_date)}}</span>
                            </dd>
        
                            <dt>Описание</dt>
                            <dd>
                                <div class="description-block flex-column">
                                    <p class="game__descriptions">{{ displayText }}</p>
                                    <button v-if="game?.summary?.length > 300" @click="showFullDesc = !showFullDesc" type="button" class="no-border description__btn">
                                        {{ showFullDesc ? 'скрыть' : 'читать подробнее'}}
                                    </button>
                                </div>
                            </dd>
                        </dl>
                    </div>
                    <hr v-if="screenshots">
                    <div class="screenshots-scroll-wrapper">
                        <div class="game-screenshots flex align-c">
                            <div v-for="screen in screenshots"
                                 class="game-screenshot-block"
                                 :key="screen.idScreenshot">
                                <picture>
                                    <img :src="getScreenshotSrc(screen.image_id || screen.image_url)" class="game__screenshot" alt="скриншот">
                                </picture>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </Transition>
</template>

<style scoped>
    .container {
        width: 100%;
        background-color: var(--bg-secondary-25);
        border-radius: 16px;
    }

    /* Банер и трейлер блок */

    .container-header {
        width: 100%;
        height: 400px;
        border-radius: 16px 16px 0px 0px;
        transition: height 0.3s ease;
    }

    .container-header.active:hover {
        height: 500px;
    }

    .game__trailer {
        width: 100%;
        height: 100%;
        object-fit: cover;
        object-position: center;
        border-radius: 16px 16px 0px 0px;
    }

    .game__baner {
        width: 100%;
        max-height: 400px;
        min-height: 400px;
        border-radius: 16px 16px 0px 0px;
    }


    /* Контент игры */

    .game-container {
        width: 100%;
        padding: 32px;
        gap: var(--gp-32);
    }

    .game-leftSide {
        width: auto;
        position: relative;
        gap: var(--gp-16);
    }

    .game__cover {
        max-width: 280px;
        min-width: 280px;
        max-height: 374px;
        min-height: 374px;
        border-radius: 8px;
    }

    .game__rating {
        position: absolute;
        top: 12px;
        left: 12px;
        font-family: Roboto_SemiBold;
        font-size: 16px;
        padding: 2px 16px;
        border-radius: 4px;
        background-color: var(--btn-color-5);
        z-index: 50;
        cursor: pointer;
    }

    .game-leftSide-btns {
        width: 100%;
        gap: var(--gp-16);
    }

    .leftSide__btn {
        width: 100%;
        background-color: var(--btn-color-6-25);
        border-radius: 4px;
        padding-block: 8px;
        font-family: Roboto_Medium;
        font-size: 16px;
    }

    .game-status-block {
        width: 100%;
        gap: var(--gp-8);
        cursor: pointer;
    }

    
    .game__btnShowForm {
        width: 24px;
        height: 24px;
        background-color: var(--font-primary-25);
        border-radius: 4px;
        padding: 4px;
    }

    .icon {
        width: 12px;
        height: 12px;
    }


    .game__status {
        font-family: Roboto_Medium;
        font-size: 20px;
        color: var(--font-primary-50);
    }
    

    /* Правая часть игры */

    .game-rightSide {
        width: 100%;
        gap: var(--gp-24);
        overflow: hidden;
    }

    .game-content {
        width: 100%;
        gap: var(--gp-16);
    }

    .game-name-block {
        width: 100%;
    }

    .game__name {
        font-family: Roboto_SemiBold;
        font-size: 30px;
    }

    .action-menu {
        position: relative;
    }

    .news-container-interaction__btn.action {
        width: 32px;
        height: 32px;
        background-color: var(--color-1);
        border-radius:4px;
    }

    .news-container-interaction__btn.action:hover {
        filter: brightness(1.25);
    }

    .dropdown-menu {
        width: fit-content;
        position: absolute;
        top: 0%;
        right: 48px;
        background-color: var(--color-1);
        border-radius: 4px;
        z-index: 1000;
        opacity: 0;
        transform: translateX(48px);
        animation: slideDown 0.3s ease forwards;
    }

    
    @keyframes slideDown {
        to {
            opacity: 1;
            transform: translateY(0);
        }
    }

  .menu-item {
        width: 100%;
        padding: 12px 16px;
        color: #fff;
        text-align: left;
        font-size: 14px;
        font-family: Roboto_Regular;
        transition: background-color 0.2s;
    }

    .menu-item:hover {
        background-color: #40444b;
    }

    .menu-item.danger {
        border-top: 1px solid #40444b;
        color: #ff6b6b;
    }

    .menu-item.danger:hover {
        background-color: #ff6b6b;
        color: #fff;
    }






    .game-info {
        display: grid;
        grid-template-columns: max-content 1fr;
        column-gap: 16px;
        row-gap: 16px;
        font-family: Roboto_Medium;
        font-size: 20px;
    }

    .game-info dt {
        margin: 0;
        white-space: normal;
        color: var(--font-primary-50);
    }

    .game-info dd {
        margin: 0;
        min-width: 0;
    }

    .description__btn {
        width: fit-content;
        font-size: 20px;
        color: var(--font-secondary);
    }

    .screenshots-scroll-wrapper {
        width: 100%;
        overflow: hidden;
    }

    .game-screenshots {
        gap: var(--gp-24);
        overflow-x: auto;
        overflow-y: hidden;
        padding-bottom: 16px;
        scrollbar-width: thin;
        scrollbar-color: var(--btn-color-6-50) transparent;
    }


    .game-screenshot-block {
        min-width: 288px;
    }

    .game__screenshot {
        width: 100%;
        max-height: 162px;
        min-height: 162px;
        border-radius: 8px;
    }


/* Попап рецензии */

    .reviewPopUp{
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

    .reviewPopUp-container {
        position: relative;
        max-width: 430px;
        width: 100%;
        padding: 48px 24px;
        background-color: var(--color-2);
        border-radius: 16px;
        border: 1px solid var(--bg-secondary-50);
        margin: 0 auto;

    }

    /* Крестик */

    .review-container-closeBtn {
        position: absolute;
        width: 32px;
        height: 32px;
        cursor: pointer;
        top: 16px;
        right: 16px;
    }

    .review-container-closeBtn::before,
    .review-container-closeBtn::after {
        content: '';
        position: absolute;
        top: 16px;
        left: 50%;
        width: 20px;
        height: 2px;
        background-color: var(--font-primary-50);
        transform: translate(-50%, -50%) rotate(45deg);
    }

    .review-container-closeBtn::after {
        transform: translate(-50%, -50%) rotate(-45deg);
    }

    .review-container-closeBtn:hover::before,
    .review-container-closeBtn:hover::after {
        background-color: var(--font-primary);
    }


    .reviewPopUp-wrapper {
        width: 100%;
        gap: var(--gp-20);
    }

    .reviewPopUp-header {
        gap: var(--gp-8);
    }

    .reviewPopUp__cover {
        width: 96px;
        height: 96px;
        border-radius: 4px;
    }

    .reviewPopUp__label {
        font-family: Roboto_Medium;
        font-size: 24px;
    }

    .reviewPopUp__score {
        font-family: Roboto_Medium;
    }

    .reviewPopUp-form {
        gap: var(--gp-8);
    }

    .reviewPopUp__input {
        font-family: Roboto_Medium;
    }


    .popup-slide-enter-active,
    .popup-slide-leave-active {
        transition: all 0.3s ease
    }

    .popup-slide-enter-from,
    .popup-slide-leave-to {
        opacity: 0;
        transform: translateY(80px);
    }

    .popup-slide-enter-to,
    .popup-slide-leave-from {
        opacity: 1;
        transform: translateY(0);
    }


            
        
</style>