<script setup>
    import { ref, onMounted, watch, provide} from 'vue'
    import { storeToRefs } from 'pinia'
    import { useAuthStore } from '../stores/authStore'
    import { useRoute, useRouter } from 'vue-router'
    import api from '../utils/axios'
    import { useNotifications } from '../stores/notifications'
    import { useApiNotifications } from '../composables/useApi'
    import { useGlobal404 } from '../composables/useGlobal404'

    const { set404 } = useGlobal404()
    const { apiCall } = useApiNotifications()
    const notification = useNotifications()

    const authStore = useAuthStore()
    const { isAuthenticated } = storeToRefs(authStore)

    const route = useRoute()
    const router = useRouter()

    const isEdit = ref(false)
    const isLoading = ref(false)

    const toggleEdit = () => {
        isEdit.value = !isEdit.value
    }

    const closeEdit = () => isEdit.value = false

    const userData = ref({})

    const form = ref({
        nickname: '',
        password: '',
        repeatPassword: ''
    })

    const userId = ref(null)
    provide('userId', userId)

    const profileKey = ref(0)

    const requestData = async () => {
        isLoading.value = true
        try {
            const { data } = await api.get(`/user/${route.params.nickname}`)
            if(data.success && data.userData) {
                userData.value = data.userData || null
                userId.value = data.userData.idUser
                form.value.nickname = userData.value.nickname
            } else {
                set404()
            }

        } catch(error) {
            userData.value = null
            set404()
        } finally {
            profileKey.value ++;
            isLoading.value = false
        }
    }

    // редактирование данных

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
            notification.warning('Никнейм должен содержать минимум 5 символов')
            form.value.nickname = userData.value.nickname
            return
        }

        const data = await apiCall(() =>
            api.put('/user/me', {
                nickname: form.value.nickname.trim(),
                password: form.value.password.trim() || null
            }),
            'Изменения сохранены'
        )

        if (data.success && data.result.user) {
            toggleEdit()
            userData.value.nickname = data.result.user.nickname
            if (data.result.user.nickname !== route.params.nickname) {
                await router.push(`/user/${data.result.user.nickname}`)
            }
        }
    }

    const updateAvatar = async () => {

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
    <div v-if="isLoading"></div>

    <input type="file" placeholder="файл загрузи" @change="onFileChange">
    <button @click="downloadPhoto" type="button">Загрузить фото</button>

    <div v-if="userData && Object.keys(userData).length > 0 && !isLoading" :key="profileKey" class="profile-wrapper flex-column">
        <div class="profile-header-banner" 
            :style="{
            backgroundImage: userData.banner_url ? `url(${userData.banner_url})` : 'none',
            backgroundSize: 'cover',
            backgroundPosition: 'center',
            backgroundRepeat: 'no-repeat'
            }"> 
        </div>
        <div class="profile-header-avatar flex align-c justify-sb">
            <img 
                v-if="userData.avatar_url"
                :src="userData.avatar_url" 
                class="profile-header-avatar__img">
            <span class="profile-header__nickname" :class="{'unactive': !userData.avatar_url}">{{  userData.nickname }}</span>
            <button v-if="isAuthenticated && authStore.user?.id === userData.idUser" 
                    @click="toggleEdit()" type="button" 
                    class="no-border profile-header-avatar__settings-btn">
                Настройки
            </button>
        </div>
        <div class="content-container flex">
            <div class="left-section flex-column">
                <RouterLink :to="`/user/${route.params.nickname}/games`" :class="{'active': $route.path.includes('/games')}" class="currentSection">Коллекция игр</RouterLink>
                <RouterLink :to="`/user/${route.params.nickname}/reviews`" :class="{'active': $route.path.includes('/reviews')}" class="currentSection">Рецензии</RouterLink>
                <RouterLink :to="`/user/${route.params.nickname}/comments`" :class="{'active': $route.path.includes('/comments')}" class="currentSection">Комментарии</RouterLink>
            </div>
            <RouterView />
      
        </div>
        <div class="profile-container">
            <hr>
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
                    </div>
                    <div class="edit-profile-block__right-side flex-column">
                        <input v-model="form.nickname" class="edit-profile-block__input no-border">
                        <input v-model="form.password" class="edit-profile-block__input no-border" placeholder="пароль">
                        <input v-model="form.repeatPassword" class="edit-profile-block__input no-border" placeholder="повторный пароль">

                        <label class="upload-btn">
                            <span>Загрузить аватар</span>
                            <input type="file" accept="image/*" @change="onFileChange('avatar', $event)" class="upload-btn__input">
                        </label>

                        <label class="upload-btn">
                            <span>Загрузить баннер</span>
                            <input type="file" accept="image/*" @change="onFileChange('banner', $event)" class="upload-btn__input">
                        </label>

                    

                    </div>
                </div>
                <div class="edit-profile-block__btns flex align-c">
                    <button @click="updateData()" type="button" class="no-border edit_profile-block__btn">Сохранить</button>
                    <button @click="closeEdit()" type="button" class="no-border edit_profile-block__btn danger">Отменить</button>
                </div>
            </div>
        </div> 
    </div>
