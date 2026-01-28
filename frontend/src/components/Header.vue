<script setup>

</script>

<template>
    <header>
        <div class="header-container flex">
            <div class="hdr-left">
                <img src="/images/logo.png" alt="Логотип">
            </div>
            <div class="hdr-middle">
                <nav aria-label="Разделы сайта">
                    <ul class="hdr-menu flex">
                        <li>
                            <span>Игры</span>
                        </li>
                        <li>
                            <span>Статьи</span>
                        </li>
                        <li>
                            <span>Новости</span>
                        </li>
                        <li>
                            <span>Сообщество</span>
                        </li>
                        <li>
                            <span>Помощь</span>
                        </li>
                    </ul>
                </nav>         
            </div>
            <div class="hdr-right flex">
                <button type="button" class="no-border search-bar" aria-label="Поиск">
                    <svg class="icon" width="22" height="22" viewBox="0 0 22 22">
                        <use href="#icon-search"/>
                    </svg>
                </button>
                <div class="theme-switcher">
                    <button type="button" class="no-border btn-menu flex-center" aria-label="Цветовая схема">
                        <svg class="icon" width="24" height="24" viewBox="0 0 24 24">
                            <use href="#icon-night-theme"/>
                        </svg>
                    </button>
                </div>
                <button type="button" class="no-border btn-menu flex-center" aria-label="Авторизоваться">
                    <svg class="icon" width="24" height="22" viewBox="0 0 24 24">
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
    padding-inline: 16px;
    margin: 0 auto;
}

.hdr-menu {
    gap:48px;
}

.hdr-right {
    gap:var(--gp-24)
}

.hdr-right button {
    width: 36px;
    height: 36px;
}

.hdr-right .btn-menu {
    background-color: var(--bg-secondary);
    border-radius: 8px;
}

</style>