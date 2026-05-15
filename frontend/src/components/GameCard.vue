<script setup>
    import { storeToRefs } from 'pinia'
    import { useAuthStore } from '../stores/authStore'

    const authStore = useAuthStore()
    const { isAuthenticated  } = storeToRefs(authStore)

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
        },
        userRating: {
            type: Number,
            default: null
        },
        userCollection: {
            type: String,
            default: null
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
            <RouterLink :to="`/game/${props.id}`" class="game__link">
                <picture>
                    <img :src="cover" class="game-card__img">
                </picture>
            </RouterLink>
            <div v-if="format === 'grid'" class="rating-block flex align-c">
                <span class="rating-block__rating flex-center">{{ ratingOverall }}</span>
                <span class="rating-block__counter flex-center">{{ counterRating }} оценок</span>
            </div>
            <button @click="openPopup" v-if="format === 'grid' && isAuthenticated" type="button" :class="{'active': props.userCollection}" class="no-border flex-center game-card__btnShowForm">
                <svg v-if="!props.userCollection" class="icon"><use href="#icon-plus"></use></svg>
                <svg v-else class="icon"><use href="#icon-minus"></use></svg>
            </button>
            <button v-if="isAuthenticated && format === 'list'" @click="openEstimatePopup" type="button" class="no-border game-card__rateBtn">
                {{ props.userRating ? `Моя оценка ${props.userRating}` : 'Поставить оценку' }}
            </button>
        </div>
        <div v-if="format === 'grid'" class="card-bottomSide flex-column">
            <RouterLink :to="`/game/${props.id}`" class="game-card__name">
                {{ name }}
            </RouterLink>
            <span class="game-card__releaseDate">{{ formatDate(releaseDate) }}</span>
            <button v-if="isAuthenticated" @click="openEstimatePopup" type="button" class="no-border game-card__rateBtn">
                {{ props.userRating ? `Моя оценка ${props.userRating}` : 'Поставить оценку' }}
            </button>
        </div>

        <div v-if="format === 'list'" class="card-rightSide flex-column">
            <div class="card-rightSide-header flex justify-sb">
                <RouterLink :to="`/game/${props.id}`" class="game-card__name">
                    {{ name }}
                </RouterLink>
                <div class="rightSide-header-right flex align-c">
                    <button v-if="isAuthenticated" @click="openPopup" type="button" class="no-border flex align-c game-card__btnShowForm">
                        <span v-if="!props.userCollection" class="flex-center span__icon">
                            <svg class="icon"><use href="#icon-plus"></use></svg>
                        </span>
                        <span v-else :class="{'active': props.userCollection}" class="flex-center span__icon active">
                            <svg class="icon">
                                <use href="#icon-minus"></use>
                            </svg>
                        </span>
                        <span v-if="props.userCollection" class="game-card__status">{{ props.userCollection }}</span>
                    </button>
                </div>
            </div>
            <div class="card-rightSide-info flex-column">
                <dl class="game-info">
                    <dt>Рейтинг</dt>
                    <dd class="flex align-c">
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
        position: relative;
        overflow: hidden;
        border-radius: 4px;
    }

    .game-card.list {
        gap: var(--gp-24);
        max-width: none;
        display: flex;
        flex-direction: row;
    }

    .game-card.grid {
        max-width: 224px;
        display: flex;
        flex-direction: column; 
    }

    .card-topSide {
        position: relative;
        width: 100%;
    }

    .game-card.list .card-topSide {
        max-width: 224px;
        width: 100%;
    }

    /* Обложка */

    .game__link {
        display: block;
        width: 100%;
        max-width: 224px;
        height: auto;
        aspect-ratio: 224 / 299;
        overflow: hidden;
    }

    .game-card__img {
        width: 100%;
        height: 100%;
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
        font-family: Roboto_Medium;
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
        padding: 6px;
    }

    .game-card__btnShowForm:hover {
        background-color: var(--font-primary-35);
    }

    .game-card.grid .game-card__btnShowForm {
        position: absolute;
        top: 8px;
        right: 8px;
        z-index: 50;
    }

    .game-card.list .game-card__btnShowForm {
        padding: 0;
    }

    .icon {
        width: 12px;
        height: 12px;
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

    .game-card__name:hover {
        color: var(--font-secondary);
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

    .game-card.list .game-card__rateBtn {
        margin: 0;
    }

    .game-card__rateBtn:hover {
        background-color: var(--font-secondary);
    }

    /* Лист */

    .card-rightSide {
        width: 100%;
        gap: var(--gp-16);
    }

    .card-rightSide-header {
        width: 100%; 
        gap: var(--gp-8);
        align-items: start;
    }

    .game-card.list .game-card__img {
        max-width: 224px;
        border-radius: 4px;
    }

    .game-card.list .game-card__name {
        font-family: Roboto_SemiBold;
        font-size: 28px;
    }

    .game-card.list .game-card__btnShowForm {
        width: fit-content;
        background-color: transparent;
        gap: var(--gp-8);
    }

    .game-card.list .game-card__btnShowForm:hover .span__icon {
       background-color: var(--font-primary-25);
    }

    .game-card.list .game-card__btnShowForm .span__icon {
        width: 28px;
        height: 28px;
        background-color: var(--bg-secondary-50);
        border-radius: 4px;
    }

    .game-card.list .game-card__btnShowForm .span__icon.active {
        background-color: var(--font-primary-25);
    }


    .game-card__btnShowForm.active {
        background-color: var(--font-primary-25);
    }


    .game-card.list .icon {
        width: 12px;
        height: 12px;
    }

    .card-rightSide-info {
        width: 100%;
        gap: var(--gp-20);
    }

    .game-info {
        display: grid;
        grid-template-columns: max-content 1fr;
        column-gap: 32px;
        row-gap: 16px;
        align-items: top;
    }

    .game-info dt {
        margin: 0;
        white-space: normal;
        font-family: Roboto_Medium;
        font-size: 20px;
        color: var(--font-primary-50);
    }

    .game-info dd {
        margin: 0;
        min-width: 0;
        font-family: Roboto_Medium;
        font-size: 20px;
    }

    .info__rating {
        width: fit-content;
        padding: 2px 6px;
        background-color: var(--btn-color-5);
        border-radius: 4px;
        font-size: 14px !important;
        font-family: Roboto_Medium;
        position: relative;
    }

    .game-card.list .card-leftSide {
        width: fit-content;
        display: flex;
        flex-direction: column;
        gap: var(--gp-10);
    }

    .info-rating-block {
        width: fit-content;
        position: relative;
        cursor: pointer;
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

    .rightSide-header-right {
        width: fit-content;
        gap: var(--gp-12);
    }

    .game-card__status {
        font-family: Roboto_Medium;
        font-size: 20px;
        color: var(--font-primary-75);
    }

    /* Адаптив */

    @media (max-width:1024px) {
        .game-card.list .card-topSide {
            max-width: 200px;
        }

        .game-card.list .game-card__name {
            font-size: 24px;
        }

        .game-card.list .game-card__btnShowForm .span__icon {
            width: 24px;
            height: 24px;
        }
    }

    @media (max-width:767px) {
        .game-card.list {
            gap: var(--gp-16);
        }

        .game-card.list .game-card__name {
            font-size: 20px;
        }

        .game-card__status {
            font-size: 18px;
        }

        .game-card.list .game-info dt,
        .game-card.list .game-info dd {
            font-size: 16px;
        }

        .game-info {
            column-gap: 24px;
            row-gap: 16px;
            align-items: top;
        }

        .game-card.list .game__link {
            max-width: 150px;
            height: 200px;
        }
    }

    @media (max-width:600px) {

        .card-rightSide-header {
            flex-direction: column;
            gap: var(--gp-12);
        }

        .game-card__status {
            font-size: 16px;
        }

        .game-card.list .game-card__btnShowForm .span__icon {
            width: 20px;
            height: 20px;
        }

        .game-card.list .icon {
            width: 10px;
            height: 10px;
        }

        .game-card.list .game-info dt,
        .game-card.list .game-info dd {
            font-size: 14px;
        }

        /* Грид */

        .game-card.grid .game-card__name {
            font-size: 14px;
        }

        .game-card.grid .game-card__rateBtn {
            font-size: 12px;
        }

        .game-card.grid .game-card__releaseDate {
            font-size: 12px;
        }

        .rating-block__rating {
            font-size: 12px
        }
    }

    @media (max-width:500px) {
        .game-card.list {
            flex-direction: column;
            align-items: center;
            justify-content: center;
        }

        .card-rightSide-header {
            align-items: center;
        }

        .game-card__name {
            text-align: center;
        }
    }


    @media (max-width:425px) {
        .game-card.grid .game-card__name {
            font-size: 14px;
        }

        .game-card.grid .game-card__rateBtn {
            font-size: 12px;
        }

        .rating-block__rating {
            font-size: 13px
        }
    }


</style>