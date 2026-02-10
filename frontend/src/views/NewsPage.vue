<script setup>
    import Comment from '../components/Comment.vue'
</script>

<template>
    <div class="container flex">
        <div class="news-container flex-column">
            <div class="label-block flex-column">
                <span class="label-news">
                    Бывший босс The Elder Scrolls Online ушёл из Bethesda из-за отмены новой MMO
                </span>
                <div class="bottom-info flex">
                    <span>Вчера в 21:41 |</span>
                    <span>Анонсы</span>
                </div>
            </div>
            <div class="author-block flex justify-sb align-c">
                <div class="author-info flex align-c">
                    <img src="/images/12.jpg" class="author-img">
                    <span class="author-name">Андрей Абашев</span>
                </div>
                <div class="counters flex align-c">
                    <span aria-label="Количество просмотров" class="flex-center"><svg class="icon icon-views"><use href="#icon-views"></use></svg>2004</span>
                    <button type="button" aria-label="Перейти к комментариям" class="no-border flex-center"><svg class="icon icon-comment"><use href="#icon-comment"></use></svg>523</button>
                </div>
            </div>

            <div class="content-block flex-column">
                <div class="img-block flex-column">
                    <picture>
                        <img src="/images/8.jpg">
                    </picture>
                    <span class="img-name">Обложка: скриншот The Elder Scrolls Online</span>
                </div>
                <p class="text-content">Бывший руководитель <a href="#" class="text-link">The Elder Scrolls Online</a> Мэтт Фирор неожиданно высказался о своём уходе из ZeniMax Online летом прошлого года. Разработчик раскрыл причину — отмена MMO-проекта Blackbird в ходе очередных сокращений в игровом подразделении Microsoft. Невышедшая игра была тем самым проектом, который Фирор мечтал создать на протяжении всей карьеры.</p>

                <p class="text-content">Сейчас Мэтт Фирор наслаждается TES Online в качестве простого игрока — разработчик не боится за судьбу и наследие игр ZeniMax Online. Также ветеран индустрии консультирует различные проекты и даже занимается инвестициями в «небольшие команды», которые потенциально могут сыграть важную роль в будущем игровой индустрии.</p>

                <p class="text-content">В целом же бывший босс TES Online благодарит всех за поддержку. Начался 2026 год, поэтому тяжёлые прошлые месяцы с сокращениями и отменами игр остались позади.</p>

                <p class="text-content">Об отменённой MMO известно не так много — вероятно, она создавалась в фантастическом сеттинге. Известный журналист и инсайдер Джез Корден рассказывал, что MMO пришлось пожертвовать ради разработки Fallout 5 и развития постапокалиптической франшизы в целом. Остаётся надеяться, что это был правильный выбор.</p>

                <button type="button" aria-label="Оценить новость" class="no-border counter-slider flex-center"><svg><use href="#icon-like"></use></svg>89</button>
            </div>

            <div class="comment-wrapper flex-column">
                <span class="label-comment">Комментарии (5)</span>   

                <div class="comments-block flex-column">
                    <Comment class="comment" />

                    <div class="comment-block flex-column">
                        <textarea type="text" class="no-border field-comment" placeholder="Ваш комментарий"></textarea>
                        <button type="button" class="no-border send-comment">Отправить</button>
                    </div>
                </div>
            </div>

        </div>

        <div class="advertisment-container flex-column">
            <span class="place-btn">Разместить рекламу</span>
        </div>
    </div>
</template>

