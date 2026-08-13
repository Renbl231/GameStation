<script setup>
    import { ref } from 'vue'
    import { onImageChange } from '@utils/validators/validateImage'
    import { useNotifications } from '@stores/notifications'
    import { useApiNotifications } from '@composables/useApi';
    import { useRoute } from 'vue-router'
    import api from '@utils/axios'

    import TextEditor from '@components/TextEditor.vue'

    const { apiCall } = useApiNotifications()
    const notification = useNotifications()

    const props = defineProps({
        article: Object
    })

    const route = useRoute()
    const emits = defineEmits(['close', 'edit'])


    const form = ref({
        title: props.article.title || '',
        category_id: props.article.category_id || '',
        cover: props.article.cover || null,
        content: props.article.content || '',
        score: props.article.score || 0
    })

    const temporaryPhoto = ref(null)

    const handleCoverChange = (event) => {
        const result = onImageChange(event)

        if(!result) return

        temporaryPhoto.value = result.temporaryPhoto
        form.value.cover = result.file
    }

    const validateForm = () => {
        if(!form.value.title.trim()) {
            notification.warning('Заголовок обязателен')
            return false
        }
        if(!Number(form.value.category_id)) {
            notification.warning('Категория обязательна')
            return false
        }
        if(!form.value.cover) {
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

    const handleEdit = async () => {
        if (!validateForm()) return

        const fd = new FormData()
        fd.append('title', form.value.title)
        fd.append('category_id', form.value.category_id)
        fd.append('content', form.value.content)
        fd.append('score', form.value.score)
        if (form.value.cover) fd.append('image', form.value.cover)

        const data = await apiCall(() => api.put(`/article/${route.params.id}/edit`, fd), 'Статья отредактирована')
        if(data.success) {
            emits('edit')
        } 
    }
    

</script>

<template>
    <div class="edit-block flex-column">
        <input 
            v-model="form.title" 
            class="field no-border" 
            placeholder="Заголовок"
            :class="{'active': form.title}"
        />

        <div class="image-uploader flex-column">
            <div v-if="temporaryPhoto" class="preview-container">
                <img :src="temporaryPhoto" class="preview-image"/>
            </div>
            <label class="upload-btn flex-center">
                <input 
                    type="file"
                    accept="image/*"
                    class="upload-input"
                    @change="handleCoverChange"
                />
                <span class="upload-text">Загрузить превью</span>
            </label>
        </div>

        <select 
            v-model="form.category_id" 
            class="category-select field no-border"
            :class="{'active': form.category_id}"
        >
            <option value="" disabled hidden selected class="empty-option">
                Изменить категорию
            </option>
            <option value="1">Обзор</option>
            <option value="2">Подборка игр</option>
        </select>

        <TextEditor v-model="form.content" :type="'articles'" class="active"/>

        <label>
            Оценка {{ form.score }}/10
            <input type="range" v-model="form.score" step="1" min="0" max="10" style="width: 100%; cursor: pointer;">
        </label>

        <div class="edit-block-interaction flex aling-c">        
            <button type="button" class="no-border edit-block-interaction__btn" @click="handleEdit">Изменить</button>
            <button type="button" class="no-border edit-block-interaction__btn reject" @click="emits('close')">Отменить</button>
        </div>

    </div>
</template>

<style lang="scss" scoped>
    /* Редактирование выбор категории */

    .edit-block {
        width: 100%;
        gap: var(--gp-16);
    }

    .edit-block-interaction {
        gap: var(--gp-8);
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

    .field {
        width: 100%;
        background-color: #1B1C21;
        padding: 12px 16px;
        border-radius: 8px;
        border-left: 3px solid var(--btn-color-2);
        color: var(--font-primary-75);
    }

    .field.active {border-left: 3px solid var(--font-secondary);}

    .field::placeholder {
        color: var(--font-primary-25);
    }

    .edit-block-interaction__btn {
        background-color: var(--btn-color-1);
        border-radius: 4px;
        padding: 8px 16px;
    }
    .edit-block-interaction__btn:hover {background-color: var(--btn-color-2);}
    
    .edit-block-interaction__btn.reject {
        background-color: var(--bg-secondary-25);
    }
    .edit-block-interaction__btn.reject:hover {background-color: var(--bg-secondary-50);}

    /* Превью */

    .image-uploader {
        gap: var(--gp-16);
    }

    .upload-btn {
        cursor: pointer;
        display: inline-flex;
        width: fit-content;
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
        width: 392px;
        height: 220px;
        border-radius: 4px;
    }
</style>