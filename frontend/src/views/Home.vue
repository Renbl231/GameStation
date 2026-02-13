<script setup>
    import { ref, onMounted } from 'vue'
    import SecondarySlide from '../components/SecondarySlide.vue'
    import ActivityCard from '../components/ActivityCard.vue'
    import ReviewCard from '../components/ArticleCard.vue'

    const slides = ref([
        {
            image: '/images/aga.jpg',
            category: 'release',
            label: 'Провальный релиз Escape From Tarkov',
            description: 'Почему релиз EFT настолько был плох...',
            likes: 14633
        },
        {
            image: '/images/orig.webp',
            category: 'update',
            label: 'Обновление v2.31',
            likes: 8234
        },
        {
            image: '/images/1.webp',
            category: 'update',
            description: 'Я хз чё тут',
            label: 'Обновление v2.31', 
            likes: 4567
        },
        {
            image: '/images/2.jpeg',
            category: 'update',
            label: 'Обновление v2.31',
            likes: 2345
        }
    ])

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

    onMounted(() => {
        startAutoSlide()
    })

</script>

<template>

    <div class="container flex-column">

        <div class="headline-bar flex justify-sb">
            <div class="headline-home flex align-c">
                <svg>
                    <use href="#icon-rule"></use>
                </svg>
                <h1 class="label-home">Главное сегодня</h1>
            </div>
            <div class="switch-btn-block flex align-c">
                <button @click="prevSlide()" type="button" class="no-border switch-slide-btn flex-center"><svg><use href="#icon-btn-slider-1"></use></svg></button>
                <button @click="nextSlide()" type="button" class="no-border switch-slide-btn flex-center"><svg><use href="#icon-btn-slider-1"></use></svg></button>
            </div>
        </div>
        <div class="slider-container flex">
            <div class="main-section flex-column">
                <Transition :name="`slide-${direction}`">
                    <div :key="currentSlide" class="main-slide"
                    @touchstart="touchStart"
                    @touchend="touchEnd">
                        <picture>
                            <img :src="slides[currentSlide].image" class="zoom-image">
                        </picture>
                        <div class="top-info flex align-c">
                            <span class="category-slider">{{ slides[currentSlide].category }}</span>
                            <button type="button" aria-label="Оценить новость" class="no-border counter-slider flex-center"><svg><use href="#icon-like"></use></svg>{{ slides[currentSlide].likes}}</button>
                        </div>
                        <div class="bottom-info flex-column">
                            <span class="label-slider">{{  slides[currentSlide].label }}</span>
                            <p class="description-slider">{{ slides[currentSlide].description }}</p>
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
            </div>

            <div class="secondary-sections flex-column">
                <SecondarySlide
                    v-for="(slide, index) in getSecondarySlides()"
                    :key="`SEC-${Date.now()}-${currentSlide.value}-${index}`"  
                    :slide="slide"
                    class="secondary-slide"
                    :style="{ '--anim-delay': index * 0.0555 }" />
            </div>

        </div>

        <div class="headline">
            <span>Игровая статистика друзей</span>
        </div>
        
        <div class="wrapper-content flex-column">
            <div class="activity-wrapper flex-column">
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
            </div>

            <div class="reviews-container flex-column">
                <div class="headline">
                    <span>Обзоры от нас</span>
                </div>
                <div class="review-wrapper">

                    <ReviewCard />
                    <ReviewCard />
                    <ReviewCard />

                </div>    
                        
            </div>
        </div>
    </div>
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
        margin-bottom: 32px;
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

    .counter-slider:hover {
        filter: brightness(1.5);
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
        padding: 8px 12px;
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

    .headline {
        padding-left: 24px;
        font-family: Roboto_SemiBold;
        font-size: 32px;
    }

    .headline.st2 {
        padding: 0;
    }

    .headline span {
        border-bottom: 2px solid var(--font-secondary);
        padding-bottom: 8px;
    }

    .headline.st2 span {
        border-color: var(--bg-secondary-50);
    }


    .review-wrapper {
        background-color: var(--bg-secondary-25);
        padding: 32px 24px;
        border-radius: 16px;
        display: grid;
        grid-template-columns: repeat(3, 1fr);
        gap: var(--gp-32);
    }

    .review-wrapper.st2 {
        grid-template-columns: repeat(1, 1fr);
        background-color: transparent;
        padding: 0;
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

    /* Эффект на фотки */

    .zoom-image {
    transition: transform 3s ease-in-out;
    transform-origin: center center;
    }

    .main-slide:has(.label-slider:hover) .zoom-image {
        transform: scale(1.25);
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
    transform: translateX(-100%);
    }

    .slide-prev-leave-to {
    transform: translateX(100%);
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
        flex-direction: column;
        gap: var(--gp-48);
    }

    .statistic-wrapper, .friend-profile {
        width: 80%;
    }

    .main-slide:has(.label-slider:hover) .zoom-image {
        transform: none
    }

}

@media (max-width:1024px) {
    .review-wrapper {
        grid-template-columns: repeat(2, 1fr);
    }

    .statistic-wrapper, .friend-profile {
        width: 100%;
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
