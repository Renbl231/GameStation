<script setup>
    import { ref, onMounted, watch} from 'vue'
    import { storeToRefs } from 'pinia'
    import { useAuthStore } from '../stores/authStore'
    import { useRoute, useRouter } from 'vue-router'
    import api from '../utils/axios'

    const authStore = useAuthStore()
    const { isAuthenticated } = storeToRefs(authStore)

    const route = useRoute()
    const router = useRouter()

    const isEdit = ref(false)

    const toggleEdit = () => {
        isEdit.value = !isEdit.value
    }

    const closeEdit = () => isEdit.value = false

// fdfsdf

const errorMessage = ref('')

const userData = ref({
    banner_url: ''
})

const form = ref({
    nickname: '',
    password: '',
    repeatPassword: '',
    avatar: '',
    banner: ''
})

const requestData = async () => {
    try {
        errorMessage.value = ''
        const { data } = await api.get(`/user/${route.params.nickname}`)
        if(data.success && data.userData) {
            userData.value = data.userData
            form.value.nickname = userData.value.nickname
            form.value.avatar = userData.value.avatar_url
            form.value.banner = userData.value.banner_url
        } else {
            userData.value = null
        }
    } catch(error) {
        if(error.response?.status === 404) {
            errorMessage.value = 'Пользователь не найден'
        } else {
            errorMessage.value = 'Ошибка загрузки профиля'
        }
    }
}

// редактирование данных


const errorUpdate = ref('')
    const updateData = async() => {
        if (form.value.password && form.value.password !== form.value.repeatPassword) {
            alert('Пароли не совпадают!')
            return
        }
        if (form.value.nickname.trim().length < 5) {
            alert('Никнейм минимум 5 символа!')
            return
        }
        try {
            errorUpdate.value = ''
            const { data } = await api.put(`/user/${route.params.nickname}/edit`, {
                nickname: form.value.nickname.trim(),
                avatar: form.value.avatar.trim() || null,
                banner: form.value.banner.trim() || null,
                password: form.value.password.trim() || null
            })
            
            if (data.success && data.result) {
                toggleEdit()
                Object.assign(userData.value, data.result)
                if(data.result.nickname !== route.params.nickname) {
                    await router.push(`/user/${data.result.nickname}`)
                } 
            } else {
                errorUpdate.value = data.error || 'Ошибка сохранения'
                return
            }
        } catch (error) {
            errorUpdate.value = error.response?.data?.error || 'Ошибка сервера'
        }
    }

    watch(
        () => route.params.nickname,
        async (newNickname) => {
            if(newNickname) {
                await requestData()
            }
        }
    )


    onMounted(() => {
        requestData()
    })
</script>

