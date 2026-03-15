<script setup>
    import { onMounted, onUnmounted, ref, watch } from 'vue'
    import api from '../utils/axios'
    import { useAuthStore } from '../stores/authStore'
    import { storeToRefs } from 'pinia'
    import { useRouter } from 'vue-router'

    const authStore = useAuthStore()
    const { isAuthenticated } = storeToRefs(authStore)

    const router = useRouter()

    const isVisible = ref(false)
    const toggleIsVisible = () => {
        event.stopPropagation()
        isVisible.value = !isVisible.value
    }

    // поиск друга

    const searchShow = ref(false)
    const toggleIsSearch = () => {
        searchShow.value = !searchShow.value
        queryNickname.value = ''
    }
    
    const queryNickname = ref('')
    const foundUsers = ref([])

    const searchUsers = async () => {
        try {
            const { data } = await api.get('/friends/searchUsers', {
                params: {
                    nickname: queryNickname.value
                }
            })
            if(data.success && data.users) {
                foundUsers.value = data.users || []
            }
        } catch(error) {
            console.log('Ошибка фронта', error.response?.data)
        }
    }

    // добавление и удаление пользователя

    const addbtnState = ref({})

    const addUser = async (user) => {
        try {
            const { data } = await api.post('/friends/add', {
                idUser: user.idUser
            })
            if(data.success === true || data.success === 'exist') {
                addbtnState.value[user.idUser] = 'remove'
            }
        } catch (error) {
            console.log('HTTP ошибка:', error.response?.data?.error || error.message)
        }
    }

    const removeUser = async (user) => {
        try {
            const { data } = await api.delete(`/friends/${user.idUser}/delete`)
            if(data.success === true) {
                addbtnState.value[user.idUser] = null
            }
        } catch(error) {
            console.log('Ошибка фронта', error.response?.data?.error)
        }
    } 

    const safeFriendAction = (user) => {
        if(!user?.idUser) {
            return
        }
        
        const state = addbtnState.value[user.idUser]
        if(state === 'remove') {
            removeUser(user)
        } else {
            addUser(user)
        }
    }

    const safeButtonText = (user) => {
        if(!user?.idUser) return 'Добавить'
        
        const state = addbtnState.value[user.idUser]
        return state === 'remove' ? 'Отменить' : 'Добавить'
    }

    // Входящие запросы

    const incomingShow = ref(false)
    const toggleIsIncoming = () => {
        incomingShow.value = !incomingShow.value
    }

    const incomingUsers = ref([])
    const totalIncoming = ref(0)

    const loadIncomingUsers = async () => {
        try {
            const { data } = await api.get('/friends/incoming')
            
            if(data.success) {
                incomingUsers.value = data.result?.users || []
                totalIncoming.value = data.result?.totalIncoming || 0
            } else {}
        } catch(error) {
            console.log('Ошибка:', error.response?.status, error.response?.data)
        }
    }

    const handleIncoming = async(action, incoming) => {
        try {
            const { data } = await api.put('/friends/handleIncoming', {
                action: action,
                user_id: incoming.idUser
            })
            if(data.success) {
                await Promise.all([
                    loadIncomingUsers(),
                    loadFriends()
                ])
            }
        } catch(error) {
            console.log('Ошибка фронта:', error.response?.data?.error)
        }
    }

    // загрузка друзей

    const friendList = ref([])

    const loadFriends = async () => {
        try {
            const { data } = await api.get('/friends')
            if(data.success && data.friends) {
                friendList.value = data.friends || []
            }
        } catch(error) {
            console.log('Ошибка фронта', error.response?.data?.error)
        }
    }

    // контекст меню

    const contextMenu = ref(null)
    const showContextMenu = ref(false)
    const contextUser = ref(null)
    
    const handleContextMenu = (event, friend) => {
        event.preventDefault()
        event.stopPropagation()
        
        contextUser.value = friend
        showContextMenu.value = true
    }

    const openProfile = () => {
        if(contextUser.value) {
            router.push(`/user/${contextUser.value.nickname}`)
        }
        showContextMenu.value = false
    }

    const closeAllMenus = (event) => {
        if(contextMenu.value && !contextMenu.value.contains(event.target)) {
            showContextMenu.value = false
        }
        
        const friendContainer = document.querySelector('.friend-container')
        if(friendContainer && !friendContainer.contains(event.target)) {
            isVisible.value = false
        }
    }

    // Удаление друга

    const removeFriend = async () => {
        if(!contextUser.value) return    
        try {
            const { data } = await api.delete(`/friends/${contextUser.value.idUser}/delete`)
            if(data.success === true) {
                await loadFriends()
            }
        } catch(error) {
            console.log('Ошибка:', error)    
        }
        
        showContextMenu.value = false
    }

    // общий метод

    const loadFriendsData = async () => {
        try {
            await Promise.all([
                loadIncomingUsers(),
                loadFriends()
            ])
        } catch(error) {
            console.log('Ошибка загрузки:', error)
        }
    }


    const debounceTimer = ref(null) // работа с таймером

    watch(queryNickname, async (newValue) => {
        if(debounceTimer.value) {
            clearTimeout(debounceTimer.value)
        }
        
        debounceTimer.value = setTimeout(async () => {
            if(newValue.trim().length >= 5) {
                await searchUsers()
            } else {
                foundUsers.value = []
            }
        }, 300)
    })

    watch(isAuthenticated, async (auth) => {
        if(auth) {
            await loadFriendsData()
        }
    })

    onMounted(async () => {
        document.addEventListener('click', closeAllMenus)
        
        if(isAuthenticated.value) {
            await loadFriendsData()
        }
    })

    onUnmounted(() => {
        document.removeEventListener('click', closeAllMenus)
    })

