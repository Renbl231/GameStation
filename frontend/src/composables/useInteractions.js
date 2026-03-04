import { ref, nextTick, watch, unref } from 'vue'
import { useRoute, useRouter } from 'vue-router'
import api from '../utils/axios'
import { useAuthStore } from '../stores/authStore'
import { storeToRefs } from 'pinia'

const authStore = useAuthStore()
const { isAuthenticated } = storeToRefs(authStore)

export const useInteractions = () => {
    const route = useRoute()
    const router = useRouter()
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

    const createComment = async(content, parent_comment_id) => {
        try {
            const entity_type = route.meta.entity_type
            const entity_id = Number(route.params.id)

            const { data } = await api.post(`/comments/${entity_type}/${entity_id}`, {
                entity_type: entity_type,
                entity_id: entity_id,
                parent_comment_id:  parent_comment_id,
                content: content   
            })

            if(data.success) {
                return true
            }

        } catch(error) {
            return false
        }
    }

    const deleteComment = async(commentId) => {
        if(!isAuthenticated && authStore.user?.id !== comment.user_id) return

        try {
            const { data } = await api.delete(`/comments/${commentId}/delete`)

            if(data.success) {
                return true
            }
        } catch(error) {
            return false
        }
    }

    

    const handleComment = async (type, entity) => {
        await loadComments()
        const entityData = unref(entity)  
        
        if(type === 'added') {
            entityData.comments_count += 1
        } else if(type === 'deleted') {
            entityData.comments_count -= 1
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
        } catch (error) {
            console.error('Like error:', error)
        } 
    }

    // скролл

    const scrollToCommentsIfNeeded = async () => {
        await nextTick();
        
        if(route.query.tab === 'comments') {
            const commentsSection = document.getElementById('comments-section');
            if(commentsSection) {
                commentsSection.scrollIntoView({ behavior: 'smooth', block: 'start' });
                
                setTimeout(async () => {
                    await router.replace({ 
                        query: {} 
                    });
                }, 1500);
            }
        }
    };

    watch(() => route.query.tab, scrollToCommentsIfNeeded, { immediate: true })

    
    return { comments, loadComments, scrollToCommentsIfNeeded, likeEntity, handleComment, createComment,
        deleteComment
     }
}
