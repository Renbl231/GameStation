<script setup>
    import { ref, onMounted } from 'vue'
    import { useAuthStore } from '@stores/authStore'
    import { storeToRefs } from 'pinia'
    import { useTheme } from '@/composables/ui/useTheme.js'
    import { useMenu } from '@/composables/ui/useMenu.js'

    import Search from './Search.vue'
    import AuthRegForm from './Auth-Reg.vue'
    
    const authStore = useAuthStore()

    const { isAuthenticated, user } = storeToRefs(authStore)
    const { currentTheme, toggleTheme, applyTheme } = useTheme()
    const { isBgMenuOpen, isProfMenuOpen, toggleBgMenu, toggleProfMenu } = useMenu()


    const logout = () => {
        isProfMenuOpen.value = false;
        authStore.logout()
    }

    const showSearch = ref(false);
    const toggleSearch = () => {
        showSearch.value = !showSearch.value
    }    
    
    const showAuthForm = ref(false);

    const toggleAuthForm = () => {
        showAuthForm.value = !showAuthForm.value
        isBgMenuOpen.value = false
    }

    onMounted(() => {
        applyTheme(currentTheme.value)
    })
         
</script>


<template>

    <header class="header">
        <div class="header-container flex align-c justify-sb">
            <div class="header-left flex-center">
                <RouterLink to="/">
                    <picture>
                        <img src="/images/logo.png" alt="Логотип" title="На главную">
                    </picture>
                </RouterLink>
            </div>
            <div class="header-middle flex-center">
                <nav class="header-nav flex-center" aria-label="Разделы сайта">
                    <ul class="header-nav__list flex-center">
                        <li class="header-nav__item flex-center" style="gap:var(--gp-8)">
                            <RouterLink to="/games" :class="{ 'active': $route.path.startsWith('/games') }">Игры</RouterLink>
                            <svg class="icon-arrow" :class="{ 'active-svg': $route.path.startsWith('/games') }" viewBox="0 0 12 8">
                                <use href="#icon-arrow"/>
                            </svg>
                            <ul class="dropdown-menu">
                                <li class="dropdown-menu__item">
                                    <RouterLink to="/games">Каталог</RouterLink>
                                </li>
                                <!-- <li>
                                    <RouterLink to="/games/selections">Подборки</RouterLink>
                                </li> -->
                                <li class="dropdown-menu__item">
                                    <RouterLink to="/games/reviews">Рецензии</RouterLink>
                                </li>
                            </ul>
                        </li>
                        <li class="header-nav__item flex-center" style="gap:var(--gp-8)">
                            <RouterLink to="/articles" :class="{'active':$route.path.startsWith('/articles')}">Статьи</RouterLink>
                            <svg class="icon-arrow" :class="{ 'active-svg': $route.path.startsWith('/articles')}" viewBox="0 0 12 8">
                                <use href="#icon-arrow"/>
                            </svg>
                            <ul class="dropdown-menu">
                                <li class="dropdown-menu__item">
                                    <RouterLink to="/articles/reviews">Обзоры</RouterLink>
                                </li>
                                <li class="dropdown-menu__item">
                                    <RouterLink to="/articles/selections">Подборки игр</RouterLink>
                                </li>
                            </ul>
                        </li>
                        <li>
                            <RouterLink to="/news" :class="{ 'active': $route.path === '/news'}">Новости</RouterLink>
                        </li>
                        <li>
                            <RouterLink to="/community" :class="{ 'active': $route.path === '/community'}">Сообщество</RouterLink>
                        </li>
                        <li>
                            <RouterLink to="/help" :class="{ 'active': ['/help', '/rules', '/contact'].includes($route.path)}">Помощь</RouterLink>
                        </li>
                    </ul>
                </nav>         
            </div>
            <div class="header-right flex-center">
                <button type="button" @click="toggleSearch" class="no-border search-bar flex-center" aria-label="Поиск">
                    <svg class="icon-search">
                        <use href="#icon-search"/>
                    </svg>
                </button>
                <div class="theme-switcher">
                    <button @click="toggleTheme" type="button" class="no-border btn-menu flex-center" aria-label="Цветовая схема">
                        <svg v-if="currentTheme === 'dark'" class="icon">
                            <use href="#icon-night-theme"/>
                        </svg>
                        <svg v-else class="icon">
                            <use href="#icon-light-theme"/>
                        </svg>
                    </button>
                </div>
                <button @click="!isAuthenticated ? toggleAuthForm() : toggleProfMenu()" :class="{'btn-avatar': user?.avatar}" type="button" class="no-border btn-menu flex-center" aria-label="Авторизоваться">
                    <picture v-if="user?.avatar">
                        <img :src="user?.avatar" class="user-avatar">
                    </picture>
                    <svg v-else class="icon">
                        <use href="#icon-profile"/>
                    </svg>
                </button>

                <button type="button" @click="toggleBgMenu()" :class="{'bg-menu-open': isBgMenuOpen}" class="no-border flex-center mobile-menu">
                    <svg class="icon-hamburger">
                        <use href="#icon-hamburger"/>
                    </svg>
                </button>


                <div class="profile-menu flex-column" :class="{ 'prof-menu-open': isProfMenuOpen }">
                    <ul class="profile-menu__list flex-column">
                        <li class="profile-menu__item flex">
                            <RouterLink :to="`/user/${authStore.user?.nickname}`">Профиль</RouterLink>
                        </li>
                        <li class="profile-menu__item flex">
                            <RouterLink :to="`/user/${authStore.user?.nickname}/games`">Мои игры</RouterLink>
                        </li>
                        <li class="profile-menu__item flex">
                            <RouterLink :to="`/user/${authStore.user?.nickname}/reviews`">Мои рецензии</RouterLink>
                        </li>
                        <!-- <li class="profile-menu__item flex">
                            <a href="">Мои подборки</a>
                        </li> -->
                        <li class="profile-menu__item flex">
                            <RouterLink :to="`/user/${authStore.user?.nickname}/requests`">Мои запросы</RouterLink>
                        </li>
                        <li class="profile-menu__item flex">
                            <RouterLink :to="`/user/${authStore.user?.nickname}/comments`">Мои комментарии</RouterLink>
                        </li>
                        <hr>
                    </ul>
                    <button type="submit" class="no-border logout-btn" @click="logout()">Выйти</button>
                </div>


                <button type="button" @click="toggleBgMenu()" :class="{'bg-menu-open': isBgMenuOpen}" class="no-border burger-close" aria-label="Закрыть меню"></button>
            </div>
        </div>

    </header>

    <AuthRegForm v-model="showAuthForm"/>
    <Search v-if="showSearch" :close-fn="toggleSearch" />

    <div class="burger-menu" :class="{ 'bg-menu-open': isBgMenuOpen }">
        <ul class="burger-menu__list flex-column">
            <li class="burger-menu__item flex">
                <button type="button" @click="toggleSearch()" class="no-border search-bar-mobile flex-center" aria-label="Поиск">
                    <svg class="icon-search">
                        <use href="#icon-search"/>
                    </svg>
                </button>
                <div class="theme-switcher-mobile">
                    <button type="button" @click="toggleTheme" class="no-border btn-menu flex-center" aria-label="Цветовая схема">
                        <svg class="icon">
                            <use href="#icon-night-theme"/>
                        </svg>
                    </button>
                </div>
            </li>
            <li class="has-mobile-menu flex-column">
                <RouterLink to="/games" :class="{ 'active': $route.path.startsWith('/games') }">Игры</RouterLink>
                <ul class="list-menu flex-column">
                    <li>
                        <RouterLink to="/games">Каталог</RouterLink>
                    </li>
                    <!-- <li>
                        <RouterLink to="/games/selections">Подборки</RouterLink>
                    </li> -->
                    <li>
                        <RouterLink to="/games/reviews">Рецензии</RouterLink>
                    </li>
                </ul>
            </li>
            <li class="burger-list__li">
                <RouterLink to="/articles" :class="{'active':$route.path.startsWith('/articles')}">Статьи</RouterLink>
            </li>
            <li class="burger-list__li">
                <RouterLink to="/news" :class="{ 'active': $route.path === '/news'}">Новости</RouterLink>
            </li>
            <li class="burger-list__li">
                <RouterLink to="/community" :class="{ 'active': $route.path === '/community'}">Сообщество</RouterLink>
            </li>
            <li class="burger-list__li">
                <RouterLink to="/help" :class="{ 'active': $route.path === '/help'}">Помощь</RouterLink>
            </li>
        </ul>
    </div>

