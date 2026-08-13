import { ref, nextTick, watch, unref } from 'vue'
import { useRoute } from 'vue-router'
import api from '@utils/axios'
import { useAuthStore } from '@stores/authStore'
import { storeToRefs } from 'pinia'
import { useApiNotifications } from '@composables/useApi'
import { useNotifications } from '@stores/notifications'

const  { apiCall } = useApiNotifications()
const notification = useNotifications()
const authStore = useAuthStore()
const { isAuthenticated, user } = storeToRefs(authStore)

export const useInteractions = () => {
    const route = useRoute()
    const comments = ref([])

    const checkValidation = (value) => {
        if(value.length < 3) {
            notification.warning('Минимальный размер сообщения 3 символа')
            return false
        }

        return true
    }
    
    // работа с комментариями

    const loadComments = async () => {
        try {
            const entity_type = route.meta.entity_type
            const entity_id = route.params.id
            const { data } = await api.get(`/comments/${entity_type}/${entity_id}`)
            comments.value = Array.isArray(data) ? data : []
        } catch(error) {
            comments.value = []
        }
    }

    const createComment = async(content, parent_comment_id = null) => {
        const validation = checkValidation(content)
        if(!validation) return
            
        const entity_type = route.meta.entity_type
        const entity_id = Number(route.params.id)

        const data = await apiCall(() => api.post(`/comments/${entity_type}/${entity_id}`, {
            entity_type: entity_type,
            entity_id: entity_id,
            parent_comment_id:  parent_comment_id,
            content: content
        }), 'Комментарий опубликован') 
        
        return data.success
    }

    const deleteComment = async(commentId, author_id) => {
        if(user.value?.id !== author_id) return

        const data = await apiCall(() => api.delete(`/comments/${commentId}/delete`), 'Комментарий удалён')
        if(data.status === 204) {
            return true
        }

        return false
    }

    const editComment = async(idComment, content, author_id) => {
        const validation = checkValidation(content)
        if(!validation) return

        if(user?.id !== author_id) return

        const data = await apiCall(() => api.put(`/comments/${idComment}/edit`, { content }), 'Комментарий изменён')
        return data.success
    }

    // Лайки

    const likeEntity = async (entityRef) => {
        if (!isAuthenticated.value) return
        
        try {
            const entity_type = route.meta.entity_type
            const entity_id = route.params.id
            const { data } = await api.post(`/${entity_type}/${entity_id}/like`, {
                entity_type, entity_id
            })
            
            if (data.success === 'removed') {
                entityRef.value.likes_count -= 1
            } else if (data.success) {
                entityRef.value.likes_count += 1
            }
        } catch (error) {} 
    }

    // скролл

    const scrollToCommentsIfNeeded = async () => {
        await nextTick();
        
        if(route.query.tab === 'comments') {
            const commentsSection = document.getElementById('comments-section');
            if(commentsSection) {
                commentsSection.scrollIntoView({ behavior: 'smooth', block: 'start' });
            }
        }
    };

    watch(() => route.query.tab, scrollToCommentsIfNeeded, { immediate: true })

    
    return { comments, loadComments, scrollToCommentsIfNeeded, likeEntity, createComment,
        deleteComment, editComment
     }
}

