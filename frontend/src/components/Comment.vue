<script setup>

</script>

<template>
    <div class="comment flex">
        <div class="author-img flex">
            <img src="/images/12.jpg">
        </div>
        <div class="comment-content flex-column">
            <div class="top-content flex-column">
                <span class="author-name">Cl0WN</span>
                <span class="date-publish">3 января 2026</span>
            </div>
            <div class="middle-content">
                <p>Я прошёл полностью, игра на разок и не более</p>
            </div>
            <button type="button" class="no-border respond-btn">Ответить</button>
        </div>
    </div>
</template>

<style scoped>
    .comment {
        width: 100%;
        gap: var(--gp-16);
        background-color: var(--bg-secondary-25);
        border-radius: 8px;
        padding: 16px;
    }

    .author-img {
        max-width: 48px;
        width: 100%;
    }

    .author-img img {
        width: 48px;
        height: 48px;
        border-radius: 50%;
    }
    
    .comment-content {
        font-family: Roboto_Medium;
        gap: var(--gp-16);
    }

    .author-name {
        font-size: 18px;
        color: var(--font-primary-75);
    }

    .date-publish {
        font-size: 16px;
        color: var(--font-primary-50);
    }

    .middle-content p {
        font-size: 18px;
    }

    .respond-btn {
        width: fit-content;
        padding: 8px 16px;
        background-color: var(--font-primary-50);
        border-radius: 4px;
    }

    @media (max-width:599px) {
        .comment, .comment-content {
            gap: var(--gp-12);
        }

        .author-img {
            max-width: 36px;
        }

        .author-img img {
            width: 36px;
            height: 36px;
        }

        .author-name, .respond-btn {
            font-size: 14px;
        }

        .date-publish {
            font-size: 12px;
        }

        .middle-content p {
            font-size: 16px;
        }


    }
</style>