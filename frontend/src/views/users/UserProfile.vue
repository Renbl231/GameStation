<script setup>
    import BanModal from '@components/BanModal.vue';

    import { ref, onMounted, watch, provide, computed} from 'vue'
    import { storeToRefs } from 'pinia'
    import { useAuthStore } from '@stores/authStore'
    import { useRoute, useRouter } from 'vue-router'
    import api from '@utils/axios'
    import { useNotifications } from '@stores/notifications'
    import { useApiNotifications } from '@composables/useApi'
    import { useGlobal404 } from '@composables/useGlobal404'

    import { useModeration } from '@composables/useModeration';
    import { checkColorRole, checkNameRole } from '@/utils/checkRole';

    import ProfileBanner from '@/components/users/ProfileBanner.vue';
    import ProfileAvatar from '@/components/users/ProfileAvatar.vue';
    import ProfileNavigation from '@/components/users/ProfileNavigation.vue';

    const { moderateUnblock, moderateRole } = useModeration()

    const { set404 } = useGlobal404()
    const { apiCall } = useApiNotifications()
    const notification = useNotifications()

    const authStore = useAuthStore()
    const { user } = storeToRefs(authStore)

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


    // Модерка

    const isBanModal = ref(false)

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

        <div v-if="userData && Object.keys(userData).length > 0 && !isLoading" class="profile flex-column">
            
            <ProfileBanner 
                :banner="userData.banner"
                :id-user="userData.idUser"
                :role-user="userData.role"
            />
            <BanModal
                :model-value="isBanModal"
                :nickname="userData.nickname"
                :type="'profile'"
                :user_id="userData.idUser"
                :text="'медиа профилю'"
                @update:model-value="isBanModal = false"
            />
            
            <div class="profile__header flex-column">
                <div class="flex align-c" style="gap: var(--gp-24);">
                    <ProfileAvatar
                        :avatar="userData.avatar"
                        :id-user="userData.idUser"
                        :user-role="userData.role"
                        :rating="userData.rating"
                    />
                    <div class="profile__header-info flex-column">
                        <div class="flex align-c" style="gap: var(--gp-16); width: 100%;">
                            <span class="profile__nickname">{{ userData.nickname }}</span>
                            <button v-if="user?.id === userData.idUser" @click="toggleEdit()" type="button" class="no-border profile__btnSettings">
                                Настройки
                            </button>
                        </div>
                        <span v-show="checkNameRole(userData.role)" class="profile__role" :style="`color: ${checkColorRole(userData.role)}`">{{ checkNameRole(userData.role) }}</span>
                        <ProfileNavigation
    
                        />
                    </div>
                </div>
                <hr>
            </div>




            <div v-if="user?.id != userData.idUser && user?.role === 4 || user?.role === 3 && userData.role != 4" class="rightSide-wrapper flex align-c">
                <div v-if="user?.id != userData.idUser && user?.role === 3 || user?.role === 4" class="unblock flex-column" style="gap: 8px">
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
                <button v-if="user?.id != userData.idUser"
                        @click="isBanModal = true" type="button" 
                        class="no-border profile-header-avatar__settings-btn block-btn">
                    Заблокировать
                </button>
            </div>

            <div class="profile-container flex-column">
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

<style lang="scss" scoped>

    .profile {
        width: 100%;
        gap: var(--gp-32);

        &__wrapper {
            width: 100%;
            padding-inline: 32px;
            padding-bottom: 32px;
        }

        &__header {
            width: 100%;
            gap: var(--gp-24);

            &-info {
                width: 100%;
                gap: var(--gp-16);
            }
        }

        &__nickname {
            font-family: Roboto_SemiBold;
            font-size: 36px;
            color: var(--text-primary);
            line-height: 1;

            @media(max-width:600px) {
                font-size: 20px;;
            }
        }

        &__role {
            width: fit-content;
            font-family: Roboto_Medium;
            font-size: 18px;
            padding: 4px 12px;
            border-radius: 16px;
            background-color: var(--bg-secondary);
        }

        &__btnSettings {
            width: fit-content;
            height: fit-content;
            font-size: 16px;
            font-family: Roboto_Medium;
            background-color: var(--bg-secondary);
            padding: 8px;
            border-radius: 4px; 
            margin-left: auto;
            color: var(--text-primary);

            &:hover {
                background-color: var(--bg-secondary-hover);
            }
        }
    }

    /* Основной блок с контентом */

    .content-container {
        width: 100%;
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