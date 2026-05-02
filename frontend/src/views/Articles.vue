<script setup>
    import { ref, computed, watch, nextTick } from 'vue'
    import { useRoute, useRouter } from 'vue-router'
    import { api } from '../utils/axios'
    import ArticleCard from '../components/ArticleCard.vue'

    
    import { storeToRefs } from 'pinia'
    import { useAuthStore } from '../stores/authStore'

    const authStore = useAuthStore()
    const { isAuthenticated, user } = storeToRefs(authStore)

    const route = useRoute()
    const router = useRouter()

    const perPage = 20
    const articleList = ref([])
    const totalPages = ref(1)

    const sectionsMap = {
        'reviews': 'Обзор',
        'selections': 'Подборка'
    }

    const getSectionName = (id) => {
        return sectionsMap[id] || 'Неизвестно'
    }

    const routeParams = computed(() => {
        const segments = route.path.split('/').slice(2) // ['p1', 'review'] или ['review']
        
        let page = 1, category = 'all'
        
        const pageMatch = segments[0]?.match(/^p(\d+)$/)
        if (pageMatch) {
            page = parseInt(pageMatch[1])
            category = segments[1] || 'all' // p1/review → 'review', p1 → 'all'
        } else {
            // 👈 ТОЛЬКО category: /articles/review
            category = segments[0] || 'all'
        }
        
        return { page, category }
    })

    const currentPage = computed(() => routeParams.value.page)
    const currentCategory = computed(() => routeParams.value.category)

    const navigate = (params) => {
        const { category = currentCategory.value, page = currentPage.value } = params
        
        const segments = []
        
        if (category !== 'all' || page !== 1) {
            segments.push(`p${page}`)
        }
        
        if (category !== 'all') {
            segments.push(category)
        }
        
        router.push(`/articles/${segments.join('/')}`)
    }

    const changeCategory = (cat) => navigate({ category: cat, page: 1 })


    const queryParams = computed(() => {
        const params = new URLSearchParams({ 
            page: currentPage.value,
            limit: perPage 
        })
        
        const backendCategory = currentCategory.value
        if (backendCategory !== 'all') {
            params.set('category', backendCategory)
        }
        
        return params
    })


    const isLoading = ref(false)

    const fetchNews = async () => {
    isLoading.value = true

    try {
        const { data } = await api.get(`/articles?${queryParams.value}`)
        
        articleList.value = data.articles || []
        totalPages.value = data.totalPages || 1
        
    } catch (error) {

        articleList.value = []
    } finally {
        isLoading.value = false
    }
}

    watch(routeParams, () => nextTick(fetchNews), { immediate: true })

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
        
        if(currentCategory.value !== 'all') {
            segments.push(currentCategory.value)
        }
        
        return `/articles/${segments.join('/')}`
    }

</script>

