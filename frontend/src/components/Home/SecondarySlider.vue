<script setup>
    import { onImageError } from '@/utils/helpers/onImageError'
    defineProps({
        slide: {
            type: Object,
            required: true
        }
    })
</script>


<template>
    <div class="slide">
        <picture>
            <img :src="slide.cover" @error="onImageError" alt="слайд" class="slide__img zoom-image">
        </picture>
        <span class="slide__category">{{ slide.category }}</span>
        <div class="slide__bottom flex-column">
            <RouterLink :to="`/newsdata/${slide.idNew}`" class="slide__label">{{ slide.title }}</RouterLink>
        </div>
    </div>
</template>
    
<style lang="scss" scoped>
    .slide {
        position: relative;
        width: 100%;
        border-radius: 4px;
        will-change: transform;
        overflow: hidden;

        &::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            bottom: 0;
            z-index: 1;
            box-shadow: inset 0 -64px 32px rgba(0, 0, 0, 0.75);
        }

        &__img {
            width: 100%;
            height: 216px;
            border-radius: 4px;
        }

        &__category {
            position: absolute;
            top: 10px;
            left: 10px;
            z-index: 10;
            font-size: 12px;
            font-family: Roboto_Regular;
            padding: 4px 8px;
            background-color: var(--color-dark-500);
            border-radius: 2px;
        }

        &__bottom {
            width: 100%;
            position: absolute;
            bottom: 10px;
            left: 10px;
            padding-right: 10px;
            z-index: 10;
        }

        &__label {
            font-family: Roboto_SemiBold;
            font-size: 20px;
            line-height: 1.2;

            &:hover {
                text-decoration: underline;
            }
        }

    }

    .slide:has(.slide__label:hover) .zoom-image {
        transform: scale(1.2);
    }

</style>