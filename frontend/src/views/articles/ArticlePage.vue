<script setup>
    import AuthorBlock from '@components/common/AuthorBlock.vue'
    import ThemeLabel from '@components/common/ThemeLabel.vue'
    import ConfirmPopUp from '@components/ConfirmPopUp.vue';
    import TextEditor from '@components/TextEditor.vue'
    import CommentWrapper from '@components/comments/CommentWrapper.vue';

    import { ref, onMounted, onUnmounted, nextTick } from 'vue'
    import { useRoute, useRouter } from 'vue-router'
    import { useAuthStore } from '@stores/authStore'
    import { storeToRefs } from 'pinia'
    import api from '@utils/axios'

    import { useGlobal404 } from '@composables/useGlobal404'
    import { useNotifications } from '@stores/notifications';
    import { useApiNotifications } from '@composables/useApi';
    import { formatDate } from '@/utils/date/formatDate';
    const { set404 } = useGlobal404()
    const { apiCall } = useApiNotifications()
    const notification = useNotifications()

    const { formatDate1 } = formatDate()
    const authStore = useAuthStore()
    const { user } = storeToRefs(authStore)
    const route = useRoute()
    const router = useRouter()

    const article = ref({ views_count: 0, comments_count: 0 })
    const isLoading = ref(true);

    const LoadArticle = async () => {

        try {
            const idArticle = route.params.id
            
            const now = Date.now()
            const hourAgo = now - (60 * 60 * 1000)
            const sessionKey = `article_view_${idArticle}`
            const lastView = localStorage.getItem(sessionKey)
            
            const shouldIncrement = !lastView || parseInt(lastView) < hourAgo
            
            if (shouldIncrement) {
                localStorage.setItem(sessionKey, now.toString())
            }
            
            const { data } = await api.get(`/article/${idArticle}${shouldIncrement ? '?incrementView=true' : ''}`)
            
            if (!data) {
                set404()
                return
            }
            
            article.value = data
            temporaryPhoto.value = article.value.image
        } catch (error) {
            article.value = {}
            set404()
        } 
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
        const data = await apiCall(() => api.delete(`/article/${route.params.id}/delete`), 'Статья удалена')
        if(data.status === 204) {
            await router.push('/articles')
        }           
    }

    //  редактирование

    const isEditing = ref(false)

    const form = ref({
        title: '',
        type_article: '',
        image: null,
        content: '',
        score: 0
    })

    const startEdit = () => {
        form.value.title = article.value.title
        form.value.image = article.value.image
        form.value.content = article.value.content
        form.value.type_article = article.value.type_article,
        form.value.score = article.value.score || 0
        isEditing.value = true
        nextTick(() => {
            const editable = document.querySelector('[contenteditable="true"]')
        })
    }

    const closeEdit = async() => {
        await LoadArticle()
        isEditing.value = false
    }

    const validateForm = () => {
        if(!form.value.title.trim()) {
            notification.warning('Заголовок обязателен')
            return false
        }
        if(!form.value.type_article.trim()) {
            notification.warning('Категория обязательна')
            return false
        }
        if(!form.value.image) {
            notification.warning('Превью обязательно')
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
            type_article: '',
            image: null,
            content: '<p class="text-content">Начните писать здесь...</p>',
            score: 0
        }
    }

    
    const MAX_FILE_SIZE = 3 * 1024 * 1024
    const temporaryPhoto = ref(null)

    const onCoverChange = (event) => {
        const file = event.target.files?.[0]
        
        if (!file) {
            form.value.image = null
            temporaryPhoto.value = null
            return
        }
        
        if (!file.type?.startsWith('image/')) {
            notification.warning('Только изображения')
            event.target.value = ''
            return
        }

        if (file.size > MAX_FILE_SIZE) {
            notification.warning('Файл слишком большой — максимум 3 МБ')
            event.target.value = ''
            return
        }
        
        form.value.image = file
        temporaryPhoto.value = URL.createObjectURL(file)
    }

    const handleEdit = async () => {
        if (!validateForm()) return

        const fd = new FormData()
        fd.append('title', form.value.title)
        fd.append('type_article', form.value.type_article)
        fd.append('content', form.value.content)
        fd.append('score', form.value.score)
        if (form.value.image) fd.append('image', form.value.image)

        const data = await apiCall(() => api.put(`/article/${route.params.id}/edit`, fd), 'Статья отредактирована')
        if(data.success) {
            Object.assign(article.value, form.value)       
            isEditing.value = false 
            resetForm()
        } 
    }

    onUnmounted(() => {
        document.removeEventListener('click', closeMenu)
    })

    onMounted(async () => {
        await LoadArticle()
        isLoading.value = false
        document.addEventListener('click', closeMenu)
    });


</script>

