<script setup>
import { ref, onMounted, nextTick, watch } from 'vue'

const props = defineProps({
    modelValue: {
        type: String, 
        default: '<p class="text-content">Начните писать здесь...</p>'
    }
})

const emit = defineEmits(['update:modelValue'])
const contentArea = ref(null)

onMounted(() => {
    nextTick(() => {
        if(contentArea.value) {
            contentArea.value.innerHTML = props.modelValue || '<p class="text-content">Начните писать здесь...</p>'
        }
    })
})

// 🔥 СИНХРОНИЗАЦИЯ v-model
watch(() => props.modelValue, (newContent) => {
    if(contentArea.value && newContent !== contentArea.value.innerHTML) {
        contentArea.value.innerHTML = newContent
    }
})

const updateContent = () => {
    if(contentArea.value) {
        emit('update:modelValue', contentArea.value.innerHTML)
    }
}


const makeBold = () => {
    document.execCommand('bold')
    contentArea.value?.focus()
}

const makeItalic = () => {
    document.execCommand('italic')
    contentArea.value?.focus()
}

const makeLink = () => {
    const url = prompt('URL ссылки:')
    if(url) {
        document.execCommand('createLink', false, url)
    }
    contentArea.value?.focus()
}

const insertImage = () => {
    const url = prompt('URL изображения:')
    if(url) {
        const caption = prompt('Подпись (опционально):') || ''
        const imgHtml = caption 
            ? `<div class="img-block flex-column"><img src="${url}" alt="${caption}"><span class="img-name">${caption}</span></div>`
            : `<div class="img-block flex-column"><img src="${url}"></div>`
        document.execCommand('insertHTML', false, imgHtml)
        contentArea.value?.focus()
    }
}

const newParagraph = () => {
    document.execCommand('insertHTML', false, '<p class="text-content"><br></p>')
    contentArea.value?.focus()
}
</script>

<template>
  <div class="editor-container flex-column field field-content">
    <div 
      ref="contentArea"
      class="content flex-column"
      contenteditable="true"
      spellcheck="false"
      @input="updateContent"
    />
    
    <div class="editor-toolbar flex align-c">
      <button type="button" @click="makeBold" title="Жирный">𝐁</button>
      <button type="button" @click="makeItalic" title="Курсив">𝐈</button>
      <button type="button" @click="makeLink" title="Ссылка">🔗</button>
      <button type="button" @click="insertImage" title="Картинка">🖼️</button>
      <button type="button" @click="newParagraph" title="Абзац">⏎</button>
    </div>
  </div>
</template>

<style scoped>
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
