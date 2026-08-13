<script setup>
    import { ref, nextTick } from 'vue'
    import { formatDate } from '@utils/date/formatDate'
    import { useInteractions } from '../../composables/useInteractions';
    import { useModeration } from '../../composables/useModeration';
    import { useAuthStore } from '../../stores/authStore'
    import { storeToRefs } from 'pinia'
    import { onAvatarError } from '../../utils/helpers/onImageError'

    import BanModal from '@components/BanModal.vue';
    import ConfirmPopUp from '@components/popups/ConfirmPopUp.vue';
    import ModerationPopUp from '@components/ModerationPopUp.vue';
    import CommentReply from '@components/Comments/CommentReply.vue'
    import EditBlock from './EditBlock.vue';
    import ReplyForm from './ReplyForm.vue';

    const { moderateComment } = useModeration()
    const { deleteComment } = useInteractions()
    const authStore = useAuthStore()
    const { isAuthenticated, user } = storeToRefs(authStore)
    const { formatDate1 } = formatDate();

    const props = defineProps({
        comment: Object,
        mode: {
            type: String,
            default: 'default',
            validator: (value) => ['default', 'profile', 'news'].includes(value)
        }
    })
    const emit = defineEmits(['reply-added', 'reply-deleted', 'reply-edited', 'reloadComments']);

    const isConfirmPopup = ref(false)
    const onConfirmDelete = () => isConfirmPopup.value = true

    const handleDelete = async () => {
        const success = await deleteComment(props.comment.idComment, props.comment.user_id)
        if (success) emit('reply-deleted')
    }

    const handleModerateDelete = async (reason) => {
        const success = await moderateComment(props.comment.idComment, reason)

        if (success) {
            emit('reply-deleted')
        }
    }

    const visibleForm = ref(false)

    const handleSubmit = () => {
        emit('reply-added')
        visibleForm.value = false
    }

    const toggleReplyForm = () => visibleForm.value = !visibleForm.value

    // редактирование

    const isEdit = ref(false)
    const onConfirmEdit = () => isEdit.value = !isEdit.value
    const handleEdit = (value) => {
        props.comment.content = value
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
        v-model="isConfirmPopup"
        :label="'комментарий'"
        @confirm="handleDelete"
    />

    <BanModal
        :model-value="isBanModal"
        :nickname="props.comment.author_name"
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

        <div v-if="props.mode === 'profile' && props.comment?.entity_title" class="mode-block">
            <RouterLink class="mode-block__link" :to="`/${props.comment?.entity_type}/${props.comment.entity_id}`">
               {{ props.comment?.entity_title }}
            </RouterLink>
        </div>
        <span v-if="props.comment.status === 'hidden'" class="reason">Причина: {{ props.comment?.reason }}</span>

        <div class="comment__wrapper flex">
            <RouterLink :to="`/user/${props.comment.author_name}`" class="author__link">
                <img loading="lazy" :src="props.comment.author_avatar || ''" @error="onAvatarError" class="author__avatar">
            </RouterLink>
            <div class="comment__content flex-column">
                <div class="comment__top flex-column">
                    <RouterLink :to="`/user/${props.comment.author_name}`" class="author__name">{{ props.comment.author_name }}</RouterLink>
                    <span class="date-publish">{{ formatDate1(props.comment.created_at) }}</span>
                </div>
                
                <p v-if="!isEdit" class="comment__p">{{ props.comment.content }}</p>
    
                <EditBlock v-else-if="isEdit && user?.id === props.comment.user_id"
                    :id-comment="props.comment.idComment"
                    :content="props.comment.content"
                    :author_id="props.comment.user_id"
                    @closed="isEdit = false"
                    @edited="handleEdit"
                />

                <div v-if="!visibleForm && isAuthenticated && !isEdit" class="middle-content__btns flex align-c">
                    <button @click="toggleReplyForm" class="no-border respond-btn">
                        Ответить
                    </button>
                    <button v-if="user?.id === props.comment.user_id" @click="onConfirmDelete" class="no-border handle-btn  flex-center"> 
                        <svg class="svg">
                            <use href="#delete-comment"></use>
                        </svg>
                    </button>
                    <button v-if="!isEdit && authStore.user?.id === props.comment.user_id" @click="onConfirmEdit" class="no-border handle-btn flex-center">
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
    
                <ReplyForm v-if="visibleForm && isAuthenticated"
                    :id-comment="props.comment.idComment"
                    @reply-added="handleSubmit"
                    @closed="visibleForm = false"
                />
                
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

<style lang="scss" scoped>

    .mode-block {
        &__link {
            font-family: Roboto_Medium;
            color: var(--font-primary-75);

            &:hover {
                color: var(--color-white);
            }
        }   
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

        &__wrapper {
            gap: var(--gp-16);
        }   

        &__content {
            width: 100%;
            font-family: Roboto_Medium;
            gap: var(--gp-12);
            flex-shrink: 1;
        }

        &__p {
            font-size: 18px;
            @media (max-width:599px) {
                font-size: 16px;
            }
        }
    }

    .author {
        &__link {
            max-width: 48px;
            max-height: 48px;
            width: 100%;
            aspect-ratio: 1 / 1;
            overflow: hidden;
            border-radius: 50%;
            display: block;

            @media (max-width: 599px) {
                max-width: 36px;
                max-height: 36px;
            }
        }

        &__avatar {
            width: 100%;
            height: 100%;
            display: block;
        }

        &__name {
            width: fit-content;
            font-size: 18px;
            color: var(--font-primary-75);

            &:hover{color: var(--color-white);}

            @media (max-width:599px) {
                font-size: 14px;
            }
        }
    }


    .date-publish {
        font-size: 16px;
        color: var(--font-primary-50);
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

    .reason {
        font-family: Roboto_Medium;
        color: var(--btn-color-2);
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
        .moder-block {
            font-size: 14px
        }

        .respond-btn {
            font-size: 14px;
        }

        .date-publish {
            font-size: 12px;
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