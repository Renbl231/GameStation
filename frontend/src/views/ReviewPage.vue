<script setup>
    import AuthorBlock from '../components/AuthorBlock.vue'
    import RatingBar from '../components/RatingBar.vue'
    import Comment from '../components/Comment.vue'
    import CommentForm from '../components/CommentForm.vue'
    import BanModal from '../components/BanModal.vue';
    import ModerationPopUp from '../components/ModerationPopUp.vue';

    import { useModeration } from '../composables/useModeration';
    const { moderateReview } = useModeration()

    import { ref, computed, watch, onMounted } from 'vue'
    import api from '../utils/axios'

    import { useAuthStore } from '../stores/authStore'
    import { storeToRefs } from 'pinia'
    const authStore = useAuthStore()
    const { isAuthenticated, user } = storeToRefs(authStore)

    import { useGlobal404 } from '../composables/useGlobal404'
    const { set404 } = useGlobal404()

    import { useRoute, useRouter } from 'vue-router'
    const route = useRoute()
    const router = useRouter()

    import { useFormatDate } from '../composables/useFormatDate';
    const { formatDate } = useFormatDate()

    import { useInteractions } from '../composables/useInteractions'
    const { comments, loadComments, scrollToCommentsIfNeeded, handleComment } = useInteractions()

    const isLoadingValue = ref(true)

    // Загрузка рецензии

    const review = ref({})

    const loadReview = async() => {
        try {
            const now = Date.now()
            const hourAgo = now - (60 * 60 * 1000)
            const sessionKey = `review_view_${route.params.id}`
            const lastView = localStorage.getItem(sessionKey)

            const shouldIncrement = !lastView || parseInt(lastView) < hourAgo

            if (shouldIncrement) {
                localStorage.setItem(sessionKey, now.toString())
            }

            const { data } = await api.get(`/reviews/${route.params.id}${shouldIncrement ? '?incrementView=true' : ''}`)
            if(!data.result) {
                set404()
                return
            }
    
            review.value = data.result
        } catch(error) {
            review.value = {}
            set404()
        }
    }

    const ratingObject = computed(() => ([
        { label: 'Геймплей', value: Number(review.value?.gameplay ?? 0) },
        { label: 'Графика', value: Number(review.value?.graphics ?? 0) },
        { label: 'Сюжет', value: Number(review.value?.story ?? 0) },
        { label: 'Музыка', value: Number(review.value?.music ?? 0) },
        { label: 'Атмосфера', value: Number(review.value?.atmosphere ?? 0) },
        { label: 'Оптимизация', value: Number(review.value?.optimization ?? 0) },
        { label: 'Инновации', value: Number(review.value?.innovation ?? 0) }
    ]).filter(item => item.value > 0))


    const isBanModal = ref(false)

    const reloadComments = async (value) => {
        if(value) {
            await loadComments()
            review.value.comments_count--
        } 
    }
    
    const redirectToPage = async (value) => {
        if(value) {
            router.push('/games/reviews')
        }
    }

    const isModeration = ref(false)

    const handleModerateDelete = async (reason) => {
        const success = await moderateReview(review.value.idReview, reason)

        if (success) {
            redirectToPage(true)
        }
    }


    onMounted(async () => {
        await Promise.all([loadReview(), loadComments()])
        await scrollToCommentsIfNeeded() 
        isLoadingValue.value = false
    });


</script>

