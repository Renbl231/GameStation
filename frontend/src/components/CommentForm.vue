<script setup>
    import { ref } from 'vue'
    import api from '../utils/axios'
    import { useRoute } from 'vue-router'

    const route = useRoute()
    const content = ref('')
    const emit = defineEmits(['comment-added'])

    const handleSubmit = async () => {
            if(content.value.length < 3) {
                return
            }
    
            const entity_type = route.meta.entity_type
            const entity_id = Number(route.params.id)
    
            const { data } = await api.post(`/comments/${entity_type}/${entity_id}`, {
                content: content.value.trim(), entity_type: entity_type, entity_id: entity_id
            })
    
            if(data.success) {
                content.value = ''
                emit('comment-added')
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
        gap: var(--gp-10);
    }

    .field-comment {
        width: 100%;
        height: 32px;
        min-height: 32px;
        resize: none;
        overflow: hidden;
        font-size: 18px;
    }

    .send-comment {
        width: fit-content;
        font-size: 14px;
        background-color: var(--btn-color-4);
        border-radius: 256px;
        padding: 8px 16px;
    }

    @media (max-width:599px) {
        .field-comment {
            font-size: 16px;
        }
    }
</style>