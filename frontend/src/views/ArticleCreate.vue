<script setup>
import { computed, ref } from 'vue'
import api from '../utils/axios'
import { storeToRefs } from 'pinia'
import { useAuthStore } from '../stores/authStore'
import TextEditor from '../components/TextEditor.vue'

import { useNotifications } from '../stores/notifications'
import { useApiNotifications } from '../composables/useApi'

const { apiCall } = useApiNotifications()
const notification = useNotifications()

const authStore = useAuthStore()
const { isAuthenticated, user } = storeToRefs(authStore)

const isAuthorized = computed(() => 
    isAuthenticated.value && [2, 4].includes(user.value?.role)
)

const form = ref({
    title: '',
    category: '',
    image: '',
    content: '<p class="text-content">Начните писать здесь...</p>'
})

const validateForm = () => {
    if(!form.value.title.trim()) {
        notification.warning('Заголовок обязателен')
        return false
    }
    if(!form.value.category.trim()) {
        notification.warning('Категория обязательна')
        return false
    }
    if(!form.value.image.trim()) {
        notification.warning('Превью обязательно')
        return false
    }
    if(!form.value.content.trim() || 
        form.value.content === '<p class="text-content">Начните писать здесь...</p>') {
        notification.warning('Напишите содержимое новости')   
        return false
    }
    return true
}

const resetForm = () => {
    form.value = {
        title: '',
        category: '',
        image: '',
        content: '<p class="text-content">Начните писать здесь...</p>'
    }
}

const submitNews = async () => {
    if(!validateForm()) return
    
    const data = await apiCall(() => api.post('/article/createArticle', form.value), 'Статья опубликована')
    if(data.success) {
        setTimeout(resetForm, 1500)  
    }
}
</script>

<template>
    <div class="container" v-if="isAuthorized">
        <div class="wrapper-container flex-column">
            <h1>Добавление статьи</h1>
            
            <input 
                v-model="form.title" 
                type="text" 
                class="field no-border"
                :class="{'active': form.title}"
                placeholder="Заголовок"
            />
            
            <select v-model="form.category" class="field no-border" 
                :class="{'active': form.category}">
                <option value="" disabled hidden selected class="empty-option">
                    Категория статьи
                </option>
                <option value="reviews">Обзор</option>
                <option value="selections">Подборка игр</option>
            </select>

            <input 
                v-model="form.image" 
                type="text" 
                class="field no-border" 
                :class="{'active': form.image}"
                placeholder="URL-превью"
            />
            
            <TextEditor v-model="form.content"/>
            
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

    .field.active {
        border-left: 3px solid var(--font-secondary);
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