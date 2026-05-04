<script setup>
    import Search from './Search.vue'
    import AuthRegForm from '../components/Auth-Reg.vue'
    import { ref, onMounted, onUnmounted } from 'vue'
    import { useAuthStore } from '../stores/authStore'
    import { storeToRefs } from 'pinia'

    const authStore = useAuthStore()
    const logout = () => {
        isProfMenuOpen.value = false;
        
        authStore.logout()
    }
    const { isAuthenticated } = storeToRefs(authStore)


    onMounted(() => {
        document.addEventListener('mousedown', closeAllMenus);
        window.addEventListener('resize', handleResize)
        handleResize()
    })
    
    onUnmounted(() => {
        document.removeEventListener('mousedown', closeAllMenus);
    });

    const showSearch = ref(false);
    const isBgMenuOpen = ref(false);
    const isProfMenuOpen = ref(false);

    const toggleBgMenu = () => {
        isBgMenuOpen.value = !isBgMenuOpen.value;
        if (isBgMenuOpen.value) isProfMenuOpen.value = false;
    }

    const toggleProfMenu = () => {
        isProfMenuOpen.value = !isProfMenuOpen.value;
        if (isProfMenuOpen.value) isBgMenuOpen.value = false;
    }

    const closeAllMenus = (event) => {
        if (event.button === 2) return;
  
        const target = event.target;
        
        const isMenuElement = target.closest('.theme-switcher-mobile, .mobile-menu, .btn-menu, .profile-menu');
        
        if (!isMenuElement) {
            isBgMenuOpen.value = false;
            isProfMenuOpen.value = false;
        }
    }

    const handleResize = () => {
        if (window.innerWidth > 1160) {
            isBgMenuOpen.value = false
        }
    }

    const toggleSearch = () => {
        showSearch.value = !showSearch.value
    }

    const showAuthForm = ref(false);

    const toggleAuthForm = () => {
        showAuthForm.value = !showAuthForm.value
        isBgMenuOpen.value = false
    }
     
</script>


