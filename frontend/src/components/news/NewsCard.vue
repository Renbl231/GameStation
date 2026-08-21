<script setup>
    import { formatDate } from '@utils/date/formatDate';
    import { onImageError } from '@utils/helpers/onImageError'

    const { formatRelativeDate } = formatDate()

    const props = defineProps({
        id: Number,           
        title: String,        
        category: String,  
        cover: String,
        likes: Number,
        comments: Number,
        created_at: [String, Date]
    })

</script>

<template>
    <div class="news">
        <div class="news__top">
            <RouterLink :to="`/newsdata/${props.id}`" class="cover-block">
                <picture>
                    <img loading="lazy" @error="onImageError" :src="props.cover" class="cover-block__img">
                </picture>
            </RouterLink>
            <div class="interaction-block align-c" data-grid-block>
                <span class="interaction-block__span flex-center">
                    <svg class="icon"><use href="#icon-like"></use></svg>
                    {{ props.likes }}
                </span>
                <RouterLink :to="`/newsdata/${props.id}?tab=comments`"
                    class="interaction-block__href flex-center"
                    aria-label="Перейти к комментариям">
                      <svg class="icon"><use href="#icon-comment"></use></svg>
                      {{ props.comments }}
                </RouterLink>
            </div>
        </div>
        <div class="news__bottom flex-column">
            <RouterLink :to="`/newsdata/${props.id}`" class="news__label">
                {{ props.title }}
            </RouterLink>
            <span class="news__data">{{ formatRelativeDate(created_at) }} <span v-if="props.category">| {{ props.category}}</span></span>
            <div class="interaction-block align-c" data-list-block>
                <span class="interaction-block__span flex-center"><svg class="icon icon-v2"><use href="#icon-like"></use></svg>{{ props.likes }}</span>
                <RouterLink :to="`/newsdata/${props.id}?tab=comments`"
                    class="interaction-block__href flex-center"
                    aria-label="Перейти к комментариям">
                      <svg class="icon icon-v2"><use href="#icon-comment"></use></svg>
                      {{ props.comments }}
                </RouterLink>
            </div>
        </div>
    </div>
</template>

<style lang="scss" scoped> 
    .news {
        width: 100%;
        height: 100%;
        font-family: Roboto_Medium;

        &__top {
            width: 100%;
            display: block;
            position: relative;
            overflow: hidden;
            border-radius: 8px;
        }

        &__label {
            color: var(--text-primary);
            font-size: 16px;
            line-height: 1.5;

            &:hover {
                text-decoration: underline;
            }
        }

        &__data {
            color: var(--text-muted);
            gap: var(--gp-4);
        }
    }

    .interaction-block {
        &__span,
        &__href {
            gap: var(--gp-4);
            color: var(--text-muted);
        }

        &__href:hover {
            color: var(--text-primary);
        }

        &[data-list-block] .interaction-block__span,
        &[data-list-block] .interaction-block__href {
            font-size: 16px;

            @media (max-width:767px) {
                font-size: 14px;
            }
        }
    }


    .cover-block {
        width: 100%;
        height: 100%;

        &__img {
            width: 100%;
            cursor: pointer;
            transition: transform 0.3s ease;
            transition: 0.4s;
            will-change: transform;
            aspect-ratio: 290 / 163;
            &:hover {transform: scale(1.05);}

        }
    }

    .grid-format {
        & .news {
            display: flex;
            flex-direction: column;
            height: 100%;
            gap: var(--gp-10);
            overflow: hidden;


            &__top:hover .interaction-block[data-grid-block] {
                opacity: 1;
                visibility: visible;
                transform: translateX(0px);
            }

            &__bottom {
                flex: 1;
                gap: var(--gp-4);
            }

            &__data {
                margin-top: auto;
                font-size: 14px
            }

            &__label {
                display: -webkit-box;
                -webkit-line-clamp: 2;
                -webkit-box-orient: vertical;
                overflow: hidden;
                text-overflow: ellipsis;
            }
        }

        & .interaction-block[data-grid-block] {
            position: absolute;
            display: flex;
            bottom: 0px;
            right: 0px;
            visibility: hidden;
            z-index: 10;
            transition: 0.3s;
            opacity: 0;
            background-color: var(--color-dark-300);
            padding-right: 6px;
            padding-block: 4px;
            padding-left: 28px;
            font-size: 14px;
            gap: var(--gp-16);
            overflow: hidden;
            transform: translateX(20px);
            clip-path: polygon(25% 0, 100% 0, 100% 100%, 0 100%);
        }

        & .interaction-block[data-list-block] {
            display: none;
        }
    }

    .icon {
        width: 16px;
        height: 16px; 

        &-v2 {
            width: 20px;
            height: 20px;

            @media (max-width:767px) {
                width: 16px;
                height: 16px;
            }
        }
    }

    .list-format {
        display: flex;
        flex-direction: column;

        & .news {
            display: flex;
            gap: var(--gp-16);
            border-bottom: 2px solid var(--bg-secondary-border);
            padding-bottom: 16px;

            @media (max-width:425px) {
                gap: var(--gp-10) !important;
            }

            &__top {
                max-width: 210px;

                @media (max-width:767px) {
                    max-width: 180px;
                }

                @media (max-width:425px) {
                    max-width: 130px;
                    .cover-block__img {
                        aspect-ratio: 130/130;
                    }
                }
            }

            &__label {
                width: fit-content;
                font-size: 20px;

                @media (max-width:767px) {
                    font-size: 18px;
                }

                @media (max-width:500px) {
                    font-size: 16px;
                    line-height: 1.3;
                }
            }

            &__bottom {
                width: 100%;
                gap: var(--gp-8);
            }

            &__data {
                font-size: 18px;
                text-wrap: wrap;

                @media (max-width:767px) {
                    font-size: 16px;
                }

                @media (max-width:425px) {
                    font-size: 14px;
                } 
            }
        }

        & .interaction-block[data-grid-block] {
            display: none;
        }

        & .interaction-block[data-list-block] {
            display: flex;
            align-items: center;
            margin-left: auto;
            margin-top: auto;
            gap: var(--gp-16);
        }

        & .interaction-block__href:hover {
            color: var(--color-white) !important;
        }
    }
    

</style>