<script setup>
    import { ref } from 'vue'
    import { api } from '@utils/axios'
    import { preloadImages } from '@helpers/preloadImages.js'
    import { newsCategories } from '@constants/categories'
    import { usePagination } from '@composables/pagination/usePagination'
    import { buildNewsUrl } from '@composables/pagination/buildUrls'
    import NewsCard from '@components/news/NewsCard.vue'
    import CategoryFilter from '@components/filters/CategoryFilter.vue'
    import Pagination from '@components/pagination/Pagination.vue'
    import ViewToggle from '@components/common/ViewToggle.vue'
    import SortToggle from '@components/sorting/SortToggle1.vue'
    import Advertisment from '@components/common/Advertisment.vue'

    const currentFormat = ref('grid')

    const {
        items: newsList,
        totalPages,
        isLoading,
        currentPage,
        currentCategory,
        currentSort,
        navigate
    } = usePagination({
        baseUrl: 'news',
        perPage: 21,
        categories: newsCategories,

        fetchData: async (params) => {
            const { data } = await api.get(`/news?${params}`)
            
            const imageUrls = data.news?.map(item => item.image).filter(Boolean) || []
            if (imageUrls.length) {
                await preloadImages(imageUrls)
            }
            
            return {
                items: data.news || [],
                totalPages: data.totalPages || 1
            }
        }
    })

    const changeCategory = (cat) => navigate({ category: cat, page: 1 })
    const changeSort = (sort) => navigate({ sort, page: 1 })

    const buildPageUrl = (page) => {
        return buildNewsUrl(page, totalPages.value, currentCategory.value, currentSort.value)
    }

    const setFormat = (format) => currentFormat.value = format
</script>



<template>
    <div v-if="isLoading" class="loading-overlay flex-center flex-column">
        <div class="loading-spinner"></div>
        <span class="loading-label">Загрузка новостей...</span>
    </div>

    <div class="container flex">
        <div class="container__wrapper flex-column">

            <CategoryFilter
                :categories="newsCategories"
                :current-category="currentCategory"
                type="news"
                @changed="changeCategory"
            />

            <div class="sortbar flex align-c justify-sb">
                <SortToggle
                    :currentSort="currentSort"
                    @toggled="changeSort"
                />
                <ViewToggle
                    :current-format="currentFormat"
                    @toggled="setFormat"
                />
            </div>

            <Transition name="news" mode="out-in">
                <div v-if="newsList.length && !isLoading" class="news-wrapper" :class="currentFormat === 'grid' ? 'grid-format' : 'list-format'">
                    <NewsCard 
                        v-for="news in newsList" 
                        :key="news.idNew"
                        :id="news.idNew"
                        :title="news.title"
                        :category="news.category"
                        :cover="news.cover"
                        :likes="news.likes"
                        :comments="news.comments"
                        :created_at="news.created_at"
                    />
                </div>
                <div v-else-if="!newsList.length && !isLoading" class="empty-state">
                    Новостей нет
                </div>
            </Transition>

            <Pagination
                :totalPages="totalPages"
                :isLoading="isLoading"
                :currentPage="currentPage"
                :build-page-url="buildPageUrl" 
            />

        </div>

        <Advertisment/>
    </div>
    
</template>

<style lang="scss" scoped>

    .empty-state {
        font-family: Roboto_Medium;
        font-size: 18px;
    }

    .container {
        width: 100%;
        padding: 32px;
        border-radius: 8px;
        gap: var(--gp-36);
        background-color: var(--bg-tertiary);

        &__wrapper {
            width: 100%;
            gap: var(--gp-24);
        }   

        .sortbar {
            border-bottom: 2px solid var(--bg-secondary-border);
            padding-bottom: 8px;
        }
    }

    .news-wrapper {
        max-width: 910px;
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
        .container {
            border-radius: 0px;
            flex-direction: column;
            gap: var(--gp-48);
        }

        .news-wrapper {
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
    }



</style>