<script setup>
    import { computed, ref, watch } from 'vue'
    import { newsCategories } from '@constants/categories'
    import { storeToRefs } from 'pinia'
    import { useAuthStore } from '@stores/authStore'
    import { onImageChange } from '@/utils/validators/validateImage'
    import { validateNews } from '@/utils/validators/validateNews'
    import { handleCrop } from '@/utils/helpers/cropper'
    import { useApiNotifications } from '@composables/useApi'
    import api from '@utils/axios'

    import TextEditor from '@components/common/TextEditor.vue'
    import Cropper from '@/components/common/Cropper.vue'

    const authStore = useAuthStore()

    const { apiCall } = useApiNotifications()
    const { isAuthenticated, user } = storeToRefs(authStore)

    const isAuthorized = computed(() => isAuthenticated.value && [2, 4].includes(user.value?.role))
    const isCrop = ref(false)

    const form = ref({
        title: '',
        category_id: null,
        short_content: '',
        cover: null,
        content: '<p class="text-content" style="font-size:18px; line-height:1.5; color: var(--text-secondary);">Контент</p>'
    })

    const resetForm = () => {
        form.value = {
            title: '',
            category_id: null,
            short_content: '',
            cover: null,
            content: '<p class="text-content" style="font-size:18px; line-height:1.5; color: var(--text-secondary);">Контент</p>'
        }
        temporaryPhoto.value = ''
    }

    const temporaryCrop = ref('')
    const temporaryPhoto = ref('')

    const onMainImageChange = (event) => {
        const result = onImageChange(event)
        temporaryCrop.value = result.temporaryPhoto
    }

    watch(() => temporaryCrop.value, (value) => {
        isCrop.value = true
    })

    const fd = new FormData()

    const submitNews = async () => {
        if(!validateNews(form.value)) return

        fd.append('title', form.value.title)
        fd.append('category_id', form.value.category_id)
        fd.append('short_content', form.value.short_content)
        fd.append('content', form.value.content)
        fd.append('cover', form.value.cover)
        
        const data = await apiCall(() => api.post('/news/createNews', fd), 'Новость опубликована')

        if (data.success) {
            setTimeout(resetForm, 500)
        }
    }

    const onHandleCrop = (croppedDataUrl) => {
        const result = handleCrop(croppedDataUrl)

        temporaryPhoto.value = result.temporaryPhoto
        form.value.cover = result.cover
    }

</script>

<template>
    <section v-if="isAuthorized" class="container flex-column">
        <h1>Добавление новости</h1>
        
        <input v-model="form.title" class="container__input no-border" placeholder="Заголовок"/>
        
        <select v-model="form.category_id" class="container__select no-border">
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
            @crop="onHandleCrop"
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