<script setup>
    import { ref } from 'vue'

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

                <div class="news-card">
                    <div class="img-block-card">
                        <picture>
                            <img src="/images/7.jpg">
                        </picture>
                        <span class="category-slider">Update</span>
                        <div class="interaction-block align-c" data-grid-block>
                            <button type="button" aria-label="Оценить новость" class="no-border flex-center"><svg><use href="#icon-like"></use></svg>1632</button>
                            <button type="button" aria-label="Перейти к комментариям" class="no-border flex-center"><svg><use href="#icon-comment"></use></svg>163</button>
                        </div>
                    </div>
                    <div class="info-block">
                        <span class="label-news">CDPR выпустила обновление для CyberPunk2077</span>
                        <div class="bottom-info flex">
                            <span>Вчера в 21:41 |</span>
                            <span>Анонсы</span>
                        </div>
                        <div class="interaction-block align-c" data-list-block>
                            <button type="button" aria-label="Оценить новость" class="no-border flex-center"><svg><use href="#icon-like"></use></svg>1632</button>
                            <button type="button" aria-label="Перейти к комментариям" class="no-border flex-center"><svg><use href="#icon-comment"></use></svg>1632</button>
                        </div>
                    </div>
                </div>

                <div class="news-card">
                    <div class="img-block-card">
                        <picture>
                            <img src="/images/8.jpg">
                        </picture>
                        <span class="category-slider">Update</span>
                        <div class="interaction-block align-c" data-grid-block>
                            <button type="button" aria-label="Оценить новость" class="no-border flex-center"><svg><use href="#icon-like"></use></svg>1632</button>
                            <button type="button" aria-label="Перейти к комментариям" class="no-border flex-center"><svg><use href="#icon-comment"></use></svg>163</button>
                        </div>
                    </div>
                    <div class="info-block">
                        <span class="label-news">CDPR выпустиdfsdfа обновление дdfgjhdfgjhd CyberPunk2077</span>
                        <div class="bottom-info flex">
                            <span>Вчера в 21:41 |</span>
                            <span>Анонсы</span>
                        </div>
                        <div class="interaction-block align-c" data-list-block>
                            <button type="button" aria-label="Оценить новость" class="no-border flex-center"><svg><use href="#icon-like"></use></svg>1632</button>
                            <button type="button" aria-label="Перейти к комментариям" class="no-border flex-center"><svg><use href="#icon-comment"></use></svg>1632</button>
                        </div>
                    </div>
                </div>

                <div class="news-card">
                    <div class="img-block-card">
                        <picture>
                            <img src="/images/23.jpg">
                        </picture>
                        <span class="category-slider">Update</span>
                        <div class="interaction-block align-c" data-grid-block>
                            <button type="button" aria-label="Оценить новость" class="no-border flex-center"><svg><use href="#icon-like"></use></svg>1632</button>
                            <button type="button" aria-label="Перейти к комментариям" class="no-border flex-center"><svg><use href="#icon-comment"></use></svg>163</button>
                        </div>
                    </div>
                    <div class="info-block">
                        <span class="label-news">CDPR CyberPunk2077</span>
                        <div class="bottom-info flex">
                            <span>Вчера в 21:41 |</span>
                            <span>Анонсы</span>
                        </div>
                        <div class="interaction-block align-c" data-list-block>
                            <button type="button" aria-label="Оценить новость" class="no-border flex-center"><svg><use href="#icon-like"></use></svg>1632</button>
                            <button type="button" aria-label="Перейти к комментариям" class="no-border flex-center"><svg><use href="#icon-comment"></use></svg>1632</button>
                        </div>
                    </div>
                </div>


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

    .news-card {
        width: 100%;
        font-family: Roboto_Medium;
        border-radius: 8px;
        min-width: 0;
    }

    .news-card img {
        border-radius: 8px;
        cursor: pointer;
    }

    .img-block-card {
        position: relative;

    }

    .label-news {
        overflow: hidden;
        text-overflow: ellipsis 
    }

    .grid-format {
        display: grid;
        grid-template-columns: repeat(3, 1fr);
    }

    .grid-format .news-card {
        max-width: 290px;
        width: 100%;
        display: flex;
        flex-direction: column;
        gap: var(--gp-10);
    }

    .grid-format .img-block-card {
        position: relative;
    }

    .grid-format .news-card img {
        width: 290px;
        height: auto;
    }

    .grid-format .info-block {
        display: flex;
        flex-direction: column;
        gap: var(--gp-10);
    }

    .grid-format .label-news {
        font-size: 16px;
        line-height: 24px;
    }

    .grid-format .bottom-info {
        font-size: 14px;
    }

    .grid-format .interaction-block[data-grid-block] {
        position: absolute;
        bottom: 0px;
        right: 0px;
        display: none;
        z-index: 10;
        background-color: #282828;
        padding: 6px;
        padding-left: 28px;
        font-size: 12px;
        overflow: hidden;
        clip-path: polygon(25% 0, 100% 0, 100% 100%, 0 100%);
    }

    .grid-format .interaction-block[data-grid-block] button svg {
        width: 16px;
        height: 16px;
    }

    .grid-format .interaction-block[data-grid-block] button{
        gap: var(--gp-4);
    }

    .grid-format .img-block-card:hover .interaction-block[data-grid-block] {
        display: flex;
    }

    .list-format {
        display: flex;
        flex-direction: column;
    }

    .list-format .news-card {
        width: 100%;
        display: flex;
        gap: var(--gp-24);
        border-bottom: 2px solid var(--bg-secondary-50);
        padding-bottom: 16px;
        border-radius: 0px;
    }
    
    .list-format .news-card img {
        max-width: 283px;
        min-height: 159px;
    }

    .list-format .info-block {
        display: flex;
        flex-direction: column;
        width: fit-content;
        gap: var(--gp-16);
    }

    .list-format .label-news {
        font-size: 24px;
        line-height: 32px;
    }

    .list-format .bottom-info {
        font-size: 20px;
    }

    .list-format .interaction-block[data-grid-block], 
    .grid-format .interaction-block[data-list-block] {
        display: none;
    }

    .list-format .interaction-block[data-list-block] {
        display: flex;
        gap: var(--gp-24);
        margin-top: 4px;
    }

    .list-format .interaction-block[data-list-block] button svg {
        width: 24px;
        height: 24px;
    }

    .interaction-block button {
        gap: var(--gp-8);
        color: var(--font-primary-25);
    }

    .bottom-info {
        color: var(--font-primary-50);
        gap: var(--gp-8);
    }

    .category-slider {
        position: absolute;
        top: 8px;
        left: 8px;
        font-size: 10px;
        font-family: Montserrat_SemiBold;
        text-transform: uppercase;
        padding: 6px;
        background-color: rgba(0, 0, 0, 0.5);
        border-radius: 4px;
        backdrop-filter: blur(4px);
    }

    .interaction-block[data-list-block] button {
        padding: 0;
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
        .grid-format .news-card img {
            width: 306px;
        }
    }

    @media (max-width:900px) {
        .category-slider {
            font-size: 8px;
        }
        .list-format .news-card img {
            max-width: 238px;
            min-height: 134px;
        }
        .list-format .label-news {
            font-size: 20px;
            line-height: 28px;
        }
        .list-format .bottom-info {
            font-size: 16px;
        }
        .list-format .info-block {
            gap: var(--gp-8);
        }
        .list-format .news-card {
            gap: var(--gp-16);
        }

    }

    @media (max-width:767px) {
        .grid-format .news-card img {
            min-height: 122px;
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
        .category-slider {
            top: 4px;
            left: 4px;
        }
        .list-format .label-news {
            font-size: 16px;
            line-height: 20px;
        }
        .list-format .bottom-info {
            font-size: 14px;
        }
        .list-format .interaction-block[data-list-block] button svg {
            width: 16px;
            height: 16px;
        }
        .list-format .interaction-block[data-list-block] button {
            gap: var(--gp-4);
        }
        .list-format .interaction-block[data-list-block] {
            gap: var(--gp-20);
            font-size: 12px;
        }
        .list-format .news-card img {
            max-width: 160px;
            min-height: 100px;
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
        .grid-format .news-card img {
            min-height: 106px;
        }
        .category-slider {
            padding: 4px 6px;
        }
        .sort-list button {
            width: 32px;
            height: 32px;
        }
        .sort-type.active::after {
            padding-bottom:9px;
        }
        .grid-format .info-block,
        .list-format .news-card  {
            gap: var(--gp-8);
        }
        .grid-format .label-news {
            font-size: 16px;
            line-height: 20px;
        }
        .grid-format .bottom-info {
            font-size: 14px;
        }
        .category {
            font-size: 16px;
        }
        .list-format .bottom-info {
            font-size: 12px;
        }
    }

    @media (max-width:375px) {
        .grid-format .label-news, .list-format .label-news {
            font-size: 14px;
            line-height: 18px;
        }
        .grid-format .bottom-info {
            font-size: 12px;
            gap: var(--gp-4);
        }
        .list-format .bottom-info {
            gap: var(--gp-4);
            flex-direction: column;
        }
        .sort-row {
            gap: var(--gp-16);
        }
        .sort-type {
            font-size: 18px;
        }
        .list-format .news-card img {
            max-width: 130px;
        }
    }

    @media (max-width:320px) {
        .grid-format .news-card img {
            min-height: 87px;
        }
    }

</style>