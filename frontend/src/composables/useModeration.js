import { ref, nextTick, watch, unref } from 'vue'
import { useRoute, useRouter } from 'vue-router'
import api from '../utils/axios'
import { useAuthStore } from '../stores/authStore'
import { storeToRefs } from 'pinia'

import { useApiNotifications } from '../composables/useApi'
import { useNotifications } from '../stores/notifications'
const  { apiCall } = useApiNotifications()
const notification = useNotifications()

const authStore = useAuthStore()
const { isAuthenticated, user } = storeToRefs(authStore)

export const useModeration = () => {

    const hasAnyRole = (roles) => roles.includes(user.value?.role)

    const canModerate = () => {
        return isAuthenticated.value && hasAnyRole([3, 4])
    }

    const moderateComment = async (commentId, reason) => {
        if (!canModerate()) return false

        const data = await apiCall(
        () => api.delete(`/moderation/${commentId}/comment`, {
            data: { reason }
        }),
        'Комментарий удалён'
        )

        return data?.status === 204
    }

    const moderateQuestion = async (questionId, reason) => {
        if (!canModerate()) return false

        const data = await apiCall(
            () => api.put(`/moderation/${questionId}/question`, {
            reason
            }),
            'Вопрос удалён'
        )

        return data?.status === 204
    }

    const moderateReview = async (reviewId, reason) => {
        if (!canModerate()) return false

        const data = await apiCall(
            () => api.put(`/moderation/${reviewId}/review`, {
            reason
            }),
            'Рецензия удалена'
        )

        return data?.status === 204
    }

    const moderateProfile = async(userId, type) => {
        if(!canModerate()) return false

        const data = await apiCall(() => api.delete(`/moderation/${userId}/userMedia`,
             { data: { type } }
        ), 'Медиа успешно удалено')

        return data?.status === 204
    }

    const moderateUnblock = async(userId, category) => {
        if(!canModerate()) return false

        const data = await apiCall(() => api.put(`/moderation/${userId}/unBlock`,
            { category }
        ), 'Категория разблокирована')

        return data?.status === 204
    }

 

    return {
        canModerate,
        moderateComment,
        moderateQuestion,
        moderateReview,
        moderateProfile,
        moderateUnblock
    }
}