<template>

    <div v-if="article && Object.keys(article).length != 0 && !isLoading" class="container flex">
        <div class="news-container flex-column">

            <div class="label-wrapper flex justify-sb">
                <ThemeLabel 
                    :label="article.title"
                    :btm-info="{date: formatDate1(article.created_at), theme: article.type_article}"
                />
                <div v-if="user?.role === 2 || user?.role === 4" class="news-container-interaction flex">
                    <div class="action-menu">
                        <button type="button" class="no-border news-container-interaction__btn action" @click="toggleMenu">
                            ...
                        </button>
                        <div v-if="showMenu" class="dropdown-menu">
                            <button class="menu-item no-border" @click="startEdit">Редактировать</button>
                            <button class="menu-item danger no-border" @click="onConfirmDelete">Удалить</button>
                        </div>
                        <ConfirmPopUp 
                        v-model="isVisiblePopup"
                        :label="'тему'" 
                        @confirm="handleDelete"/>
                    </div>
                </div>

            </div>

            <div v-if="isEditing" class="edit-block flex-column">

                <input 
                    v-model="form.title" 
                    class="field no-border" 
                    placeholder="Заголовок"
                    :class="{'active': form.title}"
                />

                <div class="image-uploader flex-column">
                    <div v-if="temporaryPhoto" class="preview-container">
                        <img :src="temporaryPhoto" class="preview-image"/>
                    </div>
                    <label class="upload-btn flex-center">
                        <input 
                            type="file"
                            accept="image/*"
                            class="upload-input"
                            @change="onCoverChange"
                        />
                        <span class="upload-text">Загрузить превью</span>
                    </label>
                </div>

                <select 
                    v-model="form.type_article" 
                    class="category-select field no-border"
                    :class="{'active': form.type_article}"
                >
                    <option value="" disabled hidden selected class="empty-option">
                        Изменить категорию
                    </option>
                    <option value="reviews">Обзор</option>
                    <option value="selections">Подборка игр</option>
                </select>

                <TextEditor v-model="form.content" :type="'articles'" class="active"/>

                <label>
                    Оценка {{ form.score }}/10
                    <input type="range" v-model="form.score" step="1" min="0" max="10" style="width: 100%; cursor: pointer;">
                </label>

                <div class="edit-block-interaction flex aling-c">        
                    <button type="button" class="no-border edit-block-interaction__btn" @click="handleEdit">Изменить</button>
                    <button type="button" class="no-border edit-block-interaction__btn reject" @click="closeEdit">Отменить</button>
                </div>

            </div>


            <AuthorBlock
                :author="{name: article.author_name, avatar: article.author_avatar, role: article.author_role}"
                :views="article.views"
                :comments="article.comments"
            />

            <div v-if="!isEditing" v-html="article.content" class="content-block flex-column">
            </div>

            <CommentWrapper
                :counter="article.comments"
                id="comments-section"
            />

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
        background-color: var(--bg-tertiary);
        border-radius: 8px;
        padding: 32px;
        gap: var(--gp-20);
    }

    .news-container {
        width: 100%;
        gap: var(--gp-24);
    }

    .news-container-interaction {
        width: fit-content;
        height: fit-content;
        background-color: #1B1C21;
        justify-content: right;
        align-items: flex-start;
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

    .label-wrapper {
        width: 100%;
    }

    /* Контент новости */

    /* .content-block {
        gap: var(--gp-24);
    } */

    :deep(.img-block img) {
        border-radius: 8px;
        width: 100%;
        max-height: 542px;
    }

    :deep(.text-content) {
        font-size: 20px;
        line-height: 32px;
        color: var(--font-primary-75);
    }

    @media (max-width:600px) {
        :deep(.text-content) {
            font-size: 16px;
            line-height: 24px;
            color: var(--font-primary-75);
        }
    }


    :deep(.video-wrapper) {
    position: relative;
    width: 100%;
    max-width: 800px;
    margin: 12px 0;
    border-radius: 8px;
    overflow: hidden;
}

:deep(.video-wrapper iframe) {
    width: 100%;
    height: auto;
    aspect-ratio: 16 / 9;
    border: none;
    border-radius: 8px;
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

    .field.active {border-left: 3px solid var(--font-secondary);}

    .field::placeholder {
        color: var(--font-primary-25);
    }

    .edit-block-interaction__btn {
        background-color: var(--btn-color-1);
        border-radius: 4px;
        padding: 8px 16px;
    }
    .edit-block-interaction__btn:hover {background-color: var(--btn-color-2);}
    
    .edit-block-interaction__btn.reject {
        background-color: var(--bg-secondary-25);
    }
    .edit-block-interaction__btn.reject:hover {background-color: var(--bg-secondary-50);}

    /* Превью */

    .image-uploader {
        gap: var(--gp-16);
    }

    .upload-btn {
        cursor: pointer;
        display: inline-flex;
        width: fit-content;
        padding: 8px 16px;
        background-color: var(--btn-color-6-25);
        border-radius: 4px;
        text-align: center;
    }

    .upload-btn:hover {
        background-color: var(--btn-color-6-50);
    }

    .upload-input {
        display: none;
    }

    .upload-text {
        font-family: Roboto_Medium;
        font-size: 16px;
        color: var(--font-primary);
    }

    .preview-image {
        width: 392px;
        height: 220px;
        border-radius: 4px;
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