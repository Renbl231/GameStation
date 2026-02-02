<script setup>
    import NavBar from '../components/HelpBar.vue'
</script>

<template>
    <div class="container flex-column">
        <NavBar />
        <div class="bck-block flex">
            <div class="wrapper-container flex-column">
                <div class="wrapper-label flex-column">
                    <h3>Правила сайта</h3>
                    <h1>За что может наказать модерация</h1>
                </div>
                <div class="content-block flex-column">
                    <div class="rule-block flex-column">
                        <h2>Нарушение законов РФ</h2>
                        <p>Запрещены любые сообщения, нарушающие законодательство РФ: разжигание ненависти и вражды, призывы к насилию, терроризму и подобные материалы</p>
                    </div>
                    <div class="rule-block flex-column">
                        <h2>Мультиаккаунты</h2>
                        <p>Запрещено создание дополнительных аккаунтов для обхода бана, накрутки оценок, лайков или манипуляций с комментариями и отзывами</p>
                    </div>
                    <div class="rule-block flex-column">
                        <h2>Спам и реклама</h2>
                        <ul class="flex-column">
                            <li class="flex align-c">
                                <svg class="icon"><use href="#icon-rule"></use></svg>
                                <p>Многократная публикация одинаковых сообщений или отзывов</p>
                            </li>
                            <li class="flex align-c">
                                <svg class="icon"><use href="#icon-rule"></use></svg>
                                <p>Реклама сторонних ресурсов, проектов и сервисов</p>
                            </li>
                        </ul>
                    </div>
                    <div class="rule-block flex-column">
                        <h2>NSFW‑контент</h2>
                        <ul class="flex-column">
                            <li class="flex align-c">
                                <svg class="icon"><use href="#icon-rule"></use></svg>
                                <p>Порнография и откровенно сексуальный контент</p>
                            </li>
                            <li class="flex align-c">
                                <svg class="icon"><use href="#icon-rule"></use></svg>
                                <p>Изображения полностью или частично обнажённых людей</p>
                            </li>
                            <li class="flex align-c">
                                <svg class="icon"><use href="#icon-rule"></use></svg>
                                <p>Сцены жестокости, насилия, издевательств над людьми или животными и подобное.</p>
                            </li>
                        </ul>
                    </div>
                    <div class="rule-block flex-column">
                        <h2>Мат и оскорбления</h2>
                        <ul class="flex-column">
                            <li class="flex align-c">
                                <svg class="icon"><use href="#icon-rule"></use></svg>
                                <p>Запрещены прямые оскорбления, травля и переход на личности</p>
                            </li>
                            <li class="flex align-c">
                                <svg class="icon"><use href="#icon-rule"></use></svg>
                                <p>Нецензурная лексика не допускается, даже если она частично «зацензурена» символами</p>
                            </li>
                        </ul>
                    </div>
                </div>
            </div>
        </div>
    </div>
</template>

<style scoped>

    .icon {
        width: 24px;
        height: 24px;
        margin-right: 8px;
    }

    .container {
        width: 100%;
        gap: var(--gp-32);
    }

    .bck-block {
        width: 100%;
        padding-inline: 96px;
        padding-block: 64px;
        margin: 0 auto;
        background-color: var(--bg-third-25);
        border: 1px solid var(--bg-third-100);
        border-radius: 32px;
        font-family: Roboto_Regular;
        font-size: 18px;
    }

    .wrapper-container {
        max-width: 736px;
        width: 100%;
        margin: 0 auto;
        gap: var(--gp-36);
    }

    .wrapper-container h1 {
        font-size: 32px;
        font-family: Roboto_Bold;
    }

    .wrapper-container h2 {
        font-size: 24px;
        font-family: Roboto_SemiBold;
    }

    .wrapper-container h3 {
        font-size: 20px;
        font-family: Roboto_SemiBold;
        letter-spacing: 1px;
        color: var(--another-color);
        text-transform: uppercase;
    }

    .content-block {
        width: 100%;
    }

    .rule-block {
        width: 100%;
        gap: var(--gp-16);
    }

    .rule-block ul {
        gap: var(--gp-20);
    }

    .rule-block p {
        font-size: 20px;
        line-height: 36px;
    }
    
    .wrapper-label {
        gap: var(--gp-24);
    }

    .content-block {
        gap: var(--gp-48)
    }

    @media (max-width: 1160px) {
        .bck-block {
            border-radius: 0px;
            padding-inline: 48px;
        }
    }

    @media (max-width:767px) {
        .bck-block {
            padding-inline: 16px;
            padding-block: 32px;
        }
    }

    @media (max-width:500px) {
        .wrapper-container h1 {
            font-size: 28px;
        }

        .wrapper-container h2 {
            font-size: 20px;
        }

        .rule-block p {
            font-size: 16px;
            line-height: 28px;
        }
    }


</style>