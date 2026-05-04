<script setup>
    import { ref, onMounted, watch, provide, computed} from 'vue'
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
    const { isAuthenticated, user } = storeToRefs(authStore)

    const route = useRoute()
    const router = useRouter()

    const isEdit = ref(false)
    const isLoading = ref(true)

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

    const collectionGames = ref([])

    const favoriteGames = computed(() => 
        collectionGames.value.filter(game => game.collection_type === 'Любимые')
    )

    const currentGames = computed(() => 
        collectionGames.value.filter(game => game.collection_type === 'Сейчас играю')
    )

    const requestData = async () => {
        try {
            const { data } = await api.get(`/user/${route.params.nickname}`)
            if(data.success && data.userData) {
                userData.value = data.userData || null
                userId.value = data.userData.idUser
                collectionGames.value = data.userData.games
                form.value.nickname = userData.value.nickname
            } else {
                set404()
            }
        } catch(error) {
            userData.value = null
            set404()
        } finally {
            profileKey.value ++;
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

    const selectedFile = ref(null)
    const currentType = ref('avatar')

        const onFileChange = async (event, type) => {
        const file = event.target.files[0]
        if (!file) return 
        
        selectedFile.value = file
        currentType.value = type
        

        await updateImages(type)
    }


    const updateImages = async (type) => {
        const file = selectedFile.value
        if (!file) return
        
        try {
            const formData = new FormData()
            formData.append(type, file)
            
            const { data } = await api.put(`/user/me/${type}`, formData)
            
            if (data.success) {
            userData.value[type + '_url'] = data.result[type + '_url']
            selectedFile.value = null
            }
        } catch (error) {
            console.error('Ошибка загрузки:', error)
        }
    }


    watch(
        () => route.params.nickname,
        async (newNickname) => {
            if (newNickname) await requestData()
        }
    )

    const onAvatarError = (event) => {
        event.target.src = '/images/plug_avatar.png'
    }

    const onBanerError = (event) => {
        event.target.src = '/images/plug_baner.png'
    }



    onMounted(async () => {
        await requestData()
        isLoading.value = false
    })
</script>

<template>

    <Transition name="fade">
        <div v-if="userData && Object.keys(userData).length > 0 && !isLoading" :key="profileKey" class="profile-wrapper flex-column">
            <div class="profile-header-banner">
                <picture>
                    <img :src="userData.banner_url || '/images/plug_baner.png'" @error="onBanerError" class="profile__banner">
                </picture>
                <label class="profile-header__label flex-center">
                    Изменить банер
                    <input type="file" 
                        accept="image/*" 
                        @change="(e) => onFileChange(e, 'banner')"
                        class="profile-header__input">
                </label>                  
            </div>
            <div class="profile-header-avatar flex align-c justify-sb">
                <div class="avatar-block flex-center">
                    <img 
                        :src="userData.avatar_url || '/images/plug_avatar.png'" 
                        @error="onAvatarError"
                        class="avatar-block__img"
                    >
                    <label class="avatar-block__label flex-center">
                        Изменить аватар
                        <input type="file" 
                            accept="image/*" 
                            @change="(e) => onFileChange(e, 'avatar')"
                            class="avatar-block__input">
                    </label>
                </div>
                <span class="profile-header__nickname">{{ userData.nickname }}</span>
                <button v-if="isAuthenticated && authStore.user?.id === userData.idUser" 
                        @click="toggleEdit()" type="button" 
                        class="no-border profile-header-avatar__settings-btn">
                    Настройки
                </button>
            </div>

            <div class="profile-container flex-column">
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
                        </div>
                    </div>
                    <div class="edit-profile-block__btns flex align-c">
                        <button @click="updateData()" type="button" class="no-border edit_profile-block__btn">Сохранить</button>
                        <button @click="closeEdit()" type="button" class="no-border edit_profile-block__btn danger">Отменить</button>
                    </div>
                </div>
            </div> 

            <div class="content-container flex">
                <div class="left-section flex-column">
                    <RouterLink 
                        :to="`/user/${route.params.nickname}`" 
                        :class="{ active: !($route.path.includes('/games') || $route.path.includes('/reviews') || $route.path.includes('/comments') || $route.path.includes('/requests')) }"
                        class="currentSection"
                    >
                        Главная
                    </RouterLink>
                    <RouterLink :to="`/user/${route.params.nickname}/games`" :class="{'active': $route.path.includes('/games')}" class="currentSection">Коллекция игр</RouterLink>
                    <RouterLink :to="`/user/${route.params.nickname}/reviews`" :class="{'active': $route.path.includes('/reviews')}" class="currentSection">Рецензии</RouterLink>
                    <RouterLink :to="`/user/${route.params.nickname}/comments`" :class="{'active': $route.path.includes('/comments')}" class="currentSection">Комментарии</RouterLink>
                    <RouterLink v-if="user?.id === userId" :to="`/user/${route.params.nickname}/requests`" :class="{'active': $route.path.includes('/requests')}" class="currentSection">Запросы</RouterLink>
                </div>
                <div v-if="!($route.path.includes('/games') || $route.path.includes('/reviews') || $route.path.includes('/comments') || $route.path.includes('/requests'))" class="game-collection flex-column">
                    <div class="collection-block-label flex align-c justify-sb">
                        <span class="collection__label">Любимые</span>
                        <RouterLink :to="`/user/${route.params.nickname}/games`"class="collection__link">Смотреть все</RouterLink>
                    </div>
                    <div class="game-wrapper">
                        <div class="game" v-for="game in favoriteGames" :key="game.idGame">
                            <RouterLink :to="`/game/${game.idGame}`">
                                <picture>
                                    <img :src="game.cover_url" class="game__cover">
                                </picture>
                            </RouterLink>
                        </div>
                    </div>
                    <hr>
                    <div class="collection-block-label flex align-c justify-sb">
                        <span class="collection__label">Сейчас играю</span>
                        <RouterLink :to="`/user/${route.params.nickname}/games` "class="collection__link">Смотреть все</RouterLink>
                    </div>
                    <div class="game-wrapper">
                        <div class="game" v-for="game in currentGames" :key="game.idGame">
                            <RouterLink :to="`/game/${game.idGame}`">
                                <picture>
                                    <img :src="game.cover_url" class="game__cover">
                                </picture>
                            </RouterLink>
                        </div>
                    </div>
                </div>
                <RouterView />
            </div>
            
        </div>
    </Transition>
</template>

<style scoped>

    .profile-wrapper {
        width: 100%;
        border-radius: 8px 8px 0 0;
        gap: var(--gp-16);
        background-color: var(--color-2);
    }

    .profile-header-banner {
        position: relative;
        width: 100%;
        height: 254px;
        border-radius: 8px 8px 0 0;
    }

    .profile__banner {
        width: 100%;
        height: 100%;
    }

    .profile-header__label {
        position: absolute;
        bottom: 4px;
        right: 4px;
        background-color: rgba(0,0,0,0.5);
        border-radius: 6px;
        color: var(--font-primary-75);
        padding:4px 8px;
        font-family: Roboto_Regular;
    }

    .profile-header__label:hover {
        color: var(--font-primary);
    }

    .profile-header__input,
    .avatar-block__input {
        display: none;
    }

    /* Аватар блок */

    .profile-header-avatar {
        width: 100%;
        gap: var(--gp-24);
        position: relative;
        padding-inline: 32px;
    }

    .avatar-block {
        position: absolute;
        width: 160px;
        height: 160px;
        border-radius: 50%;
        border: 6px solid var(--color-2);
        bottom: -20%;
    }

    .avatar-block:hover .avatar-block__img {
        filter: brightness(0.5);
    }

    .avatar-block:hover .avatar-block__label {
        position: absolute;
        display: flex;
        width: 100%;
        height: 100%;
    }

    .avatar-block__img {
        width: 100%;
        height: 100%;
        border-radius: 50%;
    }

    .avatar-block__label {
        display: none;
        font-family: Roboto_Medium;
    }

    .profile-header-avatar::before {
        content: '';
        width: 160px;
        flex-shrink: 0;
    }
    
    .profile-header__nickname {
        font-family: Roboto_SemiBold;
        font-size: 32px;
        flex: 1; 
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
        padding-inline: 32px;
        padding-bottom: 32px;
        padding-top: 16px;
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

    /* Коллекция игр */

    .game-collection {
        width: 100%;
        gap: var(--gp-16);
    }

    .game-wrapper {
        width: 100%;
        display: grid;
        grid-template-columns: repeat(5, 1fr);
        gap: var(--gp-24);

    }
    
    .collection__label {
        font-family: Roboto_Medium;
        font-size: 24px;
    }

    .collection__link {
        font-family: Roboto_Medium;
        font-size: 18px;
        color: var(--font-primary-75);
    }

    .game {
        max-width: 174px;
        max-height: 232px;
    }

    .game__cover {
        width: 100%;
        height: 100%;
        border-radius: 8px;
    }
    

    /* редактирование профиля блок */

    
    .profile-container {
        width: 100%;
        border-radius: 0 0 8px 8px;
        padding-inline: 32px;
    }

    .edit-profile-block {
        padding: 16px 24px;
        background-color: var(--bg-fourth);
        border-radius: 8px;
        gap: var(--gp-24);
        margin-top: 16px;
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


    </style>