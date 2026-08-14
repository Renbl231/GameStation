<script setup>
    import { ref, watch, computed } from 'vue'
    import { platforms, genres, brands, themes, modes, perspectives, yearOptions } from '@constants/gameFilter';

    const emits = defineEmits(['apply'])

    const isCompanyPlatform = ref(false)
    watch(isCompanyPlatform, (newVal) => {
        if(newVal) {
            selectedPlatforms.value = []
        } else {
            selectedBrands.value = []
        }
    })
    
    const selectedThemes = ref([])
    const selectedModes = ref([])
    const selectedPerspectives = ref([])
    const selectedPlatforms = ref([])
    const selectedBrands = ref([])
    const activeSelected = computed(() =>
        isCompanyPlatform.value ? selectedBrands.value : selectedPlatforms.value
    )
    const selectedYear = ref('')

    const selectedGenres = ref([])
    const ratingMin = ref(0)
    const ratingMax = ref(10)
    const ratingRange = computed(() => ({
        min: Math.min(ratingMin.value, ratingMax.value),
        max: Math.max(ratingMin.value, ratingMax.value)
    }))

    // Сброс фильтров

    const resetFilters = () => {
        isCompanyPlatform.value = false
        selectedThemes.value = []
        selectedModes.value = []
        selectedPerspectives.value = []
        selectedPlatforms.value = []
        selectedBrands.value = []
        selectedGenres.value = []
        selectedYear.value = ''
        ratingMin.value = 0
        ratingMax.value = 10
    }

    const applyFilters = () => {
        const filters = {
            themes: selectedThemes.value,
            modes: selectedModes.value,
            perspectives: selectedPerspectives.value,
            platforms: selectedPlatforms.value,
            brands: selectedBrands.value,
            genres: selectedGenres.value,
            rating: ratingRange.value,
            years: selectedYear.value
        }

        emits('apply', filters)
    }


</script>

