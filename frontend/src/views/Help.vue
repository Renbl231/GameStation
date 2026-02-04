<script setup>
    import NavBar from '../components/HelpBar.vue'

</script>


<template>
    <div class="container flex-column">
        <NavBar />
        <div class="wrapper-container flex-column flex-center">
            <div class="label-block flex-column align-c">
                <h3>Личный аккаунт пользователя</h3>
                <h1>Почему вам стоит зарегистрироваться на сайте</h1>
                <p>Ваш личный уголок превращает портал в уютное игровое пространство, где каждый визит ощущается как возвращение домой. Забудьте временные сессии, портал запоминает вас и эволюционирует вместе с вашей страстью к играм</p>
                <a href="#">Зарегистрироваться</a>
            </div>
            <div class="info-block flex-column align-c">
                <h2>Коротко: что вы получите</h2>
                <div class="cards-block">
                    <div class="card flex-column">
                        <div class="label-card flex align-c">
                            <div class="icon-container flex-center">
                                <svg class="icon">
                                    <use href="#icon-favorite" ></use>
                                </svg>
                            </div>
                            <span>Коллекции</span>
                        </div>
                        <div class="description-card">
                            <p>Добавляйте игры в списки «Играю», «Пройдено», «Буду играть» и «Избранное». Возвращайтесь к своему личному каталогу в любой момент</p>
                        </div>
                    </div>
                    <div class="card flex-column">
                        <div class="label-card flex align-c">
                            <div class="icon-container flex-center">
                                <svg class="icon">
                                    <use href="#icon-star" ></use>
                                </svg>
                            </div>
                            <span>Оценки</span>
                        </div>
                        <div class="description-card">
                            <p>Оценивайте игры разными способами: быстрая оценка или детальный разбор по графике, геймплею, сюжету. Фиксируйте впечатления навсегда</p>
                        </div>
                    </div>
                    <div class="card flex-column">
                        <div class="label-card flex align-c">
                            <div class="icon-container flex-center">
                                <svg class="icon">
                                    <use href="#icon-discuss" ></use>
                                </svg>
                            </div>
                            <span>Друзья и обсуждения</span>
                        </div>
                        <div class="description-card">
                            <p>Обсуждайте новости и релизы, добавляйте пользователей в друзья, следите за их активностью и коллекциями</p>
                        </div>
                    </div>
                    <div class="card flex-column">
                        <div class="label-card flex align-c">
                            <div class="icon-container flex-center">
                                <svg class="icon">
                                    <use href="#icon-selections" ></use>
                                </svg>
                            </div>
                            <span>Подборки</span>
                        </div>
                        <div class="description-card">
                            <p>Создавайте тематические подборки игр и делитесь ими с сообществом. Ваши рекомендации найдут своих поклонников</p>
                        </div>
                    </div>
                    <div class="card flex-column">
                        <div class="label-card flex align-c">
                            <div class="icon-container flex-center">
                                <svg class="icon">
                                    <use href="#icon-bar" ></use>
                                </svg>
                            </div>
                            <span>Игровая статистика</span>
                        </div>
                        <div class="description-card">
                            <p>Строите сами: топ игр, количество пройденных и оценённых тайтлов, любимые жанры — ваша история геймера оживает</p>
                        </div>
                    </div>
                </div>
            </div>
            <div class="help-block flex-column flex-center">
                <h2>Как добавить свою игру в каталог ?</h2>
                <div class="help-card flex-column">
                    <div class="content-block flex-column">
                        <h2>Как добавить игру в каталог</h2>
                        <span>Добавление новой игры займёт всего пару минут</span>
                        <ol>
                            <li>Откройте раздел «Связаться с нами» на портале</li>
                            <li>Выберите тему обращения «Заполнение базы игр»</li>
                            <li>Заполните форму</li>
                            <li>Отправьте игру на модерацию и дождитесь проверки</li>
                        </ol>
                    </div>
                    <button type="button" class="no-border" aria-label="Форма для добавления игры">Заполнить форму</button>
                </div>
            </div>
        </div>
    </div>
</template>


