<script setup>
    import { ref, onBeforeMount, onBeforeUnmount } from 'vue'
    import { storeToRefs } from 'pinia'
    import { useAuthStore } from '@stores/authStore'
    import { onImageError } from '@helpers/onImageError'
    import api from '@utils/axios'
import { platforms } from '@/constants/gameFilter'
    
    const authStore = useAuthStore()
    const { user } = storeToRefs(authStore)

    const sliderMode = ref("")
    const defaultMode = ref("")
    const slides = ref([])
    
    const loadSlides = async() => {
        const { data } = await api.get('/games/slides')
        if(data.success) {
            slides.value = data.slides.result || []
            sliderMode.value = data.slides.sliderMode || "best"
            defaultMode.value = sliderMode.value
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
        } catch(error) {}
    }

    const isEditModeSlider = ref(false)

    const toggleEditModeSlider = () => {
        if(user.value?.role === 4) {
            isEditModeSlider.value = !isEditModeSlider.value
        }
    }

    const closeMenu = (event) => {
        if (!event.target.closest('.slider__options')) {
            isEditModeSlider.value = false
            sliderMode.value = defaultMode.value
        }
    }

    onBeforeMount(async () => {
        await loadSlides()
        document.addEventListener('click', closeMenu)
    })

    onBeforeUnmount(() => {
        document.removeEventListener('click', closeMenu)
    })
    
</script>


<template>

<div class="slider">
    <span class="slider__label">{{ sliderMode === "best" ? 'Лучшие игры' : 'Самые ожидаемые' }}</span>
    <Transition :name="`slide-${direction}`">
        <div
            :key="currentSlide"
            @touchstart="touchStart"
            @touchend="touchEnd"
            class="slider__slide">
            <picture>
                <img class="slider__img" :src="slides[currentSlide]?.banner" @error="onImageError">
            </picture>
            <span class="slider__date">{{ formatDate(slides[currentSlide]?.release_date) }}</span>
            <div class="slider__game flex-column">
                <RouterLink :to="`/game/${slides[currentSlide]?.idGame}`" class="slider__game-name">{{ slides[currentSlide]?.name }}</RouterLink>
                <div class="slider__platforms flex">
                    <span 
                        v-for="(platform, index) in slides[currentSlide]?.platforms"
                        class="slider__platform"
                        :key="platform">
                        {{ platform }}
                    </span>
                </div>
            </div>
        </div>
    </Transition>

    <div class="slider__btns flex flex-center">
        <span 
            v-for="(slide, index) in slides"
            :key="index"
            class="slider__btns-item"
            :class="{active: index === currentSlide}"
            @click="goToSlide(index)"
            data-slide="index">
        </span>
    </div> 

    <div v-if="user?.role === 4" class="slider__options">
        <button @click="toggleEditModeSlider" type="button" class="no-border slider__options-showBtn">
            ...
        </button>
        <div v-if="isEditModeSlider" class="slider__options-menu flex-column flex-center">
            <div class="slider__options-inputs flex-column">
                <div class="slider__options-block flex align-c">
                    <input v-model="sliderMode" type="radio" class="custom-radio" id="sliderMode1" name="sliderMode" value="best" :checked="sliderMode === 'best'"/>
                    <label for="sliderMode1">Лучшие</label>
                </div>
                <div class="slider__options-block flex align-c">
                    <input v-model="sliderMode" type="radio" class="custom-radio" id="sliderMode2" name="sliderMode" value="expected" :checked="sliderMode === 'expected'"/>
                    <label for="sliderMode2">Ожидаемые</label>
                </div>
            </div>
            <div class="slider__options-btns flex-center">
                <button @click="saveSliderMode" type="button" class="no-border">Сохранить</button>
            </div>
        </div>
    </div>
</div>

</template>

