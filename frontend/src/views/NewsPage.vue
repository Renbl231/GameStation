<script setup>
    import Comment from '../components/Comment.vue'
    import CommentForm from '../components/CommentForm.vue'
    import AuthorBlock from '../components/AuthorBlock.vue'
    import ThemeLabel from '../components/ThemeLabel.vue'
</script>

<template>
    <div class="container flex">
        <div class="news-container flex-column">

            <ThemeLabel 
                label="Бывший босс The Elder Scrolls Online ушёл из Bethesda из-за отмены новой MMO"
                :btm-info="{date: 'Вчера в 21:41 |', theme: 'Анонся'}"
            />

            <AuthorBlock 
                :author="{name: 'Клоун', avatar: '/images/12.jpg'}"
                :views="2031"
                :comments="91"
            />

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
                    <CommentForm />
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

        .img-name {
            font-size: 12px;
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
    }

    @media (max-width:375px) {
        .label-news {
            font-size: 24px;
            line-height: 32px;
        }

        .bottom-info {
            font-size: 18px;
        }
        
        .content-block {
            gap: var(--gp-24);
        }
    }
</style>