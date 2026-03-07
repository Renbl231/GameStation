<script setup>
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
        <div class="author-info flex align-c">
            <RouterLink :to="`/user/${props.author.name}`" class="author-name">
                <img :src="props.author.avatar" class="author-img">
            </RouterLink>
            <RouterLink :to="`/user/${props.author.name}`" class="author-name">{{ props.author.name }}</RouterLink>
        </div>
        <div class="counters flex align-c">
            <span aria-label="Количество просмотров" class="flex-center"><svg class="icon icon-views"><use href="#icon-views"></use></svg>{{ props.views}}</span>
            <RouterLink :to="`/newsdata/${$route.params.id}?tab=comments`"
                aria-label="Перейти к комментариям"
                class="flex-center">
                <svg class="icon icon-comment"><use href="#icon-comment"></use></svg>
                {{ props.comments }}
            </RouterLink>
        </div>
    </div>
</template>

<style scoped>
    .author-block {
        border-bottom: 2px solid var(--bg-secondary-50);
        padding-bottom: 16px;
        font-family: Roboto_Medium;
    }

    .author-block.rem-p {
        padding-bottom: 0px;
        border: none;
    }

    .author-info {
        gap: var(--gp-10);
    }

    .author-img {
        width: 36px;
        height: 36px;
        border-radius: 50%;
    }

    .author-name {
        font-size: 14px;
        color: var(--font-primary-75);
    }

    .counters {
        gap: var(--gp-24);
    }

    .counters a, .counters span {
        gap: var(--gp-8);
        color: var(--font-primary-25);
        padding: 0;
    }

    .icon {
        width: 24px;
        height: 24px;
    }

    .icon-views {
        height: 16px;
    }

    @media (max-width:599px) {
        .author-name {
            font-size: 12px;
        }

        .author-block {
            padding-bottom: 12px;
        }

        .counters {
            gap: var(--gp-16);
            font-size: 14px;
        }

        .icon {
            width: 20px;
            height: 20px;
        }

        .icon-views {
            height: 13px;
        }
    }

    @media (max-width:375px) {
        .counters {
            gap: var(--gp-10);
        }

        .counters a, .counters span {
            gap: var(--gp-4);
        }
    }
</style>