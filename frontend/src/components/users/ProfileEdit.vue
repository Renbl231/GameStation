<script setup>
    import { ref, } from 'vue'
    import { useNotifications } from '@stores/notifications'
    import { useApiNotifications } from '@composables/useApi'
    import { useRoute, useRouter } from 'vue-router'
    import api from '@utils/axios'

    const { apiCall } = useApiNotifications()
    const notification = useNotifications()

    const router = useRouter()
    const route = useRoute()

    const emits = defineEmits('close')

    const currentNickname = route.params.nickname

    const form = ref({
        nickname: currentNickname,
        password: '',
        repeatPassword: ''
    })

    const updateData = async () => {
        if (form.value.password && form.value.password !== form.value.repeatPassword) {
            notification.warning('Пароли не совпадают')
            return
        }
        if (form.value.password && form.value.password.length < 6) {
            notification.warning('Пароль должен содержать минимум 6 символов')
            return
        }
        if (form.value.nickname.trim().length < 5) {
            notification.warning('Никнейм слишком короткий')
            form.value.nickname = userData.value.nickname
            return
        }
        if (form.value.nickname.trim().length > 30) {
            notification.warning('Никнейм слишком длинный')
            form.value.nickname = userData.value.nickname
            return
        }

        const data = await apiCall(() => api.put('/user/me', {
            nickname: form.value.nickname.trim(),
            password: form.value.password.trim() || null
        }), 'Изменения сохранены')

        if (data?.result.nickname !== currentNickname) {
            await router.push(`/user/${data.result.nickname}`)
        }
    }
</script>

<template>
    <div class="profile-editor flex-column">
        <span class="profile-editor__headline">Редактирование профиля</span>
        <div class="profile-editor__form flex-column">
            <label for="name" class="flex-column profile-editor__label">
                <span class="profile-editor__field-txt">Имя:</span>
                <input v-model="form.nickname" id="name" class="profile-editor__input no-border" placeholder="Введите имя">
            </label>
            <label for="password" class="flex-column profile-editor__label">   
                <span class="profile-editor__field-txt">Пароль:</span>
                <input v-model="form.password" id="password" class="profile-editor__input no-border" placeholder="Введите пароль">
            </label>
            <label for="repeat-password" class="flex-column profile-editor__label">
                <span class="profile-editor__field-txt">Повторый пароль:</span>
                <input v-model="form.repeatPassword" id="repeat-password" class="profile-editor__input no-border" placeholder="Введите повторный пароль">
            </label>
        </div>
        <div class="profile-editor__btns flex align-c">
            <button @click="emits('close')" type="button" class="no-border profile-editor__btn profile-editor__btn-danger">Отменить</button>
            <button @click="updateData" type="button" class="no-border profile-editor__btn">Сохранить</button>
        </div>
    </div>
</template>

<style lang="scss" scoped>
    .profile-editor {
        width: 100%;
        max-width: 1072px;
        margin: 0 auto;
        padding: 16px;
        border-radius: 8px;
        background-color: var(--bg-tertiary);
        border: 1px solid var(--bg-secondary-border);
        gap: var(--gp-16);

        &__headline {
            font-family: Roboto_Medium;
            font-size: 20px;
            color: var(--text-primary);
        }

        &__form {
            gap: var(--gp-16);
        }

        &__label {
            gap: var(--gp-8);
            font-family: Roboto_Regular;
            color: var(--text-secondary);
        }

        &__input {
            padding: 8px 8px;
            background-color: var(--bg-secondary);
            border: 1px solid var(--bg-secondary-border);
            border-radius: 8px;
            font-size: 14px;
            font-family: Roboto_Regular;

            &:focus {
                outline: none;
                box-shadow: 
                    0 0 0 1px rgba(74, 144, 226, 0.2),
                    0 0 20px rgba(74, 144, 226, 0.15),
                    inset 0 1px 3px rgba(0, 0, 0, 0.1);
                transition: all 0.25s ease;
            }
        }

        &__btns {
            width: fit-content;
            gap: var(--gp-12);
            margin-left: auto;
            margin-top: 8px;
        }

        &__btn {
            font-family: Roboto_Regular;
            font-size: 16px;
            background-color: var(--color-green);
            border-radius: 4px;
            padding: 6px 12px;

            &:hover {background-color: var(--color-green-hover);}

            &-danger {
                background-color: transparent;
                color: var(--text-primary);
                &:hover {
                    background-color: var(--color-red);
                    color: var(--white);
                }
            }
        }

    }
</style>