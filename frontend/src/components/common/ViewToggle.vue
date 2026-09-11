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
        <button @click="handleToggle('grid')" type="button" class="switcher__btn switcher__btn-grid no-border flex-center">
            <svg class="switcher__icon" :class="{'active': currentFormat === 'grid'}"><use href="#grid-block"></use></svg>
        </button>
        <button @click="handleToggle('list')" type="button" class="switcher__btn switcher__btn-list no-border flex-center">
            <svg class="switcher__icon" :class="{'active': currentFormat === 'list'}"><use href="#list-block"></use></svg>
        </button>
    </div>
</template>

<style scoped lang="scss">
    .switcher {
        gap: var(--gp-10);
        &__btn {
            width: 28px;
            height: 28px;
        }

        &__icon {
            color: var(--viewToggle-btn);
            width: inherit;
            height: inherit;

            &:hover {color: var(--viewToggle-btn-hover);}
            &.active {color: var(--viewToggle-btn-active);}
        }
    }
</style>