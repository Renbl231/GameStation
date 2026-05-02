<script setup>
    import Comment from '../components/Comment.vue'
    import CommentForm from '../components/CommentForm.vue'
    import AuthorBlock from '../components/AuthorBlock.vue'
    import ThemeLabel from '../components/ThemeLabel.vue'
    import ConfirmPopUp from '../components/ConfirmPopUp.vue';
    import TextEditor from '../components/TextEditor.vue'

    import { ref, onMounted, onUnmounted, nextTick } from 'vue'
    import { useRoute, useRouter } from 'vue-router'
    import { useAuthStore } from '../stores/authStore'
    import { storeToRefs } from 'pinia'
    import api from '../utils/axios'
    import { useFormatDate } from '../composables/useFormatDate';
    import { useInteractions } from '../composables/useInteractions'

    import { useGlobal404 } from '../composables/useGlobal404'
    import { useNotifications } from '../stores/notifications';
    import { useApiNotifications } from '../composables/useApi';
    const { set404 } = useGlobal404()
    const { apiCall } = useApiNotifications()
    const notification = useNotifications()

    const { comments, loadComments, scrollToCommentsIfNeeded, likeEntity, handleComment } = useInteractions()
    
    const { formatDate } = useFormatDate()
    const authStore = useAuthStore()
    const { isAuthenticated } = storeToRefs(authStore)
    const route = useRoute()
    const router = useRouter()

    const news = ref({ likes_count: 0, views_count: 0, comments_count: 0 }) // сам контент новости
    const isLoading = ref(false);

    const loadNews = async () => {
        isLoading.value = true
        
        try {
            const idNews = route.params.id
            
            // 1 час = 1 просмотр
            const now = Date.now()
            const hourAgo = now - (60 * 60 * 1000)
            const sessionKey = `news_view_${idNews}`
            const lastView = localStorage.getItem(sessionKey)
            
            const shouldIncrement = !lastView || parseInt(lastView) < hourAgo
            
            if (shouldIncrement) {
                localStorage.setItem(sessionKey, now.toString())
            }
            
            const { data } = await api.get(`/newsdata/${idNews}${shouldIncrement ? '?incrementView=true' : ''}`)
            
            if (!data) {
                set404()
                return
            }
            
            news.value = data
        } catch (error) {
            news.value = {}
            set404()
        } finally {
            isLoading.value = false
        }
    }


    const handleLike = async() => {
        likeEntity(news)
    }

    // Дроп-меню

    const showMenu = ref(false)

    const toggleMenu = () => {
        showMenu.value = !showMenu.value
    }

    const closeMenu = (event) => {
        if (!event.target.closest('.action-menu')) {
            showMenu.value = false
        }
    }

    // ConfirmPopUp

    const isVisiblePopup = ref(false)
    
    const onConfirmDelete = async() => {
        isVisiblePopup.value = true
    }

    const handleDelete = async() => {   
        const data = await apiCall(() => api.delete(`/news/${route.params.id}/delete`), 'Новость удалена')
        if(data.status === 204) {
            await router.push('/news')
        }           
    }

    //  редактирование

    const isEditing = ref(false)

    const form = ref({
        title: '',
        category: '',
        short_content: '',
        image: '',
        content: ''
    })

    const startEdit = () => {
        form.value.title = news.value.title
        form.value.image = news.value.image
        form.value.content = news.value.content
        form.value.short_content = news.value.short_content
        form.value.category = news.value.category
        isEditing.value = true
        nextTick(() => {
            const editable = document.querySelector('[contenteditable="true"]')
        })
    }

    const closeEdit = async() => {
        await loadNews()
        isEditing.value = false
    }

    const validateForm = () => {
        if(!form.value.title.trim()) {
            notification.warning('Заголовок обязателен')
            return false
        }
        if(!form.value.category.trim()) {
            notification.warning('Категория обязательна')
            return false
        }
        if(!form.value.short_content.trim()) {
            notification.warning('Краткое описание обязательно')
            return false
        }
        if(!form.value.image.trim()) {
            notification.warning('Фото обязательно')
            return false
        }
        if(!form.value.content.trim() || 
            form.value.content === '<p class="text-content">Начните писать здесь...</p>') {
            notification.warning('Напишите содержимое новости')   
            return false
        }
        return true
    }

    const resetForm = () => {
        form.value = {
            title: '',
            category: '',
            short_content: '',
            image: '',
            content: '<p class="text-content">Начните писать здесь...</p>'
        }
    }

    const handleEdit = async () => {
        if(!validateForm()) return

        const data = await apiCall(() => api.put(`/news/${route.params.id}/edit`, form.value), 'Новость отредактирована')
        if(data.success) {
            Object.assign(news.value, form.value)       
            isEditing.value = false 
            resetForm()
        } 
    }

    const reloadComments = async (value) => {
        if(value) {
            await loadComments()
            news.value.comments_count--
        } 
    }

    onUnmounted(() => {
        document.removeEventListener('click', closeMenu)
    })


    onMounted(async () => {
        await Promise.all([loadNews(), loadComments()])
        await scrollToCommentsIfNeeded() 
        document.addEventListener('click', closeMenu)
    });


</script>

