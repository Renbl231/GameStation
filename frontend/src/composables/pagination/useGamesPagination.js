import { ref, computed, watch, nextTick } from 'vue'
import { useRouter, useRoute } from 'vue-router'
import { storeToRefs } from 'pinia'
import { useAuthStore } from '@stores/authStore'
import { preloadImages } from '@utils/helpers/preloadImages'
import { buildGamesUrl } from '@composables/pagination/buildUrls'
import api from '@utils/axios'

export const useGamesPagination = (options = {}) => {
    const {
        perPage = 40,
        preload = true,
    } = options

    const router = useRouter()
    const route = useRoute()
    const authStore = useAuthStore()
    const { user } = storeToRefs(authStore)

    const games = ref([])
    const totalPages = ref(1)
    const isLoading = ref(true)

    const filters = ref({
        themes: [],
        modes: [],
        perspectives: [],
        platforms: [],
        brands: [],
        genres: [],
        rating: { min: 0, max: 10 },
        year: ''
    })

    const routeParams = computed(() => {
        const segments = route.path.split('/').slice(2)
        let page = 1
        let sort = 'recently'

        const pageMatch = segments.find(s => /^p\d+$/.test(s))
        if (pageMatch) page = parseInt(pageMatch.slice(1))

        const sortSeg = segments.find(s => !/^p\d+$/.test(s) && s !== '')
        if (sortSeg) sort = sortSeg

        return { page, sort }
    })

    const currentPage = computed(() => routeParams.value.page)
    const currentSort = computed(() => routeParams.value.sort || 'recently')

    const navigate = (params) => {
        const { sort = currentSort.value, page = currentPage.value } = params
        const segments = []

        if (sort && sort !== 'recently') segments.push(sort)
        segments.push(`p${page}`)

        router.push(`/games/${segments.join('/')}`)
    }

    const queryParams = computed(() => {
        const params = new URLSearchParams({
            page: currentPage.value,
            limit: perPage
        })

        if (filters.value.platforms?.length) params.set('platforms', filters.value.platforms.join(','))
        if (filters.value.brands?.length) params.set('brands', filters.value.brands.join(','))
        if (filters.value.genres?.length) params.set('genres', filters.value.genres.join(','))
        if (filters.value.themes?.length) params.set('themes', filters.value.themes.join(','))
        if (filters.value.modes?.length) params.set('modes', filters.value.modes.join(','))
        if (filters.value.perspectives?.length) params.set('perspectives', filters.value.perspectives.join(','))

        if (filters.value.rating?.min && filters.value.rating.min !== 0) params.set('ratingMin', filters.value.rating.min)
        if (filters.value.rating?.max && filters.value.rating.max !== 10) params.set('ratingMax', filters.value.rating.max)
        if (filters.value.year) params.set('release_date', filters.value.year)

        if (currentSort.value !== 'recently') {
            params.set('sort', currentSort.value)
        }

        if (user.value?.id) {
            params.set('user_id', user.value.id)
        }

        return params
    })

    const loadGames = async () => {
        isLoading.value = true
        try {
            const { data } = await api.get(`/games/getCatalog?${queryParams.value}`)
            
            if (data.success) {
                games.value = data.result?.games || []
                totalPages.value = data.result?.totalPages ?? 1

                if (preload) {
                    const imageUrls = games.value.map(item => item.cover).filter(Boolean)
                    if (imageUrls.length) {
                        await preloadImages(imageUrls)
                    }
                }
            }
        } catch (error) {
            games.value = []
        } finally {
            isLoading.value = false
        }
    }

    const applyFilters = async (newFilters) => {
        filters.value = newFilters
        if (currentPage.value !== 1) {
            navigate({ page: 1 })
        } else {
            await loadGames()
        }
    }

    const buildPageUrl = (page) => {
        return buildGamesUrl(page, totalPages.value, currentSort.value)
    }

    watch(routeParams, () => nextTick(loadGames), { immediate: true })

    return {
        games,
        totalPages,
        isLoading,
        currentPage,
        currentSort,
        navigate,
        loadGames,
        applyFilters,
        buildPageUrl,
        queryParams
    }
}