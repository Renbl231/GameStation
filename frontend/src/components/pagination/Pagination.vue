<script setup>
    import { computed } from 'vue'

    const props = defineProps({
        totalPages: {
            type: Number,
            required: true
        },
        isLoading: {
            type: Boolean,
            required: true
        },
        currentPage: {
            type: Number,
            required: true
        },
        buildPageUrl: {
            type: Function,
            required: true,
        },
    })

    // функция чисто для отображения item
    const visiblePages = computed(() => {
        const pages = []
        const current = props.currentPage
        const total = props.totalPages
        
        if (total <= 5) {
            for (let i = 1; i <= total; i++) pages.push(i)
        } 
        else {
            pages.push(1)
            if (current > 3) pages.push('...')
            
            const start = Math.max(2, current - 1)
            const end = Math.min(total - 1, current + 1)
            
            for (let i = start; i <= end; i++) pages.push(i)
            
            if (current < total - 2) pages.push('...')
            if (pages[pages.length - 1] !== total) pages.push(total)
        }
        
        return pages
    })


</script>

<template>
    <div v-if="!isLoading" class="pagination flex-center">
        <RouterLink 
            :to="buildPageUrl(props.currentPage - 1)"
            class="pagination__item flex-center"
            :class="{ disabled: props.currentPage === 1 }"
            tabindex="0"
        >
            <svg class="icon-arrow prev"><use href="#icon-arrow"></use></svg>
        </RouterLink>

        <RouterLink 
            v-for="(page, index) in visiblePages" 
            :key="index"
            :to="page !== '...' ? buildPageUrl(page) : '#'"
            class="pagination__item flex-center"
            :class="{ 
                active: page === props.currentPage, 
                disabled: page === '...' 
            }"
            tabindex="0"
        >
            {{ page }}
        </RouterLink>

        <RouterLink 
            :to="buildPageUrl(props.currentPage + 1)"
            class="pagination__item flex-center"
            :class="{ disabled: props.currentPage === props.totalPages }"
            tabindex="0"
        >
            <svg class="icon-arrow next"><use href="#icon-arrow"></use></svg>
        </RouterLink>
    </div>
</template>

<style lang="scss" scoped>
    .pagination {
        width: 100%;
        margin: 0 auto;
        gap: var(--gp-12);
        font-size: 16px;
        font-family: Roboto_SemiBold;
        margin-top: 16px;

        &__item {
            background-color: var(--btn-color-6-25);
            border-radius: 128px;
            min-width: 40px;
            max-height: 40px;
            padding: 12px;
            transition: 0.3s;

            &:hover,
            &.active {
               background-color: var(--btn-color-2); 
            }
        }

        &__item:hover:not(.disabled) {
            background: var(--btn-color-2)
        }

        &__item.disabled {
            opacity: 0.5;
            cursor: not-allowed;
            pointer-events: none;
        }
    }

    .icon-arrow {
        width: 16px;
        height: 16px;
        stroke: var(--font-primary);
        transition: all 0.2s ease;

        &.prev {
            transform: rotate(90deg);
        }

        &.next {
            transform: rotate(270deg);
        }
    }

</style>