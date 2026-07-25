<script setup>
    import { ref } from 'vue'
    
    const props = defineProps({
        currentFormat: {
            type: String,
            default: 'grid',
            validator: (value) => ['grid', 'list'].includes(value)
        }
    })

    const currentFormat = ref(props.currentFormat)
    const emits = defineEmits(['toggled'])

    const handleToggle = (format) => {
        currentFormat.value = format
        emits('toggled', format)
    } 
</script>

<template>
    <div class="switcher flex align-c">
        <button :class="{'active': currentFormat === 'grid'}" @click="handleToggle('grid')" type="button" class="switcher__btn switcher__btn-grid no-border flex-center">
            <svg class="switcher__icon"><use href="#grid-block"></use></svg>
        </button>
        <button :class="{'active': currentFormat === 'list'}" @click="handleToggle('list')" type="button" class="switcher__btn switcher__btn-list no-border flex-center">
            <svg class="switcher__icon"><use href="#list-block"></use></svg>
        </button>
    </div>
</template>

<style scoped lang="scss">
    .switcher {
        gap: var(--gp-12);

        &__btn {
            width: 36px;
            height: 36px;
            background-color: var(--btn-category);
            border-radius: 4px;

            &:hover {background-color: var(--btn-color-6-50);}
            &.active {background-color: var(--color-blue);}

            @media (max-width:425px) {
                width: 32px;
                height: 32px;
            }
        }

        &__icon {
            width: 22px;
            height: 22px;
        }
    }
</style>