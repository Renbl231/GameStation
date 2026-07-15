<script setup>
    import { ref, onMounted, onUnmounted, nextTick } from 'vue'
    import { onImageError } from '@/utils/helpers/onImageError'
    import api from '@/utils/axios'
    import SecondarySlider from '@/components/Home/SecondarySlider.vue'
    import { storeToRefs } from 'pinia'
    import { useAuthStore } from '@/stores/authStore'
    const { isAuthenticated, user } = storeToRefs(useAuthStore())

    // Загрузка слайдов

    const limitSlides = 3
    const emits = defineEmits(['loaded'])
    const slides = ref([])
    const sliderMode = ref("")

    const loadSlides = async () => {
        try {
            const { data } = await api.get('/news/slides', {
                params: { limit: limitSlides}
            })
            if(data.success) {
                sliderMode.value = data.news.sliderMode
                slides.value = data.news.result || []
            }
        } catch(error) {
            console.log('Ошибка', error.response?.data?.error)
        } finally {
            await nextTick()
            emits('loaded')
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

    onMounted(async() => {
        await loadSlides(),
        document.addEventListener('click', closeMenu)
        startAutoSlide()
    })


</script>


<template>
    <div class="slider-container flex-column">
        <div class="headline flex align-c">
            <svg class="headline__icon">
                <use href="#icon-rule"></use>
            </svg>
            <span class="headline__label">{{ sliderMode === 'main' ? 'Главные новости' : 'Популярные новости' }}</span>
        </div>
        <div class="flex" style="gap: var(--gp-10);">
            <div class="main-section flex-column">

                <Transition :name="`slide-${direction}`">
                    <div
                        :key="currentSlide"
                        class="main-section__slide"
                        @touchstart="touchStart"
                        @touchend="touchEnd">
                        <picture>
                            <img :src="slides[currentSlide]?.image || ''" @error="onImageError" class="zoom-image">
                        </picture>
                        <div class="main-section__top flex align-c">
                            <span class="category-slider">{{ slides[currentSlide]?.category }}</span>
                        </div>
                        <div class="main-section__bottom flex-column">
                            <RouterLink :to="`/newsdata/${slides[currentSlide]?.idNew}`" class="label-slider">{{ slides[currentSlide]?.title }}</RouterLink>
                            <p class="description-slider">{{ slides[currentSlide]?.short_content }}</p>
                        </div>
                    </div>
                </Transition>
    
                <div class="slider-btns flex-column">
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
                    <button @click="toggleEditModeSlider" type="button" class="no-border slider-options__showBtn flex-center">
                        <svg>
                            <use href="#icon-edit"></use>
                        </svg>
                    </button>
                    <div v-if="isEditModeSlider" class="slider-options__wrapper flex-column flex-center">
                        <div class="slider-options__inputs flex-column">
                            <div class="options-inputs__block flex align-c">
                                <input v-model="sliderMode" type="radio" class="custom-radio" id="sliderMode1" name="sliderMode" value="main" :checked="sliderMode === 'main'"/>
                                <label for="sliderMode1">Главное</label>
                            </div>
                            <div class="options-inputs__block flex align-c">
                                <input v-model="sliderMode" type="radio" class="custom-radio" id="sliderMode2" name="sliderMode" value="popular" :checked="sliderMode === 'popular'"/>
                                <label for="sliderMode2">Популярные</label>
                            </div>
                        </div>
                        <button @click="saveSliderMode" type="button" class="no-border slider-options__btn">Сохранить</button>
                    </div>
                </div>
    
            </div>
    
            <div class="secondary-sections flex-column">
                <SecondarySlider
                    v-for="(slide, index) in getSecondarySlides()"
                    :key="`sec-${slides[currentSlide]?.id || index}-${index}`" 
                    :slide="slide" 
                />                
            </div>



        </div>

    </div>
</template>


<style lang="scss" scoped>

    .slider-container {
        width: 100%;
        gap: var(--gp-24);

        @media(max-width:1160px) {
            padding-inline: 32px;
        }

        @media(max-width:768px) {
            padding-inline: 16px;
        }
    }

    .headline {
        gap: var(--gp-12);



        &__icon {
            width: 28px;
            height: 26px;

            @media (max-width:600px) {
                width: 24px;
                height: 22px;
            }
        }

        &__label {
            font-size: 32px;
            font-family: Roboto_SemiBold;
            color: var(--text-primary);

            @media (max-width:600px) {
                font-size: 28px;
            }

            @media (max-width:375px) {
                font-size: 24px;
            }
        }
    }
            
    .main-section {
        position: relative;
        width: 100%;
        max-width: 928px;
        max-height: 442px;
        min-height: 222px;
        aspect-ratio: 928 / 442;
        border-radius: 4px;
        overflow: hidden;

        &__slide {
            width: 100%;
            border-radius: 4px;
            will-change: transform;
            position: absolute;
            top: 0;
            left: 0;
            height: 100%;
            will-change: transform;
            overflow: hidden;

            img {
                width: 100%;
                height: 100%;
                border-radius: 4px;
            }

            &::before {
                content: '';
                position: absolute;
                top: 0;
                left: 0;
                right: 0;
                bottom: 0;
                z-index: 1;
                box-shadow: inset 0 -128px 128px rgba(0, 0, 0, 0.75);

                @media (max-width:767px) {
                    box-shadow: inset 0 -96px 96px rgba(0, 0, 0, 0.75);
                }
            }
        }

        @media (max-width:1160px) {
            max-width: none;
        }

        &__bottom {
            position: absolute;
            bottom: 0px;
            padding: 16px;
            z-index: 10;
            gap: var(--gp-8);

            @media (max-width:600px) {
                padding: 10px;
            }

            .label-slider {
                width: fit-content;
                font-family: Roboto_SemiBold;
                font-size: 30px;
                line-height: 1.1;
                transition: 0.3s;

                &:hover {
                    text-decoration: underline;
                }

                @media (max-width:767px) {
                    font-size: 24px;
                }

                @media (max-width:600px) {
                    font-size: 20px;
                }

                @media (max-width:425px) {
                    font-size: 18px;
                }
            }
        }
    }

    .category-slider {
        position: absolute;
        top: 16px;
        left: 16px;
        z-index: 10;
        font-size: 16px;
        font-family: Roboto_Regular;
        padding: 4px 10px;
        background-color: var(--color-dark-500);
        border-radius: 4px;

        @media (max-width:600px) {
            font-size: 14px;
            top: 10px;
            left: 10px;
        }
    }

    .description-slider {
        font-size: 20px;
        font-family: Roboto_Medium;
        line-height: 1.25;
        color: var(--color-gray-200);

        @media (max-width:767px) {
            font-size: 16px;
        }

        @media (max-width:600px) {
            font-size: 14px;
        }  

        @media (max-width:500px) {
            display: none;
        }   
    }

    .slider-btns  {
        position: absolute;
        top: 50%;
        transform: translateY(-50%);
        right: 8px;
        gap: var(--gp-10);
        z-index: 30;

        @media (max-width:600px) {
            display: none;
        }

        .dot {
            width: 9px;
            height: 32px;
            border-radius: 4px;
            background-color: var(--color-dark-500);
            cursor: pointer;
            transition: 0.3s;

            &.active,
            &:hover {
                background-color: var(--color-blue);
                border-color: var(--color-blue);
                box-shadow: 0 1px 2px var(--color-blue);
            }
        }
    }



 
    /* Опции слайдера */

    .slider-options {
        position: absolute;
        top: 16px;
        right: 16px;
        z-index: 100;

        @media (max-width:600px) {
            top: 10px;
            right: 10px;
        }

        &__showBtn {
            position: absolute;
            top: 0px;
            right: 0px;
            z-index: 90;
            width: 32px;
            height: 32px;
            background-color: var(--color-dark-500);
            border-radius:4px;

            &:hover {
                filter: brightness(1.25);
            }   

            svg {
                width: 20px;
                height: 20px;
                color: var(--color-white);
            }

            @media (max-width:600px) {
                width: 24px;
                height: 24px;

                svg {
                    width: 12px;
                    height: 12px;
                }
            }

        }

        /* Выпадающий блок слайдера */

        &__wrapper {
            width: fit-content;
            position: absolute;
            top: 50%;
            right: 0px;
            background-color: var(--color-1);
            border-radius: 4px;
            opacity: 0;
            animation: slideDown 0.3s ease forwards;
            z-index: 50;
            padding: 8px;
            gap: var(--gp-8);

            @keyframes slideDown {
                to {
                    opacity: 1;
                    transform: translateX(-48px);
                }
            }
        }

        &__inputs {
            width: 100%;
            font-family: Roboto_Regular;
            font-size: 14px;
            gap: var(--gp-8);

            .options-inputs__block {
                width: 100%;
                gap: var(--gp-4);
            }
        }
    }

    /* Кастом радио */

    .custom-radio {
        appearance: none;
        -webkit-appearance: none;
        width: 18px;
        height: 18px;
        border: 2px solid var(--color-gray-400);
        border-radius: 50%;
        display: inline-block;
        position: relative;
        cursor: pointer;
        transition: border-color 0.2s ease;
        vertical-align: middle;
        margin: 0;
        flex-shrink: 0;

        &:hover {
            border: 2px solid var(--color-blue);
        }

        &::after {
            content: "";
            position: absolute;
            inset: 0px;
            border-radius: 50%;
            background: var(--color-blue);
            transform: scale(0);
            transition: transform 0.2s ease;
        }

        &:checked {
            background: var(--color-blue);
            border: 2px solid var(--color-blue);

            &::after {
                transform: scale(1);
            }
        }
    }

    .slider-options__btn {
        width: 100%;
        background-color: var(--color-blue);
        border-radius: 2px;
        font-family: Roboto_Regular;
        font-size: 14px;
        padding-block: 2px;

        &:hover {
            background-color: var(--color-blue-hover);
        }
    }


    .secondary-sections {
        max-width: 480px;
        width: 100%;
        gap: var(--gp-10);

        @media (max-width:1160px) {
            display: none;
        }
    }

    // Зум слайдера

    .zoom-image {
        transform-origin: center center;
        animation: zoomInOut 11s ease-in-out forwards;

        @keyframes zoomInOut {
            0% { transform: scale(1); }
            100% { transform: scale(1.2); }
        }
    }


    /* Анимация */

    .slide-next-enter-active, .slide-next-leave-active,
    .slide-prev-enter-active, .slide-prev-leave-active {
    transition: all 0.75s cubic-bezier(0.4, 0, 0.2, 1);
    }

    .slide-next-enter-from {
    transform: translateX(100%);
    }

    .slide-next-leave-to {
    transform: translateX(-100%);
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

</style>