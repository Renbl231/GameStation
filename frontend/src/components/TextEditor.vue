<script setup>
    import { ref, onMounted, nextTick, watch } from 'vue'
    import api from '../utils/axios'

    const props = defineProps({
        modelValue: { type: String, default: '<p class="text-content">Начните писать здесь...</p>' },
        type: String
    })

    const emit = defineEmits(['update:modelValue'])
    const contentArea = ref(null)
    const imageInput = ref(null)
    const prevContent = ref('')

    const updateContent = () => {
    if (contentArea.value) {
        emit('update:modelValue', contentArea.value.innerHTML)
    }
    }

    onMounted(() => {
    nextTick(() => {
        if (contentArea.value) {
        contentArea.value.innerHTML = props.modelValue
        prevContent.value = props.modelValue  // ← инициализация
        }
    })
    })

    const handleContentChange = () => {
    const currentContent = contentArea.value.innerHTML
    
    cleanupDeletedImages(prevContent.value, currentContent)
    prevContent.value = currentContent
    updateContent()
    }

    const cleanupDeletedImages = async (oldHtml, newHtml) => {
    const oldKeys = [...oldHtml.matchAll(/data-minio-key="([^"]+)"/g)].map(m => m[1])
    const newKeys = [...newHtml.matchAll(/data-minio-key="([^"]+)"/g)].map(m => m[1])
    
    const deletedKeys = oldKeys.filter(key => !newKeys.includes(key))
    
    clearTimeout(window.imageDeleteTimeout)
    window.imageDeleteTimeout = setTimeout(async () => {
        for (const key of deletedKeys) {
        try {
            await api.delete(`/editorImage/delete`, { data: { key } })
            console.log('✅ Удалён:', key)
        } catch (e) {
            console.error('❌ Ошибка удаления:', key, e)
        }
        }
    }, 500)
    }


    const makeBold = () => {
        contentArea.value?.focus()
        document.execCommand('bold')
        updateContent()
    }

    const makeItalic = () => {
        contentArea.value?.focus()
        document.execCommand('italic')
        updateContent()
    }

    const makeLink = () => {
        contentArea.value?.focus()
        const url = prompt('URL ссылки:')
        if (url) {
            document.execCommand('createLink', false, url)
            updateContent()
        }
    }

    const newParagraph = () => {
        contentArea.value?.focus()
        document.execCommand('insertHTML', false, '<p class="text-content"><br></p>')
        updateContent()
    }

    const openImagePicker = () => {
        imageInput.value?.click()
    }

    const insertImagePreview = async (event) => {
        const file = event.target.files?.[0]
        if (!file || !file.type.startsWith('image/')) return

        contentArea.value?.focus()

        try {
            const formData = new FormData()
            formData.append('image', file)

            const response = await api.post(`/editorImage/${props.type}/upload`, formData)

            const { url, key } = response.data
            const imgHtml = `
            <div class="img-block flex-column">
                <img src="${url}" alt="" data-minio-key="${key}">
            </div>
            `

            document.execCommand('insertHTML', false, imgHtml)
            contentArea.value?.focus()
            updateContent()
        } catch (error) {
            console.error('Ошибка загрузки:', error)
        }

        event.target.value = ''
    }

</script>

<template>
  <div class="editor-container flex-column field field-content">
    <div
      ref="contentArea"
      class="content flex-column"
      contenteditable="true"
      spellcheck="false"
      @input="handleContentChange"
    />

    <input
      ref="imageInput"
      type="file"
      accept="image/*"
      style="display: none"
      @change="insertImagePreview"
    />

    <div class="editor-toolbar flex align-c">
      <button type="button" @click="makeBold" title="Жирный">𝐁</button>
      <button type="button" @click="makeItalic" title="Курсив">𝐈</button>
      <button type="button" @click="makeLink" title="Ссылка">🔗</button>
      <button type="button" @click="openImagePicker" title="Картинка">🖼️</button>
      <button type="button" @click="newParagraph" title="Абзац">⏎</button>
    </div>
  </div>
</template>

<style scoped>

        .img-block {
            display: inline-block;
            margin: 10px;
        }

        .img-block img {
            max-width: 400px;
            height: auto;
            border-radius: 8px;
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

    .field-content {
        padding: 16px;
        min-height: 300px;
        resize: vertical;
        overflow: hidden;
        field-sizing: content;
        gap: var(--gp-32);
    }

    .content {
        field-sizing: content;
        padding: 32px;
    }

    .editor-toolbar {
        gap: var(--gp-8);
        margin-top: auto;
    }

    .editor-toolbar button { 
        padding: 5px 10px; border: 1px solid var(--bg-secondary-50) ; background: var(--bg-secondary-25);
        color: var(--font-primary);
        border-radius: 4px; cursor: pointer; font-size: 16px;
    }

    @media (max-width:500px) {
        .field-content {
            height: 200px;
        }
    }
</style>