<template>
    <div class="container flex-column">
        <div class="wrapper-container flex">
            <div class="theme-container flex-column">
                <div class="theme-bar flex-column">
                    <h1>Статьи</h1>
                    <div class="theme-categories flex">
                        <button type="button" @click="changeCategory('all')" :class="{ active: currentCategory === 'all' }" class="category no-border">
                            Все
                        </button>
                        <button type="button" @click="changeCategory('reviews')" :class="{ active: currentCategory === 'reviews' }" class="category no-border">
                            Обзоры
                        </button>
                        <button type="button" @click="changeCategory('selections')" :class="{ active: currentCategory === 'selections' }" class="category no-border">
                            Подборки
                        </button>
                        <RouterLink v-if="user?.role === 2 || user?.role === 4" class="category" to="/createArticle">Создать</RouterLink>
                    </div>
                </div>

                <div v-if="!articleList.length && !isLoading" class="empty-state">
                    <h3>Статей нет</h3>
                </div>

                <Transition name="news" mode="out-in">
                    <div v-if="articleList.length && !isLoading" class="theme-wrapper grid">
                        <ArticleCard
                            v-for="article in articleList" 
                            :key="article.id"
                            :id="article.id"
                            :title="article.title"
                            :type_article="getSectionName(article.type_article )"
                            :image="article.image"
                            :comments="article.comments"
                            :created_at="article.created_at"
                        />
                    </div>
                </Transition>
                
            </div>
        </div>

        <div v-if="articleList.length && !isLoading" class="container-pages flex-center">
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

    .empty-state {
        font-family: Roboto_Medium;
        font-size: 18px;
    }

    .container {
        width: 100%;
        padding: 32px;
        border-radius: 8px;
        background-color: var(--bg-secondary-25);
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

    /*  */

    .wrapper-container {
        width: 100%;
        gap: var(--gp-36);
    }

    .theme-container {
        width: 100%;
    }

    .theme-wrapper {
        width: 100%;
        border-radius: 16px;
        display: grid;
        grid-template-columns: repeat(3, 1fr);
        gap: var(--gp-32);
    }

    .theme-bar {
        gap: var(--gp-24);
        margin-bottom: 32px;
    }

    h1 {
        font-size: 32px;
        font-family: Roboto_SemiBold;
    }

    .theme-categories {
        gap: var(--gp-16);
        flex-wrap: wrap;
    }

    .category {
        font-size: 20px;
        font-family: Roboto_Medium;
        color: var(--font-primary-35);
        background-color: var(--btn-color-6-25);
        border-radius: 4px;
        padding: 6px 12px;
    }

    .news-sortSelector {
        border-bottom: 2px solid var(--bg-secondary-50);
        padding-bottom: 8px;
        margin-bottom: 32px;
    }

    .sort-row {
        gap: var(--gp-32);
    }

   .sort-type {
        position: relative;
        font-size: 24px;
        font-family: Roboto_SemiBold;
        color: var(--font-primary-50);
        transition: 0.3s;
   }

   .sort-type.active {
        color: var(--font-primary);
   }

   .sort-type:hover {
        color: var(--font-primary);
   }

   .sort-type.active::after {
        content: '';
        position: absolute;
        top: 100%;
        left: 0;
        right: 0;
        border-bottom: 2px solid var(--font-secondary);
        padding-bottom: 8px;
   }

    .sort-list {
        gap: var(--gp-12)
    }

    .sort-list button {
        width: 36px;
        height: 36px;
        background-color: var(--btn-color-6-25);
        border-radius: 4px;
        transition: 0.3s;
    }

    .sort-list button:hover {
        background-color: var(--btn-color-6-50);
    }

    .sort-list button.active {
        background-color: var(--font-secondary);
    }

    .sort-list button.active svg { 
        stroke-opacity: 1;
    }

    .category.active {
        color: var(--font-primary);
        background-color: var(--font-primary-35);
    }

    .category:hover {
        color: var(--font-primary);
        background-color: var(--font-primary-35);
    }

    .grid-btn svg, .list-btn svg {
        width: 20px;
        height: 20px;
        stroke-opacity: 0.25;
    }

    .grid-format {
        display: grid;
        grid-template-columns: repeat(3, 1fr);
    }

    .list-format {
        display: flex;
        flex-direction: column;
    }

    /* Loading */

    .loading-overlay {
        position: fixed;
        bottom: 0;
        left: 0;
        width: 100%;
        height: fit-content;
        z-index: 9999;
        background-color: var(--bg-secondary-25);
        padding: 16px;
    }

    .loading-spinner {
        width: 64px;
        height: 64px;
        border: 4px solid #e3e3e3;
        border-top: 4px solid #007bff;
        border-radius: 50%;
        margin-bottom: 16px;
        animation: spin 1s;
    }

    .loading-label {
        font-size: 20px;
        font-family: Roboto_SemiBold;
    }

    @keyframes spin {
        0% { transform: rotate(0deg); }
        100% { transform: rotate(360deg); }
    }

    .news-enter-active, .news-leave-active {
        transition: opacity 0.3s ease;
    }
    .news-enter-from, .news-leave-to {
        opacity: 0
    }


    /*  */
    

    @media (max-width:1160px) {
        .sort-type {
            font-size: 20px;
        }
        .news-sortSelector {
            margin-bottom: 20px;
        }

        .container {
            border-radius: 0px;
        }
        .theme-wrapper {
            border-radius: 0px;
            gap: var(--gp-24);
        }
        .sort-type.active::after {
            padding-bottom: 11px;
        }
    }

    @media (max-width:1024px) {
        .wrapper-container {
            flex-direction: column;
            gap: var(--gp-48);
        }
        .advertisement-container {
            margin: 0 auto;
        }
        .theme-wrapper {
            grid-template-columns: repeat(2, 1fr);
        }
        .theme-container {
            max-width: none;
        }
    }

    @media (max-width:600px) {
        .grid-format  {
            grid-template-columns: repeat(2, 1fr);
        }
        .container {
            padding: 24px 16px;
        }
        h1 {
            font-size: 24px;
        }
        .category {
            font-size: 18px;
        }
        .theme-categories {
            row-gap: var(--gp-16);
            column-gap: var(--gp-12);
        }
        .theme-bar {
            margin-bottom: 24px;
        }
        .theme-wrapper {
            gap: var(--gp-16);
        }
        .sort-row {
            gap: var(--gp-24);
        }
        .theme-wrapper.list-format {
            gap: var(--gp-20);
        }
    }

    @media (max-width:425px) {
        .theme-wrapper {
            row-gap: var(--gp-20);
            column-gap: var(--gp-16);
        }
        .sort-list button {
            width: 32px;
            height: 32px;
        }
        .sort-type.active::after {
            padding-bottom:9px;
        }
        .category {
            font-size: 16px;
        }
    }

    @media (max-width:375px) {
        .sort-row {
            gap: var(--gp-16);
        }
        .sort-type {
            font-size: 18px;
        }
    }

</style>