</script>

<template>
    <div v-if="isAuthenticated" class="friend-container" :class="{'active': isVisible}">
        <div v-if="!isVisible" @click="toggleIsVisible" class="initial-container flex align-c">
            <span class="initial-container__label">Друзья</span>
            <span class="flex-center initial-container__svg">
                <svg class="flex" width="20" height="13" viewBox="0 0 20 13" fill="none" xmlns="http://www.w3.org/2000/svg">
                    <path d="M14 6.5C12.0656 6.5 10.5 5.04621 10.5 3.25C10.5 1.45379 12.0656 0 14 0C15.9344 0 17.5 1.45379 17.5 3.25C17.5 5.04621 15.9344 6.5 14 6.5ZM11.6 7.42857H11.8594C12.5094 7.71875 13.2312 7.89286 14 7.89286C14.7687 7.89286 15.4875 7.71875 16.1406 7.42857H16.4C18.3875 7.42857 20 8.92589 20 10.7714V11.6071C20 12.3761 19.3281 13 18.5 13H9.5C8.67188 13 8 12.3761 8 11.6071V10.7714C8 8.92589 9.6125 7.42857 11.6 7.42857ZM5 6.5C3.34375 6.5 2 5.25223 2 3.71429C2 2.17634 3.34375 0.928571 5 0.928571C6.65625 0.928571 8 2.17634 8 3.71429C8 5.25223 6.65625 6.5 5 6.5ZM3.5 7.42857H3.61875C4.05312 7.56786 4.5125 7.66071 5 7.66071C5.4875 7.66071 5.94687 7.56786 6.38125 7.42857H6.5C7.1375 7.42857 7.725 7.59978 8.24063 7.87545C7.47813 8.63862 7 9.65134 7 10.7714V11.8857C7 11.9496 7.01562 12.0105 7.01875 12.0714H1.5C0.671875 12.0714 0 11.4475 0 10.6786C0 8.88237 1.56562 7.42857 3.5 7.42857Z" fill="white"/>
                </svg>
            </span>
        </div>
        
        <div v-if="isVisible" class="container-wrapper flex-column">
            <div class="container-header flex align-c justify-sb">
                <span class="container-header__label">
                    Друзья
                </span>
                <div class="container-header__interaction flex align-c">
                    <button @click="toggleIsSearch" type="button" title="Добавить друга" class="container-header__interaction__btn no-border flex-center">
                        <svg width="24" height="24" viewBox="0 0 16 16" fill="none" xmlns="http://www.w3.org/2000/svg">
                            <path d="M0 14.6141C0 13.2746 0.595427 12.0045 1.625 11.1477L1.96406 10.8656C2.81021 10.1614 3.80574 9.65943 4.875 9.39773C5.94258 9.13643 7.05742 9.13643 8.125 9.39773C9.19426 9.65943 10.1898 10.1614 11.0359 10.8656L11.375 11.1477C12.4046 12.0045 13 13.2746 13 14.6141V16H0V14.6141Z" fill="#647279"/>
                            <circle cx="6" cy="4" r="4" fill="#647279"/>
                            <circle cx="12" cy="12" r="4" fill="#9D9D9D"/>
                            <path d="M12 10V14" stroke="white" stroke-width="1" stroke-linecap="round"/>
                            <path d="M10 12H14" stroke="white" stroke-width="1" stroke-linecap="round"/>
                        </svg>
                    </button>
                    <button @click="toggleIsIncoming" type="button" :title="`Входящих запросов: ${totalIncoming}`" class="container-header__interaction__btn no-border flex-center">
                        <svg width="24" height="24" viewBox="0 0 16 16" fill="none" xmlns="http://www.w3.org/2000/svg">
                            <path d="M0 14.6141C0 13.2746 0.595427 12.0045 1.625 11.1477L1.96406 10.8656C2.81021 10.1614 3.80574 9.65943 4.875 9.39773C5.94258 9.13643 7.05742 9.13643 8.125 9.39773C9.19426 9.65943 10.1898 10.1614 11.0359 10.8656L11.375 11.1477C12.4046 12.0045 13 13.2746 13 14.6141V16H0V14.6141Z" fill="#647279"/>
                            <circle cx="6" cy="4" r="4" fill="#647279"/>
                            <circle cx="12" cy="12" r="4" fill="#9D9D9D"/>
                            <path d="M12 9.5V12.3C12 12.4105 12.0895 12.5 12.2 12.5H14" stroke="white" stroke-width="1" stroke-linecap="round"/>
                        </svg>
                    </button>
                </div>
            </div>
            <div v-if="friendList.length" class="users-wrapper flex-column align-c">
                <div class="user flex align-c"
                    v-for="friend in friendList"
                    :key="friend.idUser"
                    @contextmenu.prevent.stop="handleContextMenu($event, friend)">
                    <div class="user-avatar">
                        <picture>
                            <img :src="friend.avatar_url" class="user-avatar__img flex">
                        </picture>
                    </div>
                    <div class="user-banner">
                        <picture>
                            <img :src="friend.banner_url" class="user-banner__img flex">
                        </picture>
                        <RouterLink :to="`/user/${friend.nickname}`" class="user-banner__nickname">{{ friend.nickname }}</RouterLink>
                    </div>
                </div>
                <div v-if="showContextMenu" 
                    ref="contextMenu"
                    class="context-menu flex-column">
                    <button @click="openProfile" class="context-btn no-border">Открыть профиль</button>
                    <button @click="removeFriend" class="context-btn danger no-border">Удалить из друзей</button>
                </div>
                <hr>
            </div>

            <div v-if="incomingShow" class="incoming-requests flex-column">
                <span class="incoming-requests__label">
                    Входящие запросы ({{ totalIncoming}})
                </span>
                <div v-if="incomingUsers.length" class="requests flex-column">
                    <div class="request flex align-c justify-sb"
                        v-for="incoming in incomingUsers"
                        :key="incoming.idUser">
                        <div class="request__user-data flex align-c">
                            <img :src="incoming.avatar_url" class="request__user-avatar">
                            <RouterLink :to="`/user/${incoming.nickname}`" class="request__user-nickname">{{ incoming.nickname }}</RouterLink>
                        </div>
                        <div class="request-btns flex-column">
                            <button @click="handleIncoming('approved', incoming)" type="button" class="no-border request__btn accept">Принять</button>
                            <button @click="handleIncoming('rejected', incoming)"type="button" class="no-border request__btn reject">Отклонить</button>
                        </div>
                    </div>
                </div>
                <hr>
            </div>

            <div v-if="searchShow" class="search-block flex-column">
                <input v-model="queryNickname" class="no-border search-block__input" placeholder="Введите имя профиля друга">
                <div v-if="foundUsers.length" class="search-results flex-column">
                    <div class="result flex align-c justify-sb"
                        v-for="user in foundUsers"
                        :key="user.idUser">
                        <div class="result__user-data flex align-c">
                            <RouterLink :to="`/user/${user.nickname}`"><img :src="user.avatar_url" alt="" class="request__user-avatar"></RouterLink>
                            <RouterLink :to="`/user/${user.nickname}`" class="request__user-nickname">{{ user.nickname }}</RouterLink>
                        </div>
                        <button 
                            @click="safeFriendAction(user)"
                            type="button" 
                            class="no-border result__btn-add"
                        >
                            {{ safeButtonText(user) }}
                        </button>
                    </div>
                </div>
            </div>
        </div>
    </div>
