<script setup>
    import Comment from '../components/Comment.vue'
    import CommentForm from '../components/CommentForm.vue'
    import AuthorBlock from '../components/AuthorBlock.vue'
    import ThemeLabel from '../components/ThemeLabel.vue'

    import { ref, onMounted, nextTick, watch } from 'vue'
    import { useRoute, useRouter } from 'vue-router'
    import { useAuthStore } from '../stores/authStore'
    import { storeToRefs } from 'pinia'
    import api from '../utils/axios'
    import { useFormatDate } from '../composables/useFormatDate';
    
    const { formatDate } = useFormatDate()
    const authStore = useAuthStore()
    const { isAuthenticated } = storeToRefs(authStore)
    const route = useRoute()
    const router = useRouter()

    const news = ref({ likes_count: 0, views_count: 0, comments_count: 0 }) // сам контент новости
    const loading = ref(true);
    const error = ref('')

    const loadNews = async () => {
        try {
            loading.value = true;
            error.value = '';
            const idNews = route.params.id;
            
            const { data } = await api.get(`/newsdata/${idNews}`);
            
            if (!data) {
                throw new Error(data.error || 'Новость не найдена');
            }
            
            news.value = data; 
            
        } catch (error) {
            error.value = error.response?.data?.error || 'Новость не найдена';
            news.value = {};
        } finally {
            loading.value = false;
        }
    };

    const likeNews = async () => {
        if(!isAuthenticated.value) {
            return;
        }
        
        const idNews = route.params.id;
        const { data } = await api.post('/newslike', { 
            news_id: idNews
        });

        if (data.success === 'already') {
            news.value.likes_count -= 1;
        } else if (data.success === 'true') {
            news.value.likes_count += 1;
        }
    };

    const scrollToCommentsIfNeeded = async () => {
        await nextTick();
        
        if(route.query.tab === 'comments') {
            const commentsSection = document.getElementById('comments-section');
            if(commentsSection) {
                commentsSection.scrollIntoView({ behavior: 'smooth', block: 'start' });
                
                setTimeout(async () => {
                    await router.replace({ 
                        query: {} 
                    });
                }, 1500);
            }
        }
    };
    const comments = ref([])
    
    const loadComments = async () => {
        try {
            const idNews = route.params.id
            const { data } = await api.get(`/newsComments/${idNews}`)

            if(!data) {
                throw new Error(data.error || 'Комментариев нет')
            }

            comments.value = data
        } catch (error) {
            console.log(error)
        }
    }
    
    watch(() => route.query.tab, scrollToCommentsIfNeeded, { immediate: true });


    onMounted(async () => {
        await loadNews();
        await loadComments();
        await scrollToCommentsIfNeeded();
    });



</script>

<template>



    <div v-if="error" class="error-container">
        <h2>Новость не найдена</h2>
        <p>{{ error }}</p>
    </div>

    <div v-else-if="news && Object.keys(news).length > 0" class="container flex">
        <div class="news-container flex-column">

            <ThemeLabel 
                :label="news.title"
                :btm-info="{date: formatDate(news.created_at), theme: news.category}"
            />

            <AuthorBlock 
                :author="{name: news.nickname, avatar: news.avatar_url}"
                :views="news.views_count"
                :comments="news.comments_count"
            />

            <div v-html="news.content" class="content-block flex-column">
            </div>
            <button v-if="isAuthenticated" @click="likeNews()" type="button" aria-label="Оценить новость" class="no-border counter-slider flex-center"><svg><use href="#icon-like"></use></svg>{{ news.likes_count }}</button>

            

            <div class="comment-wrapper flex-column" id="comments-section">
                <span class="label-comment">Комментарии (5)</span>   

                <div class="comments-block flex-column">
                    <Comment 
                    v-for="comment in comments"
                    :key="comment.idComment"
                    :id="comment.idComment"
                    :content="comment.content"
                    :author_avatar="comment.avatar_url"
                    :author_name="comment.nickname"
                    :created_at="comment.created_at"
                    class="comment"/>
                    <CommentForm />
                </div>
            </div>

        </div>

        <div class="advertisment-container flex-column">
            <span class="place-btn">Разместить рекламу</span>
        </div>
    </div>

</template>

<style scoped>

    .container {
        width: 100%;
        font-family: Roboto_Medium;
        background-color: var(--bg-secondary-25);
        border-radius: 8px;
        padding: 32px;
        gap: var(--gp-20);
    }

    .news-container {
        width: 100%;
        gap: var(--gp-24);
    }

    .label-block {
        gap: var(--gp-16);
    }

    .label-news {
        font-size: 36px;
        line-height: 48px;
        font-family: Roboto_Bold;
    }

    .bottom-info {
        font-size: 24px;
        color: var(--font-primary-50);
        gap: var(--gp-10);
    }

    /* Контент новости */

    .content-block {
        gap: var(--gp-32);
    }

    ::v-deep(.img-block) {
        gap: var(--gp-8);
    }

    ::v-deep(.img-block img) {
        border-radius: 8px;
        width: 100%;
        max-height: 542px;
    }

    ::v-deep(.img-name) {
        font-size: 14px;
        font-style: italic;
    }

    ::v-deep(.text-content) {
        font-size: 20px;
        line-height: 32px;
        color: var(--font-primary-75);
    }

    ::v-deep(.text-content a) {
        color: var(--font-secondary);
        text-decoration: underline;
    }

    .counter-slider {
        width: fit-content;
        gap: var(--gp-8);
        font-size: 14px;
        font-family: Roboto_SemiBold;
        padding: 8px 16px;
        background-color: var(--btn-color-6-25);
        border-radius: 4px;
        color: var(--font-primary-25);
        transition: 0.3s;
    }

    .counter-slider:hover {
        filter: brightness(1.5);
    }

    .counter-slider svg {
        width: 24px;
        height: 24px;
    }

    /* Блок комментариев */

    .comment-wrapper {
        width: 100%;
        gap: var(--gp-16);
        margin-top: 24px;
    }

    .label-comment {
        font-size: 32px;
        font-family: Roboto_SemiBold;
    }

    .comments-block {
        gap: var(--gp-24);
    }

    /* Рекламный блок */

    .advertisment-container {
        min-width: 284px;
    }

    .place-btn {
        font-size: 20px;
        background-color: var(--btn-color-6-25);
        padding-block: 16px;
        text-align: center;
        border-radius: 8px;
    }

    @media (max-width:1160px) {
        .container {
            border-radius: 0px;
            padding: 32px 24px;
        }
        .place-btn {
            font-size: 16px;
        }
    }

    @media (max-width:900px) {
        .advertisment-container {
            display: none;
        }
    }

    @media (max-width:599px) {
        .container {
            padding: 24px 16px;
        }

        .label-news {
            font-size: 28px;
            line-height: 38px;
        }

        .bottom-info {
            font-size: 20px;
            gap: var(--gp-8);
        }

        .img-name {
            font-size: 12px;
        }

        .img-block img {
            border-radius: 4px;
        }

        .text-content {
            font-size: 16px;
            line-height: 24px;
        }
        
        .counter-slider {
            font-size: 14px;
        }

        .label-comment {
            font-size: 24px;
        }

        .comments-block {
            gap: var(--gp-20);
        }
    }

    @media (max-width:375px) {
        .label-news {
            font-size: 24px;
            line-height: 32px;
        }

        .bottom-info {
            font-size: 18px;
        }
        
        .content-block {
            gap: var(--gp-24);
        }
    }
</style>