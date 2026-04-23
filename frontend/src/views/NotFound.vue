<template>
     <div class="global-404-overlay flex-center">
        <div class="not-found-box flex-column">
            <h1>404</h1>
            <h2>Страница не найдена</h2>
            <router-link to="/" class="btn-home">На главную</router-link>
        </div>
    </div>
</template>

<style scoped>
    h1 {
        font-size: 164px !important;
        font-family: Roboto_Regular;
        color: var(--btn-color-2);
        margin: 0;
        line-height: normal;
    }

    h2 {
        font-size: 28px;
        font-family: Roboto_Regular;
    }

    .global-404-overlay {
        position: absolute;
        z-index: 1;
    }

    .not-found-box {
        text-align: center;
    }

    .btn-home {
        margin-top: 16px;
        width: auto;
        font-family: Roboto_Medium;
        border-radius: 4px;
        background-color: var(--btn-color-1);
        padding: 4px 8px;
    }

    .btn-home:hover {
        background-color: var(--font-secondary);
    }

</style>
