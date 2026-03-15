<script setup>
    import { ref, nextTick } from 'vue'
    import { useFormatDate } from '../composables/useFormatDate';
    import { useInteractions } from '../composables/useInteractions';
    import { useAuthStore } from '../stores/authStore'
    import { storeToRefs } from 'pinia'

    import ConfirmPopUp from '../components/ConfirmPopUp.vue';

    const authStore = useAuthStore()
    const { isAuthenticated } = storeToRefs(authStore)
    const { formatDate } = useFormatDate();

    const { createComment, deleteComment, editComment } = useInteractions()

    const props = defineProps({
        comment: Object
    })
    const emit = defineEmits(['reply-added', 'reply-deleted', 'reply-edited']);

    const replyContent = ref('')
    const visibleForm = ref(false)

    const adjustHeight = () => {
        const textarea = event.target
        textarea.style.height = '0px'
        textarea.style.height = `${textarea.scrollHeight}px`
    }

    const toggleReplyForm = () => {
        visibleForm.value = !visibleForm.value
        replyContent.value = ""
        nextTick(() => {
            if (visibleForm.value) {
                adjustHeight()
            }
        })
    }

    const handleSubmit = async () => {
        const success = await createComment(replyContent.value.trim(), props.comment.idComment)
        if(success) {
            replyContent.value = '';
            toggleReplyForm();
            emit('reply-added');
        }
    }

    const isVisible = ref(false)
    
    const onConfirmDelete = async() => {
        isVisible.value = true
    }

    const handelDelete = async() => {
        const success = await deleteComment(props.comment.idComment)

        if(success) {
            emit('reply-deleted');
        }
    }

    // редактирование

    const isEdit = ref(false)
    const editContent = ref('')
    const onConfirmEdit = () => {
        isEdit.value = true
        editContent.value = props.comment.content
    }
    const handleEdit = async () => {
        if(editContent.value.trim().length < 3) {
            return
        } 
        const success = await editComment(props.comment.idComment, editContent.value.trim())
        if(success) {
            emit('reply-edited')
            isEdit.value = false
            editContent.value = ''
        }
    }
    const closeOnConfirmEdit = () => {
        isEdit.value = false
    }

</script>

<template>
    <ConfirmPopUp
        v-model="isVisible"
        :label="'комментарий'"
        @confirm="handelDelete()"
        />
    <div class="reply-comment flex-column">
        <div class="wrapper-container flex">
            <div class="author-img flex">
                <RouterLink :to="`/user/${props.comment.nickname}`" class="author-name">
                    <img :src="props.comment.publisherCom_avatar">
                </RouterLink>
            </div>
            <div class="comment-content flex-column">
                <div class="top-content flex-column">
                    <div class="reply-header flex align-c">
                        <RouterLink :to="`/user/${props.comment.nickname}`" class="author-name">{{ props.comment.nickname }}</RouterLink>
                        <span>⮞</span>
                        <RouterLink :to="`/user/${props.comment.parent_nickname}`" class="author-name">{{ props.comment.parent_nickname }}</RouterLink>
                    </div>
                    <span class="date-publish">{{ formatDate(props.comment.created_at) }}</span>
                </div>
                
                <div v-if="!isEdit" class="middle-content">
                    <p>{{ props.comment.content }}</p>
                </div>

                <div v-else-if="isEdit && authStore.user?.id === props.comment.user_id" class="middle-content">
                    <textarea v-model="editContent"
                        class="no-border field-reply" 
                        @input="adjustHeight">
                    </textarea>
                    <div class="reply-btns flex align-c">
                        <button class="no-border send-reply" @click="handleEdit()">Редактировать</button>
                        <button class="no-border send-reply" @click="closeOnConfirmEdit()">Отменить</button>
                    </div>
                </div>
                
                <div class="comment-content__btn flex align-c">
                    <button v-if="!visibleForm && isAuthenticated" @click="toggleReplyForm()" class="no-border respond-btn">
                        Ответить
                    </button>
                    <button v-if="authStore.user?.id === props.comment.user_id" @click="onConfirmDelete()" class="no-border handle-btn  flex-center"> 
                        <svg class="svg">
                            <use href="#delete-comment"></use>
                        </svg>
                    </button>
                    <button v-if="!isEdit && authStore.user?.id === props.comment.user_id" @click="onConfirmEdit()" class="no-border handle-btn flex-center">
                        <svg class="svg">
                            <use href="#edit-comment"></use>
                        </svg>
                    </button>
                </div>
            </div>
        </div>
        
        <div v-if="visibleForm && isAuthenticated" class="reply-form flex-column">
            <textarea v-model="replyContent" 
                class="no-border field-reply" 
                placeholder="Ваш комментарий"
                @input="adjustHeight">
            </textarea>
            <div class="reply-btns flex align-c">
                <button @click="handleSubmit()" class="no-border send-reply">Отправить</button>
                <button @click="toggleReplyForm()" class="no-border send-reply">Отменить</button>
            </div>
        </div>

        <div v-if="props.comment.replies?.length" class="replies-wrapper flex-column">
            <CommentReply 
                v-for="reply in props.comment.replies"
                :key="reply.idComment"
                :comment="reply"
                @reply-added="$emit('reply-added')"
                @reply-deleted="$emit('reply-deleted')"
                @reply-edited="$emit('reply-edited')"
            />
        </div>
    </div>