<template>
    <div v-if="!isLoadingValue" class="container flex-column">
        <BanModal
            :model-value="isBanModal"
            :nickname="review.nickname"
            :type="'review'"
            :user_id="review.user_id"
            :entity_id="review.idReview"
            :text="'рецензиям'"
            @update:model-value="isBanModal = false"
            @redirect-to-page="redirectToPage"
        />

        <ModerationPopUp
            v-model="isModeration"
            :label="'вопрос'"
            @confirm="handleModerateDelete"
        />

        <div class="container-wrapper flex">
            <div class="left-side flex-column">
                <picture>
                    <img :src="review.cover_url" class="img-game">
                </picture>
                <RouterLink class="name-game" :to="`/game/${review.idGame}`">
                    <span>{{ review.name }}</span>
                </RouterLink>
            </div>
            <div class="right-side flex-column">
                <div class="top-info flex justify-sb">
                    <span class="review-label">{{ review.title }}</span>
                    <span class="rating flex-center">{{ Number(review.overall_score) }}</span>
                </div>
                <span class="datePublish">{{ formatDate(review.created_at) }}</span>
                <AuthorBlock
                    :author="{name: review.nickname, avatar: review.avatar_url}"
                    :views="review.views_count"
                    :comments="review.comments_count" />
                <div class="content-block flex-column">
                    <p>{{ review.content }}</p>
                </div>
    
                <div v-if="ratingObject.length" class="rating-container flex-column">
                    <hr>
                    <div class="rating-wrapper">
                        <RatingBar
                            v-for="(param, index) in ratingObject"
                            :key="index"
                            :name="param.label"
                            :score="param.value"
                        />
                    </div>
    
                </div>
            </div>
        </div>

        <button v-if="user?.role === 3 || user?.role === 4" @click="isBanModal = true" class="no-border handle-btn flex-center">
            Заблокировать
        </button>
        <button v-if="user?.role === 3 || user?.role === 4" @click="isModeration = true" class="no-border handle-btn flex-center">
            Удалить
        </button>

        <div class="comment-wrapper flex-column" id="comments-section">
            <span class="label-comment">Комментарии ({{ review.comments_count }})</span>   

            <div class="comments-block flex-column">
                <Comment
                v-for="comment in comments" 
                    :comment="comment" 
                    @reply-added="handleComment('added', review)"
                    @reply-deleted="handleComment('deleted', review)"
                    @reply-edited="handleComment()"
                    @reload-comments="reloadComments"
                />
                <CommentForm v-if="isAuthenticated" @comment-added="handleComment('added', review)"/>
            </div>
        </div>

    </div>

</template>


<style scoped>
    .container {
        width: 100%;
        padding: 32px;
        border-radius: 8px;
        background-color: var(--bg-secondary-25);
        gap: var(--gp-32);
    }

    .container-wrapper {
        width: 100%;
        gap: var(--gp-32);
    }

    .top-info {
        align-items: flex-start;
        gap: var(--gp-4);
    }

    .left-side {
        max-width: 300px;
        width: 100%;
        gap: var(--gp-8);
    }

    .img-game {
        width: 300px;
        height: 400px;
        border-radius: 8px;
    }

    .name-game {
        font-size: 32px;
        font-family: Roboto_SemiBold;
        color: var(--another-color);
        text-align: center;
    }

    .right-side {
        width: 100%;
        gap: var(--gp-16);
        font-family: Roboto_Regular;
    }

    .review-label {
        font-size: 36px;
        font-family: Roboto_SemiBold;
    }

    .rating {
        min-width: 48px;
        height: 48px;
        font-size: 20px;
        font-family: Roboto_Bold;
        background: #000;
        border: 4px solid var(--font-secondary);
        border-radius: 50%;
        box-shadow: 0 4px 16px 0 rgba(0, 111, 255, 0.5);
        text-align: center;
    }

    .datePublish {
        font-size: 24px;
        color: var(--font-primary-50);
        font-family: Roboto_Medium;
    }

    .content-block {
        gap: var(--gp-16);
        font-size: 18px;
        line-height: 28px;
    }

    .rating-container {
        gap: var(--gp-16);
    }

    .rating-wrapper {
        display: grid;
        grid-template-columns: repeat(3, 1fr);
        column-gap: var(--gp-16);
        row-gap: var(--gp-24);
    }

    /* Комментарии */

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


    @media (max-width:1160px) {
        .container {
            border-radius: 0px;
        }
    }

    @media (max-width:900px) {
        .review-label {
            font-size: 32px;
        }
        .content-block {
            font-size: 16px;
            line-height: 22px;
        }
    }

    @media (max-width:599px) {
        .label-comment {
            font-size: 24px;
        }

        .comments-block {
            gap: var(--gp-20);
        }
    }

</style>