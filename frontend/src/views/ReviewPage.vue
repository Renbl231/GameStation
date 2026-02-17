<script setup>
    import AuthorBlock from '../components/AuthorBlock.vue'
    import RatingBar from '../components/RatingBar.vue'

    const rating = 7  // 0-10
const fillWidth = (rating / 10) * 100  // 70%
const thumbPosition = (rating / 10) * 100  // 70%
</script>

<template>
    <div class="container flex">
        <div class="left-side flex-column">
            <picture>
                <img src="/images/2.jpeg" class="img-game">
            </picture>
            <span class="name-game">Zenless Zone Zero</span>
        </div>
        <div class="right-side flex-column">
            <div class="top-info flex justify-sb">
                <span class="review-label">Первые впечатления в ZZZ</span>
                <span class="rating flex-center">9.5</span>
            </div>
            <span class="datePublish">Сегодня в 20:39</span>
            <AuthorBlock
                :author="{name: 'Андрей Абашев', avatar: '/images/12.jpg'}"
                :views="2033"
                :comments="309" />
            <div class="content-block flex-column">
                <p>Это игра почти как сон, Бои приносят удовольствия, а открытй мир поражает своей проработкой, но эффективная особенность это сама графика, это просто имба, проработка сайд квестов и  самого сюжета на уровне, я ожидал намного меньшего от этой игры, на релизе  Это игра почти как сон, Бои приносят удовольствия, а открытй мир поражает своей проработкой, но эффективная особенность это сама графика, это просто имба, проработка сайд квестов и  самого сюжета на уровне, я ожидал намного меньшего от этой игры, на релизе Это игра почти как сон, Бои приносят удовольствия, а открытй мир поражает своей проработкой, но эффективная особенность это сама графика, это просто имба, проработка сайд квестов и  самого сюжета на уровне, я ожидал намного меньшего от этой игры, на релизе Это игра почти как сон, Бои приносят удовольствия, а открытй мир поражает своей проработкой, но эффективная особенность это сама графика, это просто имба, проработка сайд квестов и  самого сюжета на уровне, я ожидал намного меньшего от этой игры, на релизе </p>
                <p>Это игра почти как сон, Бои приносят удовольствия, а открытй мир поражает своей проработкой, но эффективная особенность это сама графика, это просто имба, проработка сайд квестов и  самого сюжета на уровне, я ожидал намного </p>
            </div>
            
            <div class="rating-wrapper">

                <RatingBar />
                <RatingBar />
                <RatingBar />
                <RatingBar />
                <RatingBar />

            </div>

        </div>
    </div>

</template>


<style scoped>
    .container {
        width: 100%;
        padding: 32px;
        border-radius: 8px;
        background-color: var(--bg-secondary-25);
        gap: var(--gp-32);
    }

    .top-info {
        align-items: flex-start;
        gap: var(--gp-4);
    }

    .left-side {
        max-width: 300px;
        width: 100%;
        gap: var(--gp-8);
    }

    .img-game {
        width: 300px;
        height: 400px;
        border-radius: 8px;
    }

    .name-game {
        font-size: 32px;
        font-family: Roboto_SemiBold;
        color: var(--another-color);
        text-align: center;
    }

    .right-side {
        width: 100%;
        gap: var(--gp-16);
        font-family: Roboto_Regular;
    }

    .review-label {
        font-size: 36px;
        font-family: Roboto_SemiBold;
    }

    .rating {
        min-width: 48px;
        height: 48px;
        font-size: 20px;
        font-family: Roboto_Bold;
        background: #000;
        border: 4px solid var(--font-secondary);
        border-radius: 50%;
        box-shadow: 0 4px 16px 0 rgba(0, 111, 255, 0.5);
        text-align: center;
    }

    .datePublish {
        font-size: 24px;
        color: var(--font-primary-50);
        font-family: Roboto_Medium;
    }

    .content-block {
        gap: var(--gp-16);
        font-size: 18px;
        line-height: 28px;
        border-bottom: 2px solid var(--bg-secondary-50);
        padding-bottom: 32px;
    }

    .rating-wrapper {
        display: grid;
        grid-template-columns: repeat(3, 1fr);
        column-gap: var(--gp-16);
        row-gap: var(--gp-24);
    }

    @media (max-width:1160px) {
        .container {
            border-radius: 0px;
        }
    }

    @media (max-width:900px) {
        .review-label {
            font-size: 32px;
        }
        .content-block {
            font-size: 16px;
            line-height: 22px;
        }
    }

</style>