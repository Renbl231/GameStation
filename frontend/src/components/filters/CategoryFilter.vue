<script setup>
    import { computed } from 'vue'
    import { storeToRefs } from 'pinia'
    import { useAuthStore } from '@stores/authStore'

    const authStore = useAuthStore()
    const { user } = storeToRefs(authStore)

    const props = defineProps({
        categories: Array,
        currentCategory: {
            type: String,
            default: 'all'
        },
        type: {
            type: String,
            required: false,
            validator: (value) => ['articles', 'news'].includes(value)
        }
    })

    const emits = defineEmits(['changed'])
    
    const changeCategory = (slug) => {
        emits('changed', slug)
    }

    const createLink = computed(() => {
        return props.type === 'articles' ? '/article/create' : '/news/create'
    })
</script>

<template>

    <div class="filter flex-column">
        <span v-show="props.type" class="filter__label">{{ props.type === 'articles' ? 'Статьи' : 'Новости' }}</span>
        <div class="filter__categories flex align-c">
            <button v-for="category in categories" type="button" @click="changeCategory(category.slug)" :class="{ active: props.currentCategory === category.slug }" class="category no-border">
                {{ category.name }}
            </button>
            <RouterLink 
                v-if="user?.role === 2 || user?.role === 4" 
                class="category" 
                :to="createLink"
            >
                Создать {{ props.type === 'articles' ? 'статью' : 'новость' }}
            </RouterLink>
        </div>
    </div>
</template>

<style lang="scss" scoped>
    .filter {
        width: 100%;
        gap: var(--gp-16);

        @media (max-width:1024px) {
            max-width: none;
        }

        &__label {
            font-size: 32px;
            font-family: Roboto_SemiBold;
            color: var(--text-primary);

            @media (max-width:600px) {
                font-size: 24px;
            }
        }

        &__categories {
            gap: var(--gp-10);
            flex-wrap: wrap;
        }

        .category {
            font-size: 18px;
            font-family: Roboto_Medium;
            color: var(--text-quaternary);
            background-color: var(--btn-category);
            border-radius: 4px;
            padding: 6px 12px;

            @media (max-width:600px) {
                font-size: 16px;
                padding: 4px 10px;
            }

            &.active,
            &:hover {
                color: var(--font-primary);
                background-color: var(--color-green);
            }
        }
    }
</style>