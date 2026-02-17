<script setup>

</script>

<template>
    <div class="review flex-column">
        <div class="review-block flex">
            <img src="/images/new.png" class="img-game">
            <div class="review-content flex-column">
                <div class="top-content flex align-c justify-sb">
                    <span class="name-game">Название игры</span>
                    <span class="rating flex-center">10</span>
                </div>
                <p class="description">Это игра почти как сон, Бои приносят удовольствия, а открытй мир поражает своей проработкой, но эффективная особенность это сама графика, это просто имба, проработка сайд квестов и  самого сюжета на уровне, я ожидал намного меньшего от этой игры, на релизе игра была плохая и забагованная, но сейчас разработчики исправились и доработали (даже перереаботали игру)</p>
            </div>
        </div>
        <div class="bottom-content flex-column">
            <div class="author-block flex justify-sb align-c"> 
                <div class="author-info flex align-c">
                    <img src="/images/12.jpg" class="author-img">
                    <span class="author-name">Cl0WN</span>
                </div>
                <div class="date-block flex-center">
                    <span class="date-publish">21 декабря 2025</span>
                </div>
                <div class="counters flex align-c">
                    <button type="button" aria-label="Оценить рецензию" class="no-border flex-center"><svg class="icon icon-like"><use href="#icon-like"></use></svg>183</button>
                    <button type="button" aria-label="Перейти к комментариям" class="no-border flex-center"><svg class="icon icon-comment"><use href="#icon-comment"></use></svg>32</button>
                </div>
            </div>
            <div class="parameters-wrapper flex align-c">
                <div class="parameter">
                    <span>Геймплей: 10</span>
                </div>
                <div class="parameter">
                    <span>Графика: 9</span>
                </div>
                <div class="parameter">
                    <span>Сюжет: 5</span>
                </div>
                <div class="parameter">
                    <span>Сюжет: 5</span>
                </div>
            </div>
        </div>
    </div>
</template>

<style scoped>
    .review {
        width: 100%;
        padding: 20px;
        background-color: var(--btn-color-7);
        border-radius: 8px;
        gap: var(--gp-16);
    }

    .review-block {
        width: 100%;
        gap: var(--gp-16);
        border-bottom: 1px solid #324148;
        padding-bottom: 16px;
    }

    .img-game {
        width: 150px;
        height: 200px;
        border-radius: 8px;
    }

    .review-content {
        gap: var(--gp-16);
    }

    .bottom-content {
        gap: var(--gp-24);
    }

    .name-game {
        font-size: 24px;
        font-family: Roboto_SemiBold;
        color: var(--another-color);
    }

    .rating {
        width: 40px;
        height: 40px;
        font-size: 16px;
        font-family: Roboto_Bold;
        background: #000;
        border: 4px solid var(--font-secondary);
        border-radius: 50%;
        box-shadow: 0 4px 16px 0 rgba(0, 111, 255, 0.5);
    }

    .description {
        font-size: 16px;
        line-height: 24px;
        font-family: Roboto_Regular;
    }

    /* Автор блок */

    .author-block {
        font-family: Roboto_Medium;
        flex-wrap: wrap;
        column-gap: var(--gp-4);
        row-gap: var(--gp-10);
    }

    .author-info {
        gap: var(--gp-10);
    }

    .author-img {
        width: 36px;
        height: 36px;
        border-radius: 50%;
    }

    .author-name, .date-publish {
        font-size: 14px;
        color: var(--font-primary-75);
    }

    .counters {
        gap: var(--gp-16);
        font-size: 12px;
    }

    .counters button {
        gap: var(--gp-8);
        color: var(--font-primary-25);
        padding: 0;
    }

    .icon {
        width: 20px;
        height: 20px;
    }

    .icon-like {
        width: 20px;
        height: 20px;
    }

    /* Блок параметров */

    .parameters-wrapper {
        flex-wrap: wrap;
        gap: var(--gp-16);
        font-size: 14px;
        font-family: Roboto_Medium;
    }

    .parameter {
        background-color: #20343D;
        color: #FF5050;
        padding: 8px 12px;
        border-radius: 8px;
    }

    @media (max-width:1160px) {
        .name-game {
            font-size: 20px;
        }
        .description {
            font-size: 14px;
            line-height: 18px;
        }
    }

    @media (max-width:899px) {
        .img-game {
            width: 120px;
            height: 160px;
        }
    }   

    @media (max-width:600px) {
        .review, .review-block, .parameters-wrapper {
            gap: var(--gp-10);
        }
        .review {
            padding: 10px;
        }
        .img-game {
            width: 100px;
            height: 133px;
        }
        .rating {
            font-size: 14px;
            border-width: 3px;
        }
        .bottom-content {
            gap: var(--gp-16);
        }

        .author-name, .date-publish {
            font-size: 12px;
        }

        .parameter {
            font-size: 12px;
            padding: 4px 8px;
        }
    }

     @media (max-width:425px) {
        .review-block {
            flex-direction: column;
            align-items: center;
        }
        .top-content {
            justify-content: center;
            gap: var(--gp-8);
        }
        .counters button {
            gap: var(--gp-4);
        }
    }

    @media (max-width:375px) {
        .description {
            font-size: 12px;
            line-height: 16px;
        }
    }
</style>