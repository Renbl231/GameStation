<script setup>
    import { useRoute } from 'vue-router';

    const route = useRoute()

    const props = defineProps({
        
    })
</script>

<template>
    <nav class="profile__navigation flex align-c">
        <RouterLink :to="`/user/${route.params.nickname}`" :class="{ active: !($route.path.includes('/games') || $route.path.includes('/reviews') || $route.path.includes('/comments') || $route.path.includes('/requests')) }" class="profile__navigation-item flex align-c">
            <svg class="profile__navigation-icon"><use href="#icon-home"></use></svg>
            Главная
        </RouterLink>
        <RouterLink :to="`/user/${route.params.nickname}/games`" :class="{'active': $route.path.includes('/games')}" class="profile__navigation-item flex align-c">
            <svg class="profile__navigation-icon" style="width: 20px; height: 20px;"><use href="#icon-gamepad"></use></svg>
            196 игр
        </RouterLink>
        <RouterLink :to="`/user/${route.params.nickname}/reviews`" :class="{'active': $route.path.includes('/reviews')}" class="profile__navigation-item flex align-c">
            <svg class="profile__navigation-icon"><use href="#icon-reviews"></use></svg>
            31 рецензий
        </RouterLink>
        <RouterLink :to="`/user/${route.params.nickname}/comments`" :class="{'active': $route.path.includes('/comments')}" class="profile__navigation-item flex align-c">
            <svg class="profile__navigation-icon"><use href="#icon-comment"></use></svg>
            0 комментариев
        </RouterLink>
        <RouterLink v-if="user?.id === userId" class="profile__navigation-item flex align-c">
            <svg class="profile__navigation-icon"><use href="#icon-publications"></use></svg>
            0 публикаций
        </RouterLink>
        <RouterLink v-if="user?.id === userId" :to="`/user/${route.params.nickname}/requests`" :class="{'active': $route.path.includes('/requests')}" class="profile__navigation-item flex align-c">
            <svg class="profile__navigation-icon"><use href="#icon-plus"></use></svg>
            92 запросов
        </RouterLink>
        <RouterLink to="/moderation" class="profile__navigation-item flex align-c">Модерация</RouterLink>
    </nav>
</template>

<style lang="scss" scoped>
    .profile__navigation {
        width: fit-content;
        gap: var(--gp-10);

        &-item {
            width: fit-content;
            background-color: var(--bg-secondary);
            border-radius: 8px;
            padding: 6px 8px;
            font-family: Roboto_Regular;
            font-size: 16px;
            color: var(--text-secondary);
            gap: var(--gp-6);

            &.active {
                color: var(--color-white);
            }
        }

        &-icon {
            fill: inherit;
            width: 16px;
            height: 16px;

            .active {
                fill: inherit
            }
        }
    }
</style>