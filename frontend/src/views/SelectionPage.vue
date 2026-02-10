<script setup>
    import Comment from '../components/Comment.vue'
</script>

<template>
    <div class="container">
        <div class="selection-container flex-column">
            <div class="label-block flex-column">
                <span class="label-selection">
                    Топ 20 игр с хорошим сюжетом за 2025 год
                </span>
                <div class="bottom-info flex">
                    <span>Вчера в 21:41 |</span>
                    <span>Подборка игр</span>
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

            <div class="content-wrapper flex-column">
                <span class="description-selection">
                    Представляю вам мою подборку игр за 2025 год. Я постарался выделить все хорошие релизы с хорошим сюжетом
                </span>
                <div class="game-wrapper">
                    <img src="/images/new.png" 
                    v-for="n in 7"
                    :key="n"
                    class="game-img">
                </div>
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

    .selection-container {
        max-width: 928px;
        width: 100%;
        margin: 0 auto;
        gap: var(--gp-24);
    }

    .label-block {
        gap: var(--gp-16);
    }

    .label-selection {
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

    /* Контент блок */

    .content-wrapper {
        gap: var(--gp-32);
    }

    .description-selection {
        font-size: 24px;
        line-height: 32px;
        color: var(--font-primary-75);
    }

    .game-wrapper {
        display: grid;
        grid-template-columns: repeat(4, 1fr);
        row-gap: var(--gp-24);
        column-gap: var(--gp-32);
    }

    .game-img {
        width: 100%;
        border-radius: 8px;
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
        .game-wrapper {
            row-gap: var(--gp-24);
            column-gap: var(--gp-20);
        }

    }

    @media (max-width:599px) {


        .game-wrapper {
            grid-template-columns: repeat(3, 1fr);
            row-gap: var(--gp-20);
            column-gap: var(--gp-16);
        }

        .description-selection {
            font-size: 16px;
            line-height: 24px;
        }

        .container {
            padding: 24px 16px;
        }

        .label-selection {
            font-size: 28px;
            line-height: 38px;
        }

        .bottom-info {
            font-size: 20px;
            gap: var(--gp-8);
        }

        .author-name {
            font-size: 12px;
        }

        .counters {
            gap: var(--gp-16);
            font-size: 14px;
        }

        .author-block {
            padding-bottom: 12px;
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
        .label-selection {
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
    }
</style>