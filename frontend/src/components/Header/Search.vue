<script setup>
    import { onMounted, onBeforeUnmount, ref, watch} from 'vue'
    import api from '@utils/axios'
    import { useRoute } from 'vue-router'
    import { formatDate } from '@utils/date/formatDate.js'
    import { onImageError } from '@/utils/helpers/onImageError'
    
    const route = useRoute()

    const { simpleDate } = formatDate() 

    const props = defineProps(['closeFn'])

    const close = () => {
        isActive.value = false
        setTimeout(() => props.closeFn(), 300)
    }

    // эт для анимки
    const isActive = ref(false);
    const inputRef = ref(null)

    // Поиск
    onBeforeUnmount(() => {
        clearTimeout(timer)
    })

    let timer = null

    // массив результатов

    const results = ref([])

    const query = ref('')

    const isLoading = ref(false)

    const searchGames = async () => {
        const q = query.value.trim()

        if (q.length < 2) {
            results.value = []
            return
        }
        isLoading.value = true
        try {
            const { data } = await api.get('/games/search', {
                params: { q }
            })
            results.value = data.result
        } catch (error) {}
        finally {
            isLoading.value = false
        }
    }

    const onInput = () => {
        clearTimeout(timer)
        timer = setTimeout(() => {
            searchGames()
        }, 200)
    }

    watch(() => route.fullPath, (newPath, oldPath) => {
        if(newPath != oldPath) close()
    })

    onMounted(() => {
        setTimeout(() => {
            isActive.value = true
            inputRef.value?.focus()
        }, 30)
    })

</script>


<template>
 <div class="search flex-column" :class="{activeSearch: isActive}">
    <div class="search__container flex-column align-c">
        <div class="label-block flex align-c">
            <h1>Поиск</h1>
            <button type="button" class="btn-close no-border" @click="close()" aria-label="Закрыть"></button>
        </div>
        <div class="search-field">
            <svg class="icon-search" @click="inputRef?.focus()">
                <use href="#icon-search"/>
            </svg>
            <input v-model="query"
                @input="onInput"
                ref="inputRef"
                placeholder="Название игры" 
                aria-label="Поиск"
            >
        </div>
    </div>   

    <div class="results flex-column">
        <RouterLink v-for="game in results" :to="`/game/${game.idGame}`" :key="game.idGame" class="flex game__link">
            <div class="game flex">
                <div class="img-block">
                    <picture>
                        <img :src="game.cover_url || ''" loading="lazy" @error="onImageError" class="game__cover">
                    </picture>
                </div>
                <div class="game__content flex-column">
                    <span class="game__name">{{ game.name }}</span>
                    <span class="game__releaseDate">{{ simpleDate(game.release_date) }}</span>
                    <span class="game__status">{{ game.status }}</span>
                    <span class="game__rating">{{ Number(game.rating_overall) }}</span>
                </div>
            </div>
        </RouterLink>
    </div>

 </div>
</template>

<style lang="scss" scoped>

    /* Main */

    .search {
        position: fixed;
        z-index: 1001;
        bottom: 0;
        width: 100vw;
        height: 100vh;
        background-color: var(--bg-primary);
        transform: translateY(100%);
        transition: transform 0.2s cubic-bezier(0.25, 0.46, 0.45, 0.94);

        &.activeSearch {
            transform: translateY(0%);
        }

        &__container {
            max-width: 1348px;
            width: 100vw;
            margin: 0 auto;
            padding: 32px 16px;
            gap: var(--gp-24);
        }
    }

    .label-block {
        width: 100%;
        justify-content: space-between;
        font-family: Roboto_SemiBold;
        color: var(--text-primary);
    }

    .btn-close {
        position: relative;
        width: 32px;
        height: 32px;

        &::before,
        &::after {
            content: '';
            position: absolute;
            top: 50%;
            left: 50%;
            width: 20px;
            height: 2px;
            background: var(--text-tertiary);
            transform: translate(-50%, -50%) rotate(45deg);
        }

        &::after {
            transform: translate(-50%, -50%) rotate(-45deg);
        }

        &:hover::before,
        &:hover::after {
            background-color: var(--text-primary);
        }
    }

    .search-field {
        width: 100%;
        position: relative;

        input {
            width: 100%;
            border-radius: 8px;
            padding: 10px 16px 10px 54px;
            background-color: var(--bg-secondary);
            color: var(--text-muted);
            font-family: Roboto_Medium;
            font-size: 20px;

            &::placeholder {
                color: var(--text-muted);
            }
        }

        .icon-search {
            position: absolute;
            width: 22px;
            height: 22px;
            color: var(--text-muted);
            top: 50%;
            transform: translateY(-50%);
            left: 16px;
        }
    }

    // Результат

    .results {
        max-width: 1348px;
        width: 100vw;
        margin: 0 auto;
        margin-top: 32px;
        padding-inline: 16px;
        gap: var(--gp-16);
        overflow-y: auto;
        scrollbar-width: thin;
        scrollbar-color: var(--color-dark-400) transparent;

        .game__link {
            width: 100%;
            gap: var(--gp-16);
            background-color: var(--bg-secondary);   
            padding: 12px 16px;
            border-radius: 8px;

            &:hover {
                background-color: var(--bg-secondary-hover)
            }

            @media (max-width:600px) {
                padding: 8px 8px;
                border-radius: 4px;
            }
        }
    }

    @mixin mobile {
        @media (max-width: 600px) { @content; }
    }

    @mixin mobile-small {
        @media (max-width: 425px) { @content; }
    }

    .game {
        align-items: flex-start;
        width: 100%;
        gap: var(--gp-16);

        .img-block {
            width: 140px;
            height: 186px;
            flex-shrink: 0;

            @include mobile {
                width: 100px;
                height: 133px;
            }

            @include mobile-small {
                width: 80px;
                height: 107px;
            }
        }

        &__cover {
            display: block;
            width: 100%;
            height: 100%;
            border-radius: 4px;
            object-fit: cover;
        }

        &__content {
            width: 100%;
            height: 100%;
            position: relative;
            gap: var(--gp-12);
            display: flex;
            flex-direction: column;
        }

        &__name {
            font-family: Roboto_SemiBold;
            font-size: 24px;
            padding-right: 48px;
            color: var(--text-primary);

            @include mobile {
                font-size: 18px;
            }

            @include mobile-small {
                font-size: 16px;
            }
        }

        &__releaseDate {
            font-family: Roboto_Medium;
            font-size: 20px;
            color: var(--text-tertiary);

            @include mobile {
                font-size: 16px;
            }
        }

        &__status {
            width: fit-content;
            padding: 4px 8px;
            font-family: Roboto_Medium;
            font-size: 16px;
            color: var(--color-gray-200);
            background-color: var(--color-dark-300);
            border-radius: 4px;

            @include mobile {
                font-size: 14px;
            }
        }

        &__rating {
            width: fit-content;
            position: absolute;
            top: 0;
            right: 0;
            padding: 2px 8px;
            background-color: var(--color-blue);
            color: var(--color-white);
            border-radius: 4px;
            font-size: 18px;
            font-family: Roboto_Medium;

            @include mobile {
                font-size: 14px;
            }
        }
    }




</style>