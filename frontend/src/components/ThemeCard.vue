<script setup>

</script>

<template>
    <div class="card flex-column">
        <span class="label">Не могу войти в аккаунт</span>
        <div class="author-wrapper flex align-c">
            <img src="/images/12.jpg" class="author-avatar">
            <div class="author-info flex align-c">
                <span class="author-name">Cl0WN |</span>
                <span class="date-publish">14 декабря</span>
            </div>
        </div>
        <p class="description-theme">Описание</p>
        <div class="bottom-info flex align-c justify-sb">
            <span class="comment flex-center"><svg><use href="#icon-comment"></use></svg>Комментарии (2)</span>
            <span>Решено</span>
        </div>
    </div>
</template>

<style scoped>
    .card {
        width: 100%;
        padding: 16px;
        border-radius: 4px;
        background-color: var(--bg-secondary-25);
        gap: var(--gp-12);
        font-family: Roboto_Medium;
    }

    .label {
        font-size: 18px;
        font-family: Roboto_SemiBold;
    }

    .author-wrapper {
        gap: var(--gp-8);
    }

    .author-avatar {
        width: 32px;
        height: 32px;
        border-radius: 50%;
    }

    .author-info {
        gap: var(--gp-4);
        color: var(--font-primary-50);
    }

    .author-name {
        font-size: 16px;
    }

    .date-publish {
        font-size: 14px;
    }

    p {
        font-size: 16px;
        line-height: 24px;
        color: var(--font-primary-75);
    }
    
    .bottom-info {
        margin-top: 4px;
        font-size: 14px;
    }
    
    .comment {
        color: var(--font-primary-50);
        gap: var(--gp-8);
    }

    .comment svg {
        width: 20px;
        height: 20px;
    }

</style>