<script setup>
    import { onAvatarError } from '../helpers/onImageError'
    import { ref } from 'vue'
    import api from '../utils/axios'

    import { storeToRefs } from 'pinia'
    import { useAuthStore } from '../stores/authStore'
    const authStore = useAuthStore()
    const { user } = storeToRefs(authStore)


    import { useNotifications } from '../stores/notifications'
    import { useApiNotifications } from '../composables/useApi'
    const { apiCall } = useApiNotifications()
    const notification = useNotifications()

    const emit = defineEmits(['updateList'])


    const props = defineProps({
        item: Object
    })

    const statusMap = {
        'open': 'В ожидании',
        'closed': 'Закрыто',
    }

    const typeMap = {
        'advertisement': 'Реклама',
        'site_issues': 'Работа сайта (баги, предложения)',
        'vacancies': 'Вакансии на сайте',
        'admin_question': 'Другое',
    }

    const getStatus = (status) => statusMap[status] || status
    const getType = (type) => typeMap[type] || type

    const notes = ref('')

    const handleRequest = async() => {
        if(notes.value.trim().length <= 5) {
            notification.warning('Слишком короткий ответ')
            return
        }
        const data = await apiCall(() => api.put(`/moderation/siteRequest/${props.item.idQuestion}`, {
            notes: notes.value.trim(),
        }),'Запрос обработан')
        if(data.success) {
            emit('updateList')
        }
    }

</script>

<template>
    <div class="container flex-column">
        <RouterLink v-if="props.item.user" :to="`/user/${props.item.user}`" class="request-header flex align-c">
            <div class="avatar-block">
                <picture>
                    <img :src="props.item?.user_avatar || '/images/plug_avatar.png'" @error="onAvatarError" class="avatar__img">
                </picture>
            </div>
            <span class="user__name">{{ props.item?.user }}</span>
        </RouterLink>
        <div class="request-content flex-column">
            <span>{{ props.item.title }}</span>
            <span>{{ getType(props.item.section_name)}}</span>
            <p>{{ props.item.description }}</p>
            <span>{{ props.item.notes }}</span>
        </div>
        <div class="status-block" :class="`status-${props.item.status}`">
            <span>{{ getStatus(props.item.status) }}</span>
        </div>
        <div v-if="user.role === 4" class="moderator-btns flex align-c">
            <input v-model="notes" class="notesField" placeholder="Ответ на вопрос">
            <button @click="handleRequest" type="button" class="no-border handle-btn">Закрыть тему</button>
        </div>
    </div>

</template>

<style scoped>
    .container {
        width: 100%;
        background-color: var(--bg-secondary-25);
        border-radius: 8px;
        padding: 16px;
        position: relative;
        gap: var(--gp-16);
    }

    .request-content {
        font-family: Roboto_Medium;
    }

    .handle-btn {
        width: fit-content;
        font-family: Roboto_Medium;
        background-color: var(--bg-secondary-50);
        border-radius: 4px;
        text-wrap: nowrap;
        padding: 4px 8px;
    }
    .handle-btn:hover {
        background-color: var(--font-secondary);
    }

    .request-header {
        width: fit-content;
        gap: var(--gp-8);
    }

    .status-block {
        position: absolute;
        top: 16px;
        right: 16px;
        font-family: Roboto_Medium;
        padding: 2px 4px;
        border-radius: 4px;
    }

    .status-closed {
        background: linear-gradient(135deg, #f44336, #d32f2f);
        color: #fff;
        box-shadow: 0 2px 8px rgba(244, 67, 54, 0.4);
    }

    .status-open {
        background: linear-gradient(135deg, #4caf50, #388e3c);
        color: #fff;
        box-shadow: 0 2px 8px rgba(76, 175, 80, 0.4);
    }

    .avatar-block {
        display: block;
        width: 48px;
        height: 48px;
    }

    .avatar__img {
        width: 100%;
        height: 100%;
        border-radius: 50%;
    }

    .avatar__img.active {
        border: 2px solid var(--font-secondary);
    }

    .user__name {
        font-family: Roboto_Medium;
    }

    .request-content {
        width: fit-content;
        gap: var(--gp-12);
    }

    .moderator-btns {
        width: 100%;
        gap: var(--gp-10);
        margin-left: auto;
    }
    

    
    .notesField {
        width: 100%;
        background-color: var(--bg-secondary-50);
        color: var(--font-primary);
        padding: 4px 8px;
        border-radius: 4px;
        font-family: Roboto_Medium;
    }

</style>