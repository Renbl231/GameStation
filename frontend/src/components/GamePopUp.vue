<script setup>
    import { ref, computed, watch } from 'vue'
    import api from '../utils/axios'
    import { useNotifications } from '../stores/notifications'
    import { useApiNotifications } from '../composables/useApi'

    const { apiCall } = useApiNotifications()
    const notification = useNotifications()

    const props = defineProps({
        moduleType: {
            type: String,
            validator: value => ['View', 'Estimate'].includes(value),
            default: 'View'
        },
        gameInfo: {
            type: Object,
            default: () => ({})
        },
        gameStatus: {
            type: Object,
            default: () => ({})
        }
    })

    const emit = defineEmits(['close-popup'])
    const currentModuleType = ref(props.moduleType)
    const typeEstimate = ref(null)

    const prevStep = () => {
        if(typeEstimate.value != null && currentModuleType.value != 'View') {
            typeEstimate.value = null
        }
        else if(currentModuleType.value != 'View') {
            currentModuleType.value = 'View'
        }
    }

    const closePopUp = () => emit('close-popup')

    const getRangeStyle = (score) => {
        const percent = ((score - 1) / 9) * 100
        return {
            background: `linear-gradient(to right,
            #006FFF 0%,
            #4B99FF ${percent}%,
            var(--btn-color-6-25) ${percent}%,
            var(--btn-color-6-25) 100%)`
        }
    }


    const keyMap = {
        'Геймплей': 'gameplay',
        'Графика': 'graphics',
        'Сюжет': 'story',
        'Музыка': 'music',
        'Атмосфера': 'atmosphere',
        'Оптимизация': 'optimization',
        'Инновация': 'innovation'
    }

    const makeDefaultRatings = () => ([
        { name: 'Геймплей', score: 5, hidden: false },
        { name: 'Графика', score: 5, hidden: false },
        { name: 'Сюжет', score: 5, hidden: false },
        { name: 'Музыка', score: 5, hidden: false },
        { name: 'Атмосфера', score: 5, hidden: false },
        { name: 'Оптимизация', score: 5, hidden: false },
        { name: 'Инновация', score: 5, hidden: false }
    ])

    const ratings = ref(makeDefaultRatings())

    const totalScore = computed(() => {
        const validRatings = ratings.value.filter(item => !item.hidden && item.score !== null)
        if (!validRatings.length) return 5

        const sum = validRatings.reduce((acc, item) => acc + Number(item.score), 0)
        return Number((sum / validRatings.length).toFixed(1))
    })

    const hasRating = ref(false)

    const simpleScore = ref(5)

    const syncSimpleScoreFromProps = () => {
        const rating = props.gameStatus?.rating
        simpleScore.value = rating?.overall_score != null
            ? Number(rating.overall_score)
            : 5
    }

    const syncRatingsFromProps = () => {
        const rating = props.gameStatus?.rating

        syncSimpleScoreFromProps()

        if (!rating) {
            ratings.value = makeDefaultRatings()
            hasRating.value = false
            return
        }

        hasRating.value = rating.overall_score != null

        ratings.value.forEach(item => {
            const key = keyMap[item.name]
            const value = rating[key]
            item.score = value == null ? null : Number(value)
            item.hidden = value == null
        })
    }

    watch(
        () => props.gameStatus?.rating,
        syncRatingsFromProps,
        { immediate: true }
    )

    const hiddenParam = (item) => {
        if (item.hidden) {
            item.hidden = false
            if (item.score == null) item.score = 5
        } else {
            item.hidden = true
            item.score = null
        }
    }

    // удаление оценки

    const DeleteEstimate = async () => {
        const data = await apiCall(() =>
            api.delete('/games/estimateGame', {
            data: { game_id: props.gameInfo.id }
            }),
            'Оценка удалена'
        )

        if (data.status === 204) {
            ratings.value = makeDefaultRatings()
            simpleScore.value = 5
            hasRating.value = false
        }
    }

    // Коллекции

    const collections = [
        { name: 'Любимые' },
        { name: 'Пройденные' },
        { name: 'Хочу сыграть' },
        { name: 'Сейчас играю' },
        { name: 'Заброшено' }
    ]

    const isActiveCollection = (name) => currentCollectionType.value === name

    // Добавление в коллекцию

    const currentCollectionType = ref(props.gameStatus?.collection_type || null)

    const AddToCollection = async (collection_type) => {
        const data = await apiCall(() => api.post('/games/addToCollection', {
                collection_type,
                game_id: props.gameInfo.id
            })
        )

        if (data.success) {
            currentCollectionType.value = data.result.collection_type
        }
    }


    const EstimateGame = async (type) => {
        if(type === 'simple') {
            const data = await apiCall(() => api.post('/games/estimateGame', { 
                type,
                simpleScore: Math.round(simpleScore.value),
                game_id: props.gameInfo.id
             }), 'Игра оценена')
             if(data.success) {
                hasRating.value = true
                ratings.value.forEach(item => {
                    item.score = 0
                })
             }

        } else {
            const visibleRatings = ratings.value
            .filter(item => !item.hidden)
            .map(item => ({
                name: item.name,
                score: item.score
            }))

            const hasInvalidRating = ratings.value.some(
                item => !item.hidden && Number(item.score) < 1
            )

            if (hasInvalidRating) {
                notification.warning('Оценка не может быть меньше 1')
                return
            }

            const data = await apiCall(() =>
                api.post('/games/estimateGame', {
                    type,
                    totalScore: totalScore.value,
                    ratings: visibleRatings,
                    game_id: props.gameInfo.id
                }),'Игра оценена')
            if(data.success) {
                simpleScore.value = totalScore.value
                hasRating.value = true
             }
        }
    }

