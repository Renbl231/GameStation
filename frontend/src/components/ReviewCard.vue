<script setup>
    import { onAvatarError, onImageError } from '../utils/helpers/onImageError'
    import { useFormatDate } from '../utils/date/formatDate';
    const { formatDateRu } = useFormatDate()

    const props = defineProps({
        params: {
            type: Object,
            default: () => ({})
        }
    })

</script>

<template>
    <div class="review flex-column">
        <RouterLink :to="`/review/${props.params.idReview}`" class="review__link">
            <div class="review-block flex">
                <div class="img-block">
                    <picture>
                        <img :src="props.params.cover || '/images/plug_img.png'" @error="onImageError" class="img-game">
                    </picture>
                </div>
                <div class="review-content flex-column">
                    <div class="top-content flex justify-sb">
                        <span class="name-game">{{ props.params.name }}</span>
                        <span class="rating flex-center">{{ Number(props.params.score) }}</span>
                    </div>
                    <p class="description">{{ props.params.description }}</p>
                </div>
            </div>
        </RouterLink>
        <div class="bottom-content flex-column">
            <div class="author-block flex justify-sb align-c"> 
                <div class="author-info flex align-c">
                    <RouterLink :to="`/user/${props.params.author_nickname}`" class="userBlock flex align-c">
                        <img :src="params.author_avatar" @error="onAvatarError" class="author-img">
                        <span class="author-name">{{ props.params.author_nickname }}</span>
                    </RouterLink>
                </div>
                <div class="date-block flex-center">
                    <span class="date-publish">{{ formatDateRu(props.params.created_at)}}</span>
                </div>
                <div class="counters flex align-c">
                    <span class="no-border flex-center">
                        <svg class="icon icon-view"><use href="#icon-views"></use></svg>
                        {{ props.params.views_counter }}
                    </span>
                    <RouterLink :to="`/review/${props.params.idReview}?tab=comments`"
                        class="flex-center counters"
                        aria-label="Перейти к комментариям"
                        >
                        <svg class="icon icon-comment"><use href="#icon-comment"></use></svg>
                        {{ props.params.comments_counter }}
                    </RouterLink>
                </div>
            </div>
            <div class="parameters-wrapper flex align-c">
                <div
                    v-for="(param, index) in props.params.ratings"
                    :key="param.label"
                    class="parameter">
                    <span>{{ param.label }}: {{ param.value }}</span>
                </div>
            </div>
        </div>
    </div>
</template>

<style scoped>
    .review {
        width: 100%;
        background-color: var(--btn-color-7);
        border-radius: 8px;
        gap: var(--gp-16);
    }

    .review-block {
        width: 100%;
        gap: var(--gp-16);
        border-bottom: 1px solid #324148;
        padding-bottom: 16px;
    }

    .img-block {
        width: 150px;
        height: 200px;
        flex-shrink: 0;
    }

    .img-game {
        width: 100%;
        height: 100%;
        border-radius: 8px;
    }

    .review__link {
        padding: 20px;
        padding-bottom: 0px;
        border-radius: 8px 8px 0px 0px;
    }

    .review__link:hover {
        background-color: var(--bg-secondary-50);
    }

    .review-content {
        width: 100%;
        max-height: 230px;
        min-height: 230px;
        overflow: hidden;
        gap: var(--gp-16);
    }

    .bottom-content {
        padding: 20px;
        padding-top: 0px;
        gap: var(--gp-24);
    }

    .name-game {
        font-size: 24px;
        font-family: Roboto_SemiBold;
        color: var(--another-color);
    }

    .top-content {
        gap: var(--gp-8);
    }

    .rating {
        min-width: 40px;
        max-width: 40px;
        max-height: 40px;
        min-height: 40px;
        font-size: 16px;
        font-family: Roboto_SemiBold;
        background: #000;
        border: 3px solid var(--font-secondary);
        border-radius: 50%;
    }

    .description {
        font-size: 16px;
        line-height: 24px;
        font-family: Roboto_Regular;
    }

    /* Автор блок */

    .author-block {
        font-family: Roboto_Medium;
        flex-wrap: wrap;
        column-gap: var(--gp-12);
        row-gap: var(--gp-12);
    }

    .author-info {
        gap: var(--gp-10);
    }

    .userBlock {
        gap: var(--gp-12);
    }

    .userBlock:hover .author-name {
        color: var(--font-primary);
    }

    .author-img {
        width: 36px;
        height: 36px;
        border-radius: 50%;
    }

    .author-name, .date-publish {
        font-size: 14px;
        color: var(--font-primary-75);
    }

    .counters {
        gap: var(--gp-12);
        font-size: 12px;
    }

    .counters span, .counters a {
        gap: var(--gp-8);
        color: var(--font-primary-25);
        padding: 0;
    }

    .icon {
        width: 20px;
        height: 20px;
    }

    .icon-view {
        width: 24px;
        height: 24px;
    }

    /* Блок параметров */

    .parameters-wrapper {
        flex-wrap: wrap;
        gap: var(--gp-16);
        font-size: 14px;
        font-family: Roboto_Medium;
    }

    .parameter {
        background-color: #20343D;
        color: #FF5050;
        padding: 8px 12px;
        border-radius: 8px;
    }

    @media (max-width:1160px) {
        .name-game {
            font-size: 20px;
        }
        .description {
            font-size: 14px;
            line-height: 18px;
        }
    }

    @media (max-width:899px) {
        .img-block {
            width: 120px;
            height: 160px;
        }
    }   

    @media (max-width:600px) {
        .review, .review-block, .parameters-wrapper {
            gap: var(--gp-10);
        }
        .review__link {
            padding: 10px;
            padding-bottom: 0px;
        }
        .img-block {
            width: 100px;
            height: 133px;
        }
        .rating {
            min-width: 32px;
            min-height: 32px;
            max-width: 32px;
            max-height: 32px;
            font-size: 14px;
            border-width: 3px;
        }
        .bottom-content {
            gap: var(--gp-16);
        }

        .author-name, .date-publish {
            font-size: 12px;
        }

        .parameter {
            font-size: 12px;
            padding: 4px 8px;
        }
    }

     @media (max-width:425px) {

        .counters {
            margin: 0 auto;
        }

        .review-block {
            flex-direction: column;
            align-items: center;
        }
        .review-content {
            max-height: 230px;
            min-height: auto;
        }
        .top-content {
            justify-content: center;
            gap: var(--gp-8);
        }
        .counters span {
            gap: var(--gp-4);
        }
    }

    @media (max-width:375px) {
        .description {
            font-size: 12px;
            line-height: 16px;
        }
    }
</style>