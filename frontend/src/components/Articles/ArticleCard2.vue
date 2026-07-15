<script setup>
    import { onImageError, onAvatarError } from '@/utils/helpers/onImageError';
    import { formatDate } from '@/utils/date/formatDate';

    const { formatDateRu } = formatDate()

    const props = defineProps({
        id: Number,
        label: String,
        category: String,
        score: Number,
        comments: Number,
        cover: String,
        author: Object,
        created_at: [String, Date],
        variant: {
            type: String,
            default: 'small',
            validatar: (value) => ['small', 'large'].includes(value)
        }
    })
</script>

<template>
    <div class="article flex-column" :class="`article-${props.variant}`">
        <div class="article__top">
            <picture>
                <img :src="props.cover" @error="onImageError" loading="lazy" alt="Обложка статьи" class="article__cover zoom-image">
            </picture>
            <div class="article-bar flex align-c">
                <span class="article-bar__category">
                    {{ props.category }}
                </span>
                <span v-if="props.score" class="article-bar__score flex-center">
                    {{ props.score }}
                </span>
            </div>
        </div>
        <div class="article__bottom flex-column">
            <RouterLink :to="`/article/${props.id}`" class="article__label">
                {{ props.label }}
            </RouterLink>
            <div class="bottom__block flex-column">
                <RouterLink :to="`/user/${props.author.name}`" class="author flex align-c">
                    <picture>
                        <img 
                            loading="lazy"
                            :src="props.author.avatar" 
                            :class="{'blue': props.author.role === 2, 'red': props.author.role === 4 }" 
                            class="author__cover"
                            alt="Аватар автора"
                            @error="onAvatarError"
                        />
                    </picture>
                    <span class="author__name">{{ props.author.name }}</span>
                </RouterLink>
                <div class="flex align-c justify-sb">
                    <span class="article__date">{{ formatDateRu(props.created_at) }}</span>
                    <RouterLink :to="`/article/${props.id}?tab=comments`" class="article__comment flex-center">
                        <svg><use href="#icon-comment"></use></svg>{{ props.comments }}
                    </RouterLink>
                </div>
            </div>
        </div>
    </div>
</template>

<style lang="scss" scoped>
    .article {
        position: relative;
        max-width: 390px;
        width: 100%;
        height: 100%;
        border-radius: 8px;
        outline: 1px solid var(--bg-secondary-border);
        overflow: hidden;

        @media (max-width:768px) {
            max-width: none;
        }

        &:has(&__label:hover) .zoom-image {
            transform: scale(1.2);
        }

        &-large {
            max-width: 498px;

            @media(max-width:600px) {
                max-width: none;
            }
        }

        &__top {
            position: relative;
            width: 100%;
            overflow: hidden;
        }

        &__cover {
            width: 100%;
            max-height: 225px;
            aspect-ratio: 390 / 225;
            display: block;

            @media(max-width:768px) {
                aspect-ratio: 390 / 160;
            }
        }

        &-bar {
            position: absolute;
            bottom: 12px;
            left: 12px;
            width: fit-content;
            border-radius: 256px;
            background-color: var(--text-primary-r);
            font-family: Roboto_Medium;
            font-size: 16px;
            z-index: 4;

            @media(max-width:1160px) {
                font-size: 14px;
            }

            @media(max-width:768px) {
                left: 10px;
                bottom: 10px;
            }

            @media(max-width:500px) {
                font-size: 12px;
            }
            
            &__category {
                font-family: inherit;
                font-size: inherit;
                color: var(--text-primary);
                padding-inline: 8px;
                padding-block: 2px;
            }

            &__score {
                font-family: inherit;
                font-size: inherit;
                background-color: var(--rating-color1);
                border-radius: 256px;
                padding-inline: 12px;
                padding-block: 2px;
            }
        }

        &__bottom {
            width: 100%;
            gap: var(--gp-12);
            padding: 12px;
            flex: 1;
            background-color: var(--bg-secondary);

            @media(max-width:768px) {
                padding: 10px;
            }
        }

        &__label {
            color: var(--text-primary);
            font-family: Roboto_Medium;
            font-size: 18px;
            line-height: 1.2;

            @media (max-width:768px) {
                font-size: 16px;                
            }

            @media (max-width:600px) {
                font-size: 14px;                
            }

            &:hover {
                text-decoration: underline;
            }
        }

        .author {
            width: fit-content;
            color: var(--text-secondary);
            gap: var(--gp-6);

            @media(max-width:768px) {
                display: none;
            }

            &:hover {
                color: var(--text-primary);
            }

            &__cover{
                width: 24px;
                height: 24px;
                border-radius: 50%;

                &.blue {
                    outline: 2px solid var(--color-blue);
                }

                &.red {
                    outline: 2px solid var(--color-red);
                }
            }

            &__name {
                font-family: Roboto_Medium;
                font-size: 14px;
                color: inherit;
            }
        }

        .bottom__block {
            width: 100%;
            margin-top: auto;
            gap: var(--gp-12);
        }

        &__date {
            color: var(--text-muted);
            font-family: Roboto_Medium;
            font-size: 16px;

            @media(max-width:1160px) {
                font-size: 14px;
            }
        }

        &__comment {
            width: fit-content;
            gap: var(--gp-6);
            font-family: Roboto_Medium;
            font-size: 14px;
            color: var(--text-muted);

            &:hover {
                color: var(--text-primary);
            }

            svg {
                width: 20px;
                height: 20px;
                stroke-color: var(--text-muted);
            }
        }

    }
</style>