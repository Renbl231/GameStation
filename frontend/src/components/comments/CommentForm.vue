<script setup>
    import { ref } from 'vue'
    import { useInteractions } from '@composables/useInteractions';

    const { createComment } = useInteractions()
    const content = ref('')
    const emit = defineEmits(['comment-added'])

    const handleSubmit = async () => {
        const success = await createComment(content.value.trim())
        if(success) {
            content.value = '';
            emit('comment-added');
        }
    }

    const adjustHeight = () => {
        const textarea = event.target
        textarea.style.height = '0px'
        textarea.style.height = `${textarea.scrollHeight}px`
    }


</script>

<template>
    <div class="comment-block flex-column">
        <textarea v-model="content" class="no-border field-comment" placeholder="Ваш комментарий" @input="adjustHeight"></textarea>
        <button @click="handleSubmit()" type="button" class="no-border send-comment">Отправить</button>
    </div>
</template>

<style scoped>

    .comment-block {
        width: 100%;
        background-color: var(--bg-secondary-25);
        border-radius: 8px;
        padding: 16px;
        gap: var(--gp-4);
    }

    .field-comment {
        width: 100%;
        height: 32px;
        min-height: 32px;
        resize: none;
        overflow: hidden;
        font-size: 16px;
        font-family: Roboto_Medium;
    }

    .send-comment {
        width: fit-content;
        font-size: 14px;
        background-color: var(--btn-color-4);
        border-radius: 8px;
        padding: 8px 16px;
        font-family: Roboto_Medium;
    }

    .send-comment:hover {
        background-color: var(--font-primary-25);
    }

    @media (max-width:599px) {
        .field-comment {
            font-size: 16px;
        }
    }
</style>