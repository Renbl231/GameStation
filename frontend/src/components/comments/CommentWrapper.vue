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
        scrollToCommentsIfNeeded 
    } = useInteractions()

    const props = defineProps({
        counter: Number,
    })

    const counterComments = ref(props.counter)

    const handleComment = async (action) => {
        if(action === 'added') counterComments.value ++       
        else if(action === 'deleted') counterComments.value --
        await loadComments()
    }

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
    <section class="comment-wrapper flex-column">
        <h2 class="comment-wrapper__label">Комментарии ({{ counterComments }})</h2>   

        <div class="comments-block flex-column">
            <Comment
                v-for="comment in comments" 
                :comment="comment" 
                @reply-added="handleComment('added')"
                @reply-deleted="handleComment('deleted')"
                @reply-edited="handleComment()"
                @reload-comments="reloadComments"
            />
            <CommentForm v-if="isAuthenticated" @is-added="handleComment('added')"/>
        </div>
    </section>
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