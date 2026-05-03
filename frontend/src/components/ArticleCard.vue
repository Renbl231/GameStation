<script setup>
    import { useFormatDate } from '../composables/useFormatDate';
    import { onImageError } from '../helpers/onImageError'

    const { formatDate } = useFormatDate()

    const props = defineProps({
        id: Number,
        title: String,
        image: String,
        type_article: String,
        comments: Number,
        created_at: [String, Date],
        score: Number
    })

</script>

<template>
    <div class="review-card">
        <span v-if="props.score || props.score != 0" class="rating">{{ props.score }}</span>
        <picture>
            <img @error="onImageError" :src="props.image" class="review-card__img">
        </picture>
        <div class="type-review flex align-c">
            <svg><use href="#icon-review"></use></svg>
            <span>{{  props.type_article }}</span>
        </div>
        <div class="review-content flex-column">
            <div class="top-content">
                <RouterLink :to="`/article/${props.id}`" class="top-content__link">
                    {{  props.title }}
                </RouterLink>
            </div>
            <div class="bottom-content flex align-c justify-sb">
                <span class="datePublish">{{ formatDate(props.created_at) }}</span>
                <RouterLink :to="`/article/${id}?tab=comments`" class="counter-comment flex align-c">
                    <svg><use href="#icon-comment"></use></svg>{{ props.comments }}
                </RouterLink>
            </div>
        </div>
    </div>
</template>

<style scoped>
    .review-card {
        max-width: 396px;
        width: 100%;
        position: relative;
        background-color: var(--bg-secondary-25);
        border: 1.5px solid var(--btn-color-4);
        font-family: Roboto_Medium;
        font-size: 20px;
        border-radius: 8px;
    }

    .review-card__img {
        width: 100%;
        max-height: 220px;
        min-height: 220px;
        border-radius: 8px 8px 0 0;
    }

    .rating {
        position: absolute;
        top: 8px;
        left: 8px;
        font-size: 16px;
        font-family: Roboto_SemiBold;
        padding: 0px 16px;
        background-color: var(--btn-color-5);
        border-radius: 16px;
    }

    .type-review, .review-content{
        padding: 12px;
    }

    .type-review {
        border-bottom: 2px solid var(--bg-secondary-50);
        color: var(--font-primary-50);
        gap: var(--gp-8);
    }

    .top-content__link:hover {
        text-decoration: underline;
    }

    .type-review svg {
        width: 20px;
        height: 20px;
    }

    .review-content {
        gap: var(--gp-16);
    }

    .top-content {
        font-size: 24px;
    }

    .bottom-content {
        color: var(--font-primary-35);
    }

    .counter-comment {
        gap:var(--gp-8);
        color: inherit;
    }

    .counter-comment svg {
        width: 24px;
        height: 24px;
    }

    @media (max-width:1024px) {
        .review-card {
            max-width: none;
        }
    }

    @media (max-width:900px) {
        .top-content {
            font-size: inherit;
        }
    }

    @media (max-width:768px) {
        .review-card__img {
            min-height: 160px;
            max-height: 160px;
        }
    }

    @media (max-width:600px) {
        .review-card, .top-content {
            font-size: 14px;
        }

        .rating {
            font-size: 12px;
            padding-inline: 12px;
        }
        
        .type-review, .review-content {
            padding: 8px;
        }

        .type-review svg {
            width: 14px;
            height: 14px;
        }

        .counter-comment svg {
            width: 16px;
            height: 16px;
        }

        .counter-comment {
            gap: var(--gp-6);
        }

        .review-card__img {
            min-height: 140px;
            max-height: 140px;
        }
    }

    @media (max-width:425px) {
        .review-card__img {
            max-height: 105px;
            min-height: 105px;
        }

        .rating {
            left: 4px;
            top: 4px;
            font-size: 10px;
        }
    }

    @media (max-width:375px) {
        .review-card__img {
            max-height: 87px;
            min-height: 87px;
        }

        .review-card, .top-content {
            font-size: 12px;
        }
    }

    @media (max-width:320px) {
        .type-review svg {
            width: 12px;
            height: 12px;
        }

        .type-review {
            gap: var(--gp-6);
        }

        .bottom-content {
            font-size: 10px;
        }
        
        .counter-comment {
            gap: var(--gp-4);
        }
    }
</style>