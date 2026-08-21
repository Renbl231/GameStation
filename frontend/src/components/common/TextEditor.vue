<script setup>
    import { ref, onMounted, nextTick, watch } from 'vue'
    import { onImageChange } from '@utils/validators/validateImage'
    import { useNotifications } from '@stores/notifications'
    import api from '@utils/axios'

    const notification = useNotifications()

    const props = defineProps({
        modelValue: { 
            type: String,
            default: '<p class="text-content">Начните писать здесь...</p>' 
        },
        type: {
            type: String,
            required: true,
            validator: v => ['articles', 'news'].includes(v),
        },
    })

    const emits = defineEmits(['update:modelValue'])

    const contentArea = ref(null)
    const imageInput = ref(null)
    const prevContent = ref('')

    const updateContent = () => {
    if (contentArea.value) {
        emits('update:modelValue', contentArea.value.innerHTML)
    }
    }

    watch(() => props.modelValue, (newValue) => {
        if (contentArea.value && contentArea.value.innerHTML !== newValue) {
            contentArea.value.innerHTML = newValue
            prevContent.value = newValue
        }
    })

    onMounted(() => {
    nextTick(() => {
        if (contentArea.value) {
            contentArea.value.innerHTML = props.modelValue
            prevContent.value = props.modelValue
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
            await api.delete(`/editorImage/delete`, { data: { key } })
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
        document.execCommand('insertHTML', false, '<br><p class="text-content"><br></p>')
        updateContent()
    }

    const openImagePicker = () => {
        imageInput.value?.click()
    }

    const insertImagePreview = async (event) => {
        const result = onImageChange(event)
        if(!result) return

        const file = result.file
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
            <p class="text-content"><br></p>
            `

            document.execCommand('insertHTML', false, imgHtml)
            contentArea.value?.focus()
            updateContent()
        } catch (error) {
            console.error('Ошибка загрузки:', error)
        }

        event.target.value = ''
    }

const setFontSize = (size) => {
    contentArea.value?.focus()
    
    const selection = window.getSelection()
    if (!selection || selection.isCollapsed) {
        document.execCommand('insertHTML', false, `<span style="font-size: ${size}px; line-height: ${size + 8}px;"> Текст</span>`)
    } else {
        const range = selection.getRangeAt(0)
        const span = document.createElement('span')
        span.style.fontSize = `${size}px`
        span.style.lineHeight = `${size + 8}px`
        span.appendChild(range.extractContents())
        range.insertNode(span)
        
        range.collapse(false)
        selection.removeAllRanges()
        selection.addRange(range)
    }
    updateContent()
}


const setTextColor = (color) => {
    contentArea.value?.focus()
    
    const selection = window.getSelection()
    if (!selection || selection.isCollapsed) return
    
    const range = selection.getRangeAt(0)
    const span = document.createElement('span')
    span.style.color = color
    span.appendChild(range.extractContents())
    range.insertNode(span)
    
    selection.removeAllRanges()
    selection.addRange(range)
    updateContent()
}

const setFontFamily = (font) => {
    contentArea.value?.focus()
    
    const selection = window.getSelection()
    if (!selection || selection.isCollapsed) return
    
    const range = selection.getRangeAt(0)
    const span = document.createElement('span')
    span.style.fontFamily = font
    span.appendChild(range.extractContents())
    range.insertNode(span)
    
    selection.removeAllRanges()
    selection.addRange(range)
    updateContent()
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

    <div class="editor-toolbar flex-column" style="gap: 8px">
        <div class="flex align-c" style="gap: 8px; margin-right: auto;">
            <button type="button" @click="makeBold" title="Жирный">𝐁</button>
            <button type="button" @click="makeItalic" title="Курсив">𝐈</button>
            <button type="button" @click="makeLink" title="Ссылка">🔗</button>
            <button type="button" @click="openImagePicker" title="Фото">🖼️</button>
            <button type="button" @click="newParagraph" title="Абзац">⏎</button>
        </div>
        <div class="flex align-c" style="gap: 8px">
            <button type="button" @click="setFontSize(14)" title="Размер 14px">14px</button>
            <button type="button" @click="setFontSize(20)" title="Размер 20px">20px</button>
            <button type="button" @click="setFontSize(32)" title="Размер 32px">32px</button>
            <button type="button" @click="setTextColor('#f01937')" title="Красный">🔴</button>
            <button type="button" @click="setTextColor('var(--font-primary-75)')" title="Серый">
                <span style="filter: brightness(0.8);">⚪</span>
            </button>
            <button type="button" @click="setTextColor('var(--font-primary)')" title="Белый">⚪</button>
            <button type="button" @click="setFontFamily('Roboto_Medium')" title="Medium">𝐌𝐞𝐝</button>
            <button type="button" @click="setFontFamily('Roboto_Bold')" title="Bold">Bold</button>
        </div>
    </div>
  </div>
</template>

<style scoped>

    
    :deep(.img-block img) {
        max-height: 500px;
        width: auto;
        object-fit: cover;
        border-radius: 8px;
    }

    :deep(.img-block) {
        display: flex;
        justify-content: center;
        margin: 12px 0;
    }

    .editor-container {
        width: 100%;
        position: relative;
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
        padding: 16px;
    }

    .editor-toolbar {
        gap: var(--gp-8);
        position: fixed;
        bottom: 20px;
        left: 50%;
        transform: translateX(-50%);
        background-color: var(--btn-color-3);
        padding: 8px 16px;
        border-radius: 8px;
        z-index: 1000;
        display: flex;
        align-items: center;
        justify-content: center;
        flex-wrap: wrap;
        width: fit-content;
        max-width: 90%;
    }

    .editor-toolbar button { 
        padding: 5px 10px; border: 1px solid var(--bg-secondary-50) ; background: var(--bg-secondary-25);
        color: var(--font-primary);
        border-radius: 4px; cursor: pointer; font-size: 16px;
    }

    .editor-toolbar button:hover {
        background-color: var(--bg-secondary)
    }


    @media (max-width:500px) {
        .field-content {
            height: 200px;
        }
    }
</style>