<template>
    <div class="filter flex align-c justify-sb">
        <div class="filter__categories flex align-c">
            
            <div class="filter-category flex">
                <button type="button" class="no-border filter-category__btn flex align-c">Платформы
                    <span v-if="activeSelected.length" class="filter-category__counter align-c">
                        <span>|</span>
                        {{ activeSelected.length }}
                    </span>
                    <svg class="filter-category__icon"><use href="#icon-arrow"></use></svg>
                </button>
                <div class="filter-dropdown flex-column">
                    <div class="filter-dropdown__header flex align-c">
                        <button @click="isCompanyPlatform = false" :class="{'active': isCompanyPlatform === false}" type="button" class="no-border filter-dropdown__label">Выберите платформу</button>
                        <span>|</span>
                        <button @click="isCompanyPlatform = true" :class="{'active': isCompanyPlatform === true}" type="button" class="no-border filter-dropdown__label">Компании</button>
                    </div>
                    <div class="filter-dropdown__scroll flex">
                        <div v-if="platforms.length && !isCompanyPlatform" class="filter-dropdown__choise flex-column">
                            <label v-for="platform in platforms" @click.stop :key="platform.idPlatform"  class="custom-checkbox flex align-c">
                                <input 
                                    type="checkbox"
                                    class="custom-checkbox__input"
                                    :value="platform.idPlatform"
                                    v-model="selectedPlatforms"
                                >
                                <span class="custom-checkbox__checkmark"></span>
                                <span class="custom-checkbox__text">{{ platform.name }}</span>
                            </label>
                        </div>
                        <div v-if="brands.length && isCompanyPlatform" class="filter-dropdown__choise flex-column">
                            <label @click.stop v-for="brand in brands" :key="brand.idBrand" class="custom-checkbox flex align-c">
                                <input 
                                    type="checkbox"
                                    class="custom-checkbox__input"
                                    v-model="selectedBrands"
                                    :value="brand.idBrand"
                                >
                                <span class="custom-checkbox__checkmark"></span>
                                <span class="custom-checkbox__text">{{ brand.name }}</span>
                            </label>
                        </div>
                    </div>
                </div>
            </div>
            
            <div class="filter-category flex align-c">
                <button type="button" class="no-border filter-category__btn flex align-c">Жанры
                    <span v-if="selectedGenres.length" class="filter-category__counter align-c">
                        <span>|</span>
                        {{ selectedGenres.length }}
                    </span>
                    <svg class="filter-category__icon"><use href="#icon-arrow"></use></svg>
                </button>
                <div class="filter-dropdown flex-column">
                    <div class="filter-dropdown__scroll">
                        <div v-if="genres.length" class="filter-dropdown__choise flex-column">
                            <label v-for="genre in genres" :key="genre.idGenre"  class="custom-checkbox flex align-c">
                                <input 
                                    type="checkbox"
                                    class="custom-checkbox__input"
                                    :value="genre.idGenre"
                                    v-model="selectedGenres"
                                >
                                <span class="custom-checkbox__checkmark"></span>
                                <span class="custom-checkbox__text">{{ genre.name }}</span>
                            </label>
                        </div>
                    </div>
                </div>
            </div>

            <div class="filter-category flex align-c">
                <button type="button" class="no-border filter-category__btn flex align-c">Рейтинг
                    <svg class="filter-category__icon"><use href="#icon-arrow"></use></svg>
                </button>
                <div class="filter-dropdown filter-dropdown-range flex-column">
                    <div class="filter-range">
                        <div class="filter-range__track"></div>
                        <div class="filter-range__labels flex justify-sb">
                            <span>0</span>
                            <span>1</span>
                            <span>2</span>
                            <span>3</span>
                            <span>4</span>
                            <span>5</span>
                            <span>6</span>
                            <span>7</span>
                            <span>8</span>
                            <span>9</span>
                            <span>10</span>
                        </div>
                        <input
                            class="filter-range__input filter-range__input-min"
                            type="range"
                            min="0"
                            max="10"
                            step="1"
                            v-model="ratingMax"
                        >
                        <input
                            class="filter-range__input filter-range__input-max"
                            type="range"
                            min="0"
                            max="10"
                            step="1"
                            v-model="ratingMin"
                        >
                    </div>
                </div>
            </div>

            <div class="filter-category flex align-c">
                <button type="button" class="no-border filter-category__btn flex align-c">Режимы
                    <span v-if="selectedModes.length" class="filter-category__counter align-c">
                        <span>|</span>
                        {{ selectedModes.length }}
                    </span>
                    <svg class="filter-category__icon"><use href="#icon-arrow"></use></svg>
                </button>
                <div class="filter-dropdown flex-column">
                    <div class="filter-dropdown__scroll">
                        <div v-if="modes.length" class="filter-dropdown__choise flex-column">
                            <label v-for="mode in modes" :key="mode.idMode"  class="custom-checkbox flex align-c">
                                <input 
                                    type="checkbox"
                                    class="custom-checkbox__input"
                                    :value="mode.idMode"
                                    v-model="selectedModes"
                                >
                                <span class="custom-checkbox__checkmark"></span>
                                <span class="custom-checkbox__text">{{ mode.name }}</span>
                            </label>
                        </div>
                    </div>
                </div>
            </div>

            <div class="filter-category flex align-c">
                <button type="button" class="no-border filter-category__btn flex align-c">Перспективы
                    <span v-if="selectedPerspectives.length" class="filter-category__counter align-c">
                        <span>|</span>
                        {{ selectedPerspectives.length }}
                    </span>
                    <svg class="filter-category__icon"><use href="#icon-arrow"></use></svg>
                </button>
                <div class="filter-dropdown flex-column">
                    <div class="filter-dropdown__scroll">
                        <div v-if="perspectives.length" class="filter-dropdown__choise flex-column">
                            <label v-for="perspective in perspectives" :key="perspective.idPerspective" class="custom-checkbox flex align-c">
                                <input 
                                    type="checkbox"
                                    class="custom-checkbox__input"
                                    :value="perspective.idPerspective"
                                    v-model="selectedPerspectives"
                                >
                                <span class="custom-checkbox__checkmark"></span>
                                <span class="custom-checkbox__text">{{ perspective.name }}</span>
                            </label>
                        </div>
                    </div>
                </div>
            </div>

            <div class="filter-category flex align-c">
                <button type="button" class="no-border filter-category__btn flex align-c">Темы
                    <span v-if="selectedThemes.length" class="filter-category__counter align-c">
                        <span>|</span>
                        {{ selectedThemes.length }}
                    </span>
                    <svg class="filter-category__icon"><use href="#icon-arrow"></use></svg>
                </button>
                <div class="filter-dropdown flex-column">
                    <div class="filter-dropdown__scroll">
                        <div v-if="themes.length" class="filter-dropdown__choise flex-column">
                            <label v-for="theme in themes" :key="theme.idTheme" class="custom-checkbox flex align-c">
                                <input 
                                    type="checkbox"
                                    class="custom-checkbox__input"
                                    :value="theme.idTheme"
                                    v-model="selectedThemes"
                                >
                                <span class="custom-checkbox__checkmark"></span>
                                <span class="custom-checkbox__text">{{ theme.name }}</span>
                            </label>
                        </div>
                    </div>
                </div>
            </div>

            <div class="filter-category flex align-c">
                <button type="button" :class="{ active: selectedYear.length }" class="no-border filter-category__btn">Дата</button>
                <div class="filter-dropdown flex-column">
                    <div class="filter-dropdown__scroll">
                        <div class="filter-dropdown__choise flex-column">
                            <label v-for="item in yearOptions" :class="{ active: selectedYear === item.value }" :key="item.value" class="radio-label">
                                <input
                                    type="radio"
                                    name="year"
                                    :value="item.value"
                                    v-model="selectedYear"
                                    class="radio-input"
                                >
                                <span>{{ item.value }}</span>
                            </label>
                        </div>
                    </div>
                </div>
            </div>
            
        </div>
        <div class="filter-btns flex align-c">
            <button @click="applyFilters" type="button" class="no-border filter-btns__btn filter-btns__btn-v1">Применить</button>
            <button @click="resetFilters" type="button" class="no-border filter-btns__btn filter-btns__btn-v2">Сбросить</button>
        </div>
    </div>
