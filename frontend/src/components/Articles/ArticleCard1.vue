<script setup>
    import { formatDate } from '@utils/date/formatDate.js'
    import { onImageError, onAvatarError } from '@/utils/helpers/onImageError';

    const { formatDateRu } = formatDate();

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
            default: 'large',
            validator: (value) => ['small', 'large'].includes(value)
        }
    })
</script>

<template>
    <div class="article" :class="`article-${props.variant}`">
        <picture>
            <img loading="lazy" :src="props.cover" class="article__cover zoom-image" @error="onImageError"/>
        </picture>
        <div class="article__content flex-column">
            <div class="article__top flex align-c">
                <div class="article-bar flex align-c">
                    <span class="article-bar__category">
                        {{ props.category }}
                    </span>
                    <span v-if="props.score" class="article-bar__score flex-center">
                        {{ props.score }}
                    </span>
                </div>
                <span class="article__date">
                    {{ formatDateRu(props.created_at) }}
                </span>
            </div>
            <div class="article__middle">
                <RouterLink :to="`/article/${props.id}`" class="article__label">
                    {{ props.label }}
                </RouterLink>
            </div>
            <div class="article__bottom flex align-c justify-sb">
                <RouterLink :to="`/user/${props.author.name}`" class="author flex align-c">
                    <picture>
                        <img 
                            loading="lazy"
                            :src="props.author.avatar" 
                            :class="{'blue': props.author.role === 2, 'red': props.author.role === 4 }" 
                            class="author__cover"
                            @error="onAvatarError"
                        />
                    </picture>
                    <span class="author__name">{{ props.author.name }}</span>
                </RouterLink>
                <RouterLink :to="`/article/${props.id}?tab=comments`" class="article__comment flex-center">
                    <svg><use href="#icon-comment"></use></svg>{{ props.comments }}
                </RouterLink>
            </div>
        </div>
    </div>
</template>


<style lang="scss" scoped>

    .article {
        width: 100%;
        max-height: 380px;
        height: 100%;
        position: relative;
        border-radius: 8px;
        outline: 1px solid var(--bg-secondary-border);
        overflow: hidden;

        &:has(&__label:hover) .zoom-image {
            transform: scale(1.2);
        }

        &.article-large::before,
        &.article-small::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            bottom: 0;
            z-index: 1;
            box-shadow: inset 0 -128px 64px rgba(0, 0, 0, 0.75);
            border-radius: 8px;

            @media(max-width:768px) {
                box-shadow: inset 0 -96px 48px rgba(0, 0, 0, 0.75);
            }
        }

        &.article-small::before {
            @media(max-width:600px) {
                box-shadow: inset 0 -64px 48px rgba(0, 0, 0, 0.75);
            }
        }

        &__cover {
            width: 100%;
            aspect-ratio: 648 / 380;

            @media (max-width:600px) {
                aspect-ratio: 648 / 300;
            }
        }

        &__date {
            color: var(--color-gray-100);
            font-family: Roboto_Medium;
            font-size: 16px;

            @media(max-width:1160px) {
                font-size: 14px;
            }

            @media(max-width:600px) {
                font-size: 12px;
            }
        }

        &__label {
            display: -webkit-box;
            -webkit-line-clamp: 2;
            -webkit-box-orient: vertical;
            overflow: hidden;
            text-overflow: ellipsis;
            color: var(--color-white);
            font-family: Roboto_Medium;
            font-size: 24px;
            line-height: 1.2;
            
            @media(max-width:1160px) {
                font-size: 18px;
            }

            @media(max-width:900px) {
                line-height: 1;
                font-size: 16px;
            }

            @media (max-width:600px) {
                line-height: 1.2;
            }

            @media (max-width:425px) {
                font-size: 14px;
                
            }

            &:hover {
                text-decoration: underline;
            }
        }

        &__content {
            width: 100%;
            position: absolute;
            padding: 16px;
            bottom: 0px;
            gap: var(--gp-12);
            z-index: 2;

            @media(max-width:1160px) {
                padding: 10px;
                gap: var(--gp-8);
            }
        }   

        &__top,
        &__middle,
        &__bottom {
            width: 100%;
        }

        &__top {
            gap: var(--gp-12);
            @media (max-width:1160px) {
                gap: var(--gp-8);
            }
        }

        &__middle {
            line-height: 1;
        }


        &__bottom {
            @media(max-width:900px) {
                display: none;
            }
        }
        
        &-bar {
            width: fit-content;
            border-radius: 256px;
            background-color: var(--text-primary-r);
            font-family: Roboto_Medium;
            font-size: 16px;

            @media(max-width:1160px) {
                font-size: 14px;
            }

            @media(max-width:600px) {
                font-size: 12px;
            }

            &__category {
                font-family: inherit;
                font-size: inherit;
                color: var(--text-primary);
                padding-inline: 10px;
                padding-block: 4px;

                
                @media(max-width:600px) {
                    padding-inline: 6px;
                    padding-block: 2px;
                }
            }

            &__score {
                font-family: inherit;
                font-size: inherit;
                background-color: var(--rating-color1);
                border-radius: 256px;
                padding-inline: 16px;
                padding-block: 4px;

                @media(max-width:600px) {
                    padding-inline: 10px;
                    padding-block: 2px;
                }
            }
        }


        .author {
            width: fit-content;
            color: var(--color-gray-100);
            gap: var(--gp-6);

            &:hover {
                color: var(--color-white);
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

        &__comment {
            width: fit-content;
            gap: var(--gp-6);
            font-family: Roboto_Medium;
            font-size: 14px;
            color: var(--color-gray-100);

            &:hover {
                color: var(--color-white);
            }

            svg {
                width: 20px;
                height: 20px;
                stroke-color: var(--color-gray-100);
            }
        }
    }

    .article-small {
        width: 100%;

        &.full-width .article__cover {
            aspect-ratio: 427 / 130;

            @media (max-width:600px) {
                aspect-ratio: 648 / 380
            }
        }
        .article__cover {
            height: 100%;
            aspect-ratio: 427 / 328;
            @media (max-width:768px) {
                aspect-ratio: 648 / 380
            }

            @media (max-width:600px) {
                aspect-ratio: 648 / 260
            }
        }

        .article__label {
            font-size: 20px;

            @media(max-width:1160px) {
                font-size: 18px;
  
            }

            @media (max-width:900px) {
                font-size: 16px;
                line-height: 1.2;
            }

            @media (max-width:600px) {
                font-size: 14px;
            }
        }

        .article-bar {
            font-size: 14;
        }

        .article-bar__category {
            padding-inline: 8px;
            padding-block: 2px;
        }

        .article-bar__score {
            padding-inline: 12px;
            padding-block: 2px;
        }

        .article__date {
            font-size: 14;
        }
    }

</style>