<template>

    <div v-if="isLoading"></div>

    <div v-if="news && Object.keys(news).length != 0 && !isLoading" class="container flex">
        <div class="news-container flex-column">
            <ThemeLabel 
                :label="news.title"
                :btm-info="{date: formatDate(news.created_at), theme: news.category}"
            />
            
            <div v-if="isEditing" class="edit-block flex-column">

                <input 
                    v-model="form.title" 
                    class="field no-border" 
                    placeholder="Заголовок"
                />

                <input 
                    v-model="form.image" 
                    type="text" 
                    class="field no-border" 
                    placeholder="URL-фотография"
                />

                <select 
                    v-model="form.category" 
                    class="category-select field no-border"
                >
                    <option value="" disabled hidden selected class="empty-option">
                        Изменить категорию
                    </option>
                    <option value="Анонсы">Анонсы</option>
                    <option value="Релизы">Релизы</option>
                    <option value="Индустрия">Индустрия</option>
                    <option value="Слухи">Слухи</option>
                    <option value="Патчи">Обновления</option>
                    <option value="Консоли">Консоли</option>
                    <option value="PC">PC</option>
                    <option value="VR">VR</option>
                </select>

                <input 
                    v-model="form.short_content" 
                    type="text" 
                    class="field no-border" 
                    placeholder="Новость в кратце"
                />

                <TextEditor v-model="form.content"/>

                <div class="edit-block-interaction flex aling-c">        
                    <button type="button" class="no-border edit-block-interaction__btn" @click="handleEdit">Изменить</button>
                    <button type="button" class="no-border edit-block-interaction__btn reject" @click="closeEdit">Отменить</button>
                </div>

            </div>


            <AuthorBlock
                :author="{name: news.nickname, avatar: news.avatar_url}"
                :views="news.views_count"
                :comments="news.comments_count"
            />

            <div v-if="!isEditing" v-html="news.content" class="content-block flex-column">
            </div>
            <div class="news-container-interaction flex align-c justify-sb">
                <button v-if="isAuthenticated" @click="handleLike()" type="button" aria-label="Оценить новость" class="no-border counter-slider flex-center"><svg><use href="#icon-like"></use></svg>{{ news.likes_count }}</button>
                <div v-if="authStore.user?.role === 2 || authStore.user?.role === 4" class="action-menu">
                    <button type="button" class="no-border news-container-interaction__btn action" @click="toggleMenu">
                        ...
                    </button>
                    <div v-if="showMenu" class="dropdown-menu">
                        <button class="menu-item no-border" @click="startEdit">Редактировать</button>
                        <button class="menu-item danger no-border" @click="onConfirmDelete">Удалить</button>
                    </div>
                    <ConfirmPopUp 
                    v-model="isVisiblePopup"
                    :label="'новость'" 
                    @confirm="handleDelete"/>
                </div>
            </div>

            

            <div class="comment-wrapper flex-column" id="comments-section">
                <span class="label-comment">Комментарии ({{ news.comments_count }})</span>   

                <div class="comments-block flex-column">
                    <Comment
                    v-for="comment in comments" 
                    :comment="comment" 
                    @reply-added="handleComment('added', news)"
                    @reply-deleted="handleComment('deleted', news)"
                    @reply-edited="handleComment()"
                    @reload-comments="reloadComments"/>
                    <CommentForm v-if="isAuthenticated" @comment-added="handleComment('added', news)"/>
                </div>
            </div>

        </div>

        <div class="advertisment-container flex-column">
            <span class="place-btn">Разместить рекламу</span>
        </div>
    </div>


</template>

<style scoped>

    .action-menu {
        position: relative;
    }

    .dropdown-menu {
        width: fit-content;
        position: absolute;
        top: 0%;
        right: 48px;
        background-color: var(--color-1);
        border-radius: 4px;
        z-index: 1000;
        opacity: 0;
        transform: translateX(48px);
        animation: slideDown 0.3s ease forwards;
    }

    @keyframes slideDown {
        to {
            opacity: 1;
            transform: translateY(0);
        }
    }

    .menu-item {
        width: 100%;
        padding: 12px 16px;
        color: #fff;
        text-align: left;
        font-size: 14px;
        font-family: Roboto_Regular;
        transition: background-color 0.2s;
    }

    .menu-item:hover {
        background-color: #40444b;
    }

    .menu-item.danger {
        border-top: 1px solid #40444b;
        color: #ff6b6b;
    }

    .menu-item.danger:hover {
        background-color: #ff6b6b;
        color: #fff;
    }

    /* дроп меню */

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

    .news-container-interaction {
        width: 100%;
    }
    
    .news-container-interaction__btn.action {
        width: 32px;
        height: 32px;
        background-color: var(--color-1);
        border-radius:4px;
    }

    .news-container-interaction__btn.action:hover {
        filter: brightness(1.25);
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
        font-size: 18px;
        background-color: var(--btn-color-6-25);
        padding-block: 16px;
        text-align: center;
        border-radius: 8px;
    }

    /* Редактирование выбор категории */

    .edit-block {
        width: 100%;
        gap: var(--gp-16);
    }

    .edit-block-interaction {
        gap: var(--gp-8);
    }

    select {
        width: 100%;
        overflow: hidden;
        text-overflow: ellipsis;
        white-space: nowrap;
        cursor: pointer;
        appearance: none;
        background: url('../assets/icons/arrow.svg') no-repeat right 16px center;
        background-size: 16px;
        padding-right: 36px !important; 
    }

    .field {
        width: 100%;
        background-color: #1B1C21;
        padding: 12px 16px;
        border-radius: 8px;
        border-left: 3px solid var(--btn-color-2);
        color: var(--font-primary-75);
    }

    .field::placeholder {
        color: var(--font-primary-25);
    }

    .edit-block-interaction__btn {
        background-color: var(--btn-color-1);
        border-radius: 4px;
        padding: 8px 16px;
    }
    
    .edit-block-interaction__btn.reject {
        background-color: var(--color-1);
    }

    .container {
        animation: contentFadeIn 0.3s ease-out;
        }

        @keyframes contentFadeIn {
        from {
            opacity: 0.25;
        }
        to {
            opacity: 1;
        }
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
        .bottom-info {
            font-size: 18px;
        }
        
        .content-block {
            gap: var(--gp-24);
        }
    }
</style>