<script setup>
    import { ref, onMounted, computed, watch } from 'vue'
    import api from '../utils/axios'

    import { storeToRefs } from 'pinia'
    import { useAuthStore } from '../stores/authStore'
    const authStore = useAuthStore()
    const { user } = storeToRefs(authStore)
    
    import { useRoute, useRouter } from 'vue-router'
    const route = useRoute()
    const router = useRouter()

    import { inject } from 'vue'
    const userId = inject('userId')

    const isLoading = ref(true)

    const totalPages = ref(1)

    const perPage = 20

    const reviews = ref([])
    const reviewStatus = ref('active')

    const counterActive = ref(0)
    const counterHidden = ref(0)

    const loadReviews = async () => {
    isLoading.value = true
    const { data } = await api.get(`/user/${userId.value}/reviews?page=${currentPage.value}&limit=${perPage}&status=${reviewStatus.value}`)
        if (data.result) {
            reviews.value = data.result.reviews || []
            totalPages.value = data.result.totalPages ?? 1
            counterActive.value = data.result.stats.active || 0
            counterHidden.value = data.result.stats.hidden || 0
        }
    isLoading.value = false
    }

    watch(reviewStatus, async() => {
        if (currentPage.value !== 1) {
            router.push(`/user/${route.params.nickname}/comments/p1`)
        } else {
            await loadReviews()
        }
    })

    const currentPage = computed(() => {
        const match = route.path.match(/\/p(\d+)/)
        return match ? Number(match[1]) : 1
    })

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
        return `/user/${route.params.nickname}/reviews/p${safePage}`
    }

    onMounted(() => {
        if (userId.value) loadReviews()
    })

watch(
  () => route.path,
  async () => {
    if (userId.value) await loadReviews()
  }
)

</script>

<template>
    <Transition name="fade">
        <div v-if="!isLoading" class="container flex-column">
            <div v-if="userId === user.id" class="switcher-block flex align-c">
                <button type="button" class="switcher__btn no-border" :class="{'active': reviewStatus === 'active'}" @click="reviewStatus = 'active'">Опубликованные ({{ counterActive }})</button>
                <button type="button" class="switcher__btn no-border" :class="{'active': reviewStatus === 'hidden'}" @click="reviewStatus = 'hidden'">Удалённые ({{ counterHidden }})</button>
            </div>

            <div class="review-wrapper flex-column">
                <div v-for="review in reviews" :key="review.idReview" class="review flex-column">
                    <div class="review-content flex">
                        <div class="cover-block">
                            <RouterLink :to="`/game/${review.idGame}`">
                                <picture>
                                    <img :src="review.cover_url" class="review__cover">
                                </picture>
                            </RouterLink>
                        </div>
                        <div class="review-rightSide flex-column">
                            <span class="review__reason" v-if="reviewStatus === 'hidden'">Причина: {{ review.reason }}</span>
                            <div class="review-label flex align-c justify-sb">
                                <RouterLink :to="`/review/${review.idReview}`" class="review__title">{{ review.title }}</RouterLink>
                                <span class="review__score">{{ Number(review.overall_score) }}</span>
                            </div>
                            <p class="review__description">{{ review.content }}</p>
                        </div>
                    </div>
                    <hr>
                </div>
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
    </Transition>

</template>

<style scoped>

    .switcher-block {
        gap: var(--gp-8);
    }

    .switcher__btn {
        font-family: Roboto_Medium;
        background-color: var(--btn-color-6-25);
        border-radius: 4px;
        padding: 4px 8px;
    }
    .switcher__btn:hover {
        background-color: var(--font-primary-75);
        color: #000;
    }
    .switcher__btn.active {
        background-color: #e7e7e7;
        color: #000;
    }


    .container {
        width: 100%;
        gap: var(--gp-16);
    }

    .review-wrapper {
        width: 100%;
        gap: var(--gp-32);
    }
    
    .review {
        width: 100%;
        gap: var(--gp-16);
    }

    .review-content {
        width: 100%;
        gap: var(--gp-16);
    }

    .cover-block {
        display: block !important;
        width: 160px;
        height: 160px;
        overflow: hidden;
        flex-shrink: 0
    }

    .review__cover {
        width: 100%;
        height: 100%;
        border-radius: 8px;
    }

    @media (max-width:768px) {
        .container {
            gap: var(--gp-32);
        }

        .review-content {
            flex-direction: column;
            justify-content: center;
            align-items: center;
        }

        .review__reason {
            align-items: center;
            text-align: center;
        }
    }

    .review-rightSide {
        width: 100%;
        max-height: 160px;
        gap: var(--gp-8);
        overflow: hidden;
    }

    .review-label {
        width: 100%;
        gap: var(--gp-12);
    }

    .review__reason {
        font-family: Roboto_Medium;
        color: var(--btn-color-2);
    }

    .review__title {
        font-family: Roboto_SemiBold;
        font-size: 18px;
    }
    .review__title:hover {
        color: var(--font-secondary);
    }

    .review__score {
        font-family: Roboto_Medium;
        background-color: var(--font-secondary);
        padding: 0px 4px;
        border-radius: 4px;
    }

    .review__description {
        font-family: Roboto_Regular;
        font-size: 16px;
        color: var(--font-primary-75);
    }


    

    /* Нижний нав бар */

    .container-pages {
        width: 100%;
        margin-top: auto;
        gap: var(--gp-12);
        font-size: 16px;
        font-family: Roboto_SemiBold;
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

</style>