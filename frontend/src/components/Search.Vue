<script setup>
    import { onMounted, onBeforeUnmount, ref, watch} from 'vue'
    import api from '../utils/axios'
    
    import { useRoute } from 'vue-router'
    const route = useRoute()

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

    const searchGames = async () => {
        const q = query.value.trim()

        if (q.length < 2) {
            results.value = []
            return
        }

        try {
            const { data } = await api.get('/games/search', {
            params: { q }
            })
            results.value = data.result ?? data
        } catch (error) {}
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
    <div class="result-block flex-column">
        
        <div v-for="game in results" class="result flex-column" :key="game.idGame">
            <RouterLink :to="`/game/${game.idGame}`" class="flex-column game__link">
                <picture>
                    <img :src="game.cover_url" class="game__cover">
                </picture>
                <span class="game__name">{{ game.name }}</span>
            </RouterLink>
        </div>
    </div>
 </div>
</template>

<style scoped>
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

    .result {
        width: fit-content;
        gap: var(--gp-16);
    }

    .game__link {
        gap: var(--gp-16);
    }

    .game__cover {
        max-width: 220px;
        min-width: 220px;
        max-height: 300px;
        min-height: 300px;
        border-radius: 4px;
    }

    .game__name {
        font-family: Roboto_SemiBold;
        font-size: 24px;
        text-align: center;
    }




</style>