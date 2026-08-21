<script setup>
    import { ref,} from 'vue'
    import { storeToRefs } from 'pinia'
    import { useAuthStore } from '@stores/authStore'
    import { useGamesPagination } from '@composables/pagination/useGamesPagination'
    import { useRouter } from 'vue-router'

    import GameCard from '@components/games/GameCard.vue'
    import GameSlider from '@components/games/GameSlider.vue'
    import GameRequest from '@components/games/GameRequest.vue'
    import GameFilter from '@components/games/GameFilter.vue'
    import GameSort from '@components/games/GameSort.vue'
    import NavigationBlock from '@components/common/NavigationBlock.vue'
    import ViewToggle from '@components/common/ViewToggle.vue'
    import Pagination from '@components/pagination/Pagination.vue'

    const router = useRouter()
    const authStore = useAuthStore()
    const { isAuthenticated, user } = storeToRefs(authStore)

    const formatCatalog = ref('grid')

    const {
        games,
        totalPages,
        isLoading,
        currentPage,
        currentSort,
        navigate,
        applyFilters,
        buildPageUrl
    } = useGamesPagination({
        perPage: 35
    })

    // Запросы добавления игры
    const isRequest = ref(false)

    const showRequestForm = () => {
        if(user.value?.role === 4) {
            router.push('/game/add')
        } else {
            isRequest.value = true
        }
    }

</script>

<template>
    <Transition name="fade">
    <div class="container flex-column">
        <GameRequest v-model="isRequest" />
        <GameSlider />
        <div class="content flex-column">

            <NavigationBlock />
            <GameFilter @apply="applyFilters"/>

            <div class="content__wrapper flex-column">

                <div class="content__wrapper-header flex-column">
                    <span class="content__wrapper-label">Каталог игр</span>

                    <div class="content__wrapper-sort flex">
                        <GameSort :sort="currentSort" @selected="(value) => navigate({ sort: value, page: 1 })" />
                        <div class="flex align-c" style="width: 100%; gap: var(--gp-16); mar">
                            <div v-if="isAuthenticated" class="content__wrapper-request flex">
                                <button @click="showRequestForm" type="button" class="request__btn no-border flex align-c">
                                    <svg class="request__icon">
                                        <use href="#icon-plus"></use>
                                    </svg>
                                    Добавить игру
                                </button>
                            </div>
                            <ViewToggle :currentFormat="formatCatalog" @toggled="(val) => formatCatalog = val" style="margin-left: auto;"/>
                        </div>
                    </div>
                </div>

                <div v-if="!games.length">
                    <span style="font-family: Roboto_Medium; font-size: 24px;">Игр пока что нет</span>
                </div>

                <div class="catalog" :class="formatCatalog">
                    <GameCard
                        v-for="game in games"
                        :key="game.idGame"
                        :id="game.idGame"
                        :name="game.name"
                        :cover="game.cover_url"
                        :ratingOverall="game.rating_overall"
                        :counterRating="game.rating_counter"
                        :releaseDate="game.release_date"
                        :platforms="game.platforms"
                        :tags="game.tags"
                        :format="formatCatalog"
                        :user-rating="game.user_rating"
                        :user-collection="game.collection_type"
                    />
                </div>

                <Pagination 
                    :totalPages="totalPages"
                    :isLoading="isLoading"
                    :currentPage="currentPage"
                    :build-page-url="buildPageUrl" 
                />

            </div>
        </div>
    </div>
    </Transition>
</template>

<style lang="scss" scoped>

    .container {
        width: 100%;
        position: relative;
        background-color: var(--bg-secondary-25);
        border-radius: 8px 8px 0px 0px;
        overflow: hidden;
        gap: var(--gp-32);

        @media (max-width:1160px) {
            border-radius: 0px;
        }

        @media (max-width:600px) {
            gap: var(--gp-24);
        }
    
    }

    /* Контент блок */

    .content {
        width: 100%;
        padding-inline: 32px;
        padding-bottom: 32px;
        gap: var(--gp-32);

        @media (max-width:768px) {
            padding-inline: 24px;
        }

        @media (max-width:600px) {
            padding-inline: 16px;
        }
    
        &__wrapper {
            width: 100%;
            gap: var(--gp-32);

            &-header {
                width: 100%;
                gap: var(--gp-24);

                @media (max-width:600px) {
                    gap: var(--gp-16);
                }
            }

            &-label {
                font-family: Roboto_SemiBold;
                font-size: 32px;
            }

            &-sort {
                width: 100%;
                gap: var(--gp-32);

                @media (max-width:600px) {
                    gap: var(--gp-16);
                    flex-direction: column;
                }
            }

            &-request {
                width: 100%;

                .request__btn {
                    width: fit-content;
                    font-family: Roboto_Medium;
                    gap: var(--gp-8);
                    color: var(--font-primary-75);

                    &:hover{color: var(--font-primary);}
                }   

                .request__icon {
                    width: 12px;
                    height: 12px;
                    color: currentColor;
                }
            }
        }
    }

    /* Каталог с играми */

    .catalog {
        width: 100%;
        gap: var(--gp-32);

        &.grid {
            display: grid;
            height: 100%;
            grid-template-columns: repeat(5, 1fr);

            @media (max-width:1060px) {
                grid-template-columns: repeat(4, 1fr);
                gap: var(--gp-24);
            }

            @media (max-width:768px) {
                grid-template-columns: repeat(3, 1fr)
            }

            @media (max-width:500px) {
                grid-template-columns: repeat(2, 1fr);
                gap: var(--gp-16);
            }
        }

        &.list {
            display: flex;
            flex-direction: column;
        }
    }

</style>