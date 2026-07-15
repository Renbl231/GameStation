// composables/auth/useVerificationCode.js
import { ref, computed, nextTick } from 'vue'

export const useVerificationCode = () => {
    const code = ref(['', '', '', '', '', ''])
    const activeIndex = ref(0)
    const inputRefs = ref([])
    const codeError = ref('')

    const fullCode = computed(() => code.value.join(''))

    const validateCode = () => fullCode.value.length === 6

    const setInputRef = (el, index) => {
        if (el) inputRefs.value[index] = el
    }

    const focusInput = async (index) => {
        activeIndex.value = Math.max(0, Math.min(5, index))
        await nextTick()
        inputRefs.value[index]?.focus()
    }

    const onInput = (index, value) => {
        code.value[index] = value.slice(-1)
        if (value && index < 5) {
            focusInput(index + 1)
        }
    }

    const onKeydown = (index, event) => {
        if (event.key === 'Backspace' && !code.value[index]) {
            if (index > 0) focusInput(index - 1)
        }
    }

    const onPaste = (event) => {
        const pastedText = event.clipboardData?.getData('text/plain') || ''
        const digits = pastedText.replace(/\D/g, '').slice(0, 6)
        
        if (!digits) return
        
        event.preventDefault()
        
        for (let i = 0; i < 6; i++) {
            code.value[i] = digits[i] || ''
        }
        
        const lastIndex = Math.min(digits.length - 1, 5)
        focusInput(lastIndex)
        
        return digits.length === 6 // вернёт true, если код полный
    }

    const resetCode = () => {
        code.value = ['', '', '', '', '', '']
        codeError.value = ''
        focusInput(0)
    }

    return {
        code,
        activeIndex,
        inputRefs,
        codeError,
        fullCode,
        validateCode,
        setInputRef,
        focusInput,
        onInput,
        onKeydown,
        onPaste,
        resetCode
    }
}