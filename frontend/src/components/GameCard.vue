<script setup>
    import { storeToRefs } from 'pinia'
    import { useAuthStore } from '../stores/authStore'

    const authStore = useAuthStore()
    const { isAuthenticated, user } = storeToRefs(authStore)

    const props = defineProps({
        id: Number,
        name: String,
        ratingOverall: Number,
        counterRating: Number,
        releaseDate: String,
        cover: String,
        platforms: Array,
        tags: Array,
        format: {
            type: String,
            default: 'grid',
            validator: v => ['grid', 'list'].includes(v)
        }
    })

    const formatDate = (iso) => {
        const date = new Date(iso)

        const day = String(date.getUTCDate()).padStart(2, '0')
        const month = String(date.getUTCMonth() + 1).padStart(2, '0')
        const year = date.getUTCFullYear()

        const formatted = `${day}.${month}.${year}`

        return formatted
    }

    const emit = defineEmits(['open-popup'])
    const openPopup = () => {
        emit('open-popup', {
            id: props.id,
            name: props.name,
            cover: props.cover,
            moduleType: 'View'
        })
    }
    const openEstimatePopup = () => {
        emit('open-popup', {
            id: props.id,
            name: props.name,
            cover: props.cover,
            moduleType: 'Estimate'
        })
    }


</script>


<template>

    <div class="game-card" :class="format">
        <div class="card-topSide card-leftSide">
            <RouterLink :to="`/game/${props.id}`">
                <picture>
                    <img :src="cover" class="game-card__img">
                </picture>
            </RouterLink>
            <div v-if="format === 'grid'" class="rating-block flex align-c">
                <span class="rating-block__rating flex-center">{{ ratingOverall }}</span>
                <span class="rating-block__counter flex-center">{{ counterRating }} оценок</span>
            </div>
            <button @click="openPopup" v-if="format === 'grid' && isAuthenticated" type="button" class="no-border flex-center game-card__btnShowForm">
                <svg class="icon"><use href="#icon-plus"></use></svg>
            </button>
        </div>
        <div v-if="format === 'grid'" class="card-bottomSide flex-column">
            <RouterLink :to="`/game/${props.id}`">
                <span class="game-card__name">{{ name }}</span>
            </RouterLink>
            <span class="game-card__releaseDate">{{ formatDate(releaseDate) }}</span>
            <button v-if="isAuthenticated" @click="openEstimatePopup" type="button" class="no-border game-card__rateBtn">Поставить оценку</button>
        </div>

        <div v-if="format === 'list'" class="card-rightSide flex-column">
            <div class="card-rightSide-header flex align-c justify-sb">
                <span class="game-card__name">{{ name }}</span>
                <div class="rightSide-header-right flex align-c">
                    <button v-if="isAuthenticated" @click="openPopup" type="button" class="no-border flex-center game-card__btnShowForm">
                        <svg class="icon"><use href="#icon-plus"></use></svg>
                    </button>
                    <span class="game-card__status">Пройдено</span>
                </div>
            </div>
            <div class="card-rightSide-info flex-column">
                <dl class="game-info">
                    <dt>Рейтинг</dt>
                    <dd>
                        <div class="info-rating-block flex align-c">
                            <span class="info__rating">{{ ratingOverall }}/10</span>
                            <span class="rating-block__counter flex-center">{{ counterRating }} оценок</span>
                        </div>
                    </dd>

                    <dt>Платформы</dt>
                    <dd>
                        <span v-for="(platform, index) in platforms" :key="platform + index">
                            {{ platform }}
                            <span v-if="index < platforms.length - 1">, </span>
                        </span>
                    </dd>

                    <dt>Теги</dt>
                    <dd>
                        <span v-for="(tag, index) in tags" :key="tag + index">
                            {{ tag }}<span v-if="index < tags.length - 1">, </span>
                        </span>
                    </dd>

                    <dt>Дата релиза</dt>
                    <dd>
                        <span>{{ formatDate(releaseDate) }}</span>
                    </dd>
                </dl>
                <button v-if="isAuthenticated" @click="openEstimatePopup" type="button" class="no-border game-card__rateBtn">Поставить оценку</button>
            </div>
        </div>
    </div>
    <div v-if="format === 'list'" style="width: 100%;">
        <hr>
    </div>


</template>