<style scoped>
    .container {
        width: 100%;
        font-family: Roboto_Medium;
        background-color: var(--bg-secondary-25);
        border-radius: 8px;
        padding: 32px;
        gap: var(--gp-20);
    }

    .news-container {
        width: 100%;
        gap: var(--gp-24);
    }

    .label-block {
        gap: var(--gp-16);
    }

    .label-news {
        font-size: 36px;
        line-height: 48px;
        font-family: Roboto_Bold;
    }

    .bottom-info {
        font-size: 24px;
        color: var(--font-primary-50);
        gap: var(--gp-10);
    }

    /* Автор блок */

    .author-block {
        border-bottom: 2px solid var(--bg-secondary-50);
        padding-bottom: 16px;
    }

    .author-info {
        gap: var(--gp-10);
    }

    .author-img {
        width: 36px;
        height: 36px;
        border-radius: 50%;
    }

    .author-name {
        font-size: 14px;
        color: var(--font-primary-75);
    }

    .counters {
        gap: var(--gp-24);
    }

    .counters button, .counters span {
        gap: var(--gp-8);
        color: var(--font-primary-25);
        padding: 0;
    }

    .icon {
        width: 24px;
        height: 24px;
    }

    .icon-views {
        height: 16px;
    }

    /* Контент новости */

    .content-block {
        gap: var(--gp-32);
    }

    .img-block {
        gap: var(--gp-8);
    }

    .img-block img {
        border-radius: 8px;
    }

    .img-name {
        font-size: 14px;
        font-style: italic;
    }

    .text-content {
        font-size: 20px;
        line-height: 32px;
        color: var(--font-primary-75);
    }

    .text-link {
        color: var(--font-secondary);
        text-decoration: underline;
    }

    .counter-slider {
        width: fit-content;
        gap: var(--gp-8);
        font-size: 14px;
        font-family: Roboto_SemiBold;
        padding: 8px 16px;
        background-color: var(--btn-color-6-25);
        border-radius: 4px;
        color: var(--font-primary-25);
        transition: 0.3s;
    }

    .counter-slider:hover {
        filter: brightness(1.5);
    }

    .counter-slider svg {
        width: 24px;
        height: 24px;
    }

    /* Блок комментариев */

    .comment-wrapper {
        width: 100%;
        gap: var(--gp-16);
        margin-top: 24px;
    }

    .label-comment {
        font-size: 32px;
        font-family: Roboto_SemiBold;
    }

    .comments-block {
        gap: var(--gp-24);
    }

    .comment-block {
        background-color: var(--bg-secondary-25);
        border-radius: 8px;
        padding: 16px;
        gap: var(--gp-24);
    }

    .send-comment {
        width: fit-content;
        font-size: 14px;
        background-color: var(--btn-color-4);
        border-radius: 256px;
        padding: 8px 16px;
    }

    .field-comment {
        width: 100%;
        resize: none;
        overflow: hidden;
        field-sizing: content;
        font-size: 18px;
    }

    /* Рекламный блок */

    .advertisment-container {
        min-width: 284px;
    }

    .place-btn {
        font-size: 20px;
        background-color: var(--btn-color-6-25);
        padding-block: 16px;
        text-align: center;
        border-radius: 8px;
    }

    @media (max-width:1160px) {
        .container {
            border-radius: 0px;
            padding: 32px 24px;
        }
        .place-btn {
            font-size: 16px;
        }
    }

    @media (max-width:900px) {
        .advertisment-container {
            display: none;
        }
    }

    @media (max-width:599px) {
        .container {
            padding: 24px 16px;
        }

        .label-news {
            font-size: 28px;
            line-height: 38px;
        }

        .bottom-info {
            font-size: 20px;
            gap: var(--gp-8);
        }

        .author-name, .img-name {
            font-size: 12px;
        }

        .counters {
            gap: var(--gp-16);
            font-size: 14px;
        }

        .author-block {
            padding-bottom: 12px;
        }

        .img-block img {
            border-radius: 4px;
        }

        .text-content {
            font-size: 16px;
            line-height: 24px;
        }
        
        .counter-slider {
            font-size: 14px;
        }

        .label-comment {
            font-size: 24px;
        }

        .comments-block {
            gap: var(--gp-20);
        }

        .icon {
            width: 20px;
            height: 20px;
        }

        .icon-views {
            height: 13px;
        }

        .field-comment {
            font-size: 16px;
        }
    }

    @media (max-width:375px) {
        .label-news {
            font-size: 24px;
            line-height: 32px;
        }

        .bottom-info {
            font-size: 18px;
        }

        .counters {
            gap: var(--gp-10);
        }

        .counters button, .counters span {
            gap: var(--gp-4);
        }
        .content-block {
            gap: var(--gp-24);
        }
    }
</style>