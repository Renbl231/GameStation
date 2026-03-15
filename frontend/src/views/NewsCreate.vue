<script setup>
import { computed, ref } from 'vue'
import api from '../utils/axios'
import { storeToRefs } from 'pinia'
import { useAuthStore } from '../stores/authStore'
import TextEditor from '../components/TextEditor.vue'

const authStore = useAuthStore()
const { isAuthenticated, user } = storeToRefs(authStore)

const isAuthorized = computed(() => 
    isAuthenticated.value && [2, 4].includes(user.value?.role)
)

const form = ref({
    title: '',
    category: '',
    short_content: '',
    image: '',
    content: '<p class="text-content">Начните писать здесь...</p>'
})

const error = ref('')

// 🔥 ВАЛИДАЦИЯ
const validateForm = () => {
    if(!form.value.title.trim()) {
        error.value = 'Заголовок обязателен'
        return false
    }
    if(!form.value.category.trim()) {
        error.value = 'Категория обязательна'
        return false
    }
    if(!form.value.short_content.trim()) {
        error.value = 'Краткое описание обязательно'
        return false
    }
    if(!form.value.image.trim()) {
        error.value = 'Фото обязательно'
        return false
    }
    if(!form.value.content.trim() || 
        form.value.content === '<p class="text-content">Начните писать здесь...</p>') {
        error.value = 'Напишите содержимое новости'
        return false
    }
    error.value = ''
    return true
}

const resetForm = () => {
    form.value = {
        title: '',
        category: '',
        short_content: '',
        image: '',
        content: '<p class="text-content">Начните писать здесь...</p>'
    }
    error.value = ''
}

const submitNews = async () => {
    if(!validateForm()) return
    
    try {
        const { data } = await api.post('/news/createNews', form.value)
        
        if(data.success) {
            error.value = 'Новость опубликована!'
            setTimeout(resetForm, 1500)  
        }
    } catch(err) {
        error.value = err.response?.data?.error || 'Ошибка сервера'
    }
}
</script>

<template>
    <div class="container" v-if="isAuthorized">
        <div class="wrapper-container flex-column">
            <h1>Добавление новости</h1>
            
            <input 
                v-model="form.title" 
                type="text" 
                class="field no-border" 
                placeholder="Заголовок"
            />
            
            <select v-model="form.category" class="field no-border">
                <option value="" disabled hidden selected class="empty-option">
                    Категория новости
                </option>
                <option value="Анонсы">Анонсы</option>
                <option value="Релизы">Релизы</option>
                <option value="Индустрия">Индустрия</option>
                <option value="Слухи">Слухи</option>
                <option value="Патчи">Обновления</option>
                <option value="Консоли">Консоли</option>
                <option value="PC">PC</option>
                <option value="VR">VR</option>
            </select>

            <input 
                v-model="form.short_content" 
                type="text" 
                class="field no-border" 
                placeholder="Новость в кратце"
            />
            
            <input 
                v-model="form.image" 
                type="text" 
                class="field no-border" 
                placeholder="URL-фотография"
            />
            
            <TextEditor v-model="form.content" />
            
            <div v-if="error" class="error-span">{{ error }}</div>

            <button @click="submitNews" type="button" class="no-border send-btn">
                Опубликовать
            </button>
        </div>
    </div>
    
    <div v-else class="access-denied">
        <p>ПОШЁЛ НАХ*Й со страницы</p>
    </div>
</template>

<style scoped>

    .error-span {
        font-size: 24px;
        color: var(--btn-color-2);
        text-align: center;
    }

    .container {
        width: 100%;
        padding-inline: 96px;
        padding-block: 64px;
        background-color: var(--bg-third-25);
        border: 1px solid var(--bg-third-100);
        border-radius: 32px;
    }

    .wrapper-container {
        max-width: 736px;
        width: 100%;
        margin: 0 auto;
        gap: var(--gp-32);
        font-family: Roboto_Medium;
        font-size: 20px;
        gap: var(--gp-32);
    }

    .wrapper-container h1 {
        font-size: 32px;
        font-family: Roboto_Bold;
    }

    .field {
        width: 100%;
        background-color: #1B1C21;
        padding: 12px 16px;
        border-radius: 8px;
        border-left: 3px solid var(--btn-color-2);
        color: var(--font-primary-75);
    }

    .field::placeholder {
        color: var(--font-primary-25);
    }

    select {
        width: 100%;
        overflow: hidden;
        text-overflow: ellipsis;
        white-space: nowrap;
        cursor: pointer;
        appearance: none;
        background: url('../assets/icons/arrow.svg') no-repeat right 16px center;
        background-size: 16px;
        padding-right: 36px !important; 
    }

    .editor-content:focus { 
        border-color: #4f46e5; box-shadow: 0 0 0 3px rgba(79, 70, 229, 0.1);
    }

    .field option {
        color: #fff;
        background: #1B1C21;
        font-size: 16px;
    }

    .send-btn {
        width: 100%;
        background-color: var(--font-secondary);
        padding-block: 10px;
        border-radius: 8px;
        font-size: 16px;
    }

    @media (max-width: 1160px) {
        .container {
            border-radius: 0px;
        }

    }

     @media (max-width:1024px) {
        .container {
            padding-inline: 48px;
        }
        
    }

    @media (max-width:500px) {
        .container {
            padding-inline: 16px;
            padding-block: 32px;
        }

        .wrapper-container h1 {
            font-size: 28px;
        }

        .wrapper-container {
            font-size: 18px;
        }
    }

</style>