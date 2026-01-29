<script setup>

</script>

<template>
    <header>
        <div class="header-container flex">
            <div class="hdr-left flex-center">
                <RouterLink to="/">
                    <img src="/images/logo.png" alt="Логотип">
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
                                    <RouterLink to="/games/catalog">Каталог</RouterLink>
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
                            <RouterLink to="/help" :class="{ 'active': $route.path === '/help'}">Помощь</RouterLink>
                        </li>
                    </ul>
                </nav>         
            </div>
            <div class="hdr-right flex-center">
                <button type="button" class="no-border search-bar flex-center" aria-label="Поиск">
                    <svg class="icon">
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
                <button type="button" class="no-border btn-menu flex-center" aria-label="Авторизоваться">
                    <svg class="icon">
                        <use href="#icon-profile"/>
                    </svg>
                </button>
            </div>
        </div>
    </header>
</template>


<style scoped>

header {
    width: 100%;
    height: 72px;
    background-color: var(--hdr-primary);
    font-size: 20px;
    font-family: Roboto_SemiBold;
}

.header-container {
    max-width: 1320px;
    width: 100%;
    height: 100%;
    padding-inline: 30px;
    margin: 0 auto;
    display: flex;
    justify-content: space-between;
    align-items: center;
    gap: var(--gp-24);
    margin-bottom: 48px;
}

nav ul li a {
    color: var(--font-primary);
}

.hdr-left,
.hdr-middle,
.hdr-right,
nav {
  height: 100%;
}

nav ul {
  gap: var(--gp-48);
  height: 100%;
}

nav ul li {
  display: flex;
  align-items: center;
  height: 100%;
}

.hdr-left img {
    min-width: 306px;
    min-height: 34px;
}

.hdr-right {
    gap:var(--gp-24)
}

.hdr-right button {
    width: 36px;
    height: 36px;
}

.hdr-right .btn-menu {
    background-color: var(--bg-secondary-25);
    border-radius: 8px;
}

.icon {
    width: 24px;
    height: 24px;
    color: #FFF;
    transition: all 0.2s;
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

li:hover > a {
  color: var(--font-secondary);
}

.has-dropdown::after {
    content: '';
    top:100%;
    left: 0;
    right: 0;
    position: absolute;
    height: 0px;
    z-index: 999;
}

.icon-arrow {
    min-width: 10px;
    min-height: 10px;
    stroke: var(--font-primary-50);
    transition: all 0.2s ease;
}

.has-dropdown:hover .icon-arrow {
    stroke: var(--font-secondary);
    transform: rotate(180deg);
}

.has-dropdown:hover > a:first-child{
  color: var(--font-secondary);
}

.has-dropdown:hover::after {
    height: 8px;
}

.has-dropdown:hover .dropdown-menu {
    display: flex;
}

.btn-menu:hover {
    background-color: var(--bg-secondary-50);
}

.active, .search-bar:hover .icon {
    color: var(--font-secondary);
}

.active-svg {
    stroke: var(--font-secondary);
}

</style>