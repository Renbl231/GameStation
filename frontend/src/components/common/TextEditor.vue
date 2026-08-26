<script setup>
    import { ref, onMounted, nextTick, watch } from 'vue'
    import { onImageChange } from '@utils/validators/validateImage'
    import api from '@utils/axios'

    const props = defineProps({
        modelValue: { 
            type: String,
            default: '<p class="text-content" style="font-size:20px; line-height:1.5; color:var(--text-secondary);">Контент</p>'
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

    const updateContent = () => { if (contentArea.value) emits('update:modelValue', contentArea.value.innerHTML) }

    const DEFAULT_P_STYLES = {
    fontSize: '20px',
    lineHeight: '1.5',
    color: 'var(--text-secondary)',
}

const handleContentChange = () => {
    const el = contentArea.value
    if (!el) return

    const html = el.innerHTML.trim()

    // ✅ Если внутри просто текст (без тегов) — оборачиваем в <p> со стилями
    if (html && !html.includes('<') && !html.includes('>')) {
        el.innerHTML = `<p class="text-content" style="font-size:20px; line-height:1.5; color: var(--text-secondary);">${html}</p>`
        const range = document.createRange()
        const sel = window.getSelection()
        const textNode = el.firstChild?.firstChild
        if (textNode) {
            range.setStart(textNode, textNode.length)
            range.collapse(true)
            sel?.removeAllRanges()
            sel?.addRange(range)
        }
        prevContent.value = el.innerHTML
        updateContent()
        return
    }

    // ✅ Если пусто — вставляем <p> со стилями
    if (!html || html === '<br>' || html === '<p></p>' || html === '<p><br></p>') {
        const p = document.createElement('p')
        p.className = 'text-content'
        Object.assign(p.style, DEFAULT_P_STYLES)
        p.innerHTML = '&nbsp;'
        el.innerHTML = ''
        el.appendChild(p)

        const range = document.createRange()
        const sel = window.getSelection()
        range.setStart(p, 0)
        range.collapse(true)
        sel?.removeAllRanges()
        sel?.addRange(range)

        prevContent.value = el.innerHTML
        updateContent()
        return
    }

    prevContent.value = el.innerHTML
    updateContent()
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

    const makeUnderline = () => {
        contentArea.value?.focus()
        document.execCommand('underline')
        updateContent()
    }

    const makeStrike = () => {
        contentArea.value?.focus()
        document.execCommand('strikeThrough')
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

    const insertNewParagraph = () => {
        const selection = window.getSelection()
        if (!selection) return

        const range = selection.getRangeAt(0)
        let currentNode = range.commonAncestorContainer

        if (currentNode.nodeType === Node.TEXT_NODE) {
            currentNode = currentNode.parentElement
        }

        const defaultStyles = 'font-size:20px; line-height:1.5; color: var(--text-secondary);'

        const imgBlock = currentNode.closest?.('.img-block')
        if (imgBlock) {
            const newP = document.createElement('p')
            newP.className = 'text-content'
            newP.style.fontSize = '20px'
            newP.style.lineHeight = '1.5'
            newP.style.color = 'var(--text-secondary)'
            newP.innerHTML = '&nbsp;'
            imgBlock.parentNode?.insertBefore(newP, imgBlock.nextSibling)

            const newRange = document.createRange()
            const sel = window.getSelection()
            newRange.setStart(newP, 0)
            newRange.collapse(true)
            sel?.removeAllRanges()
            sel?.addRange(newRange)
            updateContent()
            return
        }

        const currentP = currentNode.closest?.('p')
        if (currentP) {
            const newP = document.createElement('p')
            newP.className = 'text-content'
            newP.style.fontSize = '20px'
            newP.style.lineHeight = '1.5'
            newP.style.color = 'var(--text-secondary)'
            newP.innerHTML = '&nbsp;'
            currentP.parentNode?.insertBefore(newP, currentP.nextSibling)

            const newRange = document.createRange()
            const sel = window.getSelection()
            newRange.setStart(newP, 0)
            newRange.collapse(true)
            sel?.removeAllRanges()
            sel?.addRange(newRange)
            updateContent()
            return
        }

        document.execCommand('insertHTML', false, `<p class="text-content" style="${defaultStyles}">&nbsp;</p>`)
        updateContent()
    }

    const newParagraph = () => {
        contentArea.value?.focus()
        insertNewParagraph()
    }

    const newList = () => {
        contentArea.value?.focus()
        const list = document.createElement('ul')
        list.className = 'ulist'
    

        for(let i = 0; i<3;i++) {
            const item = document.createElement('li')
            item.textContent = 'Элемент ' + (i + 1)
            list.appendChild(item)
        }

        document.execCommand('insertHTML', false, list.outerHTML)
        updateContent()
    }


    const onKeyDown = (e) => {
        if (e.key === 'Enter') {
            e.preventDefault()
            insertNewParagraph()
        }

        if (e.key === 'Backspace') {
            const selection = window.getSelection()
            if (!selection) return

            const range = selection.getRangeAt(0)
            let currentNode = range.commonAncestorContainer
            if (currentNode.nodeType === Node.TEXT_NODE) {
                currentNode = currentNode.parentElement
            }

            const currentP = currentNode.closest?.('p')
            if (currentP && currentP.innerHTML.trim() === '') {
                e.preventDefault()
                currentP.remove()
                updateContent()
            }
        }
    }

    const openImagePicker = () => imageInput.value?.click()

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
                <div class="img-block flex-column" style="gap:16px;">
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

   const applyStyleToSelection = (styles) => {
        const selection = window.getSelection()
        if (!selection || selection.isCollapsed) return

        const range = selection.getRangeAt(0)
        const container = range.commonAncestorContainer
        const parent = container.nodeType === Node.TEXT_NODE
            ? container.parentElement
            : container

        const currentP = parent.closest?.('p')
        if (currentP) {
            const fullText = currentP.textContent
            const selectedText = selection.toString()

            if (fullText === selectedText) {
                const spans = currentP.querySelectorAll('span')
                spans.forEach(span => span.replaceWith(span.textContent))
                Object.assign(currentP.style, styles)
                updateContent()
                return
            }

            try {
                const fragment = range.extractContents()

                const tempDiv = document.createElement('div')
                tempDiv.appendChild(fragment)
                const spans = tempDiv.querySelectorAll('span')
                spans.forEach(span => span.replaceWith(span.textContent))
                const span = document.createElement('span')
                Object.assign(span.style, styles)

                while (tempDiv.firstChild) {
                    span.appendChild(tempDiv.firstChild)
                }

                range.insertNode(span)

                const newRange = document.createRange()
                const sel = window.getSelection()
                newRange.setStart(span, span.childNodes.length || 1)
                newRange.collapse(true)
                sel?.removeAllRanges()
                sel?.addRange(newRange)

                updateContent()
            } catch (error) {
                const span = document.createElement('span')
                Object.assign(span.style, styles)
                span.appendChild(range.extractContents())
                range.insertNode(span)
                updateContent()
            }
            return
        }

        const span = document.createElement('span')
        Object.assign(span.style, styles)
        span.appendChild(range.extractContents())
        range.insertNode(span)
        updateContent()
    }

    const setFontFamily = (font) => {
        contentArea.value?.focus()
        const selection = window.getSelection()
        if (!selection || selection.isCollapsed) return
        applyStyleToSelection({ fontFamily: font })
    }

    const setTextColor = (color) => {
        contentArea.value?.focus()
        const selection = window.getSelection()
        if (!selection || selection.isCollapsed) return
        applyStyleToSelection({ color })
    }

    const setFontSize = (size) => {
        contentArea.value?.focus()

        const selection = window.getSelection()
        if (!selection) return

        if (selection.isCollapsed) return

        applyStyleToSelection({
            fontSize: `${size}px`,
            lineHeight: '1.5',
        })
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

</script>

<template>
  <div class="editor flex-column">
        <div class="editor__toolbar flex-column flex-center">
            <div class="flex" style="gap: 32px;">
                <div class="toolbar-group flex align-c">
                    <button class="toolbar-group__btn no-border flex-center" @click="makeBold" title="Жирный (Ctrl+B)">
                        <strong>B</strong>
                    </button>
                    <button class="toolbar-group__btn no-border flex-center" @click="makeItalic" title="Курсив (Ctrl+I)">
                        <em>K</em>
                    </button>
                    <button class="toolbar-group__btn no-border flex-center" @click="makeUnderline" title="Подчеркнутый (Ctrl+U)">
                        <u>U</u>
                    </button>
                    <button class="toolbar-group__btn no-border flex-center" @click="makeStrike" title="Зачеркнутый">
                        <s>S</s>
                    </button>
                </div>
                <div class="toolbar-group flex align-c">
                    <button class="toolbar-group__btn toolbar-group__btn-v2 no-border flex-center" @click="makeLink" title="Ссылка (Ctrl+K)">
                        <svg viewBox="0 0 24 24" width="18" height="18" fill="none" stroke="currentColor" stroke-width="2">
                            <path d="M10 13a5 5 0 0 0 7.54.54l3-3a5 5 0 0 0-7.07-7.07l-1.72 1.71"/>
                            <path d="M14 11a5 5 0 0 0-7.54-.54l-3 3a5 5 0 0 0 7.07 7.07l1.71-1.71"/>
                        </svg>
                    </button>
                    <button class="toolbar-group__btn toolbar-group__btn-v2 no-border flex-center" @click="openImagePicker" title="Изображение">
                        <svg viewBox="0 0 24 24" width="18" height="18" fill="none" stroke="currentColor" stroke-width="2">
                            <rect x="3" y="3" width="18" height="18" rx="2"/>
                            <circle cx="8.5" cy="8.5" r="1.5"/>
                            <path d="M21 15l-5-5L5 21"/>
                        </svg>
                    </button>
                    <button class="toolbar-group__btn toolbar-group__btn-v2 no-border flex-center" @click="newParagraph" title="Абзац">
                        <svg viewBox="0 0 24 24" width="18" height="18" fill="none" stroke="currentColor" stroke-width="2">
                            <path d="M6 4h12M6 12h8M6 20h12"/>
                        </svg>
                    </button>
                    <button class="toolbar-group__btn toolbar-group__btn-v2 no-border flex-center" @click="newList" title="Список">
                        <svg viewBox="0 0 24 24" width="20" height="20" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                            <circle cx="5" cy="6" r="1.5" fill="currentColor" stroke="none"/>
                            <circle cx="5" cy="12" r="1.5" fill="currentColor" stroke="none"/>
                            <circle cx="5" cy="18" r="1.5" fill="currentColor" stroke="none"/>
                            <line x1="10" y1="6" x2="20" y2="6"/>
                            <line x1="10" y1="12" x2="20" y2="12"/>
                            <line x1="10" y1="18" x2="20" y2="18"/>
                        </svg>
                    </button>
                </div>
            </div>

            <div class="toolbar-group toolbar-group-v3 flex-column">

                <div class="flex">
                    <div class="toolbar-group__btn-group">
                        <button class="toolbar-group__btn no-border" @click="setFontFamily('Roboto_Regular')">Regular</button>
                        <button class="toolbar-group__btn no-border" @click="setFontFamily('Roboto_Medium')">Medium</button>
                        <button class="toolbar-group__btn no-border" @click="setFontFamily('Roboto_Bold')">Bold</button>
                    </div>
                    <div class="toolbar-group__btn-group">
                        <button 
                            v-for="size in [14, 16, 18, 20, 24, 32]" 
                            :key="size"
                            class="toolbar-group__btn no-border"
                            @click="setFontSize(size)"
                        >
                            {{ size }}px
                        </button>
                    </div>
                </div>

                <div class="toolbar-group__btn-group flex-center">
                    <button 
                        class="toolbar-group__btn no-border"
                        @click="setTextColor('var(--text-secondary)')"
                        title="Белый/чёрный"
                    >
                        ⚪
                    </button>
                    <button 
                        class="toolbar-group__btn no-border"
                        @click="setTextColor('var(--text-tertiary)')"
                        title="Серый"
                    >
                        <span style="filter: brightness(0.5);">⚪</span>
                    </button>
                    <button 
                        class="toolbar-group__btn no-border"
                        @click="setTextColor('var(--color-red)')"
                        title="Красный"
                    >
                        🔴
                    </button>
                </div>
            </div>
        </div>

        <div
            ref="contentArea"
            class="editor__content flex-column"
            contenteditable="true"
            spellcheck="false"
            @input="handleContentChange"
            @keydown="onKeyDown"
        />

        <input ref="imageInput" type="file" accept="image/*" class="hidden" @change="insertImagePreview"/>

  </div>
</template>

<style lang="scss" scoped>

    
    .editor {
        width: 100%;
        position: relative;
        background-color: var(--input-2-bg);
        border: 1px solid var(--input-2-border);
        border-radius: 8px; 
        color: var(--text-secondary);
        min-height: 150px;
        font-family: Roboto_Medium;
        resize: vertical;
        overflow: hidden;

        &:focus-within {
            border-color: #4a90e2;
            box-shadow: 
                0 0 0 3px rgba(74, 144, 226, 0.2),
                0 0 30px rgba(74, 144, 226, 0.15),
                0 0 60px rgba(74, 144, 226, 0.05);
                transition: all 0.25s ease;
        }

        &__content {
            gap: var(--gp-32);
            height: 100%;
            padding: 12px 16px;
            outline: none !important;
        }

        &__toolbar {
            width: fit-content;
            gap: var(--gp-24);
            position: fixed;
            bottom: 20px;            
            left: 50%;              
            transform: translateX(-50%);
            z-index: 10;
            background-color: var(--color-gray-600);
            padding: 12px;
            border-radius: 12px; 
            box-shadow: 0 4px 20px rgba(0, 0, 0, 0.4);
            flex-wrap: wrap;
        }
    }

    .toolbar-group {
        gap: var(--gp-4);

        &__btn {
            padding: 2px 6px;
            color: var(--text-muted);
            border-radius: 4px;

            &:hover {
                color: var(--color-white);
            }

            &-v2 {
                padding: 4px 4px;
            }

            &-v3 {
                padding: 2px 2px;
            }
        }

        &-v3 {
            gap: var(--gp-24);
        }

        &__select {
            cursor: pointer;
            color: var(--color-white);
            border-radius: 4px;

            option {
                background-color: var(--color-gray-600);
            }
        }
    }

    :deep(.img-block) {
        justify-content: center;
    }

    :deep(.img-block img) {
        aspect-ratio: 843/474;
        border-radius: 8px;
        width: 100%;
        max-height: 480px;
    }

    :deep(.img-block) {
        gap: var(--gp-8) !important;
    }

    ::v-deep(.text-content a) {
        color: var(--color-blue);
        text-decoration: underline;
    }

    :deep(.ulist) {
        display: flex;
        flex-direction: column;
        list-style-type: disc;
        padding-inline: 16px;
        gap: var(--gp-4);
    }

</style>
