// composables/auth/useValidation.js
import { ref } from 'vue'

export const useValidation = () => {
    const errors = ref({
        email: '',
        password: '',
        repeatPassword: ''
    })

    const clearErrors = () => {
        errors.value = { email: '', password: '', repeatPassword: '' }
    }

    const validateEmail = (email) => {
        if (!email) {
            errors.value.email = 'Email обязателен'
            return false
        }
        const emailRegex = /^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$/
        if (!emailRegex.test(email)) {
            errors.value.email = 'Некорректный email'
            return false
        }
        return true
    }

    const validatePassword = (password) => {
        if (!password) {
            errors.value.password = 'Пароль обязателен'
            return false
        }
        if (password.length < 6) {
            errors.value.password = 'Пароль должен содержать минимум 6 символов'
            return false
        }
        return true
    }

    const validateRepeatPassword = (password, repeatPassword) => {
        if (password !== repeatPassword) {
            errors.value.repeatPassword = 'Пароли не совпадают'
            return false
        }
        return true
    }

    return {
        errors,
        clearErrors,
        validateEmail,
        validatePassword,
        validateRepeatPassword
    }
}