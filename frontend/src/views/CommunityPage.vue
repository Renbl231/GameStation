<script setup>
    import Comment from '../components/Comment.vue'
    import CommentForm from '../components/CommentForm.vue'
    import AuthorBlock from '../components/AuthorBlock.vue'
    import ThemeLabel from '../components/ThemeLabel.vue'
    import ConfirmPopUp from '../components/ConfirmPopUp.vue';
    import BanModal from '../components/BanModal.vue';
    import ModerationPopUp from '../components/ModerationPopUp.vue';

    import { useModeration } from '../composables/useModeration';
    const { moderateQuestion } = useModeration()

    import { ref, onMounted, onUnmounted, nextTick } from 'vue'
    import { useRoute, useRouter } from 'vue-router'

    import { useAuthStore } from '../stores/authStore'
    import { storeToRefs } from 'pinia'

    import api from '../utils/axios'
    import { useFormatDate } from '../utils/date/formatDate.js';
    import { useInteractions } from '../composables/useInteractions'

    import { useGlobal404 } from '../composables/useGlobal404'
    import { useNotifications } from '../stores/notifications';
    import { useApiNotifications } from '../composables/useApi';
    const { set404 } = useGlobal404()
    const { apiCall } = useApiNotifications()
    const notification = useNotifications()

    const { comments, loadComments, scrollToCommentsIfNeeded, handleComment } = useInteractions()
    const { formatDate } = useFormatDate()
    const authStore = useAuthStore()
    const { isAuthenticated, user } = storeToRefs(authStore)
    const route = useRoute()
    const router = useRouter()

    const sectionsMap = {
        6: 'Ищу игру',
        7: 'Проблемы', 
        8: 'Другое',
        9: 'Лор и сюжет',
        10: 'Прохождение',
        11: 'Системные требования',
        12: 'Моды'
    }

    const getSectionName = (id) => {
        return sectionsMap[id] || 'Неизвестно'
    }

    const theme = ref({ views_count: 0, comments_count: 0 })
    const isLoading = ref(true);
    const loadTheme = async () => {
        
        try {
            const idTheme = route.params.id
            
            const now = Date.now()
            const hourAgo = now - (60 * 60 * 1000)
            const sessionKey = `theme_view_${idTheme}`
            const lastView = localStorage.getItem(sessionKey)
            
            const shouldIncrement = !lastView || parseInt(lastView) < hourAgo
            
            if (shouldIncrement) {
                localStorage.setItem(sessionKey, now.toString())
            }
            
            const { data } = await api.get(`/theme/${idTheme}${shouldIncrement ? '?incrementView=true' : ''}`)
            
            if (!data) {
                set404()
                return
            }
            
            theme.value = data
        } catch (error) {
            theme.value = {}
            set404()
        }
    }

    // дроп меню

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
        const data = await apiCall(() => api.delete(`/theme/${route.params.id}/delete`), 'Тема удалена')
        if(data.status === 204) {
            await router.push('/community')
        }           
    }

    //  редактирование

    const isEditing = ref(false)

    const form = ref({
        title: '',
        section_id: '',
        description: '',
        status: ''
    })

    const startEdit = () => {
        form.value.title = theme.value.title
        form.value.description = theme.value.description
        form.value.section_id = theme.value.section_id
        form.value.status = theme.value.status
        isEditing.value = true
        nextTick(() => {
            const editable = document.querySelector('[contenteditable="true"]')
        })
    }

    const closeEdit = async() => {
        await loadTheme()
        isEditing.value = false
    }

    const validateForm = () => {
        if(!form.value.title.trim()) {
            notification.warning('Заголовок обязателен')
            return false
        }
        if(!form.value.section_id) {
            notification.warning('Категория обязательна')
            return false
        }
        if(!form.value.description.trim()) {
            notification.warning('Описание обязательно')
            return false
        }
        return true
    }

    const resetForm = () => {
        form.value = {
            title: '',
            section_id: '',
            description: '',
            status: 'Открыт'
        }
    }

    const handleEdit = async () => {
        if(!validateForm()) return
        console.log(form.value.status)
        const data = await apiCall(() => api.put(`/theme/${route.params.id}/edit`, form.value), 'Тема отредактирована')
        if(data.success) {
            Object.assign(theme.value, form.value)       
            isEditing.value = false 
            resetForm()
        } 
    }

    const isBanModal = ref(false)

    const reloadComments = async (value) => {
        console.log('reloadComments:', value)
        if (value === true) {
            await loadComments()
            theme.value.comments_count--
        }
    }

    const redirectToPage = async (value) => {
        if(value) {
            router.push('/community')
        }
    }

    const isModeration = ref(false)

    const handleModerateDelete = async (reason) => {
        const success = await moderateQuestion(theme.value.idQuestion, reason)

        if (success) {
            redirectToPage(true)
        }
    }

    onUnmounted(() => {
        document.removeEventListener('click', closeMenu)
    })

    onMounted(async () => {
        await Promise.all([loadTheme(), loadComments()])
        isLoading.value = false

        await scrollToCommentsIfNeeded() 
        document.addEventListener('click', closeMenu)
    });

