<script setup>
    import { formatDate } from '@/utils/date/formatDate';
    import { onImageError } from '@helpers/onImageError';

    const { formatDate1 } = formatDate()

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
    <div class="review-card flex-column">
        <span v-if="props.score || props.score != 0" class="rating">{{ props.score }}</span>
        <RouterLink :to="`/article/${props.id}`" class="link">
            <div class="cover-block">
                <picture>
                    <img @error="onImageError" :src="props.image" class="review-card__img">
                </picture>
            </div>
        </RouterLink>
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
                <span class="datePublish">{{ formatDate1(props.created_at) }}</span>
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
        border-radius: 8px;
        height: 100% !important;
    }

    .cover-block {
        display: block;
        width: 100%;
        height: auto;
        aspect-ratio: 392 / 220;
        overflow: hidden;
        border-radius: 8px 8px 0 0;
    }

    .review-card__img {
        width: 100%;
        height: 100%;
        border-radius: 8px 8px 0 0;
        transition: 0.4s;
        transition: transform 0.3s ease;
        will-change: transform;
    }

    .link:hover .review-card__img {
        transform: scale(1.05);
    }

    .rating {
        position: absolute;
        top: 8px;
        left: 8px;
        font-size: 16px;
        font-family: Roboto_Medium;
        padding: 0px 16px;
        background-color: var(--btn-color-5);
        border-radius: 4px;
        z-index: 50;
    }

    .type-review {
        border-bottom: 2px solid var(--bg-secondary-50);
        color: var(--font-primary-50);
        gap: var(--gp-8);
        font-size: 18px;
        padding: 12px;
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
        padding: 12px;
        flex: 1;
    }

    .top-content {
        font-size: 20px;
    }

    .bottom-content {
        height: fit-content;
        color: var(--font-primary-35);
        margin-top: auto;
    }

    .datePublish {
        font-size: 18px;
        font-family: Roboto_Medium;
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

    @media (max-width:767px) {
        .top-content__link {
            font-size: 18px;
        }

        .datePublish {
            font-size: 16px;
        }

        .rating {
            font-size: 14px;
            padding-inline: 12px;
        }
    }

    @media (max-width:600px) {
        
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

        .cover-block {
            max-height: 200px;
        }

        .top-content__link {
            font-size: 16px;
        }

    }

    @media (max-width:500px) {
        .type-review svg {
            width: 16px;
            height: 16px;
        }

        .counter-comment svg {
            width: 18px;
            height: 18px;
        }

        .counter-comment {
            font-size: 12px;
        }

        .type-review {
            font-size: 16px;
        }

        .datePublish {
            font-size: 14px;
        }
    }

    @media (max-width:320px) {
        .type-review svg {
            width: 14px;
            height: 14px;
        }
    }
</style>