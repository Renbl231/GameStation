<script setup>
    import { ref, watch } from 'vue'

    const emits = defineEmits(['selected'])

    const props = defineProps({
        sort: {
            type: String,
            default: 'recently'
        }
    })
    const selectedSort = ref(props.sort)

    watch(selectedSort, (newVal) => {
        emits('selected', newVal)
    })

</script>

<template>
    <div class="sort flex align-c">
        <select v-model="selectedSort" class="sort__select no-border">
            <option value="recently" selected>
                Недавно добавленные
            </option>
            <option value="rating">
                По рейтингу
            </option>
            <option value="popularity">
                По популярности
            </option>
            <option value="editors-estimate">
                По оценке редакции
            </option>
            <option value="expected">
                Самые ожидаемые
            </option>
                <option value="aplhabet">
                По алфавиту
            </option>
        </select>
    </div>
</template>

<style lang="scss" scoped>
    .sort {
        width: fit-content;
        gap: var(--gp-32);

        @media (max-width:425px) {
            width: 100%;
        }

        &__select {
            width: fit-content;
            overflow: hidden;
            text-overflow: ellipsis;
            white-space: nowrap;
            cursor: pointer;
            appearance: none;
            background: url('../assets/icons/arrow.svg') no-repeat right 16px center;
            background-size: 12px;
            padding-right: 36px !important; 
            border-radius: 4px;
            background-color: var(--bg-secondary-25);
            border: 1.5px solid var(--btn-color-4);
            padding: 8px 12px;
            font-size: 16px;
            color: var(--font-primary-75);
            font-family: Roboto_Medium;
            
            @media (max-width:425px) {
                width: 100%;
            }

            option {
                color: #fff;
                background: #242428;
                font-size: 16px;
                font-family: Roboto_Regular;
            }
        }
    }

</style>