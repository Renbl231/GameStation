<script setup>
    import { onAvatarError } from '@helpers/onImageError'
    import { useRoute } from 'vue-router'

    const route = useRoute()

    const props = defineProps({
        author: {
            type: [Object],
            default: () => ({})
        },
        views: {
            type: [Number],
            default: 0
        },
        comments: {
            type: [Number],
            default: 0
        }
    })
    
</script>

<template>
    <div class="author-block flex justify-sb align-c"> 
        <RouterLink :to="`/user/${props.author.name}`" class="flex align-c author">
            <img 
                :src="props.author?.avatar || ''" 
                @error="onAvatarError"
                class="author__avatar"
                :class="{'blue': props.author.role === 2, 'red': props.author.role === 4 }" 
            >
            <span class="author__name">{{ props.author.name }}</span>
        </RouterLink>
        <div class="counters flex align-c">
            <span aria-label="Количество просмотров" class="flex-center counters__view">
                <svg class="icon icon-views"><use href="#icon-views"></use></svg>
                {{ props.views}}
            </span>
            <RouterLink
                :to="{ path: route.path, hash: '#comments-section' }"
                aria-label="Перейти к комментариям"
                class="flex-center counters__comment"
            >
                <svg class="icon icon-comment"><use href="#icon-comment"></use></svg>
                {{ props.comments }}
            </RouterLink>
            
        </div>
    </div>
</template>

<style lang="scss" scoped>
    .author-block {
        border-bottom: 2px solid var(--bg-secondary-50);
        padding-bottom: 16px;

        @media (max-width:599px) {
            padding-bottom: 12px;
        }

        .author {
            color: var(--text-secondary);
            gap: var(--gp-10);

            &:hover {color: var(--text-primary)}

            &__name {
                font-size: 14px;
                color: inherit;

                @media (max-width:599px) {
                    font-size: 12px;
                }
            }

            &__avatar {
                width: 32px;
                height: 32px;
                border-radius: 50%;

                &.blue {
                    outline: 2px solid var(--color-blue);
                }

                &.red {
                    outline: 2px solid var(--color-red);
                }
            }
        }

        .counters {
            gap: var(--gp-16);

            @media (max-width:599px) {
                font-size: 14px;
            }

            @media (max-width:375px) {
                gap: var(--gp-10);
                
            }

            &__view {
                gap: var(--gp-8);
                color: var(--text-muted);
                padding: 0;

                svg {
                    stroke-color: var(--text-muted);
                }
            }

            &__comment {
                width: fit-content;
                gap: var(--gp-8);
                font-family: Roboto_Medium;
                font-size: 14px;
                color: var(--text-muted);
                
                &:hover {
                    color: var(--text-primary);
                }

                svg {
                    stroke-color: var(--text-muted);
                }
            }
        }

    
    }

    .icon {
        width: 24px;
        height: 24px;

        @media (max-width:599px) {
            width: 20px;
            height: 20px;
        }

        &-views {
            @media (max-width:599px) {
                height: 13px;
            }
        }
    }

</style>