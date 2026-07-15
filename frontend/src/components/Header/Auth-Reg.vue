<script setup>
    import { ref, watch } from 'vue'
    import api from '@utils/axios'
    import { useAuthStore } from '@stores/authStore'
    import { useValidation } from '@/composables/auth/useValidation'
    import { useVerificationCode } from '@/composables/auth/useVerificationCode'
    
    const auth = useAuthStore()
    
    const { errors, clearErrors, validateEmail, validatePassword, validateRepeatPassword } = useValidation()
    const { 
        code, 
        codeError, 
        fullCode, 
        setInputRef, 
        focusInput, 
        onInput, 
        onKeydown, 
        onPaste,
        resetCode,
        validateCode
    } = useVerificationCode()

    
    const isAuthOrReg = ref(true)
    const isRegister = ref(false)
    const isConfirmEmail = ref(false)
    const isRecoverPass = ref(false)
    const isLoading = ref(false)
    const SuccessRes = ref(false)

    const form = ref({
        email: '',
        password: '',
        repeatPassword: ''
    })

    const props = defineProps({ modelValue: Boolean })
    const emit = defineEmits(['update:modelValue'])

    const resetForm = () => {
        form.value = { email: '', password: '', repeatPassword: '' }
        clearErrors()
        resetCode()
        isRegister.value = false
        isConfirmEmail.value = false
        isRecoverPass.value = false
        SuccessRes.value = false
        isAuthOrReg.value = true
    }

    const close = () => {
        resetForm()
        emit('update:modelValue', false)
    }

    const validateForm = () => {
        clearErrors()
        const isEmailValid = validateEmail(form.value.email)
        const isPasswordValid = validatePassword(form.value.password)
        if (!isEmailValid || !isPasswordValid) return false

        if (isRegister.value) {
            return validateRepeatPassword(form.value.password, form.value.repeatPassword)
        }
        return true
    }

    const handleSubmit = async () => {
        if (!validateForm()) return

        isLoading.value = true
        clearErrors()

        const endpoint = isRegister.value ? 'auth/send-verification' : 'auth/login'

        try {
            const { data } = await api.post(endpoint, {
                email: form.value.email,
                password: form.value.password,
            })

            if (isRegister.value && data.success) {
                toggleBlock()
            }

            if (!isRegister.value && data.success) {
                await auth.checkAuth()
                close()
            }

        } catch (err) {
            errors.value.email = err.response?.data?.error || 'Ошибка сервера'
        } finally {
            isLoading.value = false
        }
    }

    const handleCodeSubmit = async () => {
        if (!validateCode()) {
            codeError.value = 'Введите все 6 цифр'
            return
        }

        codeError.value = ''

        try {
            await api.post('auth/verify-code', { code: fullCode.value })
            await auth.checkAuth()
            close()
        } catch (err) {
            codeError.value = err.response?.data?.error || 'Неверный код'
            resetCode()
        }
    }

    const handleRecoverPassword = async () => {
        SuccessRes.value = false
        if (!form.value.email) {
            errors.value.email = 'Введите email'
            return
        }

        isLoading.value = true
        clearErrors()

        try {
            const { data } = await api.post('auth/recover-password', {
                email: form.value.email
            })

            if (data.success) {
                errors.value.email = null
                SuccessRes.value = true
            } else {
                errors.value.email = data.message || 'Email не найден'
            }
        } catch (error) {
            errors.value.email = error.response?.data?.error || 'Ошибка сервера'
        } finally {
            isLoading.value = false
        }
    }

    const toggleForm = () => {
        isRegister.value = !isRegister.value
        clearErrors()
        form.value.repeatPassword = ''
    }

    const toggleBlock = () => {
        isConfirmEmail.value = !isConfirmEmail.value
    }

    const toggleRecover = () => {
        clearErrors()
        isAuthOrReg.value = !isAuthOrReg.value
        isRecoverPass.value = !isRecoverPass.value
    }

    watch(() => props.modelValue, (newVal) => {
        if (newVal) resetForm()
    })
</script>

