<script setup>
    import { ref, onMounted, computed, watch } from 'vue'
    import { useRoute, useRouter} from 'vue-router'
    import { api } from '../utils/axios'
    import NewsCard from '../components/NewsCard.vue'

    
    const route = useRoute();
    const router = useRouter();

    const currentPage = computed({
        get() {
            const pageParam = route.params.page?.replace('p', '') || '1';
            const pageNum = parseInt(pageParam);
            return isNaN(pageNum) ? 1 : pageNum;
        },
        set(newPage) {
            router.push(`/news/all/p${newPage}`);
        }
    });

    const perPage = 20; // кол-во новостей на страницу
    const totalPages = ref(1);
    const newsList = ref([]);

    const visiblePages = computed(() => {
        const pages = [];
        const current = currentPage.value;
        const total = totalPages.value;

         if (current < 5) {
            for (let i = 1; i <= Math.min(5, total); i++) {
                pages.push(i);
            }
            if (total > 5) {
                pages.push(total);
            }
        } else {
            pages.push(1); 
            pages.push('...');
            pages.push(current - 1);
            
            pages.push(current);     // 5
            
            // 1 следующяя
            if (current + 1 <= total) pages.push(current + 1);
            
            // Последняя
            if (pages[pages.length - 1] !== total) {
                pages.push(total);
            }
        }
        
        return pages;
    });

    const requestData = async () => {
        try { 
            const { data } = await api.get(`/news?${queryParams.value}`);
            newsList.value = data.news || [];
            totalPages.value = data.totalPages || 1;
        } catch (error) {
            console.error('Ошибка requestData:', error);
        }
    };

    const currentFormat = ref('grid');

    const setFormat = (format) => {
        currentFormat.value = format
    }

    const activeSort = ref('new')
    const activeCategory = ref('all')

    const queryParams = computed(() => {
        const params = {
            page: currentPage.value,
            limit: perPage
        }

        if(activeSort.value === 'popular') {
            params.sort = 'likes'
        }

        if(activeCategory.value !== 'all') {
            params.category = activeCategory.value;
        }

        return new URLSearchParams(params)
    })
    
    const changeSort = (sortType) => {
        activeSort.value = sortType
        currentPage.value = 1
    }

    const changeCategory = (categoryType) => {
        activeCategory.value = categoryType
        currentPage.value = 1
    }

    watch([currentPage, activeSort, activeCategory], () => {
        requestData();
    }, { immediate: true });

</script>

<template>
    <div class="container flex-column">
        <div class="wrapper-container flex">
            <div class="news-container flex-column">
                <div class="news-bar flex-column">
                    <h1>Игровые новости</h1>
                    <div class="news-categories flex">
                        <button type="button" @click="changeCategory('all')" :class="{ active: activeCategory === 'all' }" class="category no-border">Все</button>
                        <button type="button" @click="changeCategory('VR')" :class="{ active: activeCategory === 'VR' }" class="category no-border">VR</button>
                        <button type="button" @click="changeCategory('Анонсы')" :class="{ active: activeCategory === 'Анонсы' }" class="category no-border">Анонсы</button>
                        <button type="button" @click="changeCategory('Индустрия')" :class="{ active: activeCategory === 'Индустрия' }" class="category no-border">Индустрия</button>
                        <button type="button" @click="changeCategory('Консоли')" :class="{ active: activeCategory === 'Консоли' }" class="category no-border">Консоли</button>
                        <button type="button" @click="changeCategory('PC')" :class="{ active: activeCategory === 'PC' }" class="category no-border">ПК</button>
                        <button type="button" @click="changeCategory('Релизы')" :class="{ active: activeCategory === 'Релизы' }" class="category no-border">Релизы</button>
                        <button type="button" @click="changeCategory('Патчи')" :class="{ active: activeCategory === 'Патчи' }" class="category no-border">Обновления</button>
                        <button type="button" @click="changeCategory('Слухи')" :class="{ active: activeCategory === 'Слухи' }" class="category no-border">Слухи</button>
                    </div>
                </div>
                <div class="news-sortSelector flex align-c justify-sb">
                    <div class="sort-row flex">
                        <button type="button" @click="changeSort('new')" :class="{active: activeSort === 'new'}" class="sort-type no-border">Новые</button>
                        <button type="button" @click="changeSort('popular')" :class="{active: activeSort === 'popular'}"class="sort-type no-border">Популярные</button>
                    </div>
                    <div class="sort-list flex align-c">
                        <button :class="{'active': currentFormat === 'grid'}" @click="setFormat('grid')" type="button" class="no-border grid-btn flex-center"><svg><use href="#grid-block"></use></svg></button>
                        <button :class="{'active': currentFormat === 'list'}" @click="setFormat('list')" type="button" class="no-border list-btn flex-center"><svg><use href="#list-block"></use></svg></button>
                    </div>
                </div>
    
                <div v-if="!newsList.length" class="empty-state">
                    <h3>Новостей нет</h3>
                </div>
                
                <div v-else class="news-wrapper" :class="currentFormat === 'grid' ? 'grid-format' : 'list-format'">
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

            </div>

            <div class="advertisement-container flex-center">
                <picture>
                    <img src="/images/6.jpg">
                </picture>
            </div>
        </div>

        <div v-if="newsList.length" class="container-pages flex-center">
            <RouterLink 
                :to="`/news/all/p${Math.max(1, currentPage - 1)}`" 
                class="item flex-center"
                :class="{ disabled: currentPage === 1 }"
                tabindex="0"
                aria-label="Предыдущая страница"
            >
                <svg class="icon-arrow prev"><use href="#icon-arrow"></use></svg>
            </RouterLink>

            <RouterLink 
                v-for="(page, index) in visiblePages" 
                :key="index"
                :to="page !== '...' ? `/news/all/p${page}` : '#'"
                class="item flex-center"
                :class="{ 
                active: page === currentPage, 
                disabled: page === '...' 
                }"
                tabindex="0"
                :aria-current="page === currentPage ? 'page' : null"
            >
                {{ page }}
            </RouterLink>

            <RouterLink 
                :to="`/news/all/p${Math.min(totalPages, currentPage + 1)}`" 
                class="item flex-center"
                :class="{ disabled: currentPage === totalPages }"
                tabindex="0"
                aria-label="Следующая страница"
            >
                <svg class="icon-arrow next"><use href="#icon-arrow"></use></svg>
            </RouterLink>
        </div>


    </div>
    
</template>

<style scoped>

    h3 {
        font-family: Roboto_Medium;
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

    .grid-btn svg, .list-btn svg {
        width: 20px;
        height: 20px;
        stroke-opacity: 0.25;
    }

    .news-wrapper {
        width: 100%;
        gap: var(--gp-24);
    }

    .grid-format {
        display: grid;
        grid-template-columns: repeat(3, 1fr);
    }

    .list-format {
        display: flex;
        flex-direction: column;
    }

    .advertisement-container {
        width: 300px;
        min-width: 284px;
        margin-bottom: auto;
    }
    

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
    }

    @media (max-width:1024px) {
        .wrapper-container {
            flex-direction: column;
            gap: var(--gp-48);
        }
        .advertisement-container {
            margin: 0 auto;
        }
        .news-container {
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