</script>

<template>
        <div class="gamePopUp flex-center">
            <div class="gamePopUp-container flex-column flex-center">
                <button v-if="currentModuleType != 'View'" @click="prevStep" type="button" class="no-border flex-center gamePopUp-container-prevBtn">
                    <svg class="prev-icon"><use href="#icon-arrow"></use></svg>
                </button>
                <button @click="closePopUp" type="button" class="no-border gamePopUp-container-closeBtn"></button>
                <div v-if="currentModuleType === 'View'" class="gamePopUp-wrapper flex-column flex-center">
                    <div class="label-block">
                        <span>{{ props.gameInfo.name }}</span>
                    </div>
                    <div class="collection-block flex-column">
                        <button
                            v-for="item in collections"
                            :key="item.name"
                            @click="AddToCollection(item.name)"
                            type="button"
                            class="no-border collection-block__btn flex align-c"
                            >
                            <span
                                :class="{ active: isActiveCollection(item.name) }"
                                class="collection-block__iconBg flex-center"
                            >
                                <svg v-if="isActiveCollection(item.name)" class="collection-block__icon">
                                    <use href="#icon-minus"></use>
                                </svg>
                                <svg v-else class="collection-block__icon">
                                    <use href="#icon-plus"></use>
                                </svg>
                            </span>

                            {{ item.name }}
                        </button>
                    </div>
                    <div class="btns-block flex-column">
                        <button type="button" class="no-border btns-block__btn">Добавить в подборку</button>
                        <button @click="currentModuleType = 'Estimate'" type="button" class="no-border btns-block__btn">Оценить игру</button>
                    </div>
                </div>

                <div class="estimate-wrapper" v-else>
                    <div v-if="typeEstimate === null" class="estimate-block flex-column">
                        <span class="estimate-block__label">
                            Выберите вид оценки
                        </span>
                        <div class="estimate-block-reviews flex-column">
                            <div @click="typeEstimate = 'fast'" class="estimate-review-block flex align-c">
                                <svg class="review-block__icon flex-center" width="45" height="45" viewBox="0 0 45 45" fill="none" xmlns="http://www.w3.org/2000/svg">
                                    <path d="M21.1803 0.653162C21.5025 -0.217457 22.7339 -0.21746 23.056 0.653158L28.4408 15.2052C28.5421 15.479 28.7579 15.6948 29.0316 15.796L43.5837 21.1808C44.4543 21.503 44.4543 22.7343 43.5837 23.0565L29.0316 28.4413C28.7579 28.5425 28.5421 28.7584 28.4408 29.0321L23.056 43.5841C22.7339 44.4548 21.5025 44.4548 21.1803 43.5841L15.7956 29.0321C15.6943 28.7584 15.4785 28.5425 15.2047 28.4413L0.652673 23.0565C-0.217945 22.7343 -0.217948 21.503 0.65267 21.1808L15.2047 15.796C15.4785 15.6948 15.6943 15.479 15.7956 15.2052L21.1803 0.653162Z" fill="#006FFF"/>
                                </svg>
                                <div class="review-block-text flex-column">
                                    <span class="review-block__label">Быстрая оценка</span>
                                    <span class="review-block__summary">Ставьте оценку от 1 до 10</span>
                                </div>
                            </div>
                            <div @click="typeEstimate = 'detail'" class="estimate-review-block flex align-c">
                                <svg class="review-block__icon" width="38" height="48" viewBox="0 0 38 48" fill="none" xmlns="http://www.w3.org/2000/svg">
                                    <rect y="28" width="10" height="28" rx="0.5" fill="#8F3838"/>
                                    <rect x="14" y="12" width="10" height="36" rx="0.5" fill="#8F3838"/>
                                    <rect x="28" width="10" height="48" rx="0.5" fill="#8F3838"/>
                                </svg>

                                <div class="review-block-text flex-column">
                                    <span class="review-block__label">Подробная оценка</span>
                                    <span class="review-block__summary">Оцените игру по ключевым параметрам</span>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div v-else-if="typeEstimate === 'detail'" class="detail-block flex-column">
                        <div class="detail-block-header flex align-c justify-sb">
                            <div class="detail-left-side flex align-c">
                                <picture>
                                    <img :src="props.gameInfo.cover" class="game-cover">
                                </picture>
                                <span class="game-name">{{ props.gameInfo.name }}</span>
                            </div>
                            <span class="rating flex-center">{{  totalScore }}</span>
                        </div>
                        <hr>
                        <div class="rating-block">
                            <div v-for="(item, index) in ratings"
                                :class="{'unactive': item.hidden || item.score === null}"
                                :key="index"
                                class="rating-bar flex-column">
                                <div class="parametr-block flex align-c justify-sb">
                                    <div class="flex align-c" style="width: 100%; gap: var(--gp-4);">
                                        <button 
                                            @click="hiddenParam(item)" 
                                            v-if="item.name === 'Сюжет' || item.name === 'Музыка'" 
                                            type="button" 
                                            class="no-border removeParam">
                                            <span v-if="item.hidden">✓</span>
                                            <span v-else>×</span>

                                        </button>
                                        <span class="name-parametr">{{ item.name }}</span>
                                    </div>
                                    <span class="score-parametr">{{ item.score }}</span>
                                </div>

                                    <input
                                        v-model="item.score"
                                        class="bar-progress"
                                        type="range"
                                        min="1"
                                        max="10"
                                        step="1"
                                        :style="getRangeStyle(item.score)"
                                    />
                            </div>
                        </div>
                        <button @click="EstimateGame('detail')" type="button" class="no-border estimate-btn">Оценить</button>
                        <button v-if="hasRating" @click="DeleteEstimate" type="button" class="no-border estimate-btn">Удалить оценку</button>
                    </div>
                    <div v-else class="fast-block flex-column">
                        <div class="detail-block-header flex align-c justify-sb">
                            <div class="detail-left-side flex align-c">
                                <picture>
                                    <img :src="props.gameInfo.cover" class="game-cover">
                                </picture>
                                <span class="game-name">{{ props.gameInfo.name }}</span>
                            </div>
                            <span class="rating flex-center">{{  simpleScore }}</span>
                        </div>
                        <hr>
                        <input
                            v-model="simpleScore"
                            class="bar-progress"
                            type="range"
                            min="1"
                            max="10"
                            step="1"
                            :style="getRangeStyle(simpleScore)"
                        />
                        <button @click="EstimateGame('simple')" type="button" class="no-border estimate-btn">Оценить</button>
                        <button v-if="hasRating" @click="DeleteEstimate" type="button" class="no-border estimate-btn">Удалить оценку</button>
                    </div>
                </div>
            </div>
        </div>