<style scoped>

    .game-card {
        width: 100%;
    }

    .game-card.list {
        gap: var(--gp-32);
        padding-bottom: 16px;
    }

    .game-card.grid {
        max-width: 224px;
        width: 100%;
        display: flex;
        flex-direction: column; 
    }

    .game-card.list {
        max-width: none;
        display: flex;
        flex-direction: row;
    }

    .card-topSide {
        position: relative;
        width: 100%;
    }

    .game-card.list .card-topSide {
        max-width: 224px;
    }

    /* Обложка */

    .game-card__img {
        width: 100%;
        max-height: 299px;
        height: 100vh;
        border-radius: 4px 4px 0 0;
    }

    .rating-block {
        width: fit-content;
        position: absolute;
        top: 8px;
        left: 8px;
        gap: var(--gp-8);
    }

    .rating-block__rating {
        position: relative;
        font-family: Roboto_SemiBold;
        font-size: 14px;
        padding: 2px 8px;
        border-radius: 4px;
        background-color: var(--btn-color-5);
        z-index: 50;
        cursor: pointer;
    }
    
    .rating-block__counter {
        position: absolute;
        left: 100%;
        transform: translateX(-8px);
        font-family: Roboto_Medium;
        font-size: 12px;
        padding: 4px 8px;
        background-color: var(--color-1);
        border-radius: 4px;
        opacity: 0;
        visibility: hidden;
        white-space: nowrap;
        pointer-events: none;
        transition: all 0.3s ease;
        z-index: 40;
        margin-left: 6px;
    }

    .rating-block:hover .rating-block__counter {
        opacity: 1;
        visibility: visible;
        transform: translateX(0)
    }

    /* Кнопка добавления */

    .game-card__btnShowForm {
        background-color: var(--color-1);
        border-radius: 4px;
        padding: 5px;
    }

    .game-card.grid .game-card__btnShowForm {
        position: absolute;
        top: 8px;
        right: 8px;
    }

    .icon {
        width: 10px;
        height: 10px;
    }

    /* Нижний блок карточки */

    .card-bottomSide {
        width: 100%;
        height: 100%;
        padding: 10px 8px;
        background-color: var(--bg-secondary-25);
        border-radius: 0 0 4px 4px;
        gap: var(--gp-8);
    }

    .game-card__name {
        font-family: Roboto_Medium;
        font-size: 16px;
    }

    .game-card__releaseDate {
        font-family: Roboto_Medium;
        font-size: 14px;
        color: var(--font-primary-50);
    }

    .game-card__rateBtn {
        font-family: Roboto_Medium;
        font-size: 14px;
        padding-block: 8px;
        width: 100%;
        background-color: var(--btn-color-6-25);
        border-radius: 4px;
        text-wrap: nowrap;
        margin-top: auto;
    }

    .game-card__rateBtn:hover {
        background-color: var(--font-secondary);
    }

    /* Лист */

    .card-rightSide {
        width: 100%;
        gap: var(--gp-20);
        padding-top: 16px;
    }

    .card-rightSide-header {
        width: 100%; 
        gap: var(--gp-10);
    }

    .game-card.list .game-card__img {
        max-width: 224px;
    }

    .game-card.list .game-card__name {
        font-family: Roboto_SemiBold;
        font-size: 32px;
    }

    .game-card.list .game-card__btnShowForm {
        width: 32px;
        height: 32px;
    }

    .game-card.list .icon {
        width: 14px;
        height: 14px;
    }

    .card-rightSide-info {
        width: 100%;
        gap: var(--gp-20);
    }

    .game-info {
        display: grid;
        grid-template-columns: max-content 1fr;
        column-gap: 32px;
        row-gap: 20px;
        align-items: center;
    }

    .game-info dt {
        margin: 0;
        white-space: normal;
        font-family: Roboto_Medium;
        font-size: 24px;
        color: var(--font-primary-50);
    }

    .game-info dd {
        margin: 0;
        min-width: 0;
        font-family: Roboto_Medium;
        font-size: 24px;
    }

    .info__rating {
        width: fit-content;
        padding: 4px 10px;
        background-color: var(--btn-color-5);
        border-radius: 256px;
        font-size: 16px !important;
        font-family: Roboto_SemiBold;
        position: relative;
    }

    .game-card.list .game-card__rateBtn {
        width: fit-content;
        padding-inline: 64px;
        font-size: 16px;
    }

    .info-rating-block {
        width: fit-content;
        position: relative;
    }

    .game-card.list .rating-block__counter {
        opacity: 0;
        visibility: hidden;
        transform: translateX(-8px);
        pointer-events: none;
        transition: opacity 0.25s ease, transform 0.25s ease, visibility 0.25s ease;
        white-space: nowrap;
    }

    .info-rating-block:hover .rating-block__counter {
        opacity: 1;
        visibility: visible;
        transform: translateX(0);
        pointer-events: auto;
    }
    /* статус игры */

    .game-card__status {
        font-family: Roboto_Medium;
        font-size: 24px;
        color: var(--font-primary-50);
    }

    .rightSide-header-right {
        width: fit-content;
        gap: var(--gp-12);
    }






    /* Адаптив */

    @media (max-width:1024px) {
        .game-card.list {
            gap: var(--gp-24);
        }

        .game-card.list .card-topSide {
            max-width: 200px;
        }

        .game-card.list .game-card__name {
            font-size: 24px;
        }

        .game-card.list .game-info dt,
        .game-card.list .game-info dd {
            font-size: 20px;
        }

        .game-card.list .game-card__btnShowForm {
            width: 24px;
            height: 24px;
        }

        .game-card.list .icon {
            width: 12px;
            height: 12px;
        }

        .game-card__status {
            font-size: 20px;
        }
    }

    @media (max-width:650px) {
        .game-card.list {
            gap: var(--gp-10);
        }

        .game-card.list .card-leftSide {
            max-width: 150px;
        }

        .game-card.list .game-card__name {
            font-size: 16px;
        }

        .game-card.list .game-info dt,
        .game-card.list .game-info dd {
            font-size: 14px;
        }

        .game-card.list .info__rating {
            font-size: 12px !important;
            padding-block: 2px;
        }

        .game-info {
            row-gap: 10px;
            column-gap: 8px;
        }

        .game-card.list .game-card__rateBtn {
            width: 100%;
            font-size: 14px;
        }

        .card-rightSide {
            padding-top: 0px;
        }

        .rightSide-header-right {
            gap: var(--gp-8);
        }

        .game-card.list .game-card__btnShowForm {
            width: 20px;
            height: 20px;
        }

        .game-card.list .icon {
            width: 8px;
            height: 8px;
        }

        .game-card__status {
            font-size: 14px;
        }

        .card-rightSide {
            gap: var(--gp-10);
        }
    }

    @media (max-width:450px) {
        .game-card.list .card-leftSide {
            max-width: 100px;
            min-width: 100px;
        }

        .game-card.list .info__rating {
            font-size: 10px !important;
            padding-inline: 6px;
        }

        .card-rightSide-header {
            justify-content: start;
            flex-direction: column;
            align-items: start;
        }

        .game-card.list .game-info dt
        .game-card.list .game-info dd {
            font-size: 12px;
        }


    }

</style>