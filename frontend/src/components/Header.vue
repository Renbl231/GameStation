<script setup>

</script>

<template>
    <header>
        <div class="header-container flex">
            <div class="hdr-left flex-center">
                <routerlink to="/">
                    <img src="/images/logo.png" alt="Логотип">
                </routerlink>
            </div>
            <div class="hdr-middle flex-center">
                <nav class="flex-center" aria-label="Разделы сайта">
                    <ul class="hdr-menu flex-center">
                        <li class="has-dropdown flex-center" style="gap:var(--gp-8)">
                            <routerlink to="games">Игры</routerlink>
                            <svg class="icon-arrow" viewBox="0 0 12 8">
                                <use href="#icon-arrow"/>
                            </svg>
                            <ul class="dropdown-menu">
                                <li>
                                    <routerlink to="/" active-class="active">Каталог</routerlink>
                                </li>
                                <li>
                                    <routerlink to="games/selections">Подборки</routerlink>
                                </li>
                                <li>
                                    <routerlink to="games/reviews">Рецензии</routerlink>
                                </li>
                            </ul>
                        </li>
                        <li class="has-dropdown flex-center" style="gap:var(--gp-8)">
                            <routerlink to="articles">Статьи</routerlink>
                            <svg class="icon-arrow" viewBox="0 0 12 8">
                                <use href="#icon-arrow"/>
                            </svg>
                            <ul class="dropdown-menu">
                                <li>
                                    <routerlink to="/" active-class="active">Обзоры</routerlink>
                                </li>
                                <li>
                                    <routerlink to="games/selections">Подборки игр</routerlink>
                                </li>
                            </ul>
                        </li>
                        <li>
                            <routerlink to="news">Новости</routerlink>
                        </li>
                        <li>
                            <routerlink to="community">Сообщество</routerlink>
                        </li>
                        <li>
                            <routerlink to="help">Помощь</routerlink>
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
    fill: currentColor;
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
    stroke: var(--font-primary);
    transform: rotate(180deg);
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

.icon {
    color: #FFF;
    transition: all 0.2s;
}

.search-bar:hover .icon {
    color: var(--font-secondary)
}

</style>