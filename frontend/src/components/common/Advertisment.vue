<script setup>

</script>

<template>
    <div class="advertisment flex-column">
        <RouterLink to="/contact" class="advertisment__place-btn">Разместить рекламу</RouterLink>
    </div>
</template>

<style lang="scss" scoped>
    .advertisment {
        max-width: 300px;
        width: 100%;
        min-width: 284px;
        margin-bottom: auto;

        @media (max-width:1160px) {
            margin: 0 auto;
        }

        &__place-btn {
            font-size: 16px;
            font-family: Roboto_Medium;
            background-color: var(--btn-color-6-25);
            padding-block: 14px;
            border-radius: 8px;
            text-align: center;

            &:hover {
                background-color: var(--btn-color-6-50);
            }

            @media (max-width:1160px) {
                display: none;
            }
        }
    }
</style>
