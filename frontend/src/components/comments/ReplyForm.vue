<script setup>
    import { ref, } from 'vue'
    import { autoResizeTextarea } from '@utils/dom/textareaAutoresize'
    import { useInteractions } from '@composables/useInteractions';

    const { createComment } = useInteractions()

    const props = defineProps({
        idComment: Number,
        entity_id: Number,
        entity_type: String,
    })

    const emits = defineEmits(['reply-added', 'closed'])

    const replyContent = ref('')

    const handleSubmit = async () => {
        const success = await createComment(replyContent.value.trim(), props.idComment)
        if(success) emits('reply-added');
    }
</script>

<template>
    <div class="reply-form flex-column">
        <textarea v-model="replyContent" 
            class="no-border reply-form__field" 
            placeholder="Ваш комментарий"
            @input="autoResizeTextarea">
        </textarea>
        <div class="reply-form__btns flex align-c">
            <button @click="handleSubmit" class="no-border btn-reply">Отправить</button>
            <button @click="emits('closed')" class="no-border btn-reply">Отменить</button>
        </div>
    </div>
</template>

<style lang="scss" scoped>
    .reply-form {
        width: 100%;
        background-color: var(--bg-secondary-25);
        border-radius: 8px;
        padding: 16px;
        gap: var(--gp-10);

        &__field {
             width: 100%;
            height: 32px;
            min-height: 32px;
            resize: none;
            overflow: hidden;
            font-size: 16px;
        }

        &__btns {
            gap: var(--gp-10);

            .btn-reply {
                width: fit-content;
                font-size: 14px;
                background-color: var(--btn-color-4);
                border-radius: 8px;
                padding: 8px 12px;

                &:hover {background-color: var(--font-primary-25);}
            }
        }
    }
</style>