</template>


<style lang="scss" scoped>

// Переменные
$header-width: 1312px;
$header-height: 72px;


.header {
    width: 100%;
    height: $header-height;
    top: 0%;
    background-color: var(--hdr-primary);
    font-size: 20px;
    font-family: Roboto_SemiBold;
    position: fixed;
    z-index: 500;

    &-container {
        max-width: $header-width;
        width: 100vw;
        height: 100%;
        margin: 0 auto;
        gap: var(--gp-24);
        margin-bottom: 48px;
        position: relative;
        z-index: 490;

        @media (max-width:1160px) {
            padding-inline: 32px;
        }

        @media (max-width:768px) {
            padding-inline: 24px;
        }

        @media (max-width:600px) {
            padding-inline: 16px;
        }

        @media (max-width:500px) {
            margin-bottom: 32px;   
        }
    }

    &-left,
    &-middle,
    &-right {
        height: 100%;
    }

    &-left img {
        min-width: 306px;
        height: 34px;
        user-select: none;
        @media (max-width:600px) {
            content: url('/images/logo-tablet.png');
            min-width: 254px;
            height: 32px;
        }

        @media (max-width:500px) {
            content: url('/images/logo-mobile.png');
            min-width: 185px;
            height: 30px;
        }
    }

    &-middle {
        @media (max-width:1160px) {
            display: none;
        }
    }

    &-right {
        gap:var(--gp-24);
        position: relative;
        z-index: 200;

        button {
            width: 36px;
            height: 36px;
        }

        .btn-menu {
            background-color: var(--color-dark-200);
            border-radius: 8px;

            &:hover {
                background-color: var(--color-dark-300);
            }

            &.btn-avatar {
                border-radius: 50%;
                overflow: hidden;

                .user-avatar {
                    width: 100%;
                    height: 100%;
                    min-width: 36px;
                    min-height: 36px;

                    &:hover {
                        filter: brightness(1.1);
                    }
                }
            }
        }

        @media (max-width:500px) {
            gap: var(--gp-20);

            button {
                width: 32px;
                height: 32px;
            }
        }
    }

    &-nav {
        height: 100%;

        &__list {
            position: relative;
            gap: var(--gp-48);
            height: 100%;
            
            @media (max-width:1280px) {
                gap: var(--gp-36);
            }
        }

        &__item {
            position: relative;
            display: flex;
            align-items: center;
            height: 100%;
            cursor: pointer; 

            &:hover {
                .icon-arrow {
                     stroke: var(--color-blue);
                     transform: rotate(180deg);           
                }
                
                > a:first-child {
                    color: var(--color-blue);
                }

                .dropdown-menu {
                    display: flex;
                }
            }

            &::after {
                /* невидимый мостик для ховер эффекта*/
                content: '';
                top:100%;
                left: 0;
                right: 0;
                position: absolute;
                height: 10px;
                z-index: 999;
                background: transparent;
            }
        }

        ul li a {
            display: flex;
            align-items: center;
            height: 100%;
            color: var(--color-white);

            &:hover {
                color: var(--color-blue);
            }

            &.active {
                color: var(--color-blue);
            }
        }
    }
}

