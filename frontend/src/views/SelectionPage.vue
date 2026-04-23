<script setup>
    import Comment from '../components/Comment.vue'
    import CommentForm from '../components/CommentForm.vue'
    import AuthorBlock from '../components/AuthorBlock.vue'
    import ThemeLabel from '../components/ThemeLabel.vue'
</script>

<template>
    <div class="container">
        <div class="selection-container flex-column">
            
            <ThemeLabel 
                label="Топ 20 игр с хорошим сюжетом за 2025 год"
                :btm-info="{date: 'Сегодня в 20:39 | ', theme: 'Подборка игр'}"
            />

            <AuthorBlock
                :author="{name: 'Андрей Абашев', avatar: '/images/12.jpg'}"
                :views="2033" 
                :comments="991"  
            />

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
                    <!-- <Comment class="comment" />
                    <CommentForm /> -->
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

        .label-comment {
            font-size: 24px;
        }

        .comments-block {
            gap: var(--gp-20);
        }

    }

</style>