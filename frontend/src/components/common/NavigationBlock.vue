<template>
    <nav class="navigation flex align-c">
        <RouterLink 
        to="/games" 
        class="navigation__link" 
        :class="{ 'active': $route.path === '/games' || $route.path.startsWith('/games/') && !$route.path.includes('/selections') && !$route.path.includes('/reviews') }"
        >Каталог</RouterLink>

        <RouterLink 
        to="/games/selections" 
        class="navigation__link" 
        :class="{ 'active': $route.path.startsWith('/games/selections') }"
        >Подборки</RouterLink>

        <RouterLink 
        to="/games/reviews" 
        class="navigation__link" 
        :class="{ 'active': $route.path.startsWith('/games/reviews') }"
        >Рецензии</RouterLink>
    </nav>
</template>

<style lang="scss" scoped>
    .navigation {
        width: 100%;
        gap: var(--gp-16);

        &__link {
            width: fit-content;
            background-color: var(--color-dark-200);
            border-radius: 4px;
            padding: 8px 16px;
            color: var(--text-muted);
            font-family: Roboto_SemiBold;
            font-size: 18px;

            &:hover,
            &.active {
                background-color: var(--color-blue);
                color: var(--font-primary);
            }
        }
    }

</style>