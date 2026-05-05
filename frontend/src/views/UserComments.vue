<script setup>
    import Comment from '../components/Comment.vue'
    import { ref, onMounted, watch, computed } from 'vue'
    import api from '../utils/axios'

    import { useInteractions } from '../composables/useInteractions'
    const { handleComment } = useInteractions()

    // прокидываем id из родителя
    import { inject } from 'vue'
    const userId = inject('userId')

    import { useRoute } from 'vue-router'
    const route = useRoute()

    const perPage = 20
    const commentStatus = ref('active')

    const comments = ref([])
    const totalPages = ref(1)

    const loadUserComments = async () => {
        try {
            const { data } = await api.get(
                `/user/${userId.value}/comments?page=${currentPage.value}&limit=${perPage}&status=${commentStatus.value}`
            )
            comments.value = data.result?.comments || []
            totalPages.value = data.result?.totalPages ?? 1
        } catch(error) {
            comments.value = []
            totalPages.value = 1
        }
    }

    const handleWithReload = (type, entity) => {
        handleComment(type, entity)
        loadUserComments()
    }

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
        return `/user/${route.params.nickname}/comments/p${safePage}`
    }


    onMounted(async () => {
        if(userId) {
            await loadUserComments()
        }
    })

    watch(() => route.path, async () => {
        if(userId) {
            await loadUserComments()
        }
    })

</script>

<template>

    <div class="container flex-column">
        <Comment
            v-for="comment in comments" 
            :comment="comment" 
            @reply-added="handleWithReload('added', news)"
            @reply-deleted="handleWithReload('deleted', news)"
            @reply-edited="handleWithReload()"
            :mode="'profile'"
        />

        <div v-if="comments.length" class="container-pages flex-center">
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
    .container {
        width: 100%;
        gap: var(--gp-16);
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
    
</style>