<template>


    <Transition name="popup-auth">
        <div v-if="modelValue" class="popup flex-center">
            <div class="popup__wrapper flex-column">
                <div class="auth-reg-block" v-if="!isConfirmEmail && isAuthOrReg">
                    <div class="label-block flex align-c justify-sb">
                        <span class="label-block__label">{{ isRegister ? 'Регистрация' : 'Вход' }}</span>
                        <button @click="close" type="button" class="no-border btn-close"></button>
                    </div>
                    <div class="field-wrapper flex-column">
                        <div class="field-block flex-column">
                            <label for="email" class="field-block__label">Email:</label>
                            <div class="input-block flex align-c">
                                <input v-model="form.email" type="email" id="email" class="input-block__field no-border" placeholder="Введите email">
                            </div>
                            <div class="error-block" v-if="errors.email">
                                <span>{{ errors.email }}</span>
                            </div>
                        </div>

                        <div class="field-block flex-column">
                            <label for="password" class="field-block__label">Пароль:</label>
                            <div class="input-block flex align-c">
                                <input v-model="form.password" type="password" id="password" class="input-block__field no-border" placeholder="Введите пароль">
                            </div>
                            <div class="error-block" v-if="errors.password">
                                <span>{{ errors.password }}</span>
                            </div>
                        </div>

                        <div class="field-block flex-column" v-if="isRegister">
                            <label for="repeat-pass" class="field-block__label">Повторный пароль:</label>
                            <div class="input-block flex align-c">
                                <input v-model="form.repeatPassword" type="password" id="repeat-pass" class="input-block__field no-border" placeholder="Введите пароль">
                            </div>
                            <div class="error-block" v-if="errors.repeatPassword">
                                <span>{{ errors.repeatPassword }}</span>
                            </div>
                        </div>

                        <div class="nav-block flex align-c">
                            <button @click="toggleForm" type="button" class="no-border nav-block__btn">{{ isRegister ? 'Войти' : 'Регистрация' }}</button>
                            <button @click="toggleRecover" type="button" class="no-border nav-block__btn">Забыли пароль ?</button>
                        </div> 

                        <button 
                            @click="handleSubmit"
                            :disabled="isLoading"
                            type="button" class="no-border btn-reg-auth">
                            {{  isRegister ? 'Зарегистрироваться' : 'Войти' }}
                        </button>

                    </div>    
                </div>

                <div class="confirm-block flex-column"  v-if="isConfirmEmail">
                    <button @click="toggleBlock()" type="button" class="no-border return-to-back flex-center">
                        <svg width="16" height="16" viewBox="0 0 16 16" fill="none" xmlns="http://www.w3.org/2000/svg">
                            <path d="M14.9512 0.879883L14.9512 14.8799M8.50727 14.7239L1.03206 7.78425C0.988737 7.74402 0.989573 7.6752 1.03386 7.63604L8.50907 1.02686C8.57362 0.969791 8.67531 1.01562 8.67531 1.10178L8.67531 14.6506C8.67531 14.7379 8.57126 14.7833 8.50727 14.7239Z" stroke="#313131" stroke-width="2"/>
                        </svg>
                    </button>

                    <span class="confirm-block__label">Подтверждение адреса электронной почты</span>

                    <span class="confirm-block__message flex-center flex-column">
                        Мы отправили уведомление с кодом на
                        <span class="name-email">{{ form.email }}</span>
                    </span>

                    <div class="code-block flex-center">
                        <input 
                            v-for="(digit, index) in 6"
                            :key="index"
                            :ref="el => setInputRef(el, index)"
                            v-model="code[index]"
                            @focus="focusInput(index)"
                            @click="focusInput(index)"
                            @input="onInput(index, $event.target.value)"
                            @keydown="onKeydown(index, $event)"
                            @paste="onPaste($event)"
                            type="text"
                            class="code-block__input"
                            maxlength="1"
                            inputmode="numeric"
                        />
                    </div>

                    <div class="error-block flex-center" v-if="codeError">
                        <span>{{ codeError}}</span>
                    </div>

                    <button @click="handleCodeSubmit" type="button" class="no-border btn-reg-auth">Подтвердить</button>

                </div>

                <div class="recover-block flex-column" v-if="isRecoverPass">
                    <div class="label-block flex align-c justify-sb">
                        <span class="label-block__label">Восстановление пароля</span>
                        <button @click="close()" type="button" class="no-border btn-close"></button>
                    </div>

                    <div class="field-block flex-column">
                        <label for="email-recover" class="field-block__label">Email:</label>
                        <div class="input-block flex align-c justify-sb">
                            <input v-model="form.email" type="email" id="email-recover" class="input-block__field no-border" placeholder="Введите email">
                        </div>
                        <div class="success-block" v-if="SuccessRes">
                            <span>Ссылка для сброса пароля отправлена на указанный email</span>
                        </div>
                        <div class="error-block" v-if="errors.email">
                            <span>{{ errors.email }}</span>
                        </div>
                        <div class="flex" style="gap: 16px; margin-top: 12px;">
                            <button @click="handleRecoverPassword" :disabled="isLoading" class="no-border btn-reg-auth btns-recover">Восстановить</button>
                            <button @click="toggleRecover()" class="no-border btn-reg-auth btns-recover btn-cancel">Отменить</button>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </Transition>
</template>