<template>
    <div v-if="errorUpdate" class="er">
        {{  errorUpdate }}
    </div>


    <div v-if="errorMessage" class="error-block">
        <span>{{ errorMessage }}</span>
    </div>

    <div v-else class="profile-wrapper flex-column">
        <div class="profile-header" 
            :style="{
            backgroundImage: `url(${userData.banner_url})`,
            backgroundSize: 'cover',
            backgroundPosition: 'center',
            backgroundRepeat: 'no-repeat'
            }"> 
            <div class="profile-header__banner flex">
                <div class="profile-header__avatar-block flex align-c">
                    <img :src="userData.avatar_url" alt="" class="profile-header__avatar">
                    <span class="profile-header__nickname">{{  userData.nickname }}</span>
                </div>
                <div v-if="isAuthenticated && authStore.user?.id === userData.idUser" class="profile-header__settings-block flex">
                    <button @click="toggleEdit()" type="button" class="no-border profile-header__settings-btn">Настройки</button>
                </div>
            </div>
        </div>
        <div class="profile-container">
            <div v-if="isEdit" class="edit-profile-block flex-column">
                <span class="edit-profile-block__label">Редактирование профиля</span>
                <div class="edit-profile-block__wrapper flex align-c">
                    <div class="edit-profile-block__left-side flex-column">
                        <span class="edit-profile-block__field-name">
                            Ваше имя:
                        </span>
                        <span class="edit-profile-block__field-name">
                            Новый пароль:
                        </span>
                        <span class="edit-profile-block__field-name">
                            Повторный пароль:
                        </span>
                        <span class="edit-profile-block__field-name">
                            Аватар:
                        </span>
                        <span class="edit-profile-block__field-name">
                            Баннер:
                        </span>
                    </div>
                    <div class="edit-profile-block__right-side flex-column">
                        <input v-model="form.nickname" class="edit-profile-block__input no-border">
                        <input v-model="form.password" class="edit-profile-block__input no-border" placeholder="пароль">
                        <input v-model="form.repeatPassword" class="edit-profile-block__input no-border" placeholder="повторный пароль">
                        <input v-model="form.avatar" class="edit-profile-block__input no-border"placeholder="url-ссылка">
                        <input v-model="form.banner" class="edit-profile-block__input no-border" placeholder="url-ссылка">
                    </div>
                </div>
                <div class="edit-profile-block__btns flex align-c">
                    <button @click="updateData()" type="button" class="no-border edit_profile-block__btn">Сохранить</button>
                    <button @click="closeEdit()" type="button" class="no-border edit_profile-block__btn">Отменить</button>
                </div>
            </div>
        </div> 
    </div>
</template>

<style scoped>

    .profile-wrapper {
        width: 100%;
    }

    .profile-header {
        width: 100%;
        border-radius: 8px 8px 0 0;
    }

    .profile-header__banner {
        width: 100%;
        min-height: 200px;
        border-radius: 8px 8px 0 0;
        padding-left: 32px;
        padding-right: 16px;
    }

    .profile-header__avatar-block {
        gap: var(--gp-24);
    }

    .profile-header__avatar {
        width: 160px;
        height: 160px;
        border-radius: 50%;
    }

    .profile-header__nickname {
        font-family: Roboto_SemiBold;
        font-size: 32px;
    }

    .profile-header__settings-block {
        margin-left: auto;
        margin-top: auto;
        padding-bottom: 16px;
    }

    .profile-header__settings-btn {
        width: fit-content;
        height: fit-content;
        font-size: 18px;
        font-family: Roboto_Medium;
        background-color: var(--font-primary-25);
        padding: 8px 16px;
        border-radius: 4px;
    }

    .profile-container {
        width: 100%;
        background-color: var(--bg-secondary-25);
        border-radius: 0 0 8px 8px;
        padding: 32px;
    }

    /* редактирование профиля блок */

    .edit-profile-block {
        padding: 16px 24px;
        background-color: var(--bg-fourth);
        border-radius: 8px;
        gap: var(--gp-24);
    }

    .edit-profile-block__label {
        font-size: 18px;
        font-family: Roboto_SemiBold;
    }

    .edit-profile-block__wrapper {
        gap: var(--gp-48);
    }

    .edit-profile-block__left-side {
        width: 20%;
        gap: var(--gp-24);
    }

    .edit-profile-block__field-name {
        font-family: Roboto_Medium;
        font-size: 16px;
    }

    .edit-profile-block__right-side {
        width: 80%;
        gap: var(--gp-20);
    }

    .edit-profile-block__input {
        font-size: 14px;
        font-family: Roboto_Medium;
        background-color: #11151A;
        border-radius: 4px;
        padding: 4px 16px;
        color: var(--font-primary-50);
    }

    .edit-profile-block__input::placeholder {
        color: var(--font-primary-50);
    }

    .edit-profile-block__btns {
        gap: var(--gp-16);
    }

    .edit_profile-block__btn {
        font-size: 16px;
        font-family: Roboto_Medium;
        padding: 4px 16px;
        border-radius: 4px;
        background-color: var(--font-secondary);
    }


</style>