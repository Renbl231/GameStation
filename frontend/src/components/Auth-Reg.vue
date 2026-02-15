<script setup>
    import { ref, computed, nextTick, onMounted } from 'vue'
    import api from '../utils/axios'
    
    const isRegister = ref(false)
    const isConfirmEmail = ref(false)

    // Регистрация

    const form = ref({
        email: '',
        password: '',
        repeatPassword: ''
    })

    const isLoading = ref(false)

    const errors = ref({
        email: '',
        password: '',
        repeatPassword: ''
    })

    const clearErrors = () => {
        errors.value = {email: '', password: '', repeatPassword: ''}
    }

    // Валидация формы

    const validateForm = () => {
        clearErrors()

        if(!form.value.email) {
            errors.value.email = 'Email обязателен'
            return false
        } else {
            const emailRegex = /^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$/
            if (!emailRegex.test(form.value.email)) {
                errors.value.email = 'Некорректный email'
                return false
            }
        }

        if(!form.value.password) {
            errors.value.password = 'Пароль обязателен'
            return false
        } else if (form.value.password.length < 6) {
            errors.value.password = 'Пароль должен содержать минимум 6 символов'
            return false
        } 

        if(isRegister.value && form.value.password !== form.value.repeatPassword) {
            errors.value.repeatPassword = 'Пароли не совпадают'
            return false;
        }

        return true
    }


     // Пропсы

    const props = defineProps(['closeFn'])

    const close = () => {
        props.closeFn()
    }

    const handleSubmit = async () => {
        if (!validateForm()) {
            return;
        }
  

        isLoading.value = true;
        clearErrors();

        const endpoint = isRegister.value ? 'auth/send-verification' : 'auth/login'

        try {
            const { data } = await api.post(endpoint, {
                email: form.value.email,
                password: form.value.password,
            });
            
            if(isRegister.value && data.success) {
                toggleBlock()
            }

            if(!isRegister.value && data.success) {
                close()
            }

        } catch (err) {
            console.log('🚨 ERROR:', err.response?.data);
            if (err.response?.data?.error) {
            errors.value.email = err.response.data.error;
            } else {
            errors.value.email = 'Ошибка сервера';
            }
        } finally {
            isLoading.value = false
        }
    };


    // Работа с UI

    const toggleForm = () => {
        isRegister.value = !isRegister.value
        clearErrors()
        form.value.repeatPassword = ''
    }

    const toggleBlock = () => {
        isConfirmEmail.value = !isConfirmEmail.value
    }

    // Ячейки email

    const code = ref(['','','','','',''])
    const activeIndex = ref(0)
    const inputRefs = ref([])

    const fullCode = computed(() => code.value.join(''))

    const validateCode = () => {
        if(fullCode.value.length < 6) {
            return false
        }
        return true
    }

    const codeError = ref('');

    const handleCodeSubmit = async () => {
        if(!validateCode()) {
            return
        }

        codeError.value = ''

        try {
            await api.post('auth/verify-code', {
                code: fullCode.value
            });

            close()
        } catch (err) {
            codeError.value = err.response?.data?.error || 'Неверный код';
        }
    }
   
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


</script>

<template>
    <div class="auth-popUp-wrapper flex-center">
        <div class="auth-popUp flex-column">
            <div class="auth-reg-block" v-if="!isConfirmEmail">
                <div class="auth-label flex align-c justify-sb">
                    <span class="popUp-label">{{ isRegister ? 'Регистрация' : 'Вход' }}</span>
                    <button @click="close()" type="button" class="no-border btn-close"></button>
                </div>
                <div class="field-wrapper flex-column">

                    <div class="field-block flex-column">
                        <label for="email">Email:</label>
                        <div class="input-block flex align-c justyfy-sb">
                            <input v-model="form.email" type="email" id="email" class="input-field no-border" required>
                            <img src="/images/email-icon.png">
                        </div>
                        <div class="error-block" v-if="errors.email">
                            <span>{{ errors.email }}</span>
                        </div>
                    </div>

                    <div class="field-block flex-column">
                        <label for="password">Пароль:</label>
                        <div class="input-block flex align-c justyfy-sb">
                            <input v-model="form.password" type="password" id="password" class="input-field no-border" required>
                            <img src="/images/password.png">
                        </div>
                        <div class="error-block" v-if="errors.password">
                            <span>{{ errors.password }}</span>
                        </div>
                    </div>

                    <div class="field-block flex-column" v-if="isRegister">
                        <label for="repeat-pass">Повторный пароль:</label>
                        <div class="input-block flex align-c justyfy-sb">
                            <input v-model="form.repeatPassword" type="password" id="repeat-pass" class="input-field no-border" required>
                            <img src="/images/password.png">
                        </div>
                        <div class="error-block" v-if="errors.repeatPassword">
                            <span>{{ errors.repeatPassword }}</span>
                        </div>
                    </div>

                    <div class="nav-block flex align-c">
                        <button @click="toggleForm()" type="button" class="no-border">{{ isRegister ? 'Войти' : 'Регистрация' }}</button>
                        <button type="button" class="no-border">Забыли пароль ?</button>
                    </div> 

                    <!-- это от кнопки -->
                    <!-- @click="isRegister ? toggleBlock : handleSubmit"  -->

                    <button 
                        @click="handleSubmit"
                        :disabled="isLoading"
                        type="button" class="no-border btn-reg-auth">
                        {{  isRegister ? 'Зарегистрироваться' : 'Войти' }}
                    </button>

                </div>    
            </div>

            <div class="confirm-email-block flex-column"  v-if="isConfirmEmail">
                <button @click="toggleBlock()" type="button" class="no-border return-to-back flex-center">
                    <svg width="16" height="16" viewBox="0 0 16 16" fill="none" xmlns="http://www.w3.org/2000/svg">
                        <path d="M14.9512 0.879883L14.9512 14.8799M8.50727 14.7239L1.03206 7.78425C0.988737 7.74402 0.989573 7.6752 1.03386 7.63604L8.50907 1.02686C8.57362 0.969791 8.67531 1.01562 8.67531 1.10178L8.67531 14.6506C8.67531 14.7379 8.57126 14.7833 8.50727 14.7239Z" stroke="#313131" stroke-width="2"/>
                    </svg>
                </button>

                <span class="label-confirm label">Подтверждение адреса электронной почты</span>

                <span class="label-send label flex-center flex-column">
                    Мы отправили уведомление с кодом на электронную почту 
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
                    type="text"
                    class="code-input"
                    maxlength="1"
                    inputmode="numeric"
                    />
                </div>

                <div class="error-block flex-center" v-if="codeError">
                    <span>{{ codeError}}</span>
                </div>

                <button @click="handleCodeSubmit" type="button" class="no-border btn-reg-auth">Подтвердить</button>

            </div>

        </div>
    </div>

