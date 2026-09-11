<script setup>
    import { ref } from 'vue'
    import { articleCategories } from '@/constants/categories';
    import { validateArticle } from '@utils/validators/validateArticle';
    import { useApiNotifications } from '@composables/useApi';
    import { useRoute } from 'vue-router'
    import api from '@utils/axios'

    import TextEditor from '@components/common/TextEditor.vue'
    import ImageUploader from '@components/common/ImageUploader.vue';

    const { apiCall } = useApiNotifications()

    const route = useRoute()

    const props = defineProps({
        article: Object
    })

    const emits = defineEmits(['close', 'edit'])

    const form = ref({
        title: props.article.title || '',
        category_id: props.article.category_id || '',
        cover: props.article.cover || null,
        content: props.article.content || '',
        score: props.article.score || 0
    })

    const handleEdit = async () => {
        if (!validateArticle(form.value)) return

        const fd = new FormData()
        fd.append('title', form.value.title)
        fd.append('category_id', Number(form.value.category_id))
        fd.append('content', form.value.content)
        fd.append('score', form.value.score)
        if (form.value.cover) fd.append('cover', form.value.cover)

        const data = await apiCall(() => api.put(`/article/${route.params.id}`, fd), 'Статья отредактирована')
        if(data.success) {
            emits('edit')
        } 
    }
    

</script>

<template>
    <div class="editor flex-column">

        <input v-model="form.title" class="editor__input no-border" placeholder="Заголовок"/>

        <select v-model="form.category_id" class="editor__select no-border">
            <option value="null" disabled hidden selected class="editor__option">
                Категория новости
            </option>
            <option 
                v-for="category in articleCategories" 
                :key="category.id"
                :value="category.id"
                v-show="category.id"
                class="editor__option"
            >
                {{ category.name }}
            </option>
        </select>

        <TextEditor v-model="form.content" :type="'articles'"/>

        <ImageUploader
            :currentCover="article.cover"
            @upload="(value) => form.cover = value"
        />

        <label>
            Оценка {{ form.score }}/10
            <input type="range" v-model="form.score" step="0.1" min="0" max="10" style="width: 100%; cursor: pointer;">
        </label>

        <div class="editor__btns flex aling-c">        
            <button type="button" class="no-border editor__btn" @click="handleEdit">Изменить</button>
            <button type="button" class="no-border editor__btn editor__btn-reject" @click="emits('close')">Отменить</button>
        </div>

    </div>
</template>

<style lang="scss" scoped>
    .editor {
        width: 100%;
        gap: var(--gp-16);

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

        &__btns {
            gap: var(--gp-8);  
        }

        &__btn {
            background-color: var(--text-primary);
            color: var(--text-primary-r);
            border-radius: 4px;
            padding: 8px 16px;

            &-reject {
                background-color: var(--color-red);
                color: var(--color-white);
            }
        }
    }
</style>