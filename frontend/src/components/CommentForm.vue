<script setup>
    import { ref } from 'vue'
    import api from '../utils/axios'
    import { useRoute } from 'vue-router'

    const route = useRoute()
    const content = ref('')

    const handleSubmit = async () => {
        if(!content.value.length > 4) {
            return
        }

        const news_id = route.params.id

        const { data } = await api.post('/newsCreate', {
            content: content.value, news_id: news_id
        })

        if(data.success) {
            content.value = ''
            console.log('успешно добавлен')
        }
    }
</script>

<template>
    <div class="comment-block flex-column">
        <textarea v-model="content" class="no-border field-comment" placeholder="Ваш комментарий"></textarea>
        <button @click="handleSubmit()" type="button" class="no-border send-comment">Отправить</button>
    </div>
</template>

<style scoped>
    .comment-block {
        background-color: var(--bg-secondary-25);
        border-radius: 8px;
        padding: 16px;
        gap: var(--gp-24);
    }

    .field-comment {
        width: 100%;
        resize: none;
        overflow: hidden;
        field-sizing: content;
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