</template>

<style scoped>

    .handle-btn {
        width: fit-content;
    }

    .svg {
        width: 24px;
        height: 24px;
        color: var(--font-primary-25);
        transition: 0.3s;
    }

    .handle-btn:hover .svg {
        color: var(--font-primary);
    }

    .reply-comment {
        width: 100%;
        gap: var(--gp-10);
    }

    .wrapper-container {
        gap: var(--gp-16);
    }

    .author-img {
        max-width: 32px;
        width: 100%;
    }

    .author-img img {
        width: 32px;
        height: 32px;
        border-radius: 50%;
    }
    
    .comment-content {
        font-family: Roboto_Medium;
        gap: var(--gp-16);
    }

    .reply-header {
        gap: var(--gp-4);
    }

    .author-name {
        font-size: 16px;
        color: var(--font-primary-75);
    }

    .date-publish {
        font-size: 14px;
        color: var(--font-primary-50);
    }

    .middle-content p {
        font-size: 16px;
    }

    .respond-btn {
        width: fit-content;
        padding: 6px 12px;
        background-color: var(--btn-color-4);
        border-radius: 128px;
        font-size: 12px;
    }

    /* Отправки ответа*/

    .reply-form {
        width: 100%;
        background-color: var(--bg-secondary-25);
        border-radius: 8px;
        padding: 16px;
        gap: var(--gp-10);
    }

    .reply-btns {
        gap: var(--gp-10);
    }

    .field-reply {
        width: 100%;
        height: 32px;
        min-height: 32px;
        resize: none;
        overflow: hidden;
        font-size: 16px;
    }

    .send-reply {
        width: fit-content;
        font-size: 14px;
        background-color: var(--btn-color-4);
        border-radius: 256px;
        padding: 8px 16px;
    }

    .comment-content__btn {
        gap: var(--gp-8);
    }

    /* конец */


    @media (max-width:599px) {
        .reply-comment, .comment-content {
            gap: var(--gp-12);
        }

        .author-img {
            max-width: 36px;
        }

        .author-img img {
            width: 36px;
            height: 36px;
        }

        .author-name, .respond-btn {
            font-size: 14px;
        }

        .date-publish {
            font-size: 12px;
        }

        .middle-content p, .field-reply {
            font-size: 16px;
        }

        .reply-form {
            padding: 12px;
        }
        .send-reply {
            font-size: 13px;
        }
    }

    @media (max-width:375px) {
        .send-reply {
            font-size: 12px;
            padding-inline: 12px;
        }
    }
</style>