// Инонки
.icon {
    min-width: 24px;
    height: 24px;

    &-search {
        min-width: 22px;
        height: 22px;
        color: #FFF;

        @media (max-width:1024px) {
            min-width: 28px;
            height: 28px;
        }
    }

    &-arrow {
        min-width: 10px;
        height: 10px;
        stroke: var(--color-gray-300);
        transition: all 0.2s ease;
    }
}


/* Выпад список */

.dropdown-menu {
    position: absolute;
    top: calc(100% + var(--gp-8));
    left: 50%;
    transform: translateX(-50%);
    display: none;
    height: fit-content;
    flex-direction: column;
    gap: var(--gp-20);
    background-color: var(--hdr-primary);
    min-width: 222px;
    z-index: 1000;
    padding: 16px;
    border-radius: 12px;
    font-family: Roboto_Medium;
    font-size: 16px;

    &__item {
        width: 100%;

        a {
            width: 100%;
            justify-content: flex-start;
        }
    }
}

button .icon-hamburger {
    min-width: 32px;
    height: 28px;
}

.mobile-menu {
    width: inherit;
    display: none;

    @media (max-width:1160px) {
        display: flex;

        &.bg-menu-open {
            display: none;
        }
    }
}

.active, .search-bar:hover .icon-search, .search-bar-mobile:hover .icon-search{
    color: var(--color-blue);
}

