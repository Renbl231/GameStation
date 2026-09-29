import { useAuthStore } from '@/stores/authStore'
import { storeToRefs } from 'pinia'
import { useApiNotifications } from '@/composables/useApi'
import api from '@/utils/axios'

export const useModeration = () => {

    const authStore = useAuthStore()
    const { user } = storeToRefs(authStore)
    const { apiCall } = useApiNotifications()

    const canModerate = (idUser) => {
        if (![3, 4].includes(user.value?.role)) return false
        if (user.value?.id === idUser) return false
        return true
    }

    const moderateMedia = async(userId, type) => {
        const data = await apiCall(() => api.delete(`/moderation/${userId}/userMedia/${type}`), 'Медиа успешно удалено')
        return data?.status === 204
    }

    const moderateRole = async(userId, role) => {
        if(!role) return false

        const data = await apiCall(() => api.put(`/moderation/${userId}/role`, { 
            role 
        }), 'Роль изменена')

        if(data?.result) {
            return data.result
        }
    }

    const moderateUnblock = async(userId, category) => {
        if (!['profile', 'comment', 'question', 'review'].includes(category)) return false

        const data = await apiCall(() => api.put(`/moderation/${userId}/unblock`,
            { category }
        ), 'Категория разблокирована')

        return data?.status === 204
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

    return {
        canModerate,
        moderateComment,
        moderateQuestion,
        moderateReview,
        moderateMedia,
        moderateUnblock,
        moderateRole
    }
}