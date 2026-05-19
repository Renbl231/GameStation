<script setup>
    import BanModal from '../components/BanModal.vue';
    import ConfirmPopUp from '../components/ConfirmPopUp.vue';

    import { ref, onMounted, watch, provide, computed} from 'vue'
    import { storeToRefs } from 'pinia'
    import { useAuthStore } from '../stores/authStore'
    import { useRoute, useRouter } from 'vue-router'
    import api from '../utils/axios'
    import { useNotifications } from '../stores/notifications'
    import { useApiNotifications } from '../composables/useApi'
    import { useGlobal404 } from '../composables/useGlobal404'

    import { useModeration } from '../composables/useModeration';
    const { moderateProfile, moderateUnblock, moderateRole } = useModeration()

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

    const collectionGames = ref([])

    const favoriteGames = computed(() => 
        collectionGames.value.filter(game => game.collection_type === 'Любимые')
    )

    const currentGames = computed(() => 
        collectionGames.value.filter(game => game.collection_type === 'Сейчас играю')
    )

    const requestData = async () => {
        isLoading.value = true
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

        if (form.value.nickname.trim().length > 30) {
            notification.warning('Никнейм слишком длинный')
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


    const MAX_FILE_SIZE = 3 * 1024 * 1024

    const updateImages = async (type) => {
        const file = selectedFile.value
        if (!file) return

        if (!file.type?.startsWith('image/')) {
            notification.warning('Только изображения')
            return
        }

        if (file.size > MAX_FILE_SIZE) {
            notification.warning('Файл слишком большой — максимум 3 МБ')
            return
        }
  
        const formData = new FormData()
        formData.append(type, file)

        const data = await apiCall(() => api.put(`/user/me/${type}`, formData))
        
        if (data.success) {
            userData.value[type + '_url'] = data.result[type + '_url']
            selectedFile.value = null
        }
    }


    watch(
        () => route.params.nickname,
        async (newNickname) => {
            if (newNickname) await requestData()
        }
    )



    // потом переделать

    const onAvatarError = (event) => {
        event.target.src = '/images/plug_avatar.png'
    }

    const onBanerError = (event) => {
        event.target.src = '/images/plug_baner.png'
    }


    // Модерка

    const isBanModal = ref(false)

    const handleModerateProfile = async(type) => {
        const success = await moderateProfile(userData.value.idUser, type)
        if(!success) return
        if(type === 'avatar') userData.value.avatar_url = null
        else if(type === 'banner') userData.value.banner_url = null
    }

    const isVisiblePopup = ref(false)

    const mediaTypeToDelete = ref(null)

    const openConfirmPopup = (typeMedia) => {
        mediaTypeToDelete.value = typeMedia
        isVisiblePopup.value = true
    }

    // разблок

    const unblockCategory = ref('')

    const handleUnblockUser = async () => {
        if(!unblockCategory.value) {
            notification.warning('Выберите категорию')
            return
        }
        
        await moderateUnblock(userData.value.idUser, unblockCategory.value)
    }

    // роль

    const currentUserRole = ref('')

    const handleChangeUserRole = async () => {
        if(!currentUserRole.value) {
            notification.warning('Выберите роль')
            return
        }
        
        const success = await moderateRole(userData.value.idUser, currentUserRole.value)
        if(success) userData.value.role = currentUserRole.value
    }

    onMounted(async () => {
        await requestData()
    })
</script>

<template>

    <Transition name="fade">
        <div v-if="userData && Object.keys(userData).length > 0 && !isLoading" class="profile-wrapper flex-column">
            
            <BanModal
                :model-value="isBanModal"
                :nickname="userData.nickname"
                :type="'profile'"
                :user_id="userData.idUser"
                :text="'медиа профилю'"
                @update:model-value="isBanModal = false"
            />

            <ConfirmPopUp 
                v-model="isVisiblePopup"
                :label="'медиа'"
                @confirm="handleModerateProfile(mediaTypeToDelete)"
            />

            <div class="profile-header-banner">
                <picture>
                    <img :src="userData.banner_url || '/images/plug_baner.png'" @error="onBanerError" class="profile__banner">
                </picture>
                <label v-if="user?.id === userData.idUser" class="profile-header__label flex-center">
                    Изменить банер
                    <input type="file"
                        accept="image/*" 
                        @change="(e) => onFileChange(e, 'banner')"
                        class="profile-header__input">
                </label>
                <button v-else-if="user?.id != userData.idUser && user?.role === 4 || user?.role === 3" type="button" 
                    @click="openConfirmPopup('banner')"
                    class="no-border profile-header__label flex-center">
                    Удалить банер
                </button> 
            </div>
            <div class="profile-header-avatar flex align-c justify-sb">
                <div class="avatar-block flex-center">
                    <img 
                        :src="userData.avatar_url || '/images/plug_avatar.png'" 
                        @error="onAvatarError"
                        class="avatar-block__img"
                    >
                    <label v-if="user?.id === userData.idUser" class="avatar-block__label flex-center">
                        Изменить аватар
                        <input type="file" 
                            accept="image/*" 
                            @change="(e) => onFileChange(e, 'avatar')"
                            class="avatar-block__input">
                    </label>
                    <button v-else-if="user?.id != userData.idUser && user?.role === 4 || user?.role === 3" type="button" 
                        @click="openConfirmPopup('avatar')"
                        class="no-border avatar-block__label flex-center">
                        Удалить аватар
                    </button> 
                </div>
                <span class="profile-header__nickname">{{ userData.nickname }}</span>
                <button v-if="isAuthenticated && authStore.user?.id === userData.idUser" 
                        @click="toggleEdit()" type="button" 
                        class="no-border profile-header-avatar__settings-btn">
                    Настройки
                </button>
            </div>
            <div v-if="user?.id != userData.idUser && user?.role === 4 || user?.role === 3" class="rightSide-wrapper flex align-c">
                <div class="unblock flex-column" style="gap: 8px">
                    <button @click="handleUnblockUser" class="no-border moderate-btn">Разблокировать</button>
                    <select v-model="unblockCategory" class="no-border profile-header-avatar__settings-btn moderate-select">
                        <option value="" disabled hidden selected class="empty-option">
                            Категория
                        </option>
                        <option value="profile">Медиа</option>
                        <option value="comment">Комментарии</option>
                        <option value="review">Рецензии</option>
                        <option value="question">Обсуждения</option>
                    </select>
                </div>
                <div v-if="user?.id != userData.idUser && user?.role === 4" class="flex-column role-block" style="gap: 8px">
                    <button @click="handleChangeUserRole" class="no-border moderate-btn">Изменить</button>
                    <select v-model="currentUserRole" class="no-border profile-header-avatar__settings-btn moderate-select">
                        <option value="" disabled hidden selected class="empty-option">
                            Роль
                        </option>
                        <option value="1">Пользователь</option>
                        <option value="2">Новостник</option>
                        <option value="3">Модератор</option>
                        <option value="4">Администратор</option>
                    </select>
                </div>
                <button 
                        @click="isBanModal = true" type="button" 
                        class="no-border profile-header-avatar__settings-btn block-btn">
                    Заблокировать
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
                    <RouterLink v-if="user?.role === 4" to="/moderation" class="currentSection">Модерация</RouterLink>
                </div>
                <div v-if="!($route.path.includes('/games') || $route.path.includes('/reviews') || $route.path.includes('/comments') || $route.path.includes('/requests'))" class="game-collection flex-column">
                      
                    <div class="collection-block-label flex align-c justify-sb">
                        <span class="collection__label">Любимые</span>
                        <RouterLink v-if="favoriteGames.length" :to="`/user/${route.params.nickname}/games`"class="collection__link">Смотреть все</RouterLink>
                    </div>
                    <div v-if="favoriteGames.length" class="game-wrapper">
                        <div class="game" v-for="game in favoriteGames" :key="game.idGame">
                            <RouterLink :to="`/game/${game.idGame}`">
                                <picture>
                                    <img :src="game.cover_url" class="game__cover">
                                </picture>
                            </RouterLink>
                        </div>
                    </div>
                    <div v-else>
                        <span class="else-block">Игр пока нет</span>
                    </div>
                    <hr>
                    <div class="collection-block-label flex align-c justify-sb">
                        <span class="collection__label">Сейчас играю</span>
                        <RouterLink v-if="currentGames.length" :to="`/user/${route.params.nickname}/games` "class="collection__link">Смотреть все</RouterLink>
                    </div>
                    <div v-if="currentGames.length" class="game-wrapper">
                        <div class="game" v-for="game in currentGames" :key="game.idGame">
                            <RouterLink :to="`/game/${game.idGame}`">
                                <picture>
                                    <img :src="game.cover_url" class="game__cover">
                                </picture>
                            </RouterLink>
                        </div>
                    </div>
                    <div v-else>
                        <span class="else-block">Игр пока нет</span>
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
        font-size: 28px;
        flex: 1; 
        text-wrap: wrap;
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
        flex-shrink: 0;
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
    .currentSection:hover {
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
    .collection__link:hover {
        color: var(--font-primary);
    }
    

    .game {
        max-width: 174px;
        max-height: 232px;
        will-change: transform;
        transition: 0.4s;
    }

    .game:hover {
        transform: scale(1.03);
    }

    .game__cover {
        width: 100%;
        height: 100%;
        border-radius: 8px;
    }

    .rightSide-wrapper {
        gap: var(--gp-12);
        margin-left: auto;
        align-items: start;
        flex-wrap: wrap;
        padding-inline: 32px;
    }

    .moderate-btn { 
        font-family: Roboto_Medium;
        font-size: 14px;
        background-color: var(--font-primary);
        color: #000;
        padding-block: 4px;
    }
    .moderate-btn:hover {
        background-color: var(--font-primary-75);
    }

    .moderate-select:hover {background-color: var(--btn-color-6-50);}

    @media(max-width:375px) {
        .moderate-btn, .moderate-select, .block-btn, .unblock, .role-block {
            width: 100%;
            text-align: center;
        }
    }
    
    .moderate-select {
        font-size: 14px;
        background-color: var(--btn-color-6-25);
        cursor: pointer;
    }

    .block-btn {
        font-size: 14px;
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

    .else-block {
        font-family: Roboto_Medium;
        font-size: 18px;
        color: var(--font-primary-75);
    }



    @media (max-width:1024px) {
        .game-wrapper {
            grid-template-columns: repeat(4, 1fr);
        }
    }


    @media (max-width:900px) {
        .profile-header-banner {
            display: none;
        }

        .avatar-block {
            position: static;
        }

        .profile-header-avatar {
            padding-top: 16px;
            flex-direction: column;
            gap: var(--gp-16);
        }

        .profile-header-avatar::before {
            width: 0;
        }

        .content-container {
            flex-direction: column;
        }

        .left-section {
            flex-direction: row;
            max-width: none;
            text-wrap: nowrap;
            flex-wrap: wrap;
        }

        .currentSection {
            width: fit-content;
        }
    }


    @media(max-width:600px) {
        .game-wrapper {
            grid-template-columns: repeat(3, 1fr);
        }
        .edit-profile-block__left-side {
            display: none;
        }

        .edit-profile-block__right-side {
            width: 100%;
        }

        .edit_profile-block__btn {
            font-size: 14px !important;
        }

        .profile-header__nickname {
            font-size: 20px;
        }

        .currentSection {
            font-size: 16px;
        }

        .left-section {
            gap: var(--gp-8);
        }

        .collection__label {
            font-size: 20px;
        }

        .collection__link {
            font-size: 16px;
        }
    }

    @media(max-width:425px) {
        .game-wrapper {
            grid-template-columns: repeat(2, 1fr);
        }
    }


    </style>