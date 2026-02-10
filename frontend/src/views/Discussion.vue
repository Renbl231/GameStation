<script setup>
    import Comment from '../components/Comment.vue'
    import CommentForm from '../components/CommentForm.vue'
    import AuthorBlock from '../components/AuthorBlock.vue'
    import ThemeLabel from '../components/ThemeLabel.vue'
</script>

<template>
    <div class="container">
        <div class="theme-container flex-column">
            <ThemeLabel 
                label="Помогите найти игру"
                :btm-info="{date: 'Сегодня в 20:39 | ', theme: 'Ищу игру'}"
            />

            <AuthorBlock 
                :author="{name: 'Клоун', avatar: '/images/12.jpg'}"
                :views="2031"
                :comments="91"
            />

            <div class="content-wrapper flex-column">
                <p class="description-theme">
                    Помню что в игре мы с командой по сюжету высаживаемся на какой-то корабль и потом что-то происходит, потом появляются пришельцы Помню что в игре мы с командой по сюжету высаживаемся на какой-то корабль и потом что-то происходит, потом появляются пришельцы
                    Помню что в игре мы с командой по сюжету высаживаемся на какой-то корабль и потом что-то происходит, потом появляются пришельцы
                </p>
            </div>


            <div class="comment-wrapper flex-column">
                <span class="label-comment">Комментарии (5)</span>   

                <div class="comments-block flex-column">
                    <Comment class="comment" />
                    <CommentForm />
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

    .theme-container {
        max-width: 928px;
        width: 100%;
        margin: 0 auto;
        gap: var(--gp-24);
    }

    .label-block {
        gap: var(--gp-16);
    }

    .label-theme {
        font-size: 36px;
        line-height: 48px;
        font-family: Roboto_Bold;
    }

    .bottom-info {
        font-size: 24px;
        color: var(--font-primary-50);
        gap: var(--gp-10);
    }

    /* Контент блок */

    .content-wrapper {
        gap: var(--gp-32);
    }

    .description-theme {
        font-size: 20px;
        line-height: 32px;
        color: var(--font-primary-75);
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

        .description-theme {
            font-size: 16px;
            line-height: 24px;
        }

        .container {
            padding: 24px 16px;
        }

        .label-theme {
            font-size: 28px;
            line-height: 38px;
        }

        .bottom-info {
            font-size: 20px;
            gap: var(--gp-8);
        }

        .label-comment {
            font-size: 24px;
        }

        .comments-block {
            gap: var(--gp-20);
        }
    }

    @media (max-width:375px) {
        .label-theme {
            font-size: 24px;
            line-height: 32px;
        }

        .bottom-info {
            font-size: 18px;
        }
    }
</style>