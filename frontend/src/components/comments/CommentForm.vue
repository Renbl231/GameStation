<script setup>
    import { ref } from 'vue'
    import { useInteractions } from '@composables/useInteractions';
    import { autoResizeTextarea } from '@utils/dom/textareaAutoresize';

    const { createComment } = useInteractions()

    const content = ref('')
    const emit = defineEmits(['is-added'])

    const handleSubmit = async () => {
        const success = await createComment(content.value.trim())
        if(success) {
            content.value = '';
            emit('is-added');
        }
    }
</script>

<template>
    <div class="comment-form flex-column">
        <textarea v-model="content" class="no-border comment-form__field" placeholder="Ваш комментарий" @input="autoResizeTextarea"></textarea>
        <button @click="handleSubmit" type="button" class="no-border comment-form__btn">Отправить</button>
    </div>
</template>

<style lang="scss" scoped>

    .comment-form {
        width: 100%;
        background-color: var(--bg-secondary-25);
        border-radius: 8px;
        padding: 16px;
        gap: var(--gp-4);

        &__field {
            width: 100%;
            height: 32px;
            min-height: 32px;
            resize: none;
            overflow: hidden;
            font-size: 16px;
            font-family: Roboto_Medium;
        }

        &__btn {
            width: fit-content;
            font-size: 14px;
            background-color: var(--btn-color-4);
            border-radius: 8px;
            padding: 8px 16px;
            font-family: Roboto_Medium;

            &:hover {
                background-color: var(--font-primary-25);
            }
        }
    }

</style>