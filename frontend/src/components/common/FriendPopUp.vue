<script setup>
    import { onMounted, onUnmounted, ref, } from 'vue'
    import { useAuthStore } from '@stores/authStore'
    import { storeToRefs } from 'pinia'
    import { useRouter } from 'vue-router'
    import { onAvatarError } from '@helpers/onImageError'
    import { useFriends } from '@composables/useFriends'

    const authStore = useAuthStore()
    const { isAuthenticated } = storeToRefs(authStore)
    const { 
        contextUser,
        friendList,
        queryNickname,
        foundUsers,
        addbtnState,
        totalIncoming,
        incomingUsers,
        addUser,
        removeUser,
        handleIncoming,
        removeFriend,
        loadFriendsData
    } = useFriends()
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
    
    // добавление и удаление пользователя

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

    // контекст меню

    const contextMenu = ref(null)
    const showContextMenu = ref(false)

    const handleContextMenu = (friend) => {
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
        if (event.target.closest('.user__contextBtn')) return
        
        if(contextMenu.value && !contextMenu.value.contains(event.target)) {
            showContextMenu.value = false
        }
        
        const friendContainer = document.querySelector('.friend-container')
        if(friendContainer && !friendContainer.contains(event.target)) {
            isVisible.value = false
            searchShow.value = false
            incomingShow.value = false
        }
    }

    onMounted(async () => {
        document.addEventListener('click', closeAllMenus)
        if(isAuthenticated.value) await loadFriendsData()
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
                    <button @click="toggleIsSearch" type="button" title="Добавить друга" class="interaction__btn no-border flex-center">
                        <svg width="24" height="24" viewBox="0 0 16 16" fill="none" xmlns="http://www.w3.org/2000/svg">
                            <path d="M0 14.6141C0 13.2746 0.595427 12.0045 1.625 11.1477L1.96406 10.8656C2.81021 10.1614 3.80574 9.65943 4.875 9.39773C5.94258 9.13643 7.05742 9.13643 8.125 9.39773C9.19426 9.65943 10.1898 10.1614 11.0359 10.8656L11.375 11.1477C12.4046 12.0045 13 13.2746 13 14.6141V16H0V14.6141Z" fill="currentColor"/>
                            <circle cx="6" cy="4" r="4" fill="currentColor"/>
                            <circle cx="12" cy="12" r="4" fill="#9D9D9D"/>
                            <path d="M12 10V14" stroke="white" stroke-width="1" stroke-linecap="round"/>
                            <path d="M10 12H14" stroke="white" stroke-width="1" stroke-linecap="round"/>
                        </svg>
                    </button>
                    <button @click="toggleIsIncoming" type="button" :title="`Входящих запросов: ${totalIncoming}`" class="interaction__btn no-border flex-center">
                        <svg width="24" height="24" viewBox="0 0 16 16" fill="none" xmlns="http://www.w3.org/2000/svg">
                            <path d="M0 14.6141C0 13.2746 0.595427 12.0045 1.625 11.1477L1.96406 10.8656C2.81021 10.1614 3.80574 9.65943 4.875 9.39773C5.94258 9.13643 7.05742 9.13643 8.125 9.39773C9.19426 9.65943 10.1898 10.1614 11.0359 10.8656L11.375 11.1477C12.4046 12.0045 13 13.2746 13 14.6141V16H0V14.6141Z" fill="currentColor"/>
                            <circle cx="6" cy="4" r="4" fill="currentColor"/>
                            <circle cx="12" cy="12" r="4" fill="#9D9D9D"/>
                            <path d="M12 9.5V12.3C12 12.4105 12.0895 12.5 12.2 12.5H14" stroke="white" stroke-width="1" stroke-linecap="round"/>
                        </svg>
                    </button>
                </div>
            </div>

            <div v-if="searchShow" class="search flex-column">
                <input v-model="queryNickname" class="no-border search__input" placeholder="Введите имя профиля друга">
                <div v-if="foundUsers.length" class="search__results flex-column">
                    <div class="user flex align-c justify-sb"
                        v-for="user in foundUsers"
                        :key="user.idUser">
                        <RouterLink :to="`/user/${user.nickname}`" class="user__data flex align-c">
                            <picture>
                                <img :src="user.avatar || ''" loading="lazy" class="user__avatar" @error="onAvatarError">
                            </picture>
                            <span class="user__nickname">
                                {{ user.nickname }}
                            </span>
                        </RouterLink>
                        <button 
                            @click="safeFriendAction(user)"
                            type="button" 
                            class="no-border search__btn-add"
                        >
                            {{ safeButtonText(user) }}
                        </button>
                    </div>
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
                        <RouterLink :to="`/user/${incoming.nickname}`" class="user__data flex align-c">
                            <picture>
                                <img :src="incoming.avatar || ''" loading="lazy" class="user__avatar" @error="onAvatarError">
                            </picture>
                            <span class="user__nickname">
                                {{ incoming.nickname }}
                            </span>
                        </RouterLink>
                        <div class="request__btns flex-column">
                            <button @click="handleIncoming('approved', incoming)" type="button" class="no-border request__btn accept">Принять</button>
                            <button @click="handleIncoming('rejected', incoming)"type="button" class="no-border request__btn reject">Отклонить</button>
                        </div>
                    </div>
                </div>
                <hr>
            </div>
            
            <div v-if="friendList.length" class="users-wrapper flex-column align-c">
                <div class="user flex align-c justify-sb" v-for="friend in friendList" :key="friend.idUser">
                    <RouterLink :to="`/user/${friend.nickname}`" class="user__data flex align-c">
                        <picture>
                            <img :src="friend.avatar || ''" loading="lazy" class="user__avatar" @error="onAvatarError">
                        </picture>
                        <span class="user__nickname">
                            {{ friend.nickname }}
                        </span>
                    </RouterLink>
                    <button @click="handleContextMenu(friend)" class="user__contextBtn no-border flex-center">...</button>
                </div>
                <div v-if="showContextMenu" 
                    ref="contextMenu"
                    class="context-menu flex-column">
                    <button @click="openProfile" class="context-menu__btn no-border">Открыть профиль</button>
                    <button @click="removeFriend" class="context-menu__btn danger no-border">Удалить из друзей</button>
                </div>
            </div>

            
        </div>
    </div>
</template>

<style lang="scss" scoped>

    .friend-container {
        position: fixed;
        bottom: 16px;
        right: 16px;
        width: 122px;
        max-width: 400px;
        max-height: 400px;
        background-color: var(--color-dark-slate);
        border-radius: 4px;
        z-index: 1000;
        overflow: hidden;
        overflow-y: auto;
        transition: width 0.5s ease, height 0.5s ease;

        &.active {
            width: 100% !important;
            height: auto;
        }

        @media (max-width:599px) {
            right: 0px
        }
    }

    .initial-container {
        width: 100%;
        gap: var(--gp-12);
        background-color: var(--color-dark-slate);
        padding: 8px 12px;
        cursor: pointer;
        
        &:hover {
            background-color: var(--color-dark-slate-hover)
        }

        &__label {
            font-size: 16px;
            font-family: Roboto_Medium;
        }

        &__svg {
            background-color: var(--color-dark-100);
            border-radius: 4px;
            padding: 8px 6px;
        }
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
        background-color: #2f3539;
        box-shadow: 0 4px 4px rgba(0, 0, 0, 0.25);
        margin-bottom: 8px;

        &__label {
            font-size: 18px;
            font-family: Roboto_Medium
        }

        &__interaction {
            gap: var(--gp-10);

            .interaction__btn {
                transition: 0.1s;
                &:hover {
                    transform: scale(0.95);
                }
                &:hover svg {
                    color: var(--color-gray-200);
                }
                svg{
                    color: #647279;
                }
            }
            
        }
    }


    /* Врапер пользователей */

    .users-wrapper {
        width: 100%;
        max-height: 300px;
        position: relative;
        overflow-y: visible;
        gap: var(--gp-16);
        padding-inline: 16px;
    }

    .user {
        width: 100%;
        position: relative;

        &:hover .user__contextBtn {
            visibility: visible;
            opacity: 1;
            transform: translateY(-50%) translateX(0);
        }

        &__avatar {
            display: block;
            width: 40px;
            height: 40px;
            border-radius: 4px;
        }

        &__data {
            gap: var(--gp-10);

            &:hover .user__nickname {
                color: var(--color-white);
            }
        }

        &__nickname {
            font-size: 16px;
            font-family: Roboto_Medium;
            padding: 4px 8px;
            background-color: rgb(18, 18, 18);
            color: var(--color-gray-100);
        }

        &__contextBtn {
            position: absolute;
            right: 0px;
            top: 50%;
            transition: all 0.3s ease;
            background-color: rgb(18,18,18);
            padding:4px 8px;
            border-radius: 4px;
            font-size: 16px;
            font-family: Roboto_Bold;
            transform: translateY(-50%) translateX(120%); 
            color: var(--color-gray-100);
            visibility: none;
            opacity: 0;
            z-index: 1000;

            &:hover {
                color: var(--color-white);
                background-color: var(--color-gray-500);
            }
        }
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

        &__label {
            font-size: 16px;
            font-family: Roboto_Medium;
        }
    }

    .requests {
        width: 100%;
        gap: var(--gp-12);
    }

    .request {
        width: 100%;

        &__btns {
            gap: var(--gp-4);
        }

        &__btn {
            font-size: 14px;
            font-family: Roboto_Regular;
            padding: 2px 12px;
            border-radius: 2px;

            &:hover {
                filter: brightness(1.2);
            }

            &.accept {
                background-color: var(--color-blue);
            }

            &.reject {
                background-color: rgba(0, 0, 0, 0.25);
            }
        }
    }

    /* поиск */

    .search {
        width: 100%;
        padding-inline: 16px;
        gap: var(--gp-16);
        
        &__input {
            width: 100%;
            padding: 8px;
            border-radius: 4px;
            background-color: rgba(0, 0, 0, 0.5);
            font-size: 14px;
            font-family: Roboto_Medium;
        }

        &__results {
            width: 100%;
            gap: var(--gp-12);
        }

        &__btn-add {
            font-size: 12px;
            font-family: Roboto_Regular;
            padding: 6px;
            border-radius: 4px;
            background-color: var(--color-green);

            &:hover {
                background-color: var(--color-red);
            }
        }
    }

    /* Контекстное меню */

    .context-menu {
        width: fit-content;
        position: fixed;
        top: 100%;
        right: 5%;
        transform: translateY(-100%) translateX(5%);
        z-index: 2000;
        background: #2a2d31;
        border-radius: 4px;
        box-shadow: 0 8px 32px rgba(0,0,0,0.4);
        border: 1px solid #40444b;
        overflow: hidden;

        &__btn {
            width: 100%;
            padding: 12px 16px;
            color: var(--color-white);
            text-align: left;
            font-size: 14px;
            font-family: Roboto_Regular;
            transition: background 0.2s;

            &:hover {
                background: #40444b;
            }

            &.danger {
                border-top: 1px solid #40444b;
                color: #ff6b6b;

                &:hover {
                    background: #ff6b6b;
                    color: var(--color-white);
                }
            }
        }
    }





</style>