</script>

<template>

    <div v-if="isLoading"></div>

    <BanModal
        :model-value="isBanModal"
        :nickname="theme.nickname"
        :type="'question'"
        :user_id="theme.idUser"
        :entity_id="theme.idQuestion"
        :text="'вопросам'"
        @update:model-value="isBanModal = false"
        @redirect-to-page="redirectToPage"
    />

    <ModerationPopUp
        v-model="isModeration"
        :label="'вопрос'"
        @confirm="handleModerateDelete"
    />

    <div v-if="theme && Object.keys(theme).length != 0 && !isLoading" class="container flex-column">
        <div class="label-wrapper flex justify-sb">
            <ThemeLabel 
                :label="theme.title"
                :btm-info="{date: formatDate(theme.created_at), theme: getSectionName(theme.section_id)}"
            />
            <div v-if="authStore.user?.id === theme.idUser" class="theme-container-interaction flex">
                <div class="action-menu">
                    <button type="button" class="no-border theme-container-interaction__btn action" @click="toggleMenu">
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
                :class="{'active': form.title}"
                placeholder="Заголовок"
            />

            <select 
                v-model="form.section_id" 
                class="category-select field no-border"
                :class="{'active': form.section_id}"
            >
                <option value="" disabled hidden selected class="empty-option">
                    Изменить раздел
                </option>
                <option value=6>Ищу игру</option>
                <option value=7>Проблемы</option>
                <option value=8>Другое</option>
                <option value=9>Лор и Сюжет</option>
                <option value=10>Прохождение</option>
                <option value=11>Системные требования</option>
                <option value=12>Моды</option>
            </select>

            <textarea 
                v-model="form.description" 
                class="field no-border" 
                :class="{'active': form.description}"
                placeholder="Описание"
            />

            <label for="status">
                Статус
                <select v-model="form.status" id="status" class="no-border field" :class="{'active': form.status}">
                    <option value="open">Открыт</option>
                    <option value="closed">Закрыт</option>
                </select>
            </label>
            

            <div class="edit-block-interaction flex aling-c">        
                <button type="button" class="no-border edit-block-interaction__btn" @click="handleEdit">Изменить</button>
                <button type="button" class="no-border edit-block-interaction__btn reject" @click="closeEdit">Отменить</button>
            </div>


        </div>


        <AuthorBlock
            :author="{name: theme.nickname, avatar: theme.avatar_url}"
            :views="theme.views_count"
            :comments="theme.comments_count"
        />

        <div v-if="!isEditing" v-html="theme.description" class="content-block flex-column">
        </div>

        <div v-if="user?.role === 3 || user?.role === 4 && theme.idUser != user.id" class="moderation-block flex align-c">
            <button @click="isBanModal = true" class="no-border handle-btn flex-center">
                Заблокировать
            </button>
            <button @click="isModeration = true" class="no-border handle-btn handle-btn-danger flex-center">
                Удалить
            </button>
        </div>


        <div class="comment-wrapper flex-column" id="comments-section">
            <span class="label-comment">Комментарии ({{ theme.comments_count }})</span>   

            <div class="comments-block flex-column">
                <Comment
                    v-for="comment in comments" 
                    :comment="comment" 
                    @reply-added="handleComment('added', theme)"
                    @reply-deleted="handleComment('deleted', theme)"
                    @reply-edited="handleComment()"
                    @reload-comments="reloadComments"
                />
                <CommentForm v-if="isAuthenticated" @comment-added="handleComment('added', theme)"/>
            </div>
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

    .theme-container {
        width: 100%;
        gap: var(--gp-24);
    }

    .theme-container-interaction {
        width: fit-content;
        height: fit-content;
        background-color: #1B1C21;
        justify-content: right;
        align-items: flex-start;
    }
    
    .theme-container-interaction__btn.action {
        width: 32px;
        height: 32px;
        background-color: var(--color-1);
        border-radius:4px;
    }

    .theme-container-interaction__btn.action:hover {
        filter: brightness(1.25);
    }

    .bottom-info {
        font-size: 24px;
        color: var(--font-primary-50);
        gap: var(--gp-10);
    }

    textarea.field {
        resize: vertical;
    }

    /* Контент */

    .label-wrapper {
        width: 100%;
    }

    .label-block::v-deep(ThemeLabel) {
        width: 100%;
    }

    .content-block {
        width: 100%;
        word-break: break-all;
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
    .field.active {border-left-color: var(--font-secondary);}

    .edit-block-interaction__btn {
        background-color: var(--btn-color-1);
        border-radius: 4px;
        padding: 8px 16px;
    }
    
    .edit-block-interaction__btn.reject {
        background-color: var(--color-1);
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
    }
    .handle-btn:hover {background-color: var(--font-secondary-75);}

    .handle-btn-danger {background-color: var(--bg-secondary-50);}
    .handle-btn-danger:hover {background-color: var(--bg-secondary);}

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