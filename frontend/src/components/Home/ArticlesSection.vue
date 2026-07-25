<script setup>
    import {ref, onMounted, nextTick } from 'vue'
    import ArticleCard1 from '@components/Articles/ArticleCard1.vue'
    import ArticleCard2 from '@components/Articles/ArticleCard2.vue'
    import api from '@/utils/axios'

    const emits = defineEmits(['loaded'])
    
    const articles = ref([])

    const loadArticles = async () => {
        try {
            const { data } = await api.get('/articles/home')
            articles.value = data.articles || []
        } catch(error) {
            console.log('Ошибка', error.response?.data?.error)
        } finally {
            await nextTick()
            emits('loaded')
        }
    }

    onMounted(async () => {
        await loadArticles()
    })
</script>

<template>
    <div class="articles flex-column">
        <div class="articles__top flex align-c">
            <ArticleCard2
                v-for="(article,index) in articles.slice(0,3)"
                :key="article.idArticle"
                :id="article.idArticle"
                :label="article.title"
                :category="article.category"
                :score="Number(article.score)"
                :comments="article.comments"
                :cover="article.cover"
                :author="article.author"
                :created_at="article.created_at"
                :variant="index === 1 ? 'large' : 'small'"
                :class="index === 2 ? 'full-width' : ''"
            />
        </div>
        <div class="articles__middle flex align-c">
            <ArticleCard1 
                v-for="article in articles.slice(3, 5)"
                :key="article.idArticle"
                :id="article.idArticle"
                :label="article.title"
                :category="article.category"
                :score="Number(article.score)"
                :comments="article.comments"
                :cover="article.cover"
                :author="article.author"
                :created_at="article.created_at"
                variant="large"
            />
        </div>
        <div class="articles__bottom flex align-c">
            <ArticleCard1 
                v-for="(article, index) in articles.slice(5, 8)"
                :key="article.idArticle"
                :id="article.idArticle"
                :label="article.title"
                :category="article.category"
                :score="Number(article.score)"
                :comments="article.comments"
                :cover="article.cover"
                :author="article.author"
                :created_at="article.created_at"
                variant="small"
                :class="index === 2 ? 'full-width' : ''"
            />
        </div>
    </div>
</template>

<style lang="scss" scoped>
    .articles {
        width: 100%;
        gap: var(--gp-16);

        @media(max-width:1160px) {
            padding-inline: 32px;
        }

        @media(max-width:768px) {
            padding-inline: 16px;
        }

        &__middle {
            @media (max-width:600px) {
                flex-direction: column;
            }
        }

        &__bottom {
            @media (max-width: 768px) {
                display: grid;
                grid-template-columns: repeat(2, 1fr);
                
                .full-width {
                    grid-column: 1 / -1;
                }
            }
            

            @media (max-width: 600px) {
                display: flex;
                flex-direction: column;
            }
        }

        &__top {
            height: 100%;
            @media (max-width: 768px) {
                display: grid;
                grid-template-columns: repeat(2, 1fr);
                
                .full-width {
                    grid-column: 1 / -1;
                }
            }

            @media (max-width: 600px) {
                display: flex;
                flex-direction: column;
            }
        }

        &__top,
        &__middle,
        &__bottom {
            gap: var(--gp-16);
        }
    }
</style>