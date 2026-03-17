<script setup>
    import { ref, computed, watch, nextTick } from 'vue'
    import { useRoute, useRouter } from 'vue-router'
    import { useApiNotifications } from '../composables/useApi'
    import { api } from '../utils/axios'

    import ThemeCard from '../components/ThemeCard.vue'
    import { useAuthStore } from '../stores/authStore'
    import { storeToRefs } from 'pinia'

    const authStore = useAuthStore()
    const { apiCall } = useApiNotifications()
    const { isAuthenticated } = storeToRefs(authStore)
    const route = useRoute()
    const router = useRouter()

    const perPage = 20
    const discussionList = ref({})
    const totalPages = ref(1)

    const routeParams = computed(() => {
        const segments = route.path.split('/').slice(2) 
        
        let page = 1, sort = 'open', category = 6 
        
        const sortSeg = segments[0] && !/^(p\d+|\d+)$/.test(segments[0]) ? segments[0] : null
        if (sortSeg === 'closed') sort = 'closed'
        
        const pageMatch = segments.find(s => /^p\d+$/.test(s))
        if (pageMatch) page = parseInt(pageMatch.slice(1))
        
        const lastSeg = segments[segments.length - 1]
        if (/^\d+$/.test(lastSeg) && lastSeg !== pageMatch?.slice(1)) {
            category = parseInt(lastSeg)
        }
        
        return { page, sort, category }
    })

    const currentSectionId = computed(() => routeParams.value.category)
    const currentPage = computed(() => routeParams.value.page)
    const currentSort = computed(() => routeParams.value.sort)

    
    const navigate = (params) => {
        const { category = currentSectionId.value, sort = currentSort.value, page = 1 } = params
        const segments = []
        
        if (sort === 'closed') segments.push('closed')
        segments.push(`p${page}`)
        
        if (category !== 6) segments.push(category)
        
        router.push(`/community/${segments.join('/')}`)
    }

    const changeCategory = (sectionId) => {
        navigate({ category: sectionId, page: 1 })
    }
    const changeSort = (sort) => navigate({ sort, page: 1 })


    const queryParams = computed(() => {
        const params = new URLSearchParams({ 
            page: currentPage.value,
            limit: perPage 
        })
        
        if (currentSort.value === 'closed') {
            params.set('sort', 'closed')
        }
        
        params.set('section_id', currentSectionId.value)
        
        return params
    })

    const fetchDiscussions = async () => {
        try {
            const { data } = await api.get(`/community?${queryParams.value}`)
            discussionList.value = data.result.discussions || []
            totalPages.value = data.result.totalPages
        } catch (error) {
            console.error('Questions fetch error:', error.response?.data?.error)
            discussionList.value = []
        } 
    }

    watch(routeParams, () => nextTick(fetchDiscussions), { immediate: true })

    
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
        
        const segments = []
        
        if(currentSort.value === 'closed') {
            segments.push('closed')
        }
        
        segments.push(`p${safePage}`)
        
        if(currentSectionId.value !== 6) { 
            segments.push(currentSectionId.value)
        }
        
        return `/community/${segments.join('/')}`
    }

    // попАп создания

    import { useNotifications } from '../stores/notifications'
    const notifications = useNotifications()


    const isCreating = ref(false)
    const toggleIsCreating = () => {
        isCreating.value = !isCreating.value
    }

    const form = ref({
        title: '',
        description: '',
        section_id: null
    })

    const handleCreateTheme = async () => {
        if (form.value.title?.trim().length === 0 || 
            form.value.description?.trim().length === 0 || 
            form.value.section_id === null ) 
        {
            notifications.error('Заполни все поля')
            return 
        }

        const response = await apiCall(
            () => api.post('/community/createTheme', {
                title: form.value.title.trim(),
                description: form.value.description.trim(),
                section_id: form.value.section_id
            }), 'Успех'
        )
        
        const data = response?.data || response
        
        if (data && !data.error) {
            form.value = { title: '', description: '', section_id: null }
            toggleIsCreating()
            await fetchDiscussions()
        }
    }




</script>


