<script setup>
    import { ref, nextTick } from 'vue'
    import { formatDate } from '@utils/date/formatDate';
    import { useInteractions } from '@composables/useInteractions';
    import { useModeration } from '@composables/useModeration';
    import { useAuthStore } from '@stores/authStore'
    import { storeToRefs } from 'pinia'

    import ConfirmPopUp from '@components/popups/ConfirmPopUp.vue';
    import BanModal from '@components/BanModal.vue';
    import ModerationPopUp from '@components/ModerationPopUp.vue';

    const authStore = useAuthStore()
    const { moderateComment } = useModeration()
    const { isAuthenticated, user } = storeToRefs(authStore)

    const { formatDate1 } = formatDate();

    const { createComment, deleteComment, editComment } = useInteractions()

    const props = defineProps({
        comment: Object
    })

    const emit = defineEmits(['reply-added', 'reply-deleted', 'reply-edited', 'reloadComments']);

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

    // Модерка
    
    const isBanModal = ref(false)

    const handleReloadComments = (value) => {
        emit('reloadComments', value)
    }

    // Модерка удаление

    
    const handleModerateDelete = async (reason) => {
        const success = await moderateComment(props.comment.idComment, reason)

        if (success) {
            emit('reply-deleted')
        }
    }

    const isModeration = ref(false)


</script>

<template>
    <ConfirmPopUp
        v-model="isVisible"
        :label="'комментарий'"
        @confirm="handelDelete()"
    />
    <BanModal
        :model-value="isBanModal"
        :nickname="props.comment.nickname"
        :type="'comment'"
        :user_id="props.comment.user_id"
        :entity_id="props.comment.idComment"
        :text="'комментариям'"
        @update:model-value="isBanModal = false"
        @reload-comments="handleReloadComments"
    />
    <ModerationPopUp
        v-model="isModeration"
        :label="'комментарий'"
        @confirm="handleModerateDelete"
    />
    <div class="reply-comment flex-column">
        <div class="wrapper-container flex">
            <div class="author-img flex" v-if="props.comment.author_avatar">
                <RouterLink :to="`/user/${props.comment.nickname}`">
                    <img :src="props.comment.author_avatar" @error="props.comment.author_avatar = null">
                </RouterLink>
            </div>
            <div class="comment-content flex-column">
                <div class="top-content flex-column">
                    <div class="reply-header flex align-c">
                        <RouterLink :to="`/user/${props.comment.author_name}`" class="author-name">{{ props.comment.author_name }}</RouterLink>
                        <span>⮞</span>
                        <RouterLink :to="`/user/${props.comment.author_name}`" class="author-name">{{ props.comment.parent_name }}</RouterLink>
                    </div>
                    <span class="date-publish">{{ formatDate1(props.comment.created_at) }}</span>
                </div>
                
                <div v-if="!isEdit" class="middle-content">
                    <p>{{ props.comment.content }}</p>
                </div>

                <div v-else-if="isEdit && user?.id === props.comment.user_id" class="middle-content active flex-column">
                    <textarea v-model="editContent"
                        class="no-border field-reply" 
                        placeholder="Ваш комментарий"
                        @input="adjustHeight">
                    </textarea>
                    <div class="reply-btns flex align-c">
                        <button class="no-border send-reply send-reply-v2" @click="handleEdit()">Редактировать</button>
                        <button class="no-border send-reply send-reply-v2" @click="closeOnConfirmEdit()">Отменить</button>
                    </div>
                </div>
                
                <div class="comment-content__btn flex align-c">
                    <button v-if="!visibleForm && isAuthenticated" @click="toggleReplyForm()" class="no-border respond-btn">
                        Ответить
                    </button>
                    <button v-if="user?.id === props.comment.user_id" @click="onConfirmDelete()" class="no-border handle-btn  flex-center"> 
                        <svg class="svg">
                            <use href="#delete-comment"></use>
                        </svg>
                    </button>
                    <button v-if="!isEdit && user?.id === props.comment.user_id" @click="onConfirmEdit()" class="no-border handle-btn flex-center">
                        <svg class="svg">
                            <use href="#edit-comment"></use>
                        </svg>
                    </button>
                </div>

                <div v-if="user?.role === 3 || user?.role === 4" class="flex align-c moder-block" style="gap: var(--gp-8);">
                    <button @click="isBanModal = true" class="no-border handle-btn flex-center">
                        Заблокировать
                    </button>
                    <button @click="isModeration = true" class="no-border handle-btn flex-center">
                        Удалить
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

    .moder-block button{
        color: var(--font-primary-75);
    }

    .moder-block button:hover{
        color: var(--font-primary);
    }

    .handle-btn {
        width: fit-content;
    }

    .svg {
        width: 24px;
        height: 24px;
        color: var(--font-primary-25);
    }

    .handle-btn:hover .svg {
        color: var(--font-primary);
    }

    .reply-comment {
        width: 100%;
        gap: var(--gp-10);
    }

    .wrapper-container {
        width: 100%;
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
        width: 100%;
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

    .author-name:hover {
         color: var(--font-primary);
    }

    .date-publish {
        font-size: 14px;
        color: var(--font-primary-50);
    }

    .middle-content p {
        font-size: 16px;
    }

    
    .middle-content.active {
        padding: 16px;
        border-radius: 8px;
        border: 2px solid var(--btn-color-4);
        gap: var(--gp-4);
    }


    .respond-btn {
        width: fit-content;
        padding: 6px 12px;
        background-color: var(--btn-color-4);
        border-radius: 8px;
        font-size: 12px;
    }

    .respond-btn:hover {
        background-color: var(--font-primary-25);
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
        border-radius: 8px;
        padding: 8px 12px;
    }

    .send-reply:hover {
        background-color: var(--font-primary-25);
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