<style scoped>
    
    .icon-container {
        background: linear-gradient(to bottom, #38BDF8 30%, #1E293B 100%);
        border-radius: 50%;
        padding: 10px;
    }

    .icon {
        width: 20px;
        height: 20px;
    }


    .container {
        width: 100%;
        gap: var(--gp-32);
    }

    .wrapper-container {
        width: 100%;
        padding-inline: 96px;
        padding-block: 64px;
        margin: 0 auto;
        background-color: var(--bg-third-25);
        border: 1px solid var(--bg-third-100);
        border-radius: 32px;
        gap: var(--gp-64);
        font-family: Roboto_Regular;
        font-size: 18px;
    }
    .wrapper-container h1 {
        font-size: 32px;
        font-family: Roboto_Bold;
    }

    .wrapper-container h2 {
        font-size: 32px;
        font-family: Roboto_SemiBold;
        letter-spacing: 1px;
    }

    .wrapper-container h3 {
        font-size: 20px;
        font-family: Roboto_SemiBold;
    }

    .wrapper-container h4 {
        font-size: 18px;
        font-family: Roboto_Regular;
        line-height: 28px;
        color: var(--font-primary-75);
    }

    .label-block {
        width: 100%;
        gap: var(--gp-24);
        text-align: center;
    }

    .label-block p {
        font-size: 24px;
        color: var(--font-primary-75);
        line-height: 48px;
    }

    .label-block h3 {
        text-transform: uppercase;
        color: var(--another-color);
        letter-spacing: 2px;
    }

    .label-block a, .help-card button {
        max-width: 316px;
        width: 100%;
        padding-block: 12px;
        background-color: var(--btn-color-1);
        border-radius: 256px;
        font-family: Roboto_Medium;
    }

    .label-block p {
        margin: 0;
    }

    .info-block {
        gap: var(--gp-48);
    }

    .cards-block {
        width: 100%;
        display: grid;
        grid-template-columns: repeat(3, 1fr);
        gap: var(--gp-32);
    }

    .card {
        padding: 20px;
        background-color: var(--bg-third-25);
        border: 2px solid var(--bg-third-100);
        border-radius: 8px;
        gap: var(--gp-12);
    }

    .label-card {
        gap: var(--gp-12);
        font-size: 20px;
        font-family: Roboto_SemiBold;
    }

    .description-card {
        color: var(--font-primary-75);
        line-height: 32px;
    }


    .help-block {
        width: 100%;
        margin: 0 auto;
        gap: var(--gp-32);
    }

    .help-card {
        max-width: 928px;
        width: 100%;
        border: 1px solid var(--bg-third-100);
        border-left: 4px solid var(--btn-color-2);
        border-radius: 16px;
        padding: 32px;
        gap: var(--gp-24);
    }

    .help-block > h2 {
        text-align: center;
    }

    .help-card span {
        color: var(--another-color);
        font-family: Roboto_Medium;
        font-size: 20px;
    }

    .content-block {
        gap: var(--gp-16);
    }

    .content-block ol {
        margin-left: 24px;
        color: var(--font-primary-75);
        line-height: 28px;
    }

    .content-block h2 {
        font-size: 24px;
    }



    @media (max-width: 1160px) {
        .wrapper-container {
            border-radius: 0px;
            padding-inline: 48px;
        }

        .card {
            padding: 16px;
        }

        .label-card {
            gap: var(--gp-8);
        }
    }

    @media (max-width:1023px) {
        .cards-block {
            grid-template-columns: repeat(2, 1fr);
        }
    }

    @media (max-width:767px) {

        .cards-block {
            grid-template-columns: repeat(1, 1fr);
            gap: var(--gp-16);
        }
    
        .wrapper-container h3,
        .label-block p {
            font-size: 16px;
        }

        .label-block p {
            line-height: 28px;
        }

        .label-block a, .help-card button {
            font-size: 16px;
            padding-block: 8px;
        }

        .wrapper-container h1,
        .wrapper-container h2 {
            font-size: 24px;
        }

        .wrapper-container {
            gap: var(--gp-32);
            padding-inline: 16px;
            padding-block: 32px;
        }

        .info-block {
            gap: var(--gp-32);
        }

        .label-card {
            font-size: 18px;
        }

        .card .description-card {
            font-size: 16px;
            line-height: 24px;
        }

        .content-block h2 {
            font-size: 20px;
        }

        .help-card span {
            font-size: 16px;
        }

    }

    @media (max-width:500px) {
        
        .wrapper-container div {
            align-items: stretch;
            text-align: left;
        }

        .cards-block {
            gap: var(--gp-16);
        }

        .label-block {
            gap: var(--gp-20)
        }

        .label-block a, .help-card button {
            max-width: none;
            text-align: center;
        }

        .label-card {
            font-size: 16px;
        }

        .card .description-card {
            font-size: 14px;
            line-height: 20px;
        }

        .help-card {
            padding: 20px 16px;
        }

        .content-block ol {
            font-size: 14px;
            line-height: 24px;
        }
    }

    @media (max-width:374px) {
       .label-block h3 {
            font-size: 13px;
        }

        .wrapper-container h1,
        .wrapper-container h2 {
            font-size: 20px;
        }
    }

    



</style>