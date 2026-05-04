<script setup>
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
        'pending': 'В ожидании',
        'rejected': 'Отклонено', 
        'accepted': 'Одобрено'
    }

    const getStatus = (status) => statusMap[status] || status

    const notes = ref('')

    const handleRequest = async(type) => {
        if(notes.value.trim().length <= 5) {
            notification.warning('Слишком короткая причина')
            return
        }
        if(type === 'accept') {
            const data = await apiCall(() => api.put('/moderation/gameRequest', {
                idRequest: props.item.idRequest,
                notes: notes.value.trim(),
                status: type,
            }),'Запрос обработан')
            if(data.success) {
                emit('updateList')
            }
        } else if(type === 'reject') {
            const data = apiCall(() => api.put('/moderation/gameRequest'), {
                notes: notes.value,
                type
            })
            if(data.success) {
                emit('updateList')
            }
        } 
    }

</script>

<template>
    <div class="container flex-column">
        <RouterLink v-if="props.item.moderator" :to="`/user/${props.item.moderator}`" class="request-header flex align-c">
            <div class="avatar-block">
                <picture>
                    <img :src="props.item.moderator_avatar" class="avatar__img active">
                </picture>
            </div>
            <span class="user__name">{{ props.item.moderator }}</span>
        </RouterLink>
        <RouterLink v-else-if="props.item.user" :to="`/user/${props.item.user}`" class="request-header flex align-c">
            <div class="avatar-block">
                <picture>
                    <img :src="props.item.user_avatar" class="avatar__img active">
                </picture>
            </div>
            <span class="user__name">{{ props.item.user }}</span>
        </RouterLink>
        <div class="request-content flex-column">
            <span class="content__label">
                Название игры:
                 <span class="nameGame">{{ props.item.nameGame }}</span>
            </span>
            <a v-if="props.item?.store_url" href="#" class="content__link">Страница игры</a>
            <a v-if="props.item?.cover_url" href="#" class="content__link">Обложка игры</a>
            <a v-if="props.item?.baner_url" href="#" class="content__link">Банер игры</a>
            <span v-if="props.item?.notes">Примечание:{{ props.item.notes }}</span>
        </div>
        <div class="status-block" :class="`status-${props.item.status}`">
            <span>{{ getStatus(props.item.status) }}</span>
        </div>
        <div v-if="user.id === props.item.user_id" class="user-btns flex align-c">
            <button type="button" class="no-border">Удалить</button>
            <button v-if="props.item.status === 'pending'" type="button" class="no-border">Редактировать</button>
        </div>
        <div v-if="user.role === 4" class="moderator-btns flex align-c">
            <input v-model="notes" class="notesField" placeholder="Причина">
            <button @click="handleRequest('rejected')" type="button" class="no-border">Отклонить</button>
            <button @click="handleRequest('accepted')" type="button" class="no-border">Одобрить</button>
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

    .request-header {
        width: fit-content;
        gap: var(--gp-8);
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

    .content__link {
        width: fit-content;
        font-family: Roboto_Medium;
        color: var(--font-primary-50);
    }

    .content__label {
        font-family: Roboto_Medium;
        font-size: 18px;
    }

    .nameGame {
        font-size: 16px;
        font-family: Roboto_Regular;
        color: var(--font-primary-75);
    }

    .user-btns {
        gap: var(--gp-10);
        margin-left: auto;
    }

    .moderator-btns {
        width: 100%;
        gap: var(--gp-10);
        margin-left: auto;
    }

    .notesField {
        width: 100%;
    }

    .status-block {
        position: absolute;
        top: 16px;
        right: 16px;
        font-family: Roboto_Medium;
        padding: 2px 4px;
        border-radius: 4px;
    }

    .status-pending {
        background: linear-gradient(135deg, #ffeb3b, #fdd835);
        color: #000;
        box-shadow: 0 2px 8px rgba(255, 235, 59, 0.3);
    }

    .status-rejected {
        background: linear-gradient(135deg, #f44336, #d32f2f);
        color: #fff;
        box-shadow: 0 2px 8px rgba(244, 67, 54, 0.4);
    }

    .status-accepted {
        background: linear-gradient(135deg, #4caf50, #388e3c);
        color: #fff;
        box-shadow: 0 2px 8px rgba(76, 175, 80, 0.4);
    }

</style>