<template>


    <Transition name="popup-slide">
        <div v-if="isCreating && isAuthenticated" class="create-popUp flex-center">
            <div class="create-popup__inner flex-column">
                <div class="confirm-popup__title">
                    Создание темы
                </div>
                <div class="confirm-popup__form flex-column align-c">
                    <input v-model="form.title" class="confirm-popup__input no-border" placeholder="Заголовок">
                    <select v-model="form.section_id" class="confirm-popup__input no-border">
                        <option value="" disabled hidden selected class="empty-option">
                            Категория темы
                        </option>
                        <option value=6>Ищу игру</option>
                        <option value=7>Проблемы</option>
                        <option value=8>Другое</option>
                        <option value=9>Лор и Сюжет</option>
                        <option value=10>Прохождение</option>
                        <option value=11>Системные требования</option>
                        <option value=12>Моды</option>

                    </select>
                    <textarea v-model="form.description" class="confirm-popup__input textarea no-border" placeholder="Описание"></textarea>
                </div>
                
                <div class="confirm-popup__btns flex align-c">
                    <button type="button" class="confirm-popup__btn danger no-border" @click="toggleIsCreating">
                        Отмена
                    </button>
                    <button type="button" @click="handleCreateTheme" class="confirm-popup__btn no-border">
                        Создать
                    </button>
                </div>
            </div>
        </div>
    </Transition>

    <div class="container flex-column">
        <div class="theme-bar flex-column">
            <h1>Сообщество</h1>
            <div class="theme-categories flex">
                <button type="button" @click="changeCategory(6)" :class="{active: currentSectionId === 6}" class="category no-border">Ищу игру</button>
                <button type="button" @click="changeCategory(7)" :class="{active: currentSectionId === 7}" class="category no-border">Проблемы</button>
                <button type="button" @click="changeCategory(8)" :class="{active: currentSectionId === 8}" class="category no-border">Другое</button>
                <button type="button" @click="changeCategory(9)" :class="{active: currentSectionId === 9}" class="category no-border">Лор и сюжет</button>
                <button type="button" @click="changeCategory(10)" :class="{active: currentSectionId === 10}" class="category no-border">Прохождение</button>
                <button type="button" @click="changeCategory(11)" :class="{active: currentSectionId === 11}" class="category no-border">Системные требования</button>
                <button type="button" @click="changeCategory(12)" :class="{active: currentSectionId === 12}" class="category no-border">Моды</button>
                <button v-if="isAuthenticated" type="button" @click="changeCategory(13)" :class="{active: currentSectionId === 13}" class="category no-border">Мои вопросы (3)</button>
                <button v-if="isAuthenticated" type="button" @click="toggleIsCreating" class="category no-border create-theme">Создать тему</button>
            </div>
        </div>
        <div class="sort-row flex">
            <button type="button" @click="changeSort('open')" :class="{active: currentSort === 'open'}" class="sort-type no-border">Открытые</button>
            <button type="button" @click="changeSort('closed')" :class="{active: currentSort === 'closed'}" class="sort-type no-border">Закрытые</button>
        </div>
        <div class="theme-wrapper">
            <ThemeCard 
            v-for="discussion in discussionList"
                :key="discussion.idQuestion"
                :title="discussion.title"
                :description="discussion.description"
                :nickname="discussion.user.nickname"
                :avatar="discussion.user.avatar_url"
                :comments="discussion.comments_count"
                :created_at="discussion.created_at"/>
        </div>

        <div v-if="discussionList.length" class="container-pages flex-center">
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
        background-color: var(--bg-secondary-25);
        border-radius: 8px;
        padding: 32px;
    }
    
    .theme-bar {
        gap: var(--gp-24);
        margin-bottom: 32px;
    }

    h1 {
        font-size: 32px;
        font-family: Roboto_SemiBold;
    }

    .theme-categories {
        width: 100%;
        flex-wrap: wrap;
        gap: var(--gp-16);
    }

    .category {
        font-size: 20px;
        font-family: Roboto_Medium;
        color: var(--font-primary-35);
        background-color: var(--btn-color-6-25);
        border-radius: 4px;
        padding: 6px 12px;
    }

    .category.active {
        color: var(--font-primary);
        background-color: var(--font-primary-35);
    }

    .create-theme {
        padding-inline: 24px;
        background-color: var(--btn-color-1);
        color: var(--font-primary);
    }

    .sort-row {
        gap: var(--gp-32);
        border-bottom: 2px solid var(--bg-secondary-50);
        padding-bottom: 8px;
    }

    .sort-type {
        position: relative;
        font-size: 24px;
        font-family: Roboto_SemiBold;
        color: var(--font-primary-50);
   }

   .sort-type.active {
        color: var(--font-primary);
   }

   .sort-type.active::after {
        content: '';
        position: absolute;
        top: 100%;
        left: 0;
        right: 0;
        border-bottom: 2px solid var(--font-secondary);
        padding-bottom: 8px;
   }

   .theme-wrapper {
        display: grid;
        grid-template-columns: repeat(3, 1fr);
        gap: var(--gp-24);
        margin-top: 24px;
   }

   /* Нав бар */

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

   /*  */
    /* ПОПАП */

    .create-popUp {
        position: fixed;
        top: 0;
        bottom: 0;
        left: 0;
        right: 0;
        width: 100%;
        height: 100%;
        background-color: #00000075;
        z-index: 1000;
    }

    .create-popup__inner {
        max-width: 350px;
        width: 100%;
        padding: 32px 24px;
        background-color: #181B1D;
        border-radius: 8px;
        gap: var(--gp-24);
        border: 1px solid var(--bg-secondary-50);
    }

    .confirm-popup__title {
        font-size: 18px;
        font-family: Roboto_SemiBold;
        color: var(--font-primary-75);
    }

    .confirm-popup__btns {
        gap: var(--gp-10);
        margin-left: auto;
    }

    .confirm-popup__btn {
        background-color: var(--btn-color-1);
        border-radius: 4px;
        padding: 6px 12px;
        font-family: Roboto_Medium;
        font-size: 14px;
    }

    .confirm-popup__btn.danger {
        background-color: var(--btn-color-6-25);
    }

    .confirm-popup__form {
        width: 100%;
        gap: var(--gp-16);
    }

    .confirm-popup__input {
        width: 100%;
        background-color: #1B1C21;
        padding: 8px 16px;
        border-radius: 8px;
        border-left: 3px solid var(--btn-color-2);
        color: var(--font-primary-75);
        font-family: Roboto_Medium;
        font-size: 14px;
    }

    .confirm-popup__input::placeholder {
        color: var(--font-primary-25);
    }

    .confirm-popup__input.textarea {
        min-height: 80px;
        resize: vertical;
    }

    select {
        width: 100%;
        overflow: hidden;
        text-overflow: ellipsis;
        white-space: nowrap;
        cursor: pointer;
        appearance: none;
        background: url('../assets/icons/arrow.svg') no-repeat right 16px center;
        background-size: 12px;
        padding-right: 36px !important; 
    }

    .popup-slide-enter-active,
    .popup-slide-leave-active {
        transition: all 0.3s ease
    }

    .popup-slide-enter-from,
    .popup-slide-leave-to {
        opacity: 0;
        transform: translateY(80px);
    }

    .popup-slide-enter-to,
    .popup-slide-leave-from {
        opacity: 1;
        transform: translateY(0);
    }


   /*  */

   @media (max-width:1160px) {
        .theme-wrapper {
            grid-template-columns: repeat(2, 1fr);
        }
        .container {
            border-radius: 0px;
        }
   }

    @media (max-width:600px) {
        .theme-wrapper {
            grid-template-columns: repeat(1, 1fr);
        }
        
        h1 {
            font-size: 24px;
        }

        .category {
            font-size: 18px;
        }

        .theme-categories {
            row-gap: var(--gp-16);
            column-gap: var(--gp-12);
        }

        .sort-row {
            gap: var(--gp-24);
        }
        .container {
            padding: 24px 16px;
        }
    }

    @media (max-width:425px) {
        .category {
            font-size: 16px;
        }
    }

     @media (max-width:375px) {
        .sort-row {
            gap: var(--gp-16);
        }
        .sort-type {
            font-size: 18px;
        }
    }
</style>