<template>

    <header>
        <div class="header-container flex align-c justify-sb">
            <div class="hdr-left flex-center">
                <RouterLink to="/">
                    <img src="/images/logo.png" alt="Логотип" title="На главную">
                </RouterLink>
            </div>
            <div class="hdr-middle flex-center">
                <nav class="flex-center" aria-label="Разделы сайта">
                    <ul class="hdr-menu flex-center">
                        <li class="has-dropdown flex-center" style="gap:var(--gp-8)">
                            <RouterLink to="/games" :class="{ 'active': $route.path.startsWith('/games') }">Игры</RouterLink>
                            <svg class="icon-arrow" :class="{ 'active-svg': $route.path.startsWith('/games') }" viewBox="0 0 12 8">
                                <use href="#icon-arrow"/>
                            </svg>
                            <ul class="dropdown-menu">
                                <li>
                                    <RouterLink to="/games">Каталог</RouterLink>
                                </li>
                                <li>
                                    <RouterLink to="/games/selections">Подборки</RouterLink>
                                </li>
                                <li>
                                    <RouterLink to="/games/reviews">Рецензии</RouterLink>
                                </li>
                            </ul>
                        </li>
                        <li class="has-dropdown flex-center" style="gap:var(--gp-8)">
                            <RouterLink to="/articles" :class="{'active':$route.path.startsWith('/articles')}">Статьи</RouterLink>
                            <svg class="icon-arrow" :class="{ 'active-svg': $route.path.startsWith('/articles')}" viewBox="0 0 12 8">
                                <use href="#icon-arrow"/>
                            </svg>
                            <ul class="dropdown-menu">
                                <li>
                                    <RouterLink to="/articles/reviews">Обзоры</RouterLink>
                                </li>
                                <li>
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
            <div class="hdr-right flex-center">
                <button type="button" @click="toggleSearch()" class="no-border search-bar flex-center" aria-label="Поиск">
                    <svg class="icon-search">
                        <use href="#icon-search"/>
                    </svg>
                </button>
                <div class="theme-switcher">
                    <button type="button" class="no-border btn-menu flex-center" aria-label="Цветовая схема">
                        <svg class="icon">
                            <use href="#icon-night-theme"/>
                        </svg>
                    </button>
                </div>
                <button @click="!isAuthenticated ? toggleAuthForm() : toggleProfMenu()" type="button" class="no-border btn-menu flex-center" aria-label="Авторизоваться">
                    <svg class="icon">
                        <use href="#icon-profile"/>
                    </svg>
                </button>

                <button type="button" @click="toggleBgMenu()" :class="{'bg-menu-open': isBgMenuOpen}" class="no-border flex-center mobile-menu">
                    <svg class="icon-hamburger">
                        <use href="#icon-hamburger"/>
                    </svg>
                </button>


                <div class="profile-menu flex-column" :class="{ 'prof-menu-open': isProfMenuOpen }">
                    <ul class="profile-list flex-column">
                        <li class="profile-list__li flex">
                            <RouterLink :to="`/user/${authStore.user?.nickname}`">Профиль</RouterLink>
                        </li>
                        <li class="profile-list__li flex">
                            <RouterLink :to="`/user/${authStore.user?.nickname}/games`">Мои игры</RouterLink>
                        </li>
                        <li class="profile-list__li flex">
                            <RouterLink :to="`/user/${authStore.user?.nickname}/reviews`">Мои рецензии</RouterLink>
                        </li>
                        <li class="profile-list__li flex">
                            <a href="">Мои подборки</a>
                        </li>
                        <li class="profile-list__li flex">
                            <a href="">Мои запросы</a>
                        </li>
                        <li class="profile-list__li flex">
                            <a href="">Мои комментарии</a>
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
        <ul class="burger-list flex-column">
            <li class="mobile-bar flex">
                <button type="button" @click="toggleSearch()" class="no-border search-bar-mobile flex-center" aria-label="Поиск">
                    <svg class="icon-search">
                        <use href="#icon-search"/>
                    </svg>
                </button>
                <div class="theme-switcher-mobile">
                    <button type="button" class="no-border btn-menu flex-center" aria-label="Цветовая схема">
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
                    <li>
                        <RouterLink to="/games/selections">Подборки</RouterLink>
                    </li>
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


<style scoped>

header {
    width: 100%;
    height: 72px;
    top: 0%;
    background-color: var(--hdr-primary);
    font-size: 20px;
    font-family: Roboto_SemiBold;
    position: fixed;
    z-index: 500;
}

.header-container {
    max-width: 1348px;
    width: 100vw;
    height: 100%;
    padding-inline: 30px;
    margin: 0 auto;
    gap: var(--gp-24);
    margin-bottom: 48px;
    position: relative;
    z-index: 490;
}

.hdr-left,
.hdr-middle,
.hdr-right,
nav {
  height: 100%;
}

nav ul li a {
    color: var(--font-primary);
}

nav ul {
  gap: var(--gp-48);
  height: 100%;
}

nav ul li {
  display: flex;
  align-items: center;
  height: 100%;
  cursor: pointer;
}

nav ul li a {
    display: flex;
    justify-content: center;
    align-items: center;
    height: 100%;
}


.hdr-left img {
    min-width: 306px;
    height: 34px;
    user-select: none;
}

.hdr-right {
    gap:var(--gp-24);
    position: relative;
    z-index: 200;
}


.hdr-right button, .mobile-bar button {
    width: 36px;
    height: 36px;
}

.hdr-right .btn-menu, .theme-switcher-mobile button {
    background-color: var(--bg-secondary-25);
    border-radius: 8px;
}

.icon {
    min-width: 24px;
    height: 24px;
}

.icon-search {
    min-width: 22px;
    height: 22px;
    color: #FFF;
}

.icon-arrow {
    min-width: 10px;
    height: 10px;
    stroke: var(--font-primary-50);
    transition: all 0.2s ease;
}

/* Выпад список */

.hdr-menu, .has-dropdown {
    position: relative;
}

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
}

.dropdown-menu li {
    width: 100%;
}

.dropdown-menu li a{
    width: 100%;
    justify-content: flex-start;
}

li:hover > a {
  color: var(--font-secondary);
}

