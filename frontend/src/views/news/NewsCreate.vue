<script setup>
import { computed, ref } from 'vue'
import { newsCategories } from '@constants/categories'
import api from '@utils/axios'
import { storeToRefs } from 'pinia'
import { useAuthStore } from '@stores/authStore'
import TextEditor from '@components/TextEditor.vue'

import { useNotifications } from '@stores/notifications'
import { useApiNotifications } from '@composables/useApi'

const { apiCall } = useApiNotifications()
const notification = useNotifications()

const authStore = useAuthStore()
const { isAuthenticated, user } = storeToRefs(authStore)

const isAuthorized = computed(() => 
    isAuthenticated.value && [2, 4].includes(user.value?.role)
)

const form = ref({
    title: '',
    category: null,
    short_content: '',
    image: null,
    content: '<p class="text-content">Начните писать здесь...</p>'
})

const validateForm = () => {
    if(!form.value.title.trim()) {
        notification.warning('Заголовок обязателен')
        return false
    }
    if(!Number(form.value.category)) {
        notification.warning('Категория обязательна')
        return false
    }
    if(!form.value.short_content.trim()) {
        notification.warning('Краткое описание обязательно')
        return false
    }
    if(!form.value.image) {
        notification.warning('Обложка обязательна')
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
        short_content: '',
        image: null,
        content: '<p class="text-content">Начните писать здесь...</p>'
    }
}

const MAX_FILE_SIZE = 3 * 1024 * 1024
const temporaryPhoto = ref(null)

const onMainImageChange = (event) => {
    const file = event.target.files?.[0]
    if (!file) return
    
    if (!file.type?.startsWith('image/')) {
        notification.warning('Только изображения')
        event.target.value = ''
        return
    }
    
    if (file.size > MAX_FILE_SIZE) {
        notification.warning('Файл слишком большой — максимум 3 МБ')
        event.target.value = ''
        return
    }
    
    form.value.image = file
    temporaryPhoto.value = URL.createObjectURL(file)
}



const submitNews = async () => {
    if (!validateForm()) return

    const fd = new FormData()
    fd.append('title', form.value.title)
    fd.append('category', form.value.category)
    fd.append('short_content', form.value.short_content)
    fd.append('content', form.value.content)
    fd.append('image', form.value.image)

    const data = await apiCall(() => api.post('/news/createNews', fd), 'Новость опубликована')

    if (data.success) {
        setTimeout(resetForm, 1500)
        temporaryPhoto.value = null
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
                :class="{'active': form.title}"
                placeholder="Заголовок"
            />
            
            <select v-model="form.category" class="field no-border" 
                :class="{'active': form.category}">
                <option value="" disabled hidden selected class="empty-option">
                    Категория новости
                </option>
                <option 
                    v-for="category in newsCategories" 
                    :key="category.id"
                    :value="category.id"
                    v-show="category.id !== null"
                >
                    {{ category.name }}
                </option>
            </select>

            <input 
                v-model="form.short_content" 
                type="text" 
                class="field no-border" 
                :class="{'active': form.short_content}"
                placeholder="Новость в кратце"
            />
                        
            <TextEditor v-model="form.content" :type="'news'" class="active"/>

            <div class="image-uploader flex-column">
                <div v-if="temporaryPhoto" class="preview-container">
                    <img :src="temporaryPhoto" class="preview-image"/>
                </div>
                <label class="upload-btn flex-center">
                    <input 
                        type="file"
                        accept="image/*"
                        class="upload-input"
                        @change="onMainImageChange"
                    />
                    <span class="upload-text">Загрузить превью</span>
                </label>
            </div>
            
            <button @click="submitNews" type="button" class="no-border send-btn">
                Опубликовать
            </button>
        </div>
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

     /* Превью */

    .image-uploader {
        gap: var(--gp-16);
    }

    .upload-btn {
        cursor: pointer;
        display: inline-flex;
        width: 100%;
        padding: 8px 16px;
        background-color: var(--btn-color-6-25);
        border-radius: 4px;
        text-align: center;
    }

    .upload-btn:hover {
        background-color: var(--btn-color-6-50);
    }

    .upload-input {
        display: none;
    }

    .upload-text {
        font-family: Roboto_Medium;
        font-size: 16px;
        color: var(--font-primary);
    }

    .preview-image {
        width: 100%;
        max-height: 300px;
        border-radius: 4px;
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