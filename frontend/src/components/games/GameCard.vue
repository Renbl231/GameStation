<script setup>
    import GamePopUp from '@components/games/GamePopUp.vue'

    import { ref, computed } from 'vue'
    import { storeToRefs } from 'pinia'
    import { useAuthStore } from '@stores/authStore'
    import api from '@utils/axios'
    
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

    const userRating = ref(props.userRating)
    const userCollection = ref(props.userCollection)

    // Показ попапа игры

    const popupGameVisible = ref(false)
    const popupGameType = ref('view')
    const selectedGame = ref({})

    const showPopupGame = async (game) => {
        popupGameType.value = game.moduleType

        const { data } = await api.get(`/games/${game.id}/my-rating`)
        selectedGame.value = data.result
        popupGameVisible.value = true
    }

    const infoForPopup = ref({
        id: props.id,
        name: props.name,
        cover: props.cover
    })

    const openPopup = (moduleType) => {
        showPopupGame({
            id: props.id,
            moduleType: moduleType
        })
    }

    const formatDate = (iso) => {
        const date = new Date(iso)

        const day = String(date.getUTCDate()).padStart(2, '0')
        const month = String(date.getUTCMonth() + 1).padStart(2, '0')
        const year = date.getUTCFullYear()

        const formatted = `${day}.${month}.${year}`

        return formatted
    }

    const handleRatingUpdate = (ratingData) => {userRating.value = ratingData}

    const handleCollectionUpdate = (collectionType) => {userCollection.value = collectionType}

    const displayRating = computed(() => {
        if (props.userRating == null) return ''
        return Number(props.userRating + 1).toFixed(1)
    })


</script>


<template>

    <Transition name="popup-slide">
        <GamePopUp
            v-if="popupGameVisible"
            :game-status="selectedGame"
            :game-info="infoForPopup"
            :module-type="popupGameType"
            @close="popupGameVisible = false"
            @update:collection="handleCollectionUpdate"
            @update:rating="handleRatingUpdate"
        />
    </Transition>

    <article class="game" :class="format">
        <div class="card-topSide card-leftSide">
            <RouterLink :to="`/game/${props.id}`" class="game__link">
                <picture>
                    <img :src="cover" class="game__cover">
                </picture>
                <div class="game__drop-menu flex-column">
                    <RouterLink :to="`/game/${props.id}`" class="game__name" :title="name">
                        {{ name }}
                    </RouterLink>
                    <div class="flex align-c justify-sb">
                        <span class="game__releaseDate">{{ formatDate(releaseDate) }}</span>
                        <div class="flex align-c game__rating-block game__rating-block-v2">
                            <span class="game__rating-counter flex-center">{{ counterRating }} оценок</span>
                            <span v-show="ratingOverall" class="game__rating flex-center">{{ Number(ratingOverall).toFixed(1) }}</span>
                        </div>
                    </div>
                </div>
            </RouterLink>
            <div v-show="format === 'grid'" class="flex-column game__rating-wrapper">
                <span v-show="ratingOverall" class="game__rating flex-center">{{ Number(ratingOverall).toFixed(1) }}</span>
            </div>
            <div v-if="format === 'grid' && isAuthenticated" class="flex align-c game__blockShowForm">
                <button @click="openPopup('view')" type="button" class="no-border flex-center game__btnShowForm">
                    <svg class="icon icon-favorite"><use href="#icon-favorite"></use></svg>
                </button>
                <button @click="openPopup('view')" type="button" :class="{'active': userCollection}" class="no-border flex-center game__btnShowForm">
                    <svg v-if="!userCollection" class="icon"><use href="#icon-plus"></use></svg>
                    <svg v-else class="icon"><use href="#icon-minus"></use></svg>
                </button>
            </div>
        </div>

        <div v-if="format === 'grid'" class="card-bottomSide flex-center">
            <button v-if="isAuthenticated" @click="openPopup('estimate')" type="button" class="no-border game__rateBtn">
                {{ userRating ? `Моя оценка ${userRating}` : 'Поставить оценку' }}
            </button>
        </div>
        
        <div v-if="format === 'list'" class="card-rightSide flex-column">
            <div class="card-rightSide__header">
                <RouterLink :to="`/game/${props.id}`" class="game__name">
                    {{ name }}
                </RouterLink>
            </div>
            <div class="card-rightSide__info flex-column">
                <dl class="game__info">
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

            <div class="card-rightSide__footer flex">
                <div class="flex align-c game__rating-block-list">
                    <span v-show="ratingOverall" class="game__rating game__rating-list flex-center">{{ Number(ratingOverall).toFixed(1) }}</span>
                    <div v-show="counterRating" class="flex-column">
                        <span class="game__rating-counter-list">{{ counterRating + 835 }}</span>
                        <span class="game__rating-counter-list">оценок</span>
                    </div>
                </div>
                <div class="flex-center">
                    <button v-if="isAuthenticated" @click="openPopup('estimate')" type="button" class="no-border game__rateBtn game__rateBtn-list">
                        {{ userRating ? `Моя оценка ${userRating}` : 'Поставить оценку' }}
                    </button>
                </div>
                <div class="flex align-c" style="gap: var(--gp-8);">
                    <button @click="openPopup('view')" type="button" class="no-border flex-center game__btnShowForm game__btnShowForm-list">
                        <svg class="icon icon-favorite icon-list"><use href="#icon-favorite"></use></svg>
                    </button>
                    <button v-if="isAuthenticated" @click="openPopup('view')" type="button" class="no-border flex align-c" style="gap: var(--gp-8);">
                        <button type="button" :class="{'active': userCollection}" class="no-border flex-center game__btnShowForm game__btnShowForm-list">
                            <svg v-if="!userCollection" class="icon icon-list"><use href="#icon-plus"></use></svg>
                            <svg v-else class="icon icon-list"><use href="#icon-minus"></use></svg>
                        </button>
                        <span v-if="userCollection" class="game__status">{{ userCollection }}</span>
                    </button>
                </div>
            </div>
        </div>
    </article>

    <hr v-if="format === 'list'" style="width: 100%;">

