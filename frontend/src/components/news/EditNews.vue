<script setup>
    import { ref, } from 'vue'
    import { onImageChange } from '@utils/validators/validateImage'
    import { validateNews } from '@/utils/validators/validateNews';
    import { useApiNotifications } from '@composables/useApi';
    import { newsCategories } from '@/constants/categories';
    import { useRoute } from 'vue-router'
    import api from '@utils/axios'

    import TextEditor from '@components/common/TextEditor.vue'

    const { apiCall } = useApiNotifications()

    const route = useRoute()

    const props = defineProps({
        news: Object
    })

    const emits = defineEmits(['close', 'edit'])
    
    const form = ref({
        title: props.news.title || '',
        category_id: props.news.category_id,
        short_content: props.news.short_content || '',
        cover: props.news.cover || null,
        content: props.news.content || ''
    })

    const temporaryPhoto = ref(null)

    const handleCoverChange = (event) => {
        const result = onImageChange(event)

        if(!result) return

        temporaryPhoto.value = result.temporaryPhoto
        form.value.cover = result.file
    }

    const handleEdit = async () => {
        if (!validateNews(form.value)) return

        const fd = new FormData()
        fd.append('title', form.value.title.trim())
        fd.append('category_id', form.value.category_id)
        fd.append('short_content', form.value.short_content.trim())
        fd.append('content', form.value.content)
        if (form.value.cover) fd.append('image', form.value.cover)

        const data = await apiCall(() => api.put(`/news/${route.params.id}/edit`, fd), 'Новость отредактирована')
        if (data.success) {
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
            <option 
                v-for="category in newsCategories" :value="category.id"
                v-show="category.id">
                {{ category.name }}
            </option>

        </select>

        <input 
            v-model="form.short_content" 
            type="text" 
            class="field no-border" 
            placeholder="Новость в кратце"
            :class="{'active': form.short_content}"
        />

        <TextEditor v-model="form.content" :type="'news'" class="active"/>

        <div class="edit-block-interaction flex aling-c">        
            <button type="button" class="no-border edit-block-interaction__btn" @click="handleEdit">Изменить</button>
            <button type="button" class="no-border edit-block-interaction__btn reject" @click="emits('close')">Отменить</button>
        </div>
    </div>

</template>

<style lang="scss" scoped>
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
    .field::placeholder {color: var(--font-primary-25);}
    .field.active {border-left: 3px solid var(--font-secondary);}

    .edit-block-interaction__btn {
        background-color: var(--btn-color-1);
        border-radius: 4px;
        padding: 8px 16px;
    }
    
    .edit-block-interaction__btn.reject {
        background-color: var(--color-1);
    }

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