</template>

<style scoped>

    /* ПопАП */

    .auth-popUp-wrapper {
        position: absolute;
        top: 0;
        bottom: 0;
        left: 0;
        right: 0;
        width: 100%;
        height: 100%;
        background-color: #00000075;
        z-index: 1000;
    }

    .auth-popUp {
        max-width: 450px;
        width: 100%;
        padding: 32px 24px;
        background-color: #101010;
        border-radius: 8px;
        position: relative;
    }

    .popUp-label {
        font-family: Roboto_SemiBold;
        font-size: 32px;
        color: var(--font-secondary);
    }

    .field-wrapper {
        width: 100%;
        margin-top: 32px;
        gap: var(--gp-24);
    }

    .field-block {
        width: 100%;
        font-family: Roboto_Regular;
        font-size: 18px;
        gap: var(--gp-8);
    }

    .input-block {
        width: 100%;
        gap: var(--gp-16);
        border-bottom: 1px solid #575757;
        padding-bottom: 4px;
        padding-right: 8px;
        background-color: transparent !important;
    }

    .input-field {
        width: 100%;
        font-size: 12px;
        color: var(--font-primary-50);
        font-size: 16px;
    }

    input:-webkit-autofill {
    box-shadow: 0 0 0px 1000px #101010 inset !important;
    -webkit-text-fill-color: var(--font-primary-50) !important;
    }

    .nav-block {
        justify-content: space-between;
        font-size: 14px;
        font-family: Roboto_Regular;
    }

    .nav-block button {
        color: var(--another-color);
        border-bottom: 1px solid var(--another-color);
        padding: 0;
    }

    .btn-reg-auth {
        width: 100%;
        padding-block: 8px;
        background-color: var(--btn-color-1);
        border-radius: 8px;
        font-size: 16px;
        font-family: Roboto_Medium;
        margin-top: 32px;
    }

    .auth-label {
        width: 100%;
        position: relative;
    }

    .error-block {
        width: fit-content;
        font-family: Roboto_Regular;
        font-size: 16px;
        color: rgb(255, 55, 55);
    }

    .confirm-email-block .error-block {
        margin: 0 auto;
        margin-top: 16px;
    }

    /* Кнопка закрытия */


    .btn-close {
        position: relative;
        width: 32px;
        height: 32px;
    }

    .btn-close::before,
    .btn-close::after {
        content: '';
        position: absolute;
        top: 16px;
        width: 20px;
        height: 2px;
        background: var(--font-primary-50);
        transform: translate(-50%, -50%) rotate(45deg);
    }

    .btn-close::after {
        transform: translate(-50%, -50%) rotate(-45deg);
    }

    .btn-close:hover::before,
    .btn-close:hover::after {
        background-color: var(--font-primary);
    }

    /* Блок с подтверждением email */

    .return-to-back {
        margin-right: auto;
        padding: 0;
    }

    .return-to-back svg {
        width: 20px;
        height: 20px;
    }

    .label {
        text-align: center;
        font-family: Roboto_SemiBold;
        margin: 0 auto;
    }

    .label-confirm {
        margin-top: 24px;
        font-size: 24px;
    }

    .label-send {
        font-size: 16px;
        margin-top: 20px;
        color: var(--font-primary-50);
        gap: var(--gp-4);
    }

    .name-email {
        font-size: 18px;
        color: var(--font-primary);
    }

    .code-block {
        gap: var(--gp-12);
        margin-top: 32px;
    }

    .code-input {
        text-align: center;
        width: 36px;
        height: 36px;
        font-size: 20px;
        font-family: Roboto_SemiBold;
        border-radius: 4px;
        background-color: #181818;
        border: 1px solid #1E1E1E;
        color: var(--font-primary);
    }
</style>