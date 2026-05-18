<script setup>
    import { useFormatDate } from '../composables/useFormatDate';
    import { onImageError } from '../helpers/onImageError'

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
        <div class="top-side">
            <RouterLink :to="`/newsdata/${id}`" class="cover-block">
                <picture>
                    <img @error="onImageError" :src="image" class="cover-block__img">
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
    }

    .top-side {
        width: 100%;
        display: block;
        height: auto;
        position: relative;
        overflow: hidden;
        border-radius: 8px;
    }

    .cover-block {
        width: 100%;
        height: 100%;
    }

    .cover-block__img {
        width: 100%;
        height: 100%;
        border-radius: 8px;
        cursor: pointer;
        transition: transform 0.3s ease;
        transition: 0.4s;
        will-change: transform;
        object-position: center;
    }
    .cover-block__img:hover {transform: scale(1.05);}

    .label-news {
        overflow: hidden;
        text-overflow: ellipsis 
    }

    .label-news:hover {
        text-decoration: underline;
    }

    .grid-format .news-card {
        display: flex;
        flex-direction: column;
        gap: var(--gp-10);
        overflow: hidden;
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
        display: flex;
        bottom: 0px;
        right: 0px;
        visibility: hidden;
        z-index: 10;
        transition: 0.3s;
        opacity: 0;
        background-color: #282828;
        padding: 6px;
        padding-left: 28px;
        font-size: 12px;
        gap: var(--gp-16);
        overflow: hidden;
        transform: translateX(20px);
        clip-path: polygon(25% 0, 100% 0, 100% 100%, 0 100%);
    }

    .grid-format .top-side {
        aspect-ratio: 290 / 163;
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

    .grid-format .top-side:hover .interaction-block[data-grid-block] {
        opacity: 1;
        visibility: visible;
        transform: translateX(0px);
    }

    .list-format {
        display: flex;
        flex-direction: column;
    }

    .list-format .news-card {
        display: flex;
        gap: var(--gp-24);
        border-bottom: 2px solid var(--bg-secondary-50);
        padding-bottom: 16px;
    }

    .list-format .info-block {
        width: 100%;
        display: flex;
        flex-direction: column;
        gap: var(--gp-16);
    }

    .list-format .top-side {
        max-width: 260px;
        max-height: 146px;
        aspect-ratio: 260 / 146;
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

    @media (max-width:900px) {
        .list-format .label-news {
            font-size: 20px;
            line-height: 28px;
        }
        .list-format .bottom-info {
            font-size: 16px;
        }
        .list-format .news-card {
            gap: var(--gp-16);
        }
    }

    @media (max-width:600px) {
        .list-format .top-side {
            max-width: 130px;
            min-height: 130px;
            min-width: 130px;
            max-height:130px
        }

        .list-format .category-slider {
            top: 4px;
            left: 4px;
            font-size: 8px;
        }
        .grid-format .category-slider {
            font-size: 8px;
        }

        .list-format .label-news {
            font-size: 18px;
            line-height: 24px;
        }
        
        .list-format .info-block {
            gap: var(--gp-8);
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
    }

    @media (max-width:500px) {
        .list-format .label-news {
            font-size: 16px;
            line-height: 24px;
        }

        .list-format .bottom-info {
            font-size: 14px;
        }

        .grid-format .label-news {
            font-size: 14px;
            line-height: 18px;
        }

    }

    @media (max-width:425px) {
        .grid-format .info-block,
        .list-format .news-card  {
            gap: var(--gp-8);
        }
        .grid-format .bottom-info {
            font-size: 14px;
        }

        .grid-format .top-side {
            max-height: 160px;
        }

        .grid-format .category-slider {
            font-size: 10px;
        }

        .grid-format .label-news {
            font-size: 16px;
            line-height: 1.2;
        }

        .grid-format .bottom-info {
            font-size: 14px;
            gap: var(--gp-4);
        }
    } 

    @media (max-width:375px) {
        .list-format .bottom-info {
            font-size: 12px;
        }
        .list-format .bottom-info {
            gap: var(--gp-4);
        }
    }



</style>