<script setup>
    import { ref } from 'vue'
    import NewsCard from '../components/NewsCard.vue'

    const currentFormat = ref('grid');

    const setFormat = (format) => {
        currentFormat.value = format
    }

</script>

<template>
    <div class="wrapper-container flex">

        <div class="news-container flex-column">
            <div class="news-bar flex-column">
                <h1>Игровые новости</h1>
                <div class="news-categories flex">
                    <span class="category active">Все</span>
                    <span class="category">VR</span>
                    <span class="category">Анонсы</span>
                    <span class="category">Индустрия</span>
                    <span class="category">Консоли</span>
                    <span class="category">ПК</span>
                    <span class="category">Релизы</span>
                    <span class="category">Слухи</span>
                </div>
            </div>
            <div class="news-sortSelector flex align-c justify-sb">
                <div class="sort-row flex">
                    <span class="sort-type active">Новые</span>
                    <span class="sort-type">Популярные</span>
                </div>
                <div class="sort-list flex align-c">
                    <button :class="{'active': currentFormat === 'grid'}" @click="setFormat('grid')" type="button" class="no-border grid-btn flex-center"><svg><use href="#grid-block"></use></svg></button>
                    <button :class="{'active': currentFormat === 'list'}" @click="setFormat('list')" type="button" class="no-border list-btn flex-center"><svg><use href="#list-block"></use></svg></button>
                </div>
            </div>
            <div class="news-wrapper" :class="currentFormat === 'grid' ? 'grid-format' : 'list-format'">

                <NewsCard />
                <NewsCard />

            </div>
        </div>

        <div class="advertisement-container flex-center">
            <picture>
                <img src="/images/6.jpg">
            </picture>
        </div>

        
    </div>
</template>

<style scoped>
    .wrapper-container {
        width: 100%;
        padding: 32px;
        border-radius: 8px;
        background-color: var(--bg-secondary-25);
        gap: var(--gp-36);
    }

    .news-wrapper {
        max-width: 910px;
        width: 100%;
    }

    .news-bar {
        gap: var(--gp-24);
        margin-bottom: 32px;
    }

    h1 {
        font-size: 32px;
        font-family: Roboto_SemiBold;
    }

    .news-categories {
        gap: var(--gp-16);
        flex-wrap: wrap;
    }

    .category {
        font-size: 20px;
        font-family: Roboto_Medium;
        color: var(--font-primary-35);
        background-color: var(--btn-color-6-25);
        border-radius: 4px;
        padding: 6px 12px;
    }

    .news-sortSelector {
        border-bottom: 2px solid var(--bg-secondary-50);
        padding-bottom: 8px;
        margin-bottom: 32px;
    }

    .sort-row {
        gap: var(--gp-32);
    }

   .sort-type {
        position: relative;
        font-size: 24px;
        font-family: Roboto_SemiBold;
        color: var(--font-primary-50);
   }

   .sort-type.active {
        color: var(--font-primary);
   }

   .sort-type.active::after {
        content: '';
        position: absolute;
        top: 100%;
        left: 0;
        right: 0;
        border-bottom: 2px solid var(--font-secondary);
        padding-bottom: 8px;
   }

    .sort-list {
        gap: var(--gp-12)
    }

    .sort-list button {
        width: 36px;
        height: 36px;
        background-color: var(--btn-color-6-25);
        border-radius: 4px;
    }

    .sort-list button.active {
        background-color: var(--font-secondary);
    }

    .sort-list button.active svg { 
        stroke-opacity: 1;
    }

    .category.active {
        color: var(--font-primary);
        background-color: var(--font-primary-35);
    }

    .grid-btn svg, .list-btn svg {
        width: 20px;
        height: 20px;
        stroke-opacity: 0.25;
    }

    .news-wrapper {
        width: 100%;
        gap: var(--gp-24);
    }

    .grid-format {
        display: grid;
        grid-template-columns: repeat(3, 1fr);
    }

    .list-format {
        display: flex;
        flex-direction: column;
    }

    .advertisement-container {
        width: 300px;
        min-width: 284px;
    }
    

    @media (max-width:1160px) {
        .sort-type {
            font-size: 20px;
        }
        .news-sortSelector {
            margin-bottom: 20px;
        }

        .wrapper-container {
            border-radius: 0px;
        }
        .sort-type.active::after {
            padding-bottom: 11px;
        }
    }

    @media (max-width:1024px) {
        .wrapper-container {
            flex-direction: column;
            gap: var(--gp-48);
        }
        .advertisement-container {
            margin: 0 auto;
        }
        .news-container {
            max-width: none;
        }
    }

    @media (max-width:600px) {
        .grid-format  {
            grid-template-columns: repeat(2, 1fr);
        }
        .wrapper-container {
            padding: 24px 16px;
        }
        h1 {
            font-size: 24px;
        }
        .category {
            font-size: 18px;
        }
        .news-categories {
            row-gap: var(--gp-16);
            column-gap: var(--gp-12);
        }
        .news-bar {
            margin-bottom: 24px;
        }
        .sort-row {
            gap: var(--gp-24);
        }
        .news-wrapper.list-format {
            gap: var(--gp-20);
        }
    }

    @media (max-width:425px) {
        .news-wrapper {
            row-gap: var(--gp-20);
            column-gap: var(--gp-16);
        }
        .sort-list button {
            width: 32px;
            height: 32px;
        }
        .sort-type.active::after {
            padding-bottom:9px;
        }
        .category {
            font-size: 16px;
        }
    }

    @media (max-width:375px) {
        .sort-row {
            gap: var(--gp-16);
        }
        .sort-type {
            font-size: 18px;
        }
    }

</style>