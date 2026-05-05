import { ref, nextTick, watch, unref } from 'vue'
import { useRoute } from 'vue-router'
import api from '../utils/axios'
import { useAuthStore } from '../stores/authStore'
import { storeToRefs } from 'pinia'

import { useApiNotifications } from '../composables/useApi'
import { useNotifications } from '../stores/notifications'
const  { apiCall } = useApiNotifications()
const notification = useNotifications()

const authStore = useAuthStore()
const { isAuthenticated } = storeToRefs(authStore)

export const useInteractions = () => {
    const route = useRoute()
    const comments = ref([])
    
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

    const createComment = async(content, parent_comment_id, idEntity = null, typeEntity = null) => {
        if(content.length < 3) {
            notification.warning('Минимальный размер сообщения 3 символа')
            return
        }
        const entity_type = route.meta.entity_type || typeEntity
        const entity_id = Number(route.params.id) || idEntity

        const data = await apiCall(() => api.post(`/comments/${entity_type}/${entity_id}`, {
            entity_type: entity_type,
            entity_id: entity_id,
            parent_comment_id:  parent_comment_id,
            content: content
        }), 'Комментарий опубликован') 
        return data.success
    }

    const deleteComment = async(commentId) => {
        if(!isAuthenticated && authStore.user?.id !== comment.user_id) return

        const data = await apiCall(() => api.delete(`/comments/${commentId}/delete`), 'Комментарий удалён')
        if(data.status === 204) {
            return true
        }

        return false
    }

    const editComment = async(idComment, content) => {
        if(content.length < 3) {
            notification.warning('Минимальный размер сообщения 3 символа')
            return
        }
        if(!isAuthenticated && authStore.user?.id !== comment.user_id) return

        const data = await apiCall(() => api.put(`/comments/${idComment}/edit`, { content }), 'Комментарий изменён')
        return data.success
    }

    

    const handleComment = async (type, entity) => {
        await loadComments()
        if(entity) {
            const entityData = unref(entity)  
            if(type === 'added') {
                entityData.comments_count += 1
            } else if(type === 'deleted') {
                entityData.comments_count -= 1
            }
        }
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

    
    return { comments, loadComments, scrollToCommentsIfNeeded, likeEntity, handleComment, createComment,
        deleteComment, editComment
     }
}

