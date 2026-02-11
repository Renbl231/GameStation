<script setup>
    import ReviewCard from '../components/ReviewCard.vue';
</script>

<template>
    <div class="reviews-container flex-column">
        <span class="headline">Рецензии</span>
        <div class="reviews-wrapper">

            <ReviewCard />
            <ReviewCard />
            <ReviewCard />
            <ReviewCard />

        </div>
    </div>
</template>

<style scoped>

    .reviews-container {
        width: 100%;
        gap: var(--gp-32);
        background-color: var(--bg-secondary-25);
        border-radius: 8px;
        padding: 32px;
    }

    .headline {
        font-size: 32px;
        font-family: Roboto_SemiBold;
    }

    .reviews-wrapper {
        display: grid;
        grid-template-columns: repeat(2, 1fr);
        row-gap: var(--gp-32);
        column-gap: var(--gp-24);
    }


    @media (max-width:1160px) {
        .reviews-container {
            border-radius: 0px;
        }
    }

    @media (max-width:899px) {
        .reviews-wrapper {
            grid-template-columns: repeat(1, 1fr);
        }
    }   

    @media (max-width:600px) {
        .reviews-container {
            padding: 24px 16px;
            gap: var(--gp-24);
        }
    }


</style>