</template>

<style scoped>
    .gamePopUp {
        position: fixed;
        top: 0;
        bottom: 0;
        left: 0;
        right: 0;
        width: 100%;
        height: 100%;
        background-color: #00000075;
        z-index: 1000;
    }

    .gamePopUp-container {
        position: relative;
        max-width: 430px;
        width: 100%;
        padding: 48px 24px;
        background-color: var(--color-2);
        border-radius: 16px;
        border: 1px solid var(--bg-secondary-50);
        margin: 0 auto;

    }

    .gamePopUp-wrapper {
        width: 100%;
        gap: var(--gp-20);
    }

    .label-block {
        max-width: 80%;
        text-align: center;
        width: auto;
        font-family: Roboto_SemiBold;
        font-size: 24px;
    }

    .gamePopUp-container-closeBtn {
        position: absolute;
        width: 32px;
        height: 32px;
        cursor: pointer;
        top: 16px;
        right: 16px;
    }

    /* Крестик */

    .gamePopUp-container-closeBtn::before,
    .gamePopUp-container-closeBtn::after {
        content: '';
        position: absolute;
        top: 16px;
        left: 50%;
        width: 20px;
        height: 2px;
        background-color: var(--font-primary-50);
        transform: translate(-50%, -50%) rotate(45deg);
    }

    .gamePopUp-container-closeBtn::after {
        transform: translate(-50%, -50%) rotate(-45deg);
    }

    .gamePopUp-container-closeBtn:hover::before,
    .gamePopUp-container-closeBtn:hover::after {
        background-color: var(--font-primary);
    }

    /* Блок коллекций */

    .collection-block {
        width: auto;
        gap: var(--gp-16);
    }

    .collection-block__btn {
        gap: var(--gp-12);
        font-family: Roboto_SemiBold;
        font-size: 20px;
        color: var(--font-primary-50);
    }

    .collection-block__btn:hover {
        color: var(--font-primary);
    }

    .collection-block__btn:Hover .collection-block__iconBg {
        background-color: var(--font-primary-25)
    }

    .collection-block__iconBg {
        width: fit-content;
        padding: 8px;
        background-color: rgba(0, 0, 0, 0.5);
        border-radius: 4px;
    }

    .collection-block__icon {
        width: 16px;
        height: 16px;
    }

    .collection-block__iconBg.active {
        background-color: var(--font-primary-25);
    }

    .collection-block__iconBg.active .collection-block__icon {
        color: var(--font-primary);
    }

    .btns-block {
        width: fit-content;
        gap: var(--gp-16);
        font-family: Roboto_Medium;
    }

    .btns-block__btn {
        padding-block: 8px;
        border-radius: 8px;
        background-color: #5B5B5B;
        padding-inline: 24px;
    }

    .btns-block__btn:hover {
        background-color: var(--font-secondary);
    }

    .gamePopUp-container-prevBtn {
        position: absolute;
        top: 16px;
        left: 8px;
        width: 32px;
        height: 32px;
    }

    .gamePopUp-container-prevBtn:hover .prev-icon {
        stroke: var(--font-primary);
    }

    .prev-icon {
        width: 16px;
        height: 16px;
        transform: rotate(90deg);
        stroke: var(--font-primary-50)
    }

    /* Блок оценок */

    .estimate-wrapper {
        width: 100%;
    }

    .estimate-block {
        gap: var(--gp-32);
    }

    .estimate-block__label {
        font-family: Roboto_SemiBold;
        font-size: 24px;
        text-align: center;
    }

    .estimate-block-reviews {
        gap: var(--gp-24);
    }

    .estimate-review-block {
        width: 100%;
        gap: var(--gp-16);
        background-color: rgba(0, 0, 0, 0.25);
        border-radius: 4px;
        padding: 8px 16px;
        cursor: pointer;
    }

    .estimate-review-block:hover {
        background-color: rgba(0, 0, 0, 0.35);
    }

    .review-block__icon {
        min-width: 48px;
        min-height: 48px;
    }

    .review-block-text {
        width: 100%;
        gap: var(--gp-8);
    }

    .review-block__label {
        font-family: Roboto_Medium;
        font-size: 20px;
    }

    .review-block__summary {
        font-family: Roboto_Regular;
        font-size: 14px;
        color: var(--font-primary-50);
    }
    
    /* Детальный блок */

    .detail-block {
        width: 100%;
        gap: var(--gp-16);
        margin-top: 24px;
    }

    .detail-block-header {
        width: 100%;
        gap: var(--gp-8);
    }

    .detail-left-side {
        gap: var(--gp-12);
    }

    .game-cover {
        min-width: 64px;
        max-width: 64px;
        min-height: 64px;
        max-height: 64px;
        border-radius: 4px;
    }

    .game-name {
        font-family: Roboto_Medium;
        font-size: 20px;
    }
    
    .rating {
        min-width: 40px;
        min-height: 40px;
        font-size: 16px;
        font-family: Roboto_Bold;
        background: #000;
        border: 3px solid var(--font-secondary);
        border-radius: 50%;
        box-shadow: 0 4px 16px 0 rgba(0, 111, 255, 0.5);
    }

    /* Рейтинг блок детаил */

    .rating-block {
        width: 100%;
        display: grid;
        grid-template-columns: repeat(2, 1fr);
        row-gap: var(--gp-16);
        column-gap: var(--gp-16);
    }

    /* Ввод рейнджа */

    .rating-bar {
        padding-inline: 8px;
        padding-top: 8px;
        padding-bottom: 12px;
        background-color: rgba(0, 0, 0, 0.5);
        border-radius: 8px;
        gap: var(--gp-8);
        border-top: 2px solid var(--font-secondary)
    }

    .rating-bar.unactive {
        opacity: 0.6;
    }

    .name-parametr {
        font-size: 16px;
        font-family: Roboto_Medium;
    }

    .score-parametr {
        font-size: 18px;
        font-family: Roboto_Bold;
        color: var(--font-secondary);
        text-shadow: 0px 0px 4px rgba(0, 111, 255, 0.5);
    }

    .rating-bar.unactive .bar-progress {
        pointer-events: none;
    }

    .bar-progress {
        width: 100%;
        height: 8px;
        -webkit-appearance: none;
        appearance: none;
        outline: none;
        border-radius: 256px;
        background: transparent;
        cursor: pointer;
    }

    .bar-progress::-webkit-slider-runnable-track {
        height: 12px;
        border-radius: 256px;
        background: transparent;
    }

    .bar-progress::-moz-range-track {
        height: 12px;
        border-radius: 256px;
        background: transparent;
    }

    .bar-progress::-webkit-slider-thumb {
        -webkit-appearance: none;
        appearance: none;
        width: 16px;
        height: 16px;
        border-radius: 50%;
        background: #fff;
        margin-top: -2px;
    }

    .bar-progress::-moz-range-thumb {
        width: 16px;
        height: 16px;
        border-radius: 50%;
        background: #fff;
    }

    .estimate-btn {
        width: 100%;
        padding-block: 8px;
        font-family: Roboto_SemiBold;
        background-color: var(--font-primary-25);
        border-radius: 8px;
        margin-top: 8px;
    }

    /* Крест для параметров */

    .removeParam {
        width: fit-content;
        height: fit-content;
        cursor: pointer;
        font-size: 20px;
    }

    /* Обычная оценка блок */

    .fast-block {
        width: 100%;
        gap: var(--gp-16);
        margin-top: 24px;
    }

</style>