</template>

<style lang="scss" scoped>

    .game {
        width: 100%;
        position: relative;
        will-change: transform;
        transition: 0.4s;
        border-radius: 8px 8px 0px 0px;

        &.grid:hover .game__cover {
            transform: scale(1.05);
        }

        &.grid:hover .game__drop-menu {
            opacity: 1;
            visibility: visible;
            transform: translateX(0px);
        }

        &.grid .game__link {
            border-radius: 8px 8px 0 0;
        }

        &__link {
            position: relative;
            display: block;
            width: 100%;
            max-width: 224px;
            aspect-ratio: 224 / 299;
            overflow: hidden;
            border-radius: 8px;
            border: 1px solid var(--bg-secondary-border);
            border-bottom: none;
        }

        &__drop-menu {
            position: absolute;
            left: 0%;   
            bottom: 0px;                  
            width: 100%;
            z-index: 100;
            background-color: var(--color-dark-200);
            opacity: 0;
            visibility: hidden;
            padding: 8px;
            transform: translateY(50px);
            transition: 
                opacity 0.3s ease,
                visibility 0.3s ease,
                transform 0.3s ease;
                gap: var(--gp-6);
        }

        &__cover {
            display: block;
            width: 100%;
            height: 100%;
            transform: scale(1);
            transition: transform 0.4s cubic-bezier(0.4, 0, 0.2, 1);
            will-change: transform;
            backface-visibility: hidden; 
            transform: translateZ(0px); 

            &:hover {
                transform: scale(1.05);
            }
        }

        &__rating-wrapper {
            width: fit-content;
            position: absolute;
            bottom: 8px;
            right: 1px;
            gap: var(--gp-8);
        }

        &__rating-block {
            width: fit-content;
            position: relative;

            &:hover .game__rating-counter {
                opacity: 1;
                visibility: visible;
                transform: translateX(-8px)
            }   

            &-v2 {
                position: absolute;
                right: 0px;
                bottom: 8px;
            }

            &-list {
                width: fit-content;
                gap: var(--gp-8);
                border-right: 2px solid var(--bg-secondary-border);
                padding-right: 16px;
            }
        }


        &__rating {
            max-height: 24px;
            font-family: Roboto_Medium;
            font-size: 12px;
            padding: 2px 8px;
            border-radius: 4px 0 0 4px;
            background-color: var(--color-blue-hover);
            z-index: 50;
            cursor: pointer;

            &-list {
                max-height: none;
                border-radius: 4px;
                font-size: 18px;
                background-color: var(--color-green);
                padding-inline: 12px;

                @media (max-width:600px) {
                    font-size: 16px;
                }
                
            }
        }

        &__rating-counter {
            max-height: 24px;
            position: absolute;
            right: 100%;
            transform: translateX(0px);
            font-family: Roboto_Medium;
            font-size: 12px;
            padding: 2px 4px;
            background-color: var(--color-dark-400);
            border-radius: 4px;
            opacity: 0;
            visibility: hidden;
            white-space: nowrap;
            pointer-events: none;
            transition: all 0.3s ease;
            z-index: 100;

            &-list {
                opacity: 1;
                visibility: visible;
                font-size: 13px;
                font-family: Roboto_Medium;
                color: var(--text-muted);
            }
        }

        &.grid {
            max-width: 224px;
            display: flex;
            flex-direction: column; 

            & .game__blockShowForm {
                width: fit-content;
                gap: var(--gp-8);
                position: absolute;
                top: 8px;
                right: 8px;
                z-index: 50;
            }

        }

        &__btnShowForm {
            max-width: 24px;
            max-height: 24px;
            padding: 6px;
            background-color: var(--color-dark-200);
            border-radius: 4px;

            &:hover {
                background-color: var(--color-gray-500);
            }

            &-list {
                min-width: 32px;
                min-height: 32px;
            }
        }

        &__rateBtn {
            width: 100%;
            font-family: Roboto_Medium;
            font-size: 13px;
            background-color: var(--color-dark-400);
            border-radius: 0 0 8px 8px;
            border: 1px solid var(--bg-secondary-border);
            border-top: none;
            text-wrap: nowrap;
            padding-block: 4px;

            &:hover {
                background-color: var(--color-blue-hover);
            }

            &-list {
                width: fit-content;
                border-radius: 4px;
                padding-inline: 12px;
                font-size: 14px;
                height: 100%;
            }
        }

        &.list {
            gap: var(--gp-24);
            max-width: none;
            display: flex;
            flex-direction: row;

            @media (max-width:768px) {
                & .game__link {
                    max-width: 150px;
                    height: 200px;
                }
            }

            @media (max-width:600px) {
                & .game__info dt,
                & .game__info dd {
                    font-size: 14px;
                }
            }

            @media (max-width:600px) {
                flex-direction: column;
                align-items: center;
                justify-content: center;
            }

            & .card-topSide {
                max-width: 224px;
                width: 100%;

                @media (max-width:1024px) {
                    max-width: 200px;
                }
            }   

            & .card-leftSide {
                width: fit-content;
                display: flex;
                flex-direction: column;
                gap: var(--gp-10);
            }

            & .game__cover {
                max-width: 224px;
                border-radius: 4px;
            }

            & .game__name {
                padding-top: 8px;
                font-size: 26px;

                @media (max-width:768px) {
                    font-size: 20px;
                }

                @media (max-width:600px) {
                    text-align: center;
                    padding: 0px;
                }
            }

            & .game__rating-counter {
                opacity: 0;
                visibility: hidden;
                transform: translateX(-8px);
                pointer-events: none;
                transition: opacity 0.25s ease, transform 0.25s ease, visibility 0.25s ease;
                white-space: nowrap;
            }
        }

        &__name {
            font-family: Roboto_Medium;
            font-size: 14px;
            display: -webkit-box;
            -webkit-line-clamp: 1;
            -webkit-box-orient: vertical;
            overflow: hidden;
            text-overflow: ellipsis;
            color: var(--text-primary-soft);
            &:hover {
                color: var(--color-blue-hover);
            }
        }

        &__releaseDate {
            font-family: Roboto_Medium;
            font-size: 14px;
            color: var(--text-muted);
        }

        &__info {
            display: grid;
            grid-template-columns: max-content 1fr;
            column-gap: 24px;
            row-gap: 16px;
            align-items: top;

            & dt {
                margin: 0;
                white-space: normal;
                font-family: Roboto_Regular;
                font-size: 16px;
                color: var(--text-secondary);
            }

            & dd {
                margin: 0;
                min-width: 0;
                font-family: Roboto_Regular;
                color: var(--text-primary-soft);
                font-size: 16px;
            }
        }

        &__status {
            font-family: Roboto_Medium;
            font-size: 18px;
            color: var(--text-primary);

            @media (max-width:600px) {
                font-size: 16px;
            }
        }
    }

    .icon {
        width: 12px;
        height: 12px;

        &-favorite {
            min-width: 14px;

            &.active {
                color: var(--color-red);
            }
        }

        &-list {
            width: 20px;
            height: 20px;
        }
    }

    .card-topSide {
        position: relative;
        width: 100%;
    }

    .card-bottomSide {
        width: 100%;
        height: 100%;
    }

    .card-rightSide {
        width: 100%;
        gap: var(--gp-16);

        &__header {
            width: 100%; 
        }

        &__footer {
            flex-wrap: wrap;
            width: 100%;
            gap: var(--gp-16);
            margin-top: 8px;
        }

        &__info {
            width: 100%;
            gap: var(--gp-20);
        }
    }

</style>