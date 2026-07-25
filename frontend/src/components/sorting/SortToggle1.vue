<script setup>
    import { ref } from 'vue'
    const props = defineProps({
        currentSort: {
            type: String,
            default: 'new',
            validator: (value) => ['new', 'popular'].includes(value)
        }
    })
    const emits = defineEmits(['toggled'])
    const currentSort = ref(props.currentSort)
    
    const toggled = (sort) => {
        emits('toggled', sort)
        currentSort.value = sort
    }
</script>

<template>
    <div class="sort flex align-c">
        <button type="button" @click="toggled('new')" :class="{active: currentSort === 'new'}" class="sort__item no-border">
            Новые
        </button>
        <button type="button" @click="toggled('popular')" :class="{active: currentSort === 'popular'}"class="sort__item no-border">
            Популярные
        </button>
    </div>
</template>

<style lang="scss" scoped>
    .sort {
        gap: var(--gp-24);

        @media (max-width:375px) {
            gap: var(--gp-16);
        }

        &__item {
            position: relative;
            font-size: 20px;
            font-family: Roboto_SemiBold;
            color: var(--text-muted);

            &.active,
            &:hover {
                color: var(--text-primary);
            }

            &.active::after {
                content: '';
                position: absolute;
                top: 100%;
                left: 0;
                right: 0;
                border-bottom: 2px solid var(--color-blue);
                padding-bottom: 11px;

                @media (max-width:425px) {
                    padding-bottom:10px;
                }

                @media (max-width:375px) {
                    font-size: 18px;
                }
            }

            @media (max-width:425px) {
                font-size: 18px;
            }

        }
    }
</style>