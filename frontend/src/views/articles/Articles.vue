<script setup>
    import { api } from '@utils/axios.js'
    import { preloadImages } from '@helpers/preloadImages.js'
    import { articleCategories } from '@constants/categories'
    import { usePagination } from '@composables/pagination/usePagination'
    import { buildArticlesUrl } from '@composables/pagination/buildUrls'
    import ArticleCard2 from '@components/articles/ArticleCard2.vue'
    import CategoryFilter from '@components/filters/CategoryFilter.vue'
    import Pagination from '@components/pagination/Pagination.vue'

    const {
        items: articles,
        totalPages,
        isLoading,
        currentPage,
        currentCategory,
        navigate
    } = usePagination({
        baseUrl: 'articles',
        perPage:20 ,
        fetchData: async (params) => {
            const { data } = await api.get(`/articles?${params}`)
            
            const imageUrls = data.articles?.map(item => item.image).filter(Boolean) || []
            if (imageUrls.length) {
                await preloadImages(imageUrls)
            }
            
            return {
                items: data.articles || [],
                totalPages: data.totalPages || 1
            }
        },
        categories: articleCategories 
    })

    const buildPageUrl = (page) => {
        return buildArticlesUrl(page, totalPages.value, currentCategory.value)
    }

    const changeCategory = (category) => {
        navigate({ category, page: 1 })
    }

</script>

<template>
    <div class="container flex-column">

        <CategoryFilter 
            :categories="articleCategories"
            :current-category="currentCategory"
            type="articles"
            @changed="changeCategory"
        />

        <Transition name="articles" mode="out-in">
            <div v-if="!articles.length && !isLoading" class="empty-state">
                Статей нет
            </div>
            <div v-else-if="articles.length && !isLoading" class="articles">
                <ArticleCard2
                    v-for="article in articles"
                    :key="article.idArticle"
                    :id="article.idArticle"
                    :label="article.title"
                    :category="article.category"
                    :score="Number(article.score)"
                    :comments="article.comments"
                    :cover="article.cover"
                    :author="article.author"
                    :created_at="article.created_at"
                    variant="standart"
                />
            </div>
        </Transition>

        <Pagination
            :totalPages="totalPages"
            :isLoading="isLoading"
            :currentPage="currentPage"
            :build-page-url="buildPageUrl" 
        />


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
        background-color: var(--bg-tertiary);
        gap: var(--gp-32);

        @media (max-width:1160px) {
            border-radius: 0px; 
        }

        @media (max-width:600px) {
            padding: 24px 16px;
        }

    }

    .articles {
        width: 100%;
        display: grid;
        grid-template-columns: repeat(3, 1fr);
        gap: var(--gp-24);
        
        @media (max-width:1160px) {
            border-radius: 0px;
        }

        @media (max-width:1024px) {
            grid-template-columns: repeat(2, 1fr);
        }           

        @media (max-width:600px) {
            gap: var(--gp-16);
        }

        @media (max-width:500px) {
            grid-template-columns: repeat(1, 1fr)
        }

        @media (max-width:425px) {
            row-gap: var(--gp-20);
            column-gap: var(--gp-16);
        }

    }

    .articles-enter-active, .articles-leave-active {
        transition: opacity 0.3s ease;
    }
    
    .articles-enter-from, .articles-leave-to {
        opacity: 0
    }

</style>