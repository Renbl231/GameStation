<script setup>
    import { useFormatDate } from '../composables/useFormatDate';
    import { onImageError } from '../helpers/onImageError'

    const { formatDate } = useFormatDate()
    defineProps({
        slide: {
            type: Object,
            required: true
        }
    })
</script>


<template>
    <div class="secondary-slides">
        <picture class="zoom-image">
            <img :src="slide.image" @error="onImageError" alt="слайд" class="zoom-image">
        </picture>
        <span class="category-slider">{{ slide.category }}</span>
        <div class="bottom-info flex-column">
            <RouterLink :to="`/newsdata/${slide.idNew}`" class="label-slider">{{ slide.title }}</RouterLink>
            <span class="createDate-slider">{{ formatDate(slide.created_at) }}</span>
        </div>
    </div>
</template>
    
<style scoped>
    .secondary-slides {
        position: relative;
        width: 100%;
        box-shadow: 0 8px 64px 0 rgba(69, 171, 255, 0.25);
        border-radius: 4px;
        will-change: transform;
        overflow: hidden;
    }

    .secondary-slides::before {
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
        border-radius: 4px;
    }

    .secondary-slides img {
        width: 100%;
        height: 160px;
        border-radius: 4px;
    }

    .bottom-info {
        width: 100%;
        position: absolute;
        bottom: 16px;
        left: 16px;
        padding-right: 8px;
        z-index: 10;
        gap: var(--gp-8);
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

    .label-slider {
        font-family: Montserrat_Bold;
        transition: 0.3s;
    }

    .label-slider:hover {
        text-decoration: underline;
    }

    .createDate-slider {
        font-size: 20px;
        font-family: Montserrat_Medium;
        line-height: 32px;
        color: var(--font-primary-50);
    }

    .secondary-slides .bottom-info {
        gap: var(--gp-4);
        left: 8px;
        bottom: 8px;
    }

    .secondary-slides .label-slider {
        max-width: none;
        font-size: 14px;
        line-height: 22px;
    }

    .secondary-slides .category-slider {
        font-size: 10px;
        padding: 4px 8px;
        border-radius: 4px;
    }

    .secondary-slides .createDate-slider {
        font-size: 14px;
        line-height: 17px;
    }

    .secondary-slides .category-slider {
        top: 8px;
        left: 8px;
    }

    .zoom-image {
        transition: transform 3s ease-in-out;
        transform-origin: center center;
    }

    .secondary-slides:has(.label-slider:hover) .zoom-image {
        transform: scale(1.25);
    }
</style>