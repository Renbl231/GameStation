<script setup>
import { computed, ref, watch } from 'vue'
import { newsCategories } from '@constants/categories'
import { storeToRefs } from 'pinia'
import { useAuthStore } from '@stores/authStore'
import api from '@utils/axios'

import TextEditor from '@components/common/TextEditor.vue'
import Cropper from '@/components/common/Cropper.vue'

import { useNotifications } from '@stores/notifications'
import { useApiNotifications } from '@composables/useApi'

const notification = useNotifications()
const authStore = useAuthStore()

const { apiCall } = useApiNotifications()
const { isAuthenticated, user } = storeToRefs(authStore)

const isAuthorized = computed(() => isAuthenticated.value && [2, 4].includes(user.value?.role))

const form = ref({
    title: '',
    category: null,
    short_content: '',
    image: null,
    content: '<p class="text-content" style="font-size:18px; line-height:1.5; color: var(--text-secondary);">Контент</p>'
})


const isCrop = ref(false)


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
    if(!form.value.content.trim()) {
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
const temporaryCrop = ref(null)
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
    
    temporaryCrop.value = URL.createObjectURL(file)
}


watch(() => temporaryCrop.value, (value) => {
    isCrop.value = true
})

const fd = new FormData()

const submitNews = async () => {
    if (!validateForm()) return

    fd.append('title', form.value.title)
    fd.append('category_id', form.value.category)
    fd.append('short_content', form.value.short_content)
    fd.append('content', form.value.content)
    fd.append('image', form.value.image)
    

    const data = await apiCall(() => api.post('/news/createNews', fd), 'Новость опубликована')

    if (data.success) {
        setTimeout(resetForm, 1500)
        temporaryPhoto.value = null
    }
}

    const handleCrop = (croppedDataUrl) => {
        temporaryPhoto.value = croppedDataUrl

        const file = dataURLtoFile(croppedDataUrl, 'cropped-image.png')
        form.value.image = file
        
    }

    const dataURLtoFile = (dataURL) => {
        const arr = dataURL.split(',')
        const mime = arr[0].match(/:(.*?);/)[1]
        const bstr = atob(arr[1])
        let n = bstr.length
        const u8arr = new Uint8Array(n)
        while (n--) {
            u8arr[n] = bstr.charCodeAt(n)
        }
        
        const filename = `cropped-${Date.now()}.png`
        
        return new File([u8arr], filename, { type: mime })
    }

</script>

<template>
    <section v-if="isAuthorized" class="container flex-column">
        <h1>Добавление новости</h1>
        
        <input v-model="form.title" class="container__input no-border" placeholder="Заголовок"/>
        
        <select v-model="form.category" class="container__select no-border">
            <option value="null" disabled hidden selected class="container__option">
                Категория новости
            </option>
            <option 
                v-for="category in newsCategories" 
                :key="category.id"
                :value="category.id"
                v-show="category.id !== null"
                class="container__option"
            >
                {{ category.name }}
            </option>
        </select>

        <input v-model="form.short_content" class="container__input no-border" placeholder="Новость в кратце"/>
                    
        <TextEditor v-model="form.content" :type="'news'" class="editor"/>

        <Cropper
            v-model="isCrop"
            @crop="handleCrop"
            :temporary-photo="temporaryCrop"
            :aspect-ratio="16/9"
        />

        <div class="image-uploader flex flex-center">
            <picture v-if="temporaryPhoto">
                <img :src="temporaryPhoto" class="image-uploader__preview"/>
            </picture>
            <div class="flex-column flex-center" style="gap: var(--gp-16); padding:16px;">
                <label class="image-uploader__btn flex-center">
                    <input 
                        type="file"
                        accept="image/*"
                        class="image-uploader__input"
                        @change="onMainImageChange"
                    />
                    <span class="image-uploader__label">Загрузить превью</span>
                </label>
                <span class="image-uploader__txt">Рекомендуемый размер 16:9, до 5 МБ</span>
            </div>
        </div>
        
        <button @click="submitNews" type="button" class="no-border send-btn">
            Опубликовать
        </button>
    </section>
</template>

<style lang="scss" scoped>

    .container {
        max-width: 900px;
        width: 100%;
        margin: 0 auto;
        gap: var(--gp-24);
        padding: 48px;
        background-color: var(--bg-tertiary);
        border-radius: 16px;

        @media (max-width: 900px) {
            border-radius: 0px;
        }

        @media (max-width:500px) {
            padding: 32px;
        }

        h1 {
            font-size: 32px;
            font-family: Roboto_Bold;
            color: var(--text-primary);

            @media (max-width:500px) {
                font-size: 24px;
            }
        }

        &__input,
        &__select {
            width: 100%;
            background-color: var(--input-2-bg) !important;
            border: 1px solid var(--input-2-border);
            padding: 12px 16px;
            border-radius: 8px;
            color: var(--text-primary);
            font-family: Roboto_Medium;
            font-size: 16px;


            &::placeholder {
                color: var(--text-muted);
            }

            &:focus {
                outline: none;
                border-color: #4a90e2;
                box-shadow: 
                    0 0 0 2px rgba(74, 144, 226, 0.2),
                    0 0 20px rgba(74, 144, 226, 0.15),
                    inset 0 1px 3px rgba(0, 0, 0, 0.1);
                transition: all 0.25s ease;
            }
        }

        &__select {
            overflow: hidden;
            text-overflow: ellipsis;
            white-space: nowrap;
            cursor: pointer;
            appearance: none;
            background: url('../../assets/icons/arrow.svg') no-repeat right 16px center;
            background-size: 16px;
            padding-right: 36px !important; 
        }

    }

    .send-btn {
        width: 100%;
        background-color: var(--text-primary);
        color: var(--text-primary-r);
        padding-block: 10px;
        border-radius: 8px;
        font-size: 16px;
        font-family: Roboto_Medium;

        &:hover {
            background-color: var(--color-green);
            color: var(--color-white);
        }
    }

    /* Превью */

    .image-uploader {
        width: fit-content;
        margin: 0 auto;
        border-radius: 16px;

        &__btn {
            cursor: pointer;
            width: fit-content;
            padding: 8px 16px;
            border-radius: 256px;
            background-color: var(--color-gray-200);

            &:hover {
                background-color: var(--color-gray-100);
            }
        }

        &__input {
            display: none;
        }

        &__label {
            font-family: Roboto_Medium;
            font-size: 14px;
            color: var(--text-primary);
        }

        &__preview {
            aspect-ratio: 336 / 186;
            width: 100%;
            max-width: 336px;
            border-radius: 16px;
            border: 1px solid var(--input-2-border);
        }

        &__txt {
            font-size: 12px;
            font-family: Roboto_Regular;
            color: var(--color-gray-200);
        }
    }




    


</style>