.active-svg {
    stroke: var(--color-blue);
}

// профиль меню

.profile-menu {
    position: absolute;
    z-index: 10;
    min-width: 248px;
    width: 100%;
    right: 0;
    top: calc(100% + 8px);
    background-color: var(--hdr-primary);
    padding: 20px;
    border-radius: 8px;
    transform: translateY(-40px);
    transition: all 0.3s ease-in-out;
    opacity: 0;
    visibility: hidden;
    font-size: 16px;
    font-family: Roboto_Medium;

    &.prof-menu-open {
        transform: translateY(0);
        opacity: 1;
        visibility: visible;
    }

    &__list {
        width: 100%;
        gap: var(--gp-16);
    }

    &__item {
        width: 100%;

        a {
            width: 100%;
        }

        &:hover {
            > a {
                color: var(--color-blue);
            }
        }
    }

    .logout-btn {
        width: 100%;
        text-align: left;
        margin-top: 16px;

        &:hover {
            color: var(--color-blue);
        }
    }
}

/* Бургер меню */

.burger-menu {    
    position: fixed;
    z-index: 120;
    max-width: 320px;
    width: 100%;
    top: 80px;
    right: 8px;
    background-color: var(--hdr-primary);
    padding: 20px;
    border-radius: 8px;
    transform: translateY(-100%);
    transition: all 0.4s ease-in-out;
    opacity: 0;
    visibility: hidden;
    font-size: 20px;
    font-family: Roboto_SemiBold;

    @media (max-width:500px) {
        max-width: 500px;
        right: 0px;
        border-radius: 0px;
    }

    &.bg-menu-open {
        transform: translateY(0);
        opacity: 1;
        visibility: visible;
    }

    &__list {
        width: 100%;
        gap: var(--gp-16);

        > li {
            border-bottom: 1px solid var(--color-dark-400);
            padding-bottom: 16px;
        }

        li a {
            width: 100%;
        }
    }

    &__item {
        display: none;
        justify-content: flex-end;
        width: 100%;
        gap: var(--gp-16);

        button {
            width: 36px;
            height: 36px;
        }

        @media (max-width:768px) {
            display: flex;
        }
    }
}

.theme-switcher-mobile button {
    background-color: var(--color-dark-200);
    border-radius: 8px;
}

.has-mobile-menu {
    width: 100%;
    gap: var(--gp-20);

    .list-menu {
        width: 100%;
        gap: var(--gp-20);
        padding-inline: 16px;
        font-size: 16px;

        li {
            display: flex;
            width: 100%;

            a {
                width: 100%;
            }
        }
    }
}

.burger-list__li {
    display: flex;
    width: 100%;
}

.burger-close {
    position: relative;
    display: none;

    &::before,
    &::after {
        content: '';
        position: absolute;
        top: 50%;
        left: 50%;
        width: 24px;
        height: 2px;
        background: var(--color-white);
        transform: translate(-50%, -50%) rotate(45deg);
    }

    &::after {
        transform: translate(-50%, -50%) rotate(-45deg);
    }

    @media (max-width:1160px) {
        display: none;

        &.bg-menu-open {
            display: flex;
        }
    }
}

/* Адаптив */

@media (max-width:768px) {
    .theme-switcher, 
    .search-bar-mobile {
        display: none;
    }

    button .icon-hamburger {
        min-width: 28px;
        height: 26px;
    }
}

@media (max-width:375px) {
    .search-bar {
        display: none;

        &-mobile {
            display: flex;
        }
    }
}

</style>