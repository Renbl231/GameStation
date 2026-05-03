<script setup>
    import { ref, onMounted, onUnmounted } from 'vue'
    import SecondarySlide from '../components/SecondarySlide.vue'
    // import ActivityCard from '../components/ActivityCard.vue'
    import ReviewCard from '../components/ArticleCard.vue'
    import api from '../utils/axios'

    import { preloadImages } from '../helpers/preloadImages'
    import { onImageError } from '../helpers/onImageError'
    import { storeToRefs } from 'pinia'
    import { useAuthStore } from '../stores/authStore'

    const authStore = useAuthStore()
    const { isAuthenticated, user } = storeToRefs(authStore)

    // Загрузка слайдов

    const slides = ref([])
    const isLoading = ref(true)
    
    const sliderMode = ref("")

    const loadSlides = async () => {
        try {
            const { data } = await api.get('/news/slides')
            if(data.success) {
                slides.value = data.news.result || []
                sliderMode.value = data.news.sliderMode
            }

            const imageUrls = slides.value
            .map(item => item.image)
            .filter(Boolean)

            await preloadImages(imageUrls)
        } catch(error) {
            console.log('Ошибка', error.response?.data?.error)
        }
    }

    // Работа со слайдером

    const currentSlide = ref(0)
    const direction = ref('next')
    let autoSlideInterval = null

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

   const getSecondarySlides = () => {
    return slides.value
        .filter((_, index) => index !== currentSlide.value)
        .slice(0, 3)
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

    //  Статьи

    const articles = ref([])

    const loadArticles = async () => {
        try {
            const { data } = await api.get('/articles/home')
            if(data.success) {
                articles.value = data.articles || []
            }

            const imageUrls = articleList.value
            .map(item => item.image)
            .filter(Boolean)


            await preloadImages(imageUrls)
        } catch(error) {
            console.log('Ошибка', error.response?.data?.error)
        }
    }

    // Редак мода слайдера

    const saveSliderMode = async () => {
        try {
            const { data } = await api.put('/news/slider-mode', { sliderMode: sliderMode.value })
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


    onUnmounted(() => {
        document.removeEventListener('click', closeMenu)
    })

    onMounted(async () => {
        await Promise.all([
            loadSlides(),
            loadArticles()
        ])

        isLoading.value = false
        
        document.addEventListener('click', closeMenu)
        startAutoSlide()
    })


</script>

<template>

    <Transition name="fade">
        <div v-if="!isLoading" class="container flex-column">
            <div class="headline-bar flex justify-sb">
                <div class="headline-home flex align-c">
                    <svg>
                        <use href="#icon-rule"></use>
                    </svg>
                    <h1 class="label-home">{{ sliderMode === 'main' ? 'Главные новости' : 'Популярные новости' }}</h1>
                </div>
                <div class="switch-btn-block flex align-c">
                    <button @click="prevSlide()" type="button" class="no-border switch-slide-btn flex-center"><svg><use href="#icon-btn-slider-1"></use></svg></button>
                    <button @click="nextSlide()" type="button" class="no-border switch-slide-btn flex-center"><svg><use href="#icon-btn-slider-1"></use></svg></button>
                </div>
            </div>
            <div class="slider-container flex">
                <div class="main-section flex-column">
                    <Transition :name="`slide-${direction}`">
                        <div
                            :key="currentSlide"
                            class="main-slide"
                            @touchstart="touchStart"
                            @touchend="touchEnd">
                            <picture>
                                <img :src="slides[currentSlide]?.image" @error="onImageError" class="zoom-image">
                            </picture>
                            <div class="top-info flex align-c">
                                <span class="category-slider">{{ slides[currentSlide]?.category }}</span>
                                <span class="counter-slider flex-center"><svg><use href="#icon-like"></use></svg>{{ slides[currentSlide]?.likes_count}}</span>
                            </div>
                            <div class="bottom-info flex-column">
                                <RouterLink :to="`/newsdata/${slides[currentSlide]?.idNew}`" class="label-slider">{{ slides[currentSlide]?.title }}</RouterLink>
                                <p class="description-slider">{{ slides[currentSlide]?.short_content }}</p>
                            </div>
                        </div>
                    </Transition>
                    <div class="switch-btn-block-mob flex justify-sb align-c hidden">
                        <button @click="prevSlide()" type="button" class="no-border switch-slide-btn flex-center"><svg><use href="#icon-btn-slider-1"></use></svg></button>
                        <div class="slider-dots-mob flex-center">
                            <span 
                                v-for="(slide, index) in slides"
                                :key="index"
                                class="dot"
                                :class="{active: index === currentSlide}"
                                @click="goToSlide(index)"
                                data-slide="index">
                            </span>
                        </div>
                        <button @click="nextSlide()" type="button" class="no-border switch-slide-btn flex-center"><svg><use href="#icon-btn-slider-1"></use></svg></button>
                    </div>
                    <div class="slider-dots flex-column">
                        <span 
                            v-for="(slide, index) in slides"
                            :key="index"
                            class="dot"
                            :class="{active: index === currentSlide}"
                            @click="goToSlide(index)"
                            data-slide="index">
                        </span>
                    </div>

                    <div v-if="user?.role === 4 || user?.role === 2" class="slider-options">
                        <button @click="toggleEditModeSlider" type="button" class="no-border slider-options__showBtn">
                            ...
                        </button>
                        <div v-if="isEditModeSlider" class="slider-options-wrapper flex-column flex-center">
                            <div class="slider-options-inputs flex-column">
                                <div class="options-inputs__block flex align-c">
                                    <input v-model="sliderMode" type="radio" class="custom-radio" id="sliderMode1" name="sliderMode" value="main" :checked="sliderMode === 'main'"/>
                                    <label for="sliderMode1">Главное</label>
                                </div>
                                <div class="options-inputs__block flex align-c">
                                    <input v-model="sliderMode" type="radio" class="custom-radio" id="sliderMode2" name="sliderMode" value="popular" :checked="sliderMode === 'popular'"/>
                                    <label for="sliderMode2">Популярные</label>
                                </div>
                            </div>
                            <div class="slider-options-btns flex-center">
                                <button @click="saveSliderMode" type="button" class="no-border">Сохранить</button>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="secondary-sections flex-column">
                    <SecondarySlide
                        v-for="(slide, index) in getSecondarySlides()"
                        :key="`sec-${slides[currentSlide]?.id || index}-${index}`" 
                        :slide="slide"
                        class="secondary-slide"
                        :style="{ '--anim-delay': index * 0.0555 }" />
                </div>

            </div>

            <!-- <div v-if="isAuthenticated" class="headline">
                <span>Игровая статистика друзей</span>
            </div> -->
            
            <!-- :class="{st2: isAuthenticated}" -->

            <div class="wrapper-content flex-column">
                <!-- <div v-if="isAuthenticated" class="activity-wrapper flex-column">

                    <div class="activity-card flex-column">
                        <div class="friend-profile flex">
                            <img src="/images/12.jpg" class="friend-avatar">
                            <div class="banner-container">
                                <img src="/images/5.jpg" class="friend-banner">
                                <span class="friend-name">Cl0WN1CH</span>
                            </div>
                        </div>
                        <ActivityCard />
                        <button type="button" class="no-border show-more-activity">Подробнее...</button>
                        <div class="statistic-wrapper flex align-c">
                            <div class="completed-game stat-block flex align-c">
                                <span>пройдено:</span>
                                <span class="quantity-stat">1500</span>
                            </div>
                            <div class="rated stat-block flex align-c">
                                <span>оценено:</span>
                                <span class="quantity-stat">131</span>
                            </div>
                            <div class="played stat-block flex align-c">
                                <span>сыграно:</span>
                                <span class="quantity-stat">32</span>
                            </div>
                        </div>
                    </div>

                </div> -->

                <div v-if="articles.length && !isLoading" class="reviews-container flex-column">
                    <div class="headline flex">
                        <span>Обзоры от нас</span>
                    </div>
                    <div class="review-wrapper">
                        <ReviewCard
                            v-for="article in articles" 
                            :key="article.id"
                            :id="article.idArticle"
                            :title="article.title"
                            :type_article="article.type_article === 'reviews' ? 'Обзор' : 'Неизвестно'"
                            :image="article.image"
                            :comments="article.comments_count"
                            :created_at="article.created_at"
                            :score="Number(article.score)"
                        />
                    </div>           
                </div>

            </div>
        </div>
    </Transition>
</template>


<style scoped>

    .container {
        width: 100%;
        gap: var(--gp-32);
    }

    .headline-home {
        gap: var(--gp-10);
    }

    .headline-home svg {
        width: 28px;
        height: 26px;
    }

    .label-home {
        font-size: 32px;
        font-family: Montserrat_SemiBold;
    }

    .switch-btn-block {
        gap: var(--gp-16);
    }

    .switch-slide-btn {
        position: relative;
        width: 36px;
        height: 36px;
        border: 2px solid var(--font-secondary);
        transition: 0.3s;
    }

    .switch-slide-btn:hover {
        filter: brightness(1.5);
    }

    .switch-btn-block button:nth-child(1), .switch-btn-block-mob button:nth-child(1) svg {
        transform: rotate(180deg);
    }

    .switch-btn-block button:nth-child(2) svg, .switch-btn-block-mob button:nth-child(2) svg  {
        transform: rotate(0deg);
    }

    .switch-slide-btn svg {
        width: 16px;
        height: 16px;
    }

    .slider-container {
        width: 100%;
        gap: var(--gp-32);
        margin-bottom: 16px;
    }

    .main-section {
        position: relative;
        max-width: 928px;
        height: 522px;
        width: 100%;
        border-radius: 8px;
        overflow: hidden;
        box-shadow: 0 8px 64px 0 rgba(69, 171, 255, 0.25);
    }

    .main-slide {
        width: 100%;
        border-radius: 8px;
        will-change: transform;
        position: absolute;
        top: 0;
        left: 0;
        height: 100%;
        will-change: transform;
        overflow: hidden;
    }

    .main-slide img {
        width: 100%;
        height: 522px;
        border-radius: 8px;
    }

    .main-slide::before {
        content: '';
        position: absolute;
        top: 0;
        left: 0;
        right: 0;
        bottom: 0;

        background: linear-gradient(
            to bottom,
            transparent 0%,
            transparent 40%,
            rgba(0,0,0,0.6) 70%,
            rgba(0,0,0,0.9) 100%
        );

        z-index: 1;
    }

    .counter-slider {
        position: absolute;
        top: 16px;
        right: 16px;
        z-index: 10;
        gap: var(--gp-8);
        font-size: 14px;
        font-family: Roboto_SemiBold;
        padding: 8px;
        background-color: var(--btn-color-3);
        border-radius: 4px;
        color: var(--font-primary-25);
        transition: 0.3s;
    }

    .counter-slider svg {
        width: 24px;
        height: 24px;
    }

    .bottom-info {
        max-width: 90%;
        position: absolute;
        bottom: 16px;
        left: 16px;
        z-index: 10;
        gap: var(--gp-8);
    }

    .label-slider {
        font-family: Montserrat_Bold;
        font-size: 32px;
        line-height: 42px;
        transition: 0.3s;
    }

    .label-slider:hover {
        text-decoration: underline;
    }

    .description-slider {
        font-size: 20px;
        font-family: Montserrat_Medium;
        line-height: 32px;
        color: var(--font-primary-50);
    }

    .category-slider {
        position: absolute;
        top: 16px;
        left: 16px;
        z-index: 10;
        font-size: 16px;
        font-family: Montserrat_SemiBold;
        text-transform: uppercase;
        padding: 6px 8px;
        background-color: rgba(0, 0, 0, 0.5);
        border-radius: 4px;
        backdrop-filter: blur(4px);
    }

    .slider-dots, .slider-dots-mob {
        position: absolute;
        top: 50%;
        right: 16px;
        gap: var(--gp-20);
        z-index: 30;
        transform: translateY(-50%);
    }

    .dot {
        width: 20px;
        height: 20px;
        border-radius: 50%;
        border: 2px solid var(--font-primary-50);
        cursor: pointer;
        transition: 0.3s;
    }

    .dot.active, .dot:hover {
        background-color: var(--font-secondary);
        border-color: var(--font-secondary);
    }

    .secondary-sections {
        max-width: 352px;
        width: 100%;
        gap: var(--gp-20);
    }

    .wrapper-content {
        gap: var(--gp-36);
    }

    .wrapper-content.st2 {
        flex-direction: row;
    }

    /* Отзывы */

    .reviews-container {
        width: 100%;
        gap: var(--gp-24);
    }

    .reviews-container.st2 {
        max-width: 508px;
        background-color: var(--bg-secondary-25);
        border-radius: 16px;
        padding: 32px 24px;
    }

    .reviews-container.st2 .headline {
        padding: 0;
    }

    .reviews-container.st2 .headline span {
        border-color: var(--bg-secondary-50);
    }

    .headline {
        padding-left: 24px;
        font-family: Roboto_SemiBold;
        font-size: 32px;
    }

    .headline span {
        border-bottom: 2px solid var(--font-secondary);
        padding-bottom: 8px;
    }

    .review-wrapper {
        background-color: var(--bg-secondary-25);
        padding: 32px 24px;
        border-radius: 16px;
        display: grid;
        grid-template-columns: repeat(3, 1fr);
        gap: var(--gp-32);
    }

    .reviews-container.st2 .review-wrapper {
        grid-template-columns: repeat(1, 1fr);
        background-color: transparent;
        padding: 0;
    }

    .reviews-container.st2 .review-wrapper :deep(.review-card) {
        max-width: none;
    }

    .reviews-container.st2 .headline span {
        width: 100%;
    }

    .switch-btn-block-mob {
        position: relative;
        width: 100%;
        padding: 16px;
        border-bottom: 2px solid var(--bg-secondary-25);
        margin-top: auto;
    }

    .slider-dots-mob {
        position: absolute;
        top: 50%;
        left: 50%;
        gap: var(--gp-20);
        z-index: 30;
        transform: translate(-50%, -50%);
    }

    .activity-wrapper {
        max-width: 768px;
        width: 100%;
        gap: var(--gp-32);
    }

    .activity-card {
        width: 100%;
        padding: 24px;
        gap: var(--gp-32);
        font-family: Roboto_Medium;
        border-radius: 8px;
        background-color: var(--bg-secondary-25);
    }

    .friend-profile {
        width: 100%;
        height: 90px;
    }

    .friend-avatar {
        width: 90px;
        height: 90px;
        border-radius: 8px 0px 0px 8px;
    }

    .friend-banner {
        width: 100%;
        height: 90px;
        border-radius: 0px 8px 8px 0px;
    }

    .banner-container {
        width: 100%;
        position: relative;
        border-radius: 8px;
    }

    .friend-name {
        position: absolute;
        top: 50%;
        transform: translateY(-50%);
        padding-left: 32px;
        font-size: 32px;
        font-family: Roboto_SemiBold;
        overflow: hidden;
    }

    .show-more-activity {
        width: fit-content;
        padding: 0px;
        color: var(--font-secondary);
        border-bottom: 1px solid var(--font-secondary);
        font-size: 20px;
        transition: 0.3s;
    }
    
    .show-more-activity:hover {
        color: var(--font-primary);
        border-color: var(--font-primary);
    }

    .statistic-wrapper {
        width: 100%;
        padding-block: 10px;
        background-color: var(--btn-color-6-25);
        justify-content: space-around;
        border-radius: 8px;
    }

    .stat-block {
        gap: var(--gp-8);
    }

    .quantity-stat {
        font-size: 14px;
        color: var(--font-primary-50);
    }

    .zoom-image {
        transform-origin: center center;
        animation: zoomInOut 11s ease-in-out forwards;
    }

    @keyframes zoomInOut {
        0% { transform: scale(1); }
        100% { transform: scale(1.25); }
    }

    /* Опции слайдера */

    .slider-options {
        position: absolute;
        bottom: 0;
        right: 0px;
        padding: 32px;
        z-index: 100;
    }

    .slider-options__showBtn {
        position: absolute;
        top: 0%;
        right: 16px;
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



    /* Анимация */

    .slide-next-enter-active, .slide-next-leave-active,
    .slide-prev-enter-active, .slide-prev-leave-active {
    transition: all 0.75s cubic-bezier(0.4, 0, 0.2, 1);
    }

    .slide-next-enter-from {
    transform: translateX(-100%);
    }

    .slide-next-leave-to {
    transform: translateX(100%);
    }

    .slide-prev-enter-from {
    transform: translateX(100%);
    }

    .slide-prev-leave-to {
    transform: translateX(-100%);
    }

    .slide-next-enter-to, .slide-prev-enter-to,
    .slide-next-leave-from, .slide-prev-leave-from {
    transform: translateX(0);
    }


@media (max-width:1160px) {
    .secondary-sections {
        display: none;
    }

    .main-section, .activity-wrapper {
        max-width: none;
    }

    .main-section, .main-slide, .main-slide img, .review-wrapper, .activity-card  {
        border-radius: 0px;
    }

    .headline-bar, .headline {
        padding-inline: 32px;
    }

    .review-wrapper {
        gap: var(--gp-24);
    }

    .wrapper-content {
        flex-direction: column !important;
        gap: var(--gp-48);
    }

    .main-slide:has(.label-slider:hover) .zoom-image {
        transform: none
    }

    .reviews-container.st2 {
        background: none;
        max-width: none;
        width: 100%;
        border-radius: 0px;
        padding: 0px
    }

    .reviews-container.st2 .review-wrapper {
        grid-template-columns: repeat(3, 1fr);
        background-color: var(--bg-secondary-25);
        padding: 32px 24px;
    }

    .reviews-container.st2 .headline {
        padding-left: 24px;
    }

    .reviews-container.st2 .headline span {
        border-color: var(--font-secondary);
    }
}

@media (max-width:1024px) {
    .review-wrapper, .reviews-container.st2 .review-wrapper {
        grid-template-columns: repeat(2, 1fr);
    }
}

@media (max-width:900px) {
    .main-section, .main.section, .main-slide img {
        height: 432px;
    }
}

@media (max-width:767px) {
    .label-slider {
        font-size: 24px;
        line-height: 29px;
    }
    .description-slider {
        font-size: 16px;
        line-height: 20px;
    }
}

@media (max-width:600px) {
    .wrapper-content {
        gap: var(--gp-32);
    }
    .headline-bar, .headline {
       padding-inline: 16px; 
    }
    .switch-btn-block, .slider-dots {
        display: none;
    }
    .label-slider {
        font-size: 20px;
        line-height: 26px;
    }
    .description-slider {
        font-size: 12px;
        line-height: 18px;
    }
    .category-slider {
        font-size: 14px;
        top: 8px;
        left: 8px;
    }
    .counter-slider {
        font-size: 12px;
        top: 8px;
        right: 8px;
    }
    .counter-slider svg {
        width: 20px;
        height: 20px;
    }
    .bottom-info {
        max-width:none;
        bottom: 8px;
        left: 8px;
        gap: var(--gp-4);
        padding-right: 8px;
    }

    .review-wrapper {
        padding: 16px;
        gap: var(--gp-16);
    }

    .slider-container {
        margin-bottom: 0px;
    }

    .statistic-wrapper {
        font-size: 14px;
    }

    .label-home {
        font-size: 28px;
    }

    .headline {
        font-size: 24px;
    }

    .headline-home svg {
        width: 24px;
        height: 22px;
    }

    .activity-card {
        padding: 16px
    }

    .activity-wrapper, .activity-card {
        gap: var(--gp-24);
    }

    .friend-avatar {
        width: 60px;
        height: 60px;
    }
    .friend-banner, .friend-profile {
        height: 60px;
    }
    .friend-name {
        font-size: 20px;
        padding-left: 16px;
    }

    .show-more-activity {
        font-size: 16px;
    }

    .quantity-stat {
        font-size: 12px;
    }

    .stat-block {
        gap: var(--gp-4);
    }
    .switch-btn-block-mob {
        display: flex;
    }
        
    .main-slide, .main-slide img {
        height: 239px;
    }

    .main-slide {
    box-shadow: 0 8px 64px 0 rgba(69, 171, 255, 0.25);
    }    

    .main-section {
        height: 309px;
        box-shadow: none;
    }

    .slider-options {
        bottom: 64px;
    }

}

@media (max-width:425px) {
    .headline {
        font-size: 24px;
    }
    .category-slider {
        font-size: 10px;
        padding: 6px 8px;
    }
    .counter-slider {
        font-size: 12px;
        padding: 6px;
    }
    .counter-slider svg {
        width: 16px;
        height: 16px;
    }
    .label-slider {
        font-size: 18px;
        line-height: 22px;
    }
    .description-slider {
        font-size: 10px;
        line-height: 14px;
    }
}

@media (max-width:375px) {
    .label-home {
        font-size: 24px;
    }
    .dot {
        width: 16px;
        height: 16px;
    }
    .label-slider {
        font-size: 14px;
        line-height: 18px;
    }

    .statistic-wrapper {
        font-size: 13px;
    }
    .headline {
        font-size: 20px
    }
} 

@media (max-width:350px) {
    .main-slide, .main-slide img {
        height: 200px;
    }
    .main-section {
        height: 270px;
    }
}

@media (max-width:320px) {
    .switch-slide-btn {
        width: 32px;
        height: 32px;
    }
    .friend-avatar {
        width: 48px;
        height: 48px;
    }
    .friend-banner, .friend-profile {
        height: 48px;
    }
    .friend-name {
        font-size: 16px;
    }
    .statistic-wrapper, .quantity-stat {
        font-size: 10px;
    }
} 

</style>
