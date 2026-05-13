<script setup>
    import { ref, nextTick } from 'vue'
    import { useFormatDate } from '../composables/useFormatDate'
    import { useInteractions } from '../composables/useInteractions';
    import { useModeration } from '../composables/useModeration';
    import { useAuthStore } from '../stores/authStore'
    import { storeToRefs } from 'pinia'
    import { onAvatarError } from '../helpers/onImageError'

    import BanModal from '../components/BanModal.vue';
    import ConfirmPopUp from '../components/ConfirmPopUp.vue';
    import ModerationPopUp from '../components/ModerationPopUp.vue';
    import CommentReply from './CommentReply.vue'

    const { moderateComment } = useModeration()
    const { createComment, deleteComment, editComment } = useInteractions()
    const authStore = useAuthStore()
    const { isAuthenticated, user } = storeToRefs(authStore)
    const { formatDate } = useFormatDate();

    const props = defineProps({
        comment: Object,
        mode: {
            type: String,
            default: 'default',
            validator: (value) => ['default', 'profile', 'news'].includes(value)
        }
    })
    const emit = defineEmits(['reply-added', 'reply-deleted', 'reply-edited', 'reloadComments']);

    const replyContent = ref('')
    const visibleForm = ref(false)

    const handleSubmit = async () => {
        const success = await createComment(replyContent.value.trim(), props.comment.idComment, props.comment.entity_id, props.comment.entity_type)
        if(success) {
            replyContent.value = '';
            toggleReplyForm();
            emit('reply-added');
        }
    }

    const isVisiblePopup = ref(false)
    
    const onConfirmDelete = async() => {
        isVisiblePopup.value = true
    }

    const handleDelete = async () => {
        const success = await deleteComment(props.comment.idComment)

        if (success) {
            emit('reply-deleted')
        }
    }

    const handleModerateDelete = async (reason) => {
        const success = await moderateComment(props.comment.idComment, reason)

        if (success) {
            emit('reply-deleted')
        }
    }

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

    // Модерка №2

    const isModeration = ref(false)


</script>


<template>
     <ConfirmPopUp 
        v-model="isVisiblePopup"
        :label="'комментарий'"
        @confirm="handleDelete()"/>
        <BanModal
            :model-value="isBanModal"
            :nickname="props.comment.nickname"
            :type="'comment'"
            :user_id="props.comment.user_id"
            :entity_id="props.comment.idComment"G
            :text="'комментариям'"
            @update:model-value="isBanModal = false"
            @reload-comments="handleReloadComments"
        />
        <ModerationPopUp
            v-model="isModeration"
            :label="'комментарий'"
            @confirm="handleModerateDelete"
        />
     <div class="comment flex-column">
        <div v-if="props.mode === 'profile'" class="mode-block">
            <RouterLink class="mode-block__link" :to="`/${props.comment?.entity_type}/${props.comment.entity_id}`">
               {{ props.comment?.entity_title }}
            </RouterLink>
        </div>
        <div class="comment-wrapper flex">
            <div class="author-img flex" v-if="props.comment.publisherCom_avatar">
                <RouterLink :to="`/user/${props.comment.nickname}`">
                    <img :src="props.comment.publisherCom_avatar || '/images/plug_avatar.png'" @error="onAvatarError">
                </RouterLink>
            </div>
            <div class="comment-content flex-column">
                <div class="top-content flex-column">
                    <RouterLink :to="`/user/${props.comment.nickname}`" class="author-name">{{ props.comment.nickname }}</RouterLink>
                    <span class="date-publish">{{ formatDate(props.comment.created_at) }}</span>
                </div>
                
                <div v-if="!isEdit" class="middle-content">
                    <p>{{ props.comment.content }}</p>
                </div>
    
                <div v-else-if="isEdit && authStore.user?.id === props.comment.user_id" class="middle-content active flex-column">
                    <textarea v-model="editContent"
                        class="no-border field-reply" 
                        @input="adjustHeight"
                        placeholder="Ваш комментарий">
                    </textarea>
                    <div class="reply-btns flex align-c">
                        <button class="no-border send-reply edit-send" @click="handleEdit()">Редактировать</button>
                        <button class="no-border send-reply edit-send" @click="closeOnConfirmEdit()">Отменить</button>
                    </div>
                </div>
                <div class="middle-content__btns flex align-c">
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
                    <button v-if="isAuthenticated" class="no-border handle-btn flex-center"> 
                        <svg class="svg">
                            <use href="#icon-attention"></use>
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
                        @reload-comments="handleReloadComments"
                    />
                </div>
            </div>
        </div>
    </div>

</template>

<style scoped>

    .mode-block__link {
        font-family: Roboto_Medium;
        color: var(--font-primary-75);
    }

    .mode-block__link:hover {
        color: var(--font-primary);
    }

    .middle-content__btns {
        width: 100%;
        gap: var(--gp-8);
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

    .comment {
        width: 100%;
        gap: var(--gp-10);
        background-color: var(--bg-secondary-25);
        border-radius: 8px;
        padding: 16px;
    }

    .comment-wrapper {
        gap: var(--gp-16);
    }

    .author-img {
        max-width: 48px;
        width: 100%;
        height: fit-content;
    }

    .author-img img {
        width: 48px;
        height: 48px;
        border-radius: 50%;
    }
    
    .comment-content {
        width: 100%;
        font-family: Roboto_Medium;
        gap: var(--gp-12);
        flex-shrink: 1;
    }

    .author-name {
        width: fit-content;
        font-size: 18px;
        color: var(--font-primary-75);
    }

    .author-name:hover {
         color: var(--font-primary);
    }

    .date-publish {
        font-size: 16px;
        color: var(--font-primary-50);
    }

    .middle-content p {
        font-size: 18px;
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
        font-size: 14px;
    }

    .respond-btn:hover {
        background-color: var(--font-primary-25);
    }

    /* БЛОК ответа изменить потом */

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

    /* Модер блок */

    .moder-block button{
        color: var(--font-primary-75);
    }

    .moder-block button:hover {
        color: var(--font-primary);
    }

    /* Блок с дочерними комментами */

    .replies-wrapper {
        gap: var(--gp-16);
    }

    @media (max-width:599px) {
        .comment, .comment-content {
            gap: var(--gp-12);
        }

        .moder-block {
            font-size: 14px
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