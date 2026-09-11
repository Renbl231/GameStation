
<script setup>
    import { ref, onMounted, computed, watch } from 'vue'
    import api from '../utils/axios'
    
    import { useRoute } from 'vue-router'
    const route = useRoute()

    import { inject } from 'vue'
    const userId = inject('userId')

    // Загрузка коллекции

    const isLoading = ref(true)

    const totalPages = ref(1)

    const perPage = 20

    const gameCollection = ref([])

    const loadGamesCollection = async () => {
    const { data } = await api.get(`/user/${userId.value}/games?page=${currentPage.value}&limit=${perPage}`)
    if (data.result) {
        gameCollection.value = data.result.rows || []
        totalPages.value = data.result.totalPages ?? 1
    }
    }

    const currentPage = computed(() => {
        const match = route.path.match(/\/p(\d+)/)
        return match ? Number(match[1]) : 1
    })


    const visiblePages = computed(() => {
        const pages = [], current = currentPage.value, total = totalPages.value
        
        if (total <= 5) {
            for (let i = 1; i <= total; i++) pages.push(i)
        } else {
            pages.push(1)
            if (current > 3) pages.push('...')
            
            const start = Math.max(2, current - 1)
            const end = Math.min(total - 1, current + 1)
            
            for (let i = start; i <= end; i++) pages.push(i)
            
            if (current < total - 2) pages.push('...')
            if (pages[pages.length - 1] !== total) pages.push(total)
        }
        
        return pages
    })


    const buildPageUrl = (pageNum) => {
        const safePage = Math.max(1, Math.min(totalPages.value, pageNum))
        return `/user/${route.params.nickname}/games/p${safePage}`
    }

    const collectionOrder = [
        'Любимые',
        'Пройденные',
        'Сейчас играю',
        'Хочу сыграть',
        'Заброшено'
    ]

    const groupedGames = computed(() => {
        const map = (gameCollection.value || []).reduce((acc, game) => {
            (acc[game.collection_type] ||= []).push(game)
            return acc
        }, {})

        return collectionOrder
            .filter(type => map[type]?.length)
            .map(type => ({
            type,
            games: map[type]
            }))
    })

    watch(
        currentPage,
        async () => {
            await loadGamesCollection()
            isLoading.value = false
        },
        { immediate: true }
        )
    </script>

<template>
    <div v-if="gameCollection.length && !isLoading" class="container flex-column">
        <div v-for="section in groupedGames" :key="section.type" class="flex-column section-wrapper">
            <span class="section__type">{{ section.type }}</span>
            <div class="game-wrapper">
                <div v-for="game in section.games" class="game" :key="game.idGame">
                     <RouterLink :to="`/game/${game.idGame}`">
                         <picture>
                             <img :src="game.cover_url" class="game__cover">
                         </picture>
                     </RouterLink>
                     <span v-if="game?.overall_score" class="game__rating">{{ Number(game.overall_score) }}</span>
                </div>
            </div>
        </div>
        <div v-if="gameCollection.length" class="container-pages flex-center">
            <RouterLink 
                :to="buildPageUrl(currentPage - 1)"
                class="item flex-center"
                :class="{ disabled: currentPage === 1 }"
                tabindex="0"
            >
                <svg class="icon-arrow prev"><use href="#icon-arrow"></use></svg>
            </RouterLink>

            <RouterLink 
                v-for="(page, index) in visiblePages" 
                :key="index"
                :to="page !== '...' ? buildPageUrl(page) : '#'"
                class="item flex-center"
                :class="{ 
                    active: page === currentPage, 
                    disabled: page === '...' 
                }"
                tabindex="0"
            >
                {{ page }}
            </RouterLink>

            <RouterLink 
                :to="buildPageUrl(currentPage + 1)"
                class="item flex-center"
                :class="{ disabled: currentPage === totalPages }"
                tabindex="0"
            >
                <svg class="icon-arrow next"><use href="#icon-arrow"></use></svg>
            </RouterLink>
        </div>
    </div>
    <div v-if="!gameCollection.length && !isLoading" class="else-block">
        Игр пока нет
    </div>
</template>

<style scoped>
    .else-block {
        font-family: Roboto_Medium;
        font-size: 18px;
        color: var(--font-primary-75);
    }

    .container {
        width: 100%;
        gap: var(--gp-16);
    }

    .section-wrapper {
        width: 100%;
        gap: var(--gp-16);
    }

    .section__type {
        font-family: Roboto_Medium;
        font-size: 24px;
    }

    .game-wrapper {
        width: 100%;
        display: grid;
        grid-template-columns: repeat(4, 1fr);
        gap: var(--gp-24);
    }

    @media (max-width:768px) {
        .game-wrapper {
            grid-template-columns: repeat(3, 1fr);
        }
    }

    @media (max-width:600px) {
        .game__rating {
            font-size: 14px;
        }
    }

    @media (max-width:425px) {
        .game-wrapper {
            grid-template-columns: repeat(2, 1fr);
        }
    }

    .game {
        position: relative;
        width: 100%;
        will-change: transform;
        transition: 0.4s;
    }
    .game:hover {transform: scale(1.03);}

    .game__rating {
        position: absolute;
        top: 8px;
        left: 8px;
        font-family: Roboto_Medium;
        background-color: var(--font-secondary);
        padding: 2px 8px;
        border-radius: 4px;
    }

    .game__cover {
        width: 100%;
        height: auto;
        aspect-ratio: 210 / 280;
        border-radius: 8px;
        object-position: center;
    }

    .game__name {
        font-family: Roboto_Medium;
        font-size: 18px;
    }


    /* Нижний нав бар */

    .container-pages {
        width: 100%;
        margin: 0 auto;
        gap: var(--gp-12);
        font-size: 16px;
        font-family: Roboto_SemiBold;
        margin-top: 64px;
    }


    .icon-arrow {
        width: 16px;
        height: 16px;
        stroke: var(--font-primary);
        transition: all 0.2s ease;
    }

    .icon-arrow.prev {
        transform: rotate(90deg);
    }

    .icon-arrow.next {
        transform: rotate(270deg);
    }

    .item {
        background-color: var(--btn-color-6-25);
        border-radius: 128px;
        min-width: 40px;
        max-height: 40px;
        padding: 12px;
        transition: 0.3s;
    }

    .item:hover {
        background-color: var(--btn-color-2);
    }

    .item.active {
        background-color: var(--btn-color-2);
    }

    .container-pages .item:hover:not(.disabled) {
        background: var(--btn-color-2)
    }

    .container-pages .item.disabled {
        opacity: 0.5;
        cursor: not-allowed;
        pointer-events: none;
    }
    

</style>