.has-dropdown::after { /* невидимый мостик для ховер эффекта*/
    content: '';
    top:100%;
    left: 0;
    right: 0;
    position: absolute;
    height: 10px;
    z-index: 999;
    background: transparent;
}

.has-dropdown:hover .icon-arrow {
    stroke: var(--font-secondary);
    transform: rotate(180deg);
}

.has-dropdown:hover > a:first-child{
  color: var(--font-secondary);
}


.has-dropdown:hover .dropdown-menu {
    display: flex;
}

button .icon-hamburger {
    min-width: 32px;
    height: 28px;
}

.mobile-menu {
    width: inherit;
    display: none;
}


.btn-menu:hover {
    background-color: var(--bg-secondary-50);
}

.active, .search-bar:hover .icon-search, .search-bar-mobile:hover .icon-search{
    color: var(--font-secondary);
}

.active-svg {
    stroke: var(--font-secondary);
}

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
}

.profile-list {
    width: 100%;
    gap: var(--gp-16);
}

.profile-list__li {
    width: 100%;
}

.profile-list__li a {
    width: 100%;
}

.profile-menu .logout-btn {
    width: 100%;
    text-align: left;
    margin-top: 16px;
}

.logout-btn:hover {
    color: var(--font-secondary);
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
}

.burger-menu.bg-menu-open, .profile-menu.prof-menu-open {
    transform: translateY(0);
    opacity: 1;
    visibility: visible;
}


.burger-list, .mobile-bar {
    width: 100%;
    gap: var(--gp-16);
}

.burger-list > li {
    border-bottom: 1px solid var(--bg-secondary);
    padding-bottom: 16px;
}

.has-mobile-menu {
    width: 100%;
    gap: var(--gp-20);
}

.list-menu {
    width: 100%;
    gap: var(--gp-20);
    padding-inline: 16px;
    font-size: 16px;
}

.list-menu li {
    display: flex;
    width: 100%;
}

.list-menu li a {
    width: 100%;
}

.burger-list__li {
    display: flex;
    width: 100%;
}

.burger-list li a {
    width: 100%;
}

.mobile-bar {
    display: none;
    justify-content: flex-end;
}

.burger-close {
    position: relative;
    display: none;
}

.burger-close::before,
.burger-close::after {
    content: '';
    position: absolute;
    top: 50%;
    left: 50%;
    width: 24px;
    height: 2px;
    background: var(--font-primary);
    transform: translate(-50%, -50%) rotate(45deg);
}

.burger-close::after {
    transform: translate(-50%, -50%) rotate(-45deg);
}


/* Адаптив */

@media (max-width:1280px) {
    nav ul {
        gap: var(--gp-24);
    }
}

@media (max-width:1160px) {
    .hdr-middle {
        display: none;
    }
    .mobile-menu {
        display: flex;
    }

    .burger-close {
        display: none;
    }
    
    .burger-close.bg-menu-open {
        display: flex;
    }

    .mobile-menu.bg-menu-open {
        display: none;
    }

}

@media (max-width:1024px) {
    .icon-search {
        min-width: 28px;
        height: 28px;
    }
}

@media (max-width:768px) {
    .theme-switcher, .search-bar-mobile {
        display: none;
    }

    .mobile-bar {
        display: flex;
    }

    button .icon-hamburger {
        min-width: 28px;
        height: 26px;
    }
}

@media (max-width:600px) {
    .hdr-left img {
        content: url('/images/logo-tablet.png');
        min-width: 254px;
        height: 32px;
    }

    .header-container {
        padding-inline: 16px;
    }

}

@media (max-width:500px) {
    .hdr-left img {
        content: url('/images/logo-mobile.png');
        min-width: 185px;
        height: 30px;
    }

    .hdr-right {
        gap: var(--gp-20);
    }

    .hdr-right button {
        width: 32px;
        height: 32px;
    }

    .header-container {
        margin-bottom: 32px;
    }

    .burger-menu {
        max-width: 500px;
        right: 0px;
        border-radius: 0px;
    }
}

@media (max-width:375px) {
    .search-bar {
        display: none;
    }
    .search-bar-mobile {
        display: flex;
    }
}

</style>