<script setup>
    import AuthorBlock from '../components/AuthorBlock.vue'
    import RatingBar from '../components/RatingBar.vue'
    import Comment from '../components/Comment.vue'
    import CommentForm from '../components/CommentForm.vue'
    import BanModal from '../components/BanModal.vue';
    import ModerationPopUp from '../components/ModerationPopUp.vue';

    import { onImageError } from '../helpers/onImageError';

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

    const isLoading = ref(true)

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
        isLoading.value = false
    });


</script>

<template>
    <Transition name="fade">
        <div v-if="!isLoading" class="container flex-column">
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
                :label="'рецензию'"
                @confirm="handleModerateDelete"
            />

            <div class="container-wrapper flex">
                <div class="left-side flex-column">
                    <div class="img-block">
                        <picture>
                            <img :src="review.cover_url || '/images/plug_img.png'" @error="onImageError" class="img-game">
                        </picture>
                    </div>
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

            <div v-if="user?.role === 3 || user?.role === 4 && review.user_id != user.id" class="moderation-block flex align-c">
                <button @click="isBanModal = true" class="no-border handle-btn flex-center">
                    Заблокировать
                </button>
                <button @click="isModeration = true" class="no-border handle-btn handle-btn-danger flex-center">
                    Удалить
                </button>
            </div>

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
    </Transition>

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
        flex-wrap: wrap;
        gap: var(--gp-8);
    }

    .left-side {
        max-width: 280px;
        width: 100%;
        gap: var(--gp-8);
        flex-shrink: 0;
    }

    .img-block {
        width: 280px;
        height: 374px;
    }

    .img-game {
        width: 100%;
        height: 100%;
        border-radius: 8px;
    }

    .name-game {
        font-size: 28px;
        font-family: Roboto_SemiBold;
        color: var(--another-color);
        text-align: center;
    }
    .name-game:hover {color: var(--font-secondary);}

    .right-side {
        width: 100%;
        gap: var(--gp-16);
        font-family: Roboto_Regular;
    }

    .review-label {
        max-width: 80%;
        font-size: 30px;
        font-family: Roboto_SemiBold;
    }

    .rating {
        min-width: 40px;
        height: 40px;
        font-size: 16px;
        font-family: Roboto_Bold;
        background: #000;
        border: 3px solid var(--font-secondary);
        border-radius: 50%;
        box-shadow: 0 4px 16px 0 rgba(0, 111, 255, 0.5);
        text-align: center;
    }

    .datePublish {
        font-size: 20px;
        color: var(--font-primary-50);
        font-family: Roboto_Medium;
    }

    .content-block {
        gap: var(--gp-12);
        font-size: 16px;
        line-height: 26px;
        font-family: Roboto_Medium;
    }

    :deep(p) {
        font-size: 18px;
        line-height: 26px;
        font-family: Roboto_Medium;
        color: #dcdcdc
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

    .content-block p {
        white-space: pre-wrap;
    }

  /* Модерка */

    .moderation-block {
        width: fit-content;
        gap: var(--gp-16);
        margin-left: auto;
    }

    .handle-btn {
        width: fit-content;
        background-color: var(--font-secondary);
        border-radius: 4px;
        padding: 6px 12px;
        font-family: Roboto_Medium;
    }
    .handle-btn:hover {background-color: var(--font-secondary-75);}

    .handle-btn-danger {background-color: var(--bg-secondary-50);}
    .handle-btn-danger:hover {background-color: var(--bg-secondary);}


    @media (max-width:1160px) {
        .container {
            border-radius: 0px;
        }
    }

    @media (max-width:1024px) {
        .img-block {
            width: 240px;
            height: 320px;
        }

        .name-game {
            font-size: 24px;
        }

        .left-side {
            max-width: 240px;
        }
    }

    @media (max-width:900px) {
        .rating-wrapper {
            grid-template-columns: repeat(2, 1fr);
        }
    }

    @media (max-width:768px) {
        .container-wrapper {
            flex-direction: column;
            justify-content: center;
            align-items: center;
        }

        .review-label {
            font-size: 24px;
        }

        .rating {
            min-width: 36px;
            height: 36px;
            font-size: 14px;
        }

        .datePublish {
            font-size: 16px;
        }

        .left-side {
            max-width: 320px;
            width: 100%;
            justify-content: center;
            align-items: center;
        }
    }

    @media (max-width:599px) {
        .label-comment {
            font-size: 24px;
        }

        .content-block {
            font-size: 14px;
            line-height: 22px;
        }

        .rating-wrapper {
            gap: var(--gp-16);
        }

        .comments-block {
            gap: var(--gp-20);
        }
    }

</style>