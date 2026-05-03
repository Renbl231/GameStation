<script setup>
    import ReviewCard from '../components/ReviewCard.vue';
    import { ref, computed, onMounted, watch } from 'vue'
    import api from '../utils/axios'

    import { useRoute, useRouter } from 'vue-router';
    const route = useRoute()
    const router = useRouter()
    
    
    const isLoading = ref(true)

    const totalPages = ref(1)
    const reviews = ref([])

    const perPage = 20

    const currentPage = computed(() => {
        const match = route.path.match(/\/p(\d+)/)
        return match ? Number(match[1]) : 1
    })

    const loadReviews = async () => {
        try {
            const { data } = await api.get(`/reviews?page=${currentPage.value}&limit=${perPage}`)
            if (data.success) {
                reviews.value = data.result.reviews || []
                totalPages.value = data.result.totalPages ?? 1
            }
        } catch (error) {}
    }

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
        
        const segments = []

        segments.push(`p${safePage}`)
        
        return `/games/${segments.join('/')}`
    }

    // Объект с параметрами оценки


    const buildRatings = (review) => ([
    { label: 'Геймплей', value: review.gameplay },
    { label: 'Графика', value: review.graphics },
    { label: 'Сюжет', value: review.story },
    { label: 'Музыка', value: review.music },
    { label: 'Атмосфера', value: review.atmosphere },
    { label: 'Оптимизация', value: review.optimization },
    { label: 'Инновации', value: review.innovation }
    ].filter(item => Number(item.value) > 0))


    onMounted(async () => {
        await loadReviews()

        isLoading.value = false
    })
    watch(
        () => currentPage.value,
        async () => {
            await loadReviews()
        }
    )


</script>

<template>
    <div class="reviews-container flex-column">
        <span class="headline">Рецензии</span>
        <div class="nav-block flex align-c">
            <RouterLink 
            to="/games" 
            class="nav-block__link" 
            :class="{ 'active': $route.path === '/games' || $route.path.startsWith('/games/') && !$route.path.includes('/selections') && !$route.path.includes('/reviews') }"
            >Каталог</RouterLink>

            <RouterLink 
            to="/games/selections" 
            class="nav-block__link" 
            :class="{ 'active': $route.path.startsWith('/games/selections') }"
            >Подборки</RouterLink>

            <RouterLink 
            to="/games/reviews" 
            class="nav-block__link" 
            :class="{ 'active': $route.path.startsWith('/games/reviews') }"
            >Рецензии</RouterLink>
        </div>
        <div class="reviews-wrapper">

             <ReviewCard
                v-for="review in reviews"
                :key="review.idReview"
                :params="{
                    idReview: review.idReview,
                    name: review.name,
                    score: Number(review.overall_score),
                    cover: review.cover_url,
                    description: review.content,
                    author_avatar: review.avatar_url,
                    author_nickname: review.nickname,
                    created_at: review.created_at,
                    views_counter: review.views_count,
                    comments_counter: review.comments_count,
                    ratings: buildRatings(review)
                }"
            />

        </div>

        <div v-if="reviews.length" class="container-pages flex-center">
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
</template>

<style scoped>

    .reviews-container {
        width: 100%;
        gap: var(--gp-32);
        background-color: var(--bg-secondary-25);
        border-radius: 8px;
        padding: 32px;
    }

    .nav-block {
        width: 100%;
        gap: var(--gp-24);
    }

    .nav-block__link {
        width: fit-content;
        background-color: var(--bg-secondary-25);
        border-radius: 4px;
        padding: 8px 16px;
        color: var(--font-primary-35);
        font-family: Roboto_SemiBold;
        font-size: 20px;
    }

    .nav-block__link:hover {
        background-color: var(--font-primary-25);
        color: var(--font-primary);
    }

    .nav-block__link.active {
        background-color: var(--font-primary-25);
        color: var(--font-primary);
    }

    .headline {
        font-size: 32px;
        font-family: Roboto_SemiBold;
    }

    .reviews-wrapper {
        display: grid;
        grid-template-columns: repeat(2, 1fr);
        row-gap: var(--gp-32);
        column-gap: var(--gp-24);
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


    @media (max-width:1160px) {
        .reviews-container {
            border-radius: 0px;
        }
    }

    @media (max-width:899px) {
        .reviews-wrapper {
            grid-template-columns: repeat(1, 1fr);
        }
    }   

    @media (max-width:600px) {
        .reviews-container {
            padding: 24px 16px;
            gap: var(--gp-24);
        }
    }


</style>