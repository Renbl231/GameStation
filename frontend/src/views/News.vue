<script setup>
    import NewsCard from '../components/NewsCard.vue'

    import { ref, computed, watch, nextTick } from 'vue'
    import { useRoute, useRouter } from 'vue-router'
    import { api } from '../utils/axios'
    import { preloadImages } from '../helpers/preloadImages'

    import { storeToRefs } from 'pinia'
    import { useAuthStore } from '../stores/authStore'

    const authStore = useAuthStore()
    const { isAuthenticated, user } = storeToRefs(authStore)

    const route = useRoute()
    const router = useRouter()


    const CATEGORY_MAP = {
        'all': 'all',
        'VR': 'VR',
        'PC': 'PC',
        'announcements': 'Анонсы',
        'industry': 'Индустрия',
        'consoles': 'Консоли',
        'releases': 'Релизы',
        'patches': 'Патчи',
        'rumors': 'Слухи'
    }

    const perPage = 21
    const newsList = ref([])
    const totalPages = ref(1)
    const currentFormat = ref('grid')

    const routeParams = computed(() => {
        const segments = route.path.split('/').slice(2) 
        
        let page = 1, sort = 'new', category = 'all'
        
        const pageMatch = segments.find(s => /^p\d+$/.test(s))
        if (pageMatch) page = parseInt(pageMatch.slice(1))
        
        const sortSeg = segments[0] && !/^p\d+$/.test(segments[0]) ? segments[0] : null
        if (sortSeg === 'popular') sort = 'popular'
        
        const pageIndex = segments.indexOf(pageMatch)
        if (pageIndex > -1 && pageIndex < segments.length - 1) {
            category = segments.slice(pageIndex + 1).join('/')
        }
        
        return { page, sort, category }
    })

    const currentPage = computed(() => routeParams.value.page)
    const currentSort = computed(() => routeParams.value.sort)
    const currentCategory = computed(() => routeParams.value.category)

    const navigate = (params) => {
        const { category = currentCategory.value, sort = currentSort.value, page = 1 } = params
        const segments = []
        
        if (sort === 'popular') segments.push('popular')
        segments.push(`p${page}`)
        if (category !== 'all') segments.push(category)
        
        router.push(`/news/${segments.join('/')}`)
    }

    const changeCategory = (cat) => navigate({ category: cat, page: 1 })
    const changeSort = (srt) => navigate({ sort: srt, page: 1 })


    const queryParams = computed(() => {
        const params = new URLSearchParams({ 
            page: currentPage.value,
            limit: perPage 
        })
        
        if (currentSort.value === 'popular') {
            params.set('sort', 'likes')
        }
        
        const backendCategory = CATEGORY_MAP[currentCategory.value] || currentCategory.value
        if (backendCategory !== 'all') {
            params.set('category', backendCategory)
        }
        
        return params
    })


    const isLoading = ref(true)

    const fetchNews = async () => {
        isLoading.value = true

        try {
            const { data } = await api.get(`/news?${queryParams.value}`)
            newsList.value = data.news || []
            totalPages.value = data.totalPages || 1

            const imageUrls = newsList.value
            .map(item => item.image)
            .filter(Boolean)

            await preloadImages(imageUrls)

        } catch (error) {
            console.error('News fetch error:', error.response?.data)
            newsList.value = []
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
        
        if(currentSort.value === 'popular') {
            segments.push('popular')
        }
        
        segments.push(`p${safePage}`)
        
        if(currentCategory.value !== 'all') {
            segments.push(currentCategory.value)
        }
        
        return `/news/${segments.join('/')}`
    }


    const setFormat = (format) => currentFormat.value = format
</script>



<template>
    <div v-if="isLoading" class="loading-overlay flex-center flex-column">
        <div class="loading-spinner"></div>
        <span class="loading-label">Загрузка новостей...</span>
    </div>

    <div class="container flex-column">
        <div class="wrapper-container flex">
            <div class="news-container flex-column">
                <div class="news-bar flex-column">
                    <h1>Игровые новости</h1>
                    <div class="news-categories flex">
                        <button type="button" @click="changeCategory('all')" :class="{ active: currentCategory === 'all' }" class="category no-border">
                            Все
                        </button>
                        <button type="button" @click="changeCategory('vr')" :class="{ active: currentCategory === 'vr' }" class="category no-border">
                            VR
                        </button>
                        <button type="button" @click="changeCategory('announcements')" :class="{ active: currentCategory === 'announcements' }" class="category no-border">
                            Анонсы
                        </button>
                        <button type="button" @click="changeCategory('industry')" :class="{ active: currentCategory === 'industry' }" class="category no-border">
                            Индустрия
                        </button>
                        <button type="button" @click="changeCategory('consoles')" :class="{ active: currentCategory === 'consoles' }" class="category no-border">
                            Консоли
                        </button>
                        <button type="button" @click="changeCategory('pc')" :class="{ active: currentCategory === 'pc' }" class="category no-border">
                            ПК
                        </button>
                        <button type="button" @click="changeCategory('releases')" :class="{ active: currentCategory === 'releases' }" class="category no-border">
                            Релизы
                        </button>
                        <button type="button" @click="changeCategory('patches')" :class="{ active: currentCategory === 'patches' }" class="category no-border">
                            Обновления
                        </button>
                        <button type="button" @click="changeCategory('rumors')" :class="{ active: currentCategory === 'rumors' }" class="category no-border">
                            Слухи
                        </button>
                        <RouterLink v-if="user?.role === 4 || user?.role === 2" to="/createNews" class="category no-border">
                            Добавить новость
                        </RouterLink>
                    </div>
                </div>
                <div class="news-sortSelector flex align-c justify-sb">
                    <div class="sort-row flex">
                        <button type="button" @click="changeSort('new')" :class="{active: currentSort === 'new'}" class="sort-type no-border">Новые</button>
                        <button type="button" @click="changeSort('popular')" :class="{active: currentSort === 'popular'}"class="sort-type no-border">Популярные</button>
                    </div>
                    <div class="sort-list flex align-c">
                        <button :class="{'active': currentFormat === 'grid'}" @click="setFormat('grid')" type="button" class="no-border grid-btn flex-center"><svg><use href="#grid-block"></use></svg></button>
                        <button :class="{'active': currentFormat === 'list'}" @click="setFormat('list')" type="button" class="no-border list-btn flex-center"><svg><use href="#list-block"></use></svg></button>
                    </div>
                </div>

                <div v-if="!newsList.length && !isLoading" class="empty-state">
                    <h3>Новостей нет</h3>
                </div>

                <Transition name="news" mode="out-in">
                    <div v-if="newsList.length && !isLoading" class="news-wrapper" :class="currentFormat === 'grid' ? 'grid-format' : 'list-format'">
                        <NewsCard 
                            v-for="news in newsList" 
                            :key="news.id"
                            :id="news.id"
                            :title="news.title"
                            :category="news.category"
                            :image="news.image"
                            :likes="news.likes"
                            :comments="news.comments"
                            :created_at="news.created_at"
                        />
                    </div>
                </Transition>
                
            </div>

            <div class="advertisment-container flex-column">
                <RouterLink to="/contact" class="place-btn">Разместить рекламу</RouterLink>
            </div>

        </div>

        <div v-if="newsList.length && !isLoading" class="container-pages flex-center">
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

    .news-container {
        width: 100%;
    }

    .news-wrapper {
        max-width: 910px;
        width: 100%;
        gap: var(--gp-24);
    }

    .news-bar {
        gap: var(--gp-24);
        margin-bottom: 32px;
    }

    h1 {
        font-size: 32px;
        font-family: Roboto_SemiBold;
    }

    .news-categories {
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

    .category.active, .category:hover {
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

    .advertisment-container {
        max-width: 300px;
        width: 100%;
        min-width: 284px;
        margin-bottom: auto;
    }

    .place-btn {
        font-size: 16px;
        font-family: Roboto_Medium;
        background-color: var(--btn-color-6-25);
        padding-block: 14px;
        border-radius: 8px;
        text-align: center;
    }

    .place-btn:hover {
        background-color: var(--btn-color-6-50);
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
        opacity: 0;
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
        .sort-type.active::after {
            padding-bottom: 11px;
        }
        .wrapper-container {
            flex-direction: column;
            gap: var(--gp-48);
        }
        .advertisment-container {
            margin: 0 auto;
        }
        .place-btn {
            font-size: 14px;
        }
        .news-wrapper {
            max-width: none;
        }
    }

    @media (max-width:1024px) {
        .news-container {
            max-width: none;
        }
    }

    @media (max-width:767px) {
        .news-wrapper {
            grid-template-columns: repeat(2, 1fr);
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
        .news-categories {
            row-gap: var(--gp-16);
            column-gap: var(--gp-12);
        }
        .news-bar {
            margin-bottom: 24px;
        }
        .sort-row {
            gap: var(--gp-24);
        }
        .news-wrapper.list-format {
            gap: var(--gp-20);
        }
    }

    @media (max-width:425px) {
        .news-wrapper {
            row-gap: var(--gp-20);
            column-gap: var(--gp-16);
            grid-template-columns: repeat(1, 1fr);
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