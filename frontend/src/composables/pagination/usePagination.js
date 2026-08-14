import { ref, computed, watch, nextTick } from 'vue'
import { useRoute, useRouter } from 'vue-router'
import { getCategoryId } from '@constants/categories'

export const usePagination = (options) => {
    const {
        baseUrl,
        perPage = 20,
        fetchData,
        parseRoute = null,
        categories = null,
    } = options

    const router = useRouter()
    const route = useRoute()

    const items = ref([])
    const totalPages = ref(1)
    const isLoading = ref(true)

    // Парсим URL
    const routeParams = computed(() => {
        if (parseRoute) {
            return parseRoute(route.path)
        }

        const segments = route.path.split('/').slice(2)
        let page = 1, category = 'all', sort = 'new'

        const pageMatch = segments[0]?.match(/^p(\d+)$/)
        if (pageMatch) {
            page = parseInt(pageMatch[1])
            const rest = segments.slice(1)
            if (rest.length > 0) {
                if (!['new', 'popular'].includes(rest[0])) {
                    category = rest[0]
                    sort = rest[1] || 'new'
                } else {
                    sort = rest[0] || 'new'
                }
            }
        } else {
            category = segments[0] || 'all'
            sort = segments[1] || 'new'
        }

        return { page, category, sort }
    })

    const currentPage = computed(() => routeParams.value.page)
    const currentCategory = computed(() => routeParams.value.category)
    const currentSort = computed(() => routeParams.value.sort)

    // Навигация
    const navigate = (params) => {
        const {
            category = currentCategory.value,
            page = currentPage.value,
            sort = currentSort.value
        } = params

        const segments = []

        if (category !== 'all' || page !== 1 || sort !== 'new') {
            segments.push(`p${page}`)
        }

        if (category !== 'all') {
            segments.push(category)
        }

        if (sort && sort !== 'new') {
            segments.push(sort)
        }

        router.push(`/${baseUrl}/${segments.join('/')}`)
    }

    // Параметры для API
    const queryParams = computed(() => {
        const params = new URLSearchParams({
            page: currentPage.value,
            limit: perPage
        })

        const categoryId = getCategoryId(currentCategory.value, categories)
        
        if (categoryId !== null) {
            params.set('category_id', categoryId)
        }

        if(currentSort.value !== 'new') {
            params.set('sort', currentSort.value)
        }

        return params
    })

    const loadData = async () => {
        isLoading.value = true
        try {
            const result = await fetchData(queryParams.value)
            items.value = result.items || []
            totalPages.value = result.totalPages || 1
        } catch (error) {
            console.error('Ошибка загрузки:', error)
            items.value = []
        } finally {
            isLoading.value = false
        }
    }

    watch(routeParams, () => nextTick(loadData), { immediate: true })

    return {
        items,
        totalPages,
        isLoading,
        currentPage,
        currentCategory,
        currentSort,
        navigate,
        loadData,
        queryParams
    }
}