</template>

<style scoped>

    .friend-container {
        position: fixed;
        bottom: 16px;
        right: 16px;
        width: 122px;
        max-width: 400px;
        max-height: 400px;
        background-color: #252A2D;
        border-radius: 4px;
        z-index: 1000;
        overflow: hidden;
        overflow-y: auto;
        transition: width 0.5s ease, height 0.5s ease;
    }

    .friend-container.active {
        width: 100% !important;
        height: auto;
    }

    .initial-container {
        width: 100%;
        gap: var(--gp-12);
        background-color: #252A2D;
        padding: 8px 12px;
        cursor: pointer;
    }

    .initial-container__label {
        width: fit-content;
        font-size: 16px;
        font-family: Roboto_Medium;
    }

    .initial-container__svg {
        background-color: #1F1F1F;
        border-radius: 4px;
        padding: 8px 6px;
    }

    /* Враппер */

    .container-wrapper {
        width: 100%;
        padding-bottom: 16px;
        gap: var(--gp-16);
    }

    .container-header {
        width: 100%;
        padding: 8px 16px;
        border-radius: 4px 4px 0 0;
        background-color: #394247;
        box-shadow: 0 4px 4px rgba(0, 0, 0, 0.25);
        margin-bottom: 8px;
    }

    .container-header__label {
        font-size: 18px;
        font-family: Roboto_Medium
    }

    .container-header__interaction {
        gap: var(--gp-10);
    }

    /* Врапер пользователей */

    .users-wrapper {
        width: 100%;
        position: relative;
        gap: var(--gp-16);
        padding-inline: 16px;
    }

    .user {
        width: 100%;
        border-radius: 4px
    }

    .user-avatar__img {
        max-width: 48px;
        min-width: 48px;
        height: 48px;
        border-radius: 4px 0 0 4px;
    }

    .user-banner {
        position: relative;
        width: 100%;
    }

    .user-banner__img {
        width: 100%;
        height: 48px;
        border-radius: 0 4px 4px 0;
    }

    .user-banner__nickname {
        position: absolute;
        font-size: 16px;
        font-family: Roboto_Medium;
        top: 25%;
        left: 12px;
    }
    
    hr {
        width: 100%;
        background: #394247;
        margin: 0px;
    }

    /* Входящие запросы */

    .incoming-requests {
        width: 100%;
        padding-inline:16px;
        gap: var(--gp-16);
    }

    .incoming-requests__label {
        font-size: 16px;
        font-family: Roboto_Medium;
    }

    .requests {
        width: 100%;
    }

    .request {
        width: 100%;
    }

    .request__user-data {
        width: 100%;
        gap: var(--gp-8);
    }

    .request__user-avatar {
        width: 48px;
        height: 48px;
        border-radius: 4px;
    }

    .request__user-nickname {
        font-size: 14px;
        font-family: Roboto_Medium;
    }

    .request-btns {
        gap: var(--gp-4);
    }

    .request__btn {
        font-size: 14px;
        font-family: Roboto_Regular;
        padding: 2px 12px;
        border-radius: 2px;
    }

    .request__btn.accept {
        background-color: var(--font-secondary);
    }
    
    .request__btn.reject {
        background-color: rgba(0, 0, 0, 0.25);
    }

    .request-hr {
        margin-top: 16px;
    }

    /* поиск */

    .search-block {
        width: 100%;
        padding-inline: 16px;
        gap: var(--gp-16);
    }

    .search-block__input {
        width: 100%;
        padding: 8px;
        border-radius: 4px;
        background-color: rgba(0, 0, 0, 0.5);
        font-size: 14px;
        font-family: Roboto_Medium;
    }

    /* Сам результат поиска */

    .search-results {
        width: 100%;
        gap: var(--gp-12);
    }

    .result {
        width: 100%;
    }

    .result__user-data {
        width: 100%;
        gap: var(--gp-12);
    }

    .request__user-avatar {
        width: 48px;
        height: 48px;
        border-radius: 4px;
    }

    .result__btn-add {
        font-size: 12px;
        font-family: Roboto_Regular;
        padding: 6px;
        border-radius: 4px;
        background-color: var(--font-primary-50);
    }

    /* Контекстное меню */

    .context-menu {
        width: fit-content;
        position: fixed;
        z-index: 2000;
        background: #2a2d31;
        border-radius: 4px;
        box-shadow: 0 8px 32px rgba(0,0,0,0.4);
        border: 1px solid #40444b;
    }

    .context-btn {
        width: 100%;
        padding: 12px 16px;
        color: #fff;
        text-align: left;
        font-size: 14px;
        font-family: Roboto_Regular;
        transition: background 0.2s;
    }

    .context-btn:hover {
        background: #40444b;
    }

    .context-btn.danger {
        border-top: 1px solid #40444b;
        color: #ff6b6b;
    }

    .context-btn.danger:hover {
        background: #ff6b6b;
        color: #fff;
    }


</style>