<style lang="scss" scoped>

    /* ПопАП */

    .popup {
        position: fixed;
        top: 0;
        bottom: 0;
        left: 0;
        right: 0;
        width: 100%;
        height: 100%;
        z-index: 1000;
        background: rgba(0,0,0,0.5);
        
        &__wrapper {
            max-width: 450px;
            width: 100%;
            padding: 32px 24px;
            background-color: var(--bg-primary);
            border-radius: 8px;
            position: relative;
        }
    }


    .field-wrapper {
        width: 100%;
        margin-top: 32px;
        gap: var(--gp-24);
    }

    .field-block {
        width: 100%;
        gap: var(--gp-8);

        &__label {
            font-family: Roboto_Regular;
            font-size: 18px;
            color: var(--text-tertiary);
        }
    }

    .input-block {
        width: 100%;

        &__field {
            width: 100%;
            color: var(--text-primary);
            background-color: var(--input-1-bg);
            font-size: 16px;
            font-family: Roboto_Regular;
            padding: 8px;
            border-radius: 8px;
            border: 1px solid var(--input-1-border);
        }
        
    }

    .nav-block {
        justify-content: space-between;
        font-size: 14px;
        font-family: Roboto_Regular;

        &__btn {
            color: #7c7cff;
            padding: 0;
            text-decoration: underline;

            &:hover {
                text-decoration: none;
            }
        }
    }

    .btn-reg-auth {
        width: 100%;
        padding-block: 8px;
        background-color: var(--text-primary);
        color: var(--text-primary-r);
        border-radius: 8px;
        font-size: 16px;
        font-family: Roboto_Medium;
        margin-top: 8px;

        &:hover {
            background-color: var(--color-green);
            color: var(--color-white)
        }
    }

    .btns-recover {
        background-color:var(--color-green);
        color: var(--color-white);

        &:hover {
            background-color:var(--color-green-hover)
        }
    }

    .btn-cancel {
        background-color: var(--text-primary);
        color: var(--text-primary-r);

        &:hover{
            background-color: var(--color-red)
        }
    }

    .label-block {
        width: 100%;
        position: relative;

        &__label {
            font-family: Roboto_SemiBold;
            font-size: 32px;
            color: var(--text-primary);
        }
    }

    .error-block {
        width: fit-content;
        font-family: Roboto_Regular;
        font-size: 16px;
        color: rgb(255, 55, 55);
    }

    /* Кнопка закрытия */

    .btn-close {
        position: relative;
        width: 32px;
        height: 32px;

        &::before,
        &::after {
            content: '';
            position: absolute;
            top: 16px;
            width: 20px;
            height: 2px;
            background: var(--text-tertiary);
            transform: translate(-50%, -50%) rotate(45deg);
        }

        &::after {
            transform: translate(-50%, -50%) rotate(-45deg);
        }

        &:hover::before,
        &:hover::after {
            background-color: var(--text-primary);
        }
    }


    /* Блок с подтверждением email */

    .confirm-block {
        .error-block {
            margin: 0 auto;
            margin-top: 16px;
        }

        &__label {
            text-align: center;
            font-family: Roboto_SemiBold;
            margin: 0 auto;
            margin-top: 24px;
            font-size: 24px;
            color: var(--text-primary);
        }

        &__message {
            text-align: center;
            font-family: Roboto_Medium;
            margin: 0 auto;
            font-size: 18px;
            margin-top: 16px;
            color: var(--text-primary);
            gap: var(--gp-4);

            .name-email {
                font-family: Roboto_Medium;
                font-size: 16px;
                color: var(--color-blue);
                margin-top: 10px;
            }
        }
    }

    // Блок успеха

    .success-block {
        text-align: center;
        margin-top: 16px;
        font-size: 20px;
        font-family: Roboto_SemiBold;
    }

    .return-to-back {
        margin-right: auto;
        padding: 0;

        svg {
            width: 20px;
            height: 20px;
        }
    }

    .code-block {
        gap: var(--gp-12);
        margin-top: 32px;
        margin-bottom: 32px;

        &__input {
            text-align: center;
            width: 36px;
            height: 36px;
            font-size: 20px;
            font-family: Roboto_SemiBold;
            border-radius: 4px;
            background-color: var(--bg-secondary);
            border: 1px solid var(--bg-secondary-border);
            color: var(--text-primary);
        }
    }


    .recover-block  {
        
        .field-block {
            margin-top: 32px;
        }

        .label-block__label {
            font-size: 30px;
        }
    }

    // Анимка

    .popup-auth-enter-active,
    .popup-auth-leave-active {
        transition: all 0.3s ease;
    }

    .popup-auth-enter-from,
    .popup-auth-leave-to {
        opacity: 0;
        transform: translateY(80px);
    }

    .popup-auth-enter-to,
    .popup-auth-leave-from {
        opacity: 1;
        transform: translateY(0);
    }


</style>