</template>

<style lang="scss" scoped>
    .filter {
        width: 100%;
        border-radius: 16px;
        background-color: rgba(0, 0, 0, 0.25);
        padding-block: 16px;
        gap: var(--gp-20);
        flex-wrap: wrap;
        padding-inline: 16px;

        &__categories {
            gap: var(--gp-24);
            flex-wrap: wrap;
        }

        &-category {
            width: fit-content;
            font-family: Roboto_Medium;
            position: relative;

            &:hover .filter-category__btn,
            &:hover .filter-category__btn .filter-category__icon,
            &:hover .filter-category__counter span {
                color:  var(--color-blue);
                stroke: var(--color-blue)
            }

            &:hover::after {
                position: absolute;
                top: 100%;
                content: '';
                width: 100% + 100%;
                height: 28px;
                cursor: pointer;
                background: transparent;
                z-index: 50;
            }


            &:hover .filter-dropdown {
                opacity: 1;
                visibility: visible;
            }

            &__counter {
                font-size: 18px;
                color: var(--color-blue);

                span {color: var(--font-primary);}
            }

            &__btn {
                width: fit-content;
                gap: var(--gp-8);
                font-size: 18px;

                &.active {
                    color: var(--color-blue);
                }
            }

            &__icon {
                width: 12px;
                height: 10px;
                stroke: var(--font-primary-50);
            }
        }

        &-btns {
            gap: var(--gp-16);

            &__btn {
                width: fit-content;
                font-family: Roboto_Medium;
                padding: 8px 12px;
                border-radius: 8px;
                
                &-v1 {
                    background-color: var(--color-blue);
                    &:hover {background-color: var(--font-secondary-75);}
                }

                &-v2 {
                    background-color: var(--bg-third-100);
                    &:hover {background-color: #26323d;}
                }
            }
        }

        &-dropdown {
            position: absolute;
            top: 100%;
            margin-top: 28px;
            left: 0%;
            width: max-content;
            height: fit-content;
            z-index: 500;
            background-color: rgb(18, 18, 18);
            border-radius: 16px;
            padding-left: 16px;
            padding-block: 16px;
            opacity: 0;
            visibility: hidden;
            gap: var(--gp-16);

            @media (max-width:1024px) {
                position: fixed !important;
                bottom: auto !important;
                top: 40px !important;
                width: 100vw !important;
                border-radius: 0px;
                padding-bottom: 32px;
            }

            &__header {
                width: 100%;
                gap: var(--gp-8);
                font-family: Roboto_Medium;
                color: var(--font-primary);
                padding-right: 16px;
            }

            &__label {
                color: var(--font-primary-25);

                &:hover {color: var(--font-primary-75);}
                &.active {color: var(--font-primary);}
            }

            &__scroll {
                max-height: 300px;
                overflow-y: auto;
                overflow-x: hidden;

                @media (max-width:1024px) {max-height: 400px !important;}
            }

            &__choise {
                width: 100%;
                gap: var(--gp-10);
                max-height: 300px;
                overflow-y: auto;
                padding-right: 16px;
                scrollbar-width: auto;
                scrollbar-color: var(--btn-color-6-50) transparent;

                @media (max-width:1024px) {max-height: 400px !important;}
            }

            &-range {
                width: 350px;
                padding-right: 16px;
            }
        }

        &-range {
            position: relative;
            width: 100%;
            height: 64px;

            &__track {
                position: absolute;
                top: 16px;
                left: 0;
                right: 0;
                height: 8px;
                background: var(--btn-color-6-25);
                border-radius: 256px;
            }

            &__labels {
                width: 100%;
                position: absolute;
                left: 6px;
                right: 0px;
                top: 50%;
                font-family: Roboto_Regular;
            }

            &__input {
                position: absolute;
                left: 0;
                top: 15%;
                width: 100%;
                background: transparent;
                pointer-events: none;
                appearance: none;
                -webkit-appearance: none;

                &::-webkit-slider-thumb {
                    pointer-events: auto;
                    -webkit-appearance: none;
                    appearance: none;
                    width: 12px;
                    height: 16px;
                    border-radius: 2px;
                    background: var(--font-secondary);
                    cursor: pointer;
                }
            }
        }
    }

    .custom-checkbox {
        cursor: pointer;
        font-family: Roboto_Medium;
        position: relative;

        &__input {
            appearance: none;
            -webkit-appearance: none;
            position: absolute;
            opacity: 0;
            width: 0;
            height: 0;
            pointer-events: none;
            user-select: none;

            &:checked + .custom-checkbox__checkmark {
                background-color: var(--color-blue);
            }

            &:checked + .custom-checkbox__checkmark::after {
                content: '';
                position: absolute;
                width: 5px;
                height: 10px;
                border: solid white;
                border-width: 0 2px 2px 0;
                transform: translate(-50%, -60%) rotate(45deg);
                left: 50%;
                top: 50%;
            }

            &:checked ~ .custom-checkbox__text {
                color: var(--font-primary);
            }
        }

        &__checkmark {
            width: 20px;    
            height: 20px;
            border-radius: 4px;
            background: var(--btn-color-6-25);
            margin-right: 12px;
            position: relative;
            transition: all 0.2s ease;
            flex-shrink: 0;
        }

        &__text {
            color: var(--font-primary-50);
        }
    }

    .radio-input {
        position: absolute;
        opacity: 0;
        visibility: hidden;
        pointer-events: none;
    }

    .radio-label {
        color: var(--font-primary-75);

        &.active {color: var(--font-secondary);}
    }
</style>