</template>

<style scoped>

    hr {
        width: 100%;
        color: var(--bg-secondary);
        margin-bottom: 16px;
    }

    .profile-wrapper {
        width: 100%;
        background-color: var(--btn-color-7);
        border-radius: 8px 8px 0 0;
    }

    .profile-header-banner {
        width: 100%;
        height: 254px;
        border-radius: 8px 8px 0 0;
    }

    .profile-header-avatar {
        width: 100%;
        gap: var(--gp-24);
        position: relative;
        padding-inline: 32px;
        padding-top: 10px;
    }

    .profile-header-avatar__img {
        position: absolute;
        width: 160px;
        height: 160px;
        border-radius: 50%;
        border: 6px solid var(--btn-color-7);
        border-bottom: none;
        bottom: 0px;
    }

    .profile-header__nickname {
        font-family: Roboto_SemiBold;
        font-size: 32px;
        margin-left: 184px;
    }

    .profile-header__nickname.unactive {
        margin-left: 0px;
    }

    .profile-header-avatar__settings-btn {
        width: fit-content;
        height: fit-content;
        font-size: 18px;
        font-family: Roboto_Medium;
        background-color: var(--font-primary-25);
        padding: 8px 16px;
        border-radius: 4px;
    }

    .profile-header-avatar__settings-btn:hover {
        background-color: var(--font-primary-50);
    }

    /* Основной блок с контентом */

    .content-container {
        width: 100%;
        padding: 32px;
        gap: var(--gp-32);
    }

    .left-section {
        max-width: 20%;
        width: 100%;
        gap: var(--gp-16);
    }

    .currentSection {
        width: 100%;
        padding: 8px 12px;
        background-color: var(--bg-secondary-25);
        border-radius: 4px;
        font-family: Roboto_Medium;
        font-size: 18px;
    }

    .currentSection.active {
        background-color: var(--font-secondary);
    }
    

    /* редактирование профиля блок */

    
    .profile-container {
        width: 100%;
        border-radius: 0 0 8px 8px;
        padding-inline: 32px;
        padding-top: 10px;
        padding-bottom: 16px;
    }


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

    .edit_profile-block__btn.danger {
        background-color: var(--btn-color-2);
    }

    .profile-wrapper {
        animation: contentFadeIn 0.3s ease-out;
    }

   .profile-wrapper {
        animation: contentFadeIn 0.4s ease-out;
    }

    @keyframes contentFadeIn {
        from {
            opacity: 0.25;
        }
        to {
            opacity: 1;
        }
    }



    /* Кнопка загрузки аватар */

    .upload-btn {
        display: inline-block;
        padding: 12px 20px;
        background: #4299e1;
        color: white;
        border-radius: 8px;
        cursor: pointer;
        font-weight: 500;
        transition: background 0.3s;
    }

    .upload-btn:hover {
         background: #3182ce;
    }

    .upload-btn__input {
        display: none;  /* ✅ Скрываем input */
    }

    </style>