<style lang="scss" scoped>

    .slider {
        width: 100%;
        min-height: 360px;
        max-height: 360px;
        position: relative;

        @media (max-width:768px) {
            min-height: 300px;
            max-height: 300px;
        }

        @media (max-width:600px) {
            min-height: 250px;
            max-height: 250px;
        }

        @media (max-width:425px) {
            min-height: 200px;
            max-height: 200px;
        }

        &__label {
            position: absolute;
            top: 16px;
            left: 32px;
            font-family: Roboto_CondensedBold;
            font-size: 40px;
            z-index: 100;

            @media (max-width:1024px) {
                font-size: 36px;
            }

            @media (max-width:768px) {
                left:24px;
                font-size: 32px;
            }

            @media (max-width:600px) {
                left: 16px;
                font-size: 24px;
            }

            @media (max-width:425px) {
                font-size: 20px;;
            }
        }

        &__slide {
            position: absolute;
            width: 100%;
            min-height: 360px;
            overflow: hidden;

            &::after {
                content: "";
                position: absolute;
                inset: 0;
                box-shadow: inset 64px 64px 250px 0px rgba(0, 0, 0, 0.75);
                pointer-events: none;
                z-index: 1;
            }
        }

        &__img {
            width: 100%;
            min-height: 360px;
            max-height: 360px;  
        }

        &__date {
            position: absolute;
            top: 32px;
            right: 32px;
            z-index: 100;
            font-family: Roboto_CondensedSemiBold;
            font-size: 24px;

            @media (max-width:768px) {
                right: 24px;
                font-size: 20px;
            }

            @media (max-width:600px) {
                font-size: 16px;
                right: 16px;
                top: 24px;
            }

            @media (max-width:425px) {
                font-size: 14px;
            }
        }

        &__game {
            width: fit-content;
            position: absolute;
            left: 32px;
            bottom: 32px;
            gap: var(--gp-12);
            z-index: 100;     

            @media (max-width:768px) {
                left: 24px;
                bottom: 24px;
                gap: var(--gp-8)
            }

            @media (max-width:600px) {
                left: 16px;
                bottom: 16px;
                gap: var(--gp-4);
            }

            &-name {
                font-family: Roboto_CondensedSemiBold;
                font-size: 32px;

                &:hover {
                    text-decoration: underline;
                }

                @media (max-width:1024px) {
                    font-size: 30px;
                }

                @media (max-width:768px) {
                    font-size: 24px;
                }

                @media (max-width:600px) {
                    font-size: 20px;
                }

                @media (max-width:425px) {
                    font-size: 16px;
                }
            }  
            
            .slider__platforms {
                width: fit-content;
                font-family: Roboto_Medium;
                font-size: 20px;
                background-color: var(--btn-color-3);
                padding: 4px 8px;
                color: var(--font-primary-50);
                gap: var(--gp-8);
                border-radius: 4px;

                @media (max-width:1024px) {
                    font-size: 18px;
                }

                @media (max-width:768px) {
                    font-size: 14px;
                }

                @media (max-width:600px) {
                    font-size: 12px;
                }

                @media (max-width:375px) {
                    font-size: 12px;
                }
            }
        }   

        // Кнопки слайдера

        &__btns {
            width: fit-content;
            position: absolute;
            bottom: 32px;
            left: 50%;
            transform: translate(-50%, 0%);
            gap: var(--gp-32);
            z-index: 50;

            @media (max-width:1024px) { display: none; }

            &-item {
                width: 24px;
                height: 24px;
                border-radius: 50%;
                border: 2px solid var(--font-primary-50);
                cursor: pointer;
                transition: 0.3s;

                &.active, &:hover {
                    background-color: var(--color-blue);
                    border-color: var(--color-blue);
                }
            }
        }

        // Опции слайдер

        &__options {
            position: absolute;
            bottom: 0;
            right: 0px;
            padding: 32px;
            z-index: 100;

            @media (max-width:768px) {
                bottom: 8px;
                right: 0px;
                padding: 16px;
            }

            &-showBtn {
                position: absolute;
                top: 0%;
                right: 32px;
                z-index: 90;
                width: 32px;
                height: 32px;
                background-color: var(--color-1);
                border-radius:4px;
                font-family: Roboto_Medium;

                &:hover {filter: brightness(1.25);}

                @media (max-width:768px) {
                    right: 16px;
                    width: 24px;
                    height: 24px;
                    font-size: 12px;
                }
            }

            // Выпадющее меню

            &-menu {
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

                @keyframes slideDown {
                    to {
                        opacity: 1;
                        transform: translateX(-48px);
                    }
                }

                @media (max-width:768px) {
                    bottom: 8px;
                    right: 16px;
                }
            }

            &-inputs {
                width: 100%;
                font-family: Roboto_Regular;
                font-size: 14px;
                gap: var(--gp-8);
            }

            &-block {
                width: 100%;
                gap: var(--gp-4);
            }

            &-btns {
                width: 100%;
                background-color: var(--font-secondary);
                border-radius: 2px;
                font-family: Roboto_Regular;
                font-size: 14px;
                padding-block: 2px;

                &:hover {background-color: var(--btn-color-5);}
            }
        }

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

        &::after {
            content: "";
            position: absolute;
            inset: 3px;
            border-radius: 50%;
            background: #4f46e5;
            transform: scale(0);
            transition: transform 0.2s ease;
        }

        &:hover {border-color: #4f46e5;}

        &:checked {
            border-color: #4f46e5;

            &::after {transform: scale(1);}
        }
    }

    // Анимка для слайдера
    
    .slide-next-enter-active, .slide-next-leave-active,
    .slide-prev-enter-active, .slide-prev-leave-active {
        transition: all 0.5s;
    }

    .slide-next-enter-from {
        transform: translateX(100%);
    }
    .slide-next-enter-to {
        transform: translateX(0);
    }
    .slide-next-leave-from {
        transform: translateX(0);
    }
    .slide-next-leave-to {
        transform: translateX(-100%);
    }

    .slide-prev-enter-from {
        transform: translateX(-100%);
    }
    .slide-prev-enter-to {
        transform: translateX(0);
    }
    .slide-prev-leave-from {
        transform: translateX(0);
    }
    .slide-prev-leave-to {
        transform: translateX(100%);
    }

</style>