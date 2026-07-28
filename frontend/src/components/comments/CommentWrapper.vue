<script setup>
    import { ref, onMounted, } from 'vue'
    import { storeToRefs } from 'pinia';
    import { useAuthStore } from '@stores/authStore';
    import { useInteractions } from '@composables/useInteractions'

    import Comment from '@components/comments/Comment.vue';
    import CommentForm from '@components/comments/CommentForm.vue';

    const authStore = useAuthStore()
    const { isAuthenticated } = storeToRefs(authStore)
    const { 
        comments, 
        loadComments,
        handleComment, 
        scrollToCommentsIfNeeded 
    } = useInteractions()

    const props = defineProps({
        counter: Number,
    })

    const counterComments = ref(props.counter)

    const reloadComments = async (value) => {
        if(value) {
            await loadComments()
            counterComments--
        } 
    }

    onMounted(async () => {
        await loadComments()
        await scrollToCommentsIfNeeded() 
    })
</script>

<template>
    <div class="comment-wrapper flex-column">
        <span class="comment-wrapper__label">Комментарии ({{ counterComments }})</span>   

        <div class="comments-block flex-column">
            <Comment
                v-for="comment in comments" 
                :comment="comment" 
                @reply-added="handleComment('added', article)"
                @reply-deleted="handleComment('deleted', article)"
                @reply-edited="handleComment()"
                @reload-comments="reloadComments"
            />
            <CommentForm v-if="isAuthenticated" @comment-added="handleComment('added', article)"/>
        </div>
    </div>
</template>

<style lang="scss" scoped>
    .comment-wrapper {
        width: 100%;
        gap: var(--gp-16);
        margin-top: 24px;

        &__label {
            font-size: 32px;
            font-family: Roboto_SemiBold;
        }

        .comments-block {
            gap: var(--gp-24);
        }
    }


</style>