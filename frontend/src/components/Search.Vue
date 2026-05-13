<script setup>
    import { onMounted, onBeforeUnmount, ref, watch} from 'vue'
    import api from '../utils/axios'
    
    import { useRoute } from 'vue-router'
    const route = useRoute()

    import { useFormatDate } from '../composables/useFormatDate'
    const { simpleDate } = useFormatDate() 

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
            results.value = data.result ?? data
        } catch (error) {}
        finally {
            isLoading.value = false
        }
    }

    const onInput = () => {
        clearTimeout(timer)
        timer = setTimeout(() => {
            searchGames()
        }, 150)
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
 <div class="search-block flex-column" :class="{activeSearch: isActive}">
    <div class="search-container flex-column align-c">
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
    
    <!-- <div v-if="isLoading" class="loading-overlay flex-center flex-column">
        <div class="loading-spinner flex-center"></div>
    </div> -->

    <div class="result-block flex-column">
        
        <RouterLink v-for="game in results" :to="`/game/${game.idGame}`" :key="game.idGame" class="flex game__link">
            <div class="result flex">
                <div class="img-block">
                    <picture>
                        <img :src="game.cover_url" class="game__cover">
                    </picture>
                </div>
                <div class="game-content flex-column">
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

<style scoped>

    /* Loading */

    /* .loading-overlay {
        position: fixed;
        top: 50%;
        left: 50%;
        transform: translate(-50%, -50%);
        width: fit-content;
        height: fit-content;
        z-index: 9999;
        padding: 16px;
    }

    .loading-spinner {
        width: 64px;
        height: 64px;
        border: 4px solid #e3e3e3;
        border-top: 4px solid #007bff;
        border-radius: 50%;
        animation: spin 1s linear infinite;
    }

    @keyframes spin {
        0% { transform: rotate(0deg); }
        100% { transform: rotate(360deg); }
    } */

    /* Main */

    .search-block {
        position: fixed;
        z-index: 1001;
        bottom: 0;
        width: 100vw;
        height: 100vh;
        background-color: var(--hdr-primary);

        font-size: 20px;
        font-family: Roboto_SemiBold;

        transform: translateY(100%);
        transition: transform 0.2s cubic-bezier(0.25, 0.46, 0.45, 0.94);
    }

    .search-block.activeSearch {
        transform: translateY(0%);
    }

    .search-container {
        max-width: 1348px;
        width: 100vw;
        margin: 0 auto;
        padding: 32px 16px;
        gap: var(--gp-32);
    }

    .result-block {
        max-width: 1348px;
        width: 100vw;
        margin: 0 auto;
        padding: 32px 16px;
        gap: var(--gp-16);
        overflow-y: auto;
        scrollbar-width: thin;
        scrollbar-color: var(--btn-color-6-50) transparent;
    }


    .label-block {
        width: 100%;
        justify-content: space-between;
    }

    .search-field {
        width: 100%;
        position: relative;
    }

    .search-field input {
        width: 100%;
    }

    .search-field input {
        border-radius: 8px;
        padding: 10px 16px 10px 54px;
        background-color: var(--bg-secondary-25);
        color: var(--font-primary-50);
        font-family: Roboto_Medium;
    }

    
    .search-field input::placeholder {
        color: var(--font-primary-50);
    }
    
    .icon-search {
        position: absolute;
        width: 22px;
        height: 22px;
        color: var(--font-primary-50);
        top: 50%;
        transform: translateY(-50%);
        left: 16px;
    }

    .btn-close {
        position: relative;
        width: 32px;
        height: 32px;
    }

    .btn-close::before,
    .btn-close::after {
        content: '';
        position: absolute;
        top: 50%;
        left: 50%;
        width: 20px;
        height: 2px;
        background: var(--font-primary-50);
        transform: translate(-50%, -50%) rotate(45deg);
    }

    .btn-close::after {
        transform: translate(-50%, -50%) rotate(-45deg);
    }

    .btn-close:hover::before,
    .btn-close:hover::after {
        background-color: var(--font-primary);
    }

    .game__link {
        width: 100%;
        gap: var(--gp-16);
        background-color: var(--bg-secondary-25);   
        padding: 12px 16px;
        border-radius: 8px;
    }

    .game__link:hover {
        background-color: var(--bg-secondary-50);
    }

    .result {
        align-items: flex-start;
        width: 100%;
        gap: var(--gp-16);
    }

    .img-block {
        width: 140px;
        height: 186px;
        flex-shrink: 0;
    }

    .game__cover {
        display: block;
        width: 100%;
        height: 100%;
        border-radius: 4px;
    }

    .game-content {
        width: 100%;
        height: 100%;
        position: relative;
        gap: var(--gp-12);
    }

    .game__name {
        font-family: Roboto_SemiBold;
        font-size: 24px;
        padding-right: 48px;
    }

    .game__releaseDate {
        font-family: Roboto_Medium;
        font-size: 20px;
        color: var(--font-primary-75);
    }

    .game__status {
        width: fit-content;
        padding: 4px 8px;
        font-family: Roboto_Medium;
        font-size: 16px;
        color: var(--font-primary-75);
        background-color: var(--bg-secondary-50);
        border-radius: 4px;
    }

    .game__rating {
        width: fit-content;
        position: absolute;
        top: 0px;
        right: 0px;
        padding: 2px 8px;
        background-color: var(--font-secondary);
        border-radius: 4px;
        font-size: 18px;
        font-family: Roboto_Medium;
    }

    @media (max-width:600px) {
        .game__link {
            padding: 8px 8px;
            border-radius: 4px;
        }

        .game__name {
            font-size: 18px;
        }

        .game__releaseDate {
            font-size: 16px;
        }

        .game__status {
            font-size: 14px;
        }

        .game__rating {
            font-size: 14px;
        }

        .img-block {
            width: 100px;
            height: 133px;
        }
    }

    @media (max-width:425px) {
        .img-block {
            width: 80px;
            height: 107px;
        }

        .game__name {
            font-size: 16px;
        }
    }



</style>