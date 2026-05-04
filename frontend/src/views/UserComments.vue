<script setup>
    import { ref, onMounted, watch, computed } from 'vue'
    import api from '../utils/axios'

    // прокидываем id из родителя
    import { inject } from 'vue'
    const userId = inject('userId')

    import { useRoute, useRouter } from 'vue-router'
    const route = useRoute()
    const router = useRouter()

    const totalPages = ref(1)

    const perPage = 20

    const comments = ref([])

    const commentStatus = ref('active')

    const loadComments = async () => {
    const { data } = await api.get(`/user/${userId.value}/comments?page=${currentPage.value}&limit=${perPage}&status=${commentStatus.value}`)
        if (data.result) {
            comments.value = data.result.comments || []
            totalPages.value = data.result.totalPages ?? 1
        }
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

     onMounted(() => {
        if (userId.value) loadComments()
    })

    watch(
        () => route.path,
        async () => {
            if (userId.value) await loadComments()
        }
    )

</script>

<template>

    <div class="container flex-column">
        <div class="comment" v-for="comment in comments" :key="comment.idComment">
            <span>{{ comment.content }}</span>
        </div>
    </div>

</template>

<style scoped>
    .container {
        width: 100%;
    }
</style>