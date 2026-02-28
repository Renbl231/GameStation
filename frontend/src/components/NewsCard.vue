<script setup>
    import { useFormatDate } from '../composables/useFormatDate';

    const { formatDate } = useFormatDate()

    const props = defineProps({
        id: Number,           
        title: String,        
        category: String,  
        image: String,
        likes: Number,
        comments: Number,
        created_at: [String, Date]
    })
</script>

<template>
    <div class="news-card">
        <div class="img-block-card">
            <RouterLink :to="`/newsdata/${id}`">
                <picture>
                    <img :src="image">
                </picture>
            </RouterLink>
            <span class="category-slider">{{ category}}</span>
            <div class="interaction-block align-c" data-grid-block>
                <span class="flex-center"><svg><use href="#icon-like"></use></svg>{{ likes}}</span>
                <RouterLink :to="`/newsdata/${id}?tab=comments`"
                    class="flex-center"
                    aria-label="Перейти к комментариям">
                      <svg><use href="#icon-comment"></use></svg>
                      {{ comments }}
                </RouterLink>
            </div>
        </div>
        <div class="info-block">
            <RouterLink :to="`/newsdata/${id}`" class="label-news">{{ title}}</RouterLink>
            <div class="bottom-info flex">
                <span>{{ formatDate(created_at) }} |</span>
                <span>{{ category}}</span>
            </div>
            <div class="interaction-block align-c" data-list-block>
                <span class="flex-center"><svg><use href="#icon-like"></use></svg>{{ likes}}</span>
                <RouterLink :to="`/newsdata/${id}?tab=comments`"
                    class="flex-center"
                    aria-label="Перейти к комментариям">
                      <svg><use href="#icon-comment"></use></svg>
                      {{ comments }}
                </RouterLink>
            </div>
        </div>
    </div>
</template>

<style scoped> 
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

    .grid-format .news-card {
        max-width: 290px;
        width: 100%;
        display: flex;
        flex-direction: column;
        gap: var(--gp-10);
    }

    .grid-format .news-card img {
        width: 290px;
        max-height: 191px;
        height: auto;
    }

    .grid-format .img-block-card {
        position: relative;
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
        gap: var(--gp-16);
        overflow: hidden;
        clip-path: polygon(25% 0, 100% 0, 100% 100%, 0 100%);
    }

    .grid-format .interaction-block[data-grid-block] span svg,
    .grid-format .interaction-block[data-grid-block] a svg {
        width: 16px;
        height: 16px;
    }

    .grid-format .interaction-block[data-grid-block] span,
    .grid-format .interaction-block[data-grid-block] a{
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
        width: 283px;
        max-height: 159px;
        height: auto;
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

    .list-format .interaction-block[data-list-block] span svg,
    .list-format .interaction-block[data-list-block] a svg {
        width: 24px;
        height: 24px;
    }

    .interaction-block span,
    .interaction-block a {
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

    .interaction-block[data-list-block] span,
    .interaction-block[data-list-block] a {
        padding: 0;
    }

    @media (max-width:1024px) {
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
        .list-format .interaction-block[data-list-block] span svg,
        .list-format .interaction-block[data-list-block] a svg {
            width: 16px;
            height: 16px;
        }
        .list-format .interaction-block[data-list-block] span,
        .list-format .interaction-block[data-list-block] a {
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
    }

    @media (max-width:425px) {
        .grid-format .news-card img {
            min-height: 106px;
        }
        .category-slider {
            padding: 4px 6px;
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