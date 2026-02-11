<script setup>
    import ThemeCard from '../components/ThemeCard.vue'
</script>


<template>
    <div class="container flex-column">
        <div class="theme-bar flex-column">
            <h1>Сообщество</h1>
            <div class="theme-categories flex">
                <span class="category active">Ищу игру</span>
                <span class="category">Проблемы</span>
                <span class="category">Другое</span>
                <span class="category">Лор и сюжет</span>
                <span class="category">Прохождение</span>
                <span class="category">Системные требования</span>
                <span class="category">Моды</span>
                <span class="category">Мои вопросы (3)</span>
                <span class="category create-theme">Создать тему</span>
            </div>
        </div>
        <div class="sort-row flex">
            <span class="sort-type active">Открытые</span>
            <span class="sort-type">Закрытые</span>
        </div>
        <div class="theme-wrapper">
            <ThemeCard v-for="n in 4"
                :key="n" />
        </div>
    </div>
</template>

<style scoped>
    .container {
        width: 100%;
        background-color: var(--bg-secondary-25);
        border-radius: 8px;
        padding: 32px;
    }
    
    .theme-bar {
        gap: var(--gp-24);
        margin-bottom: 32px;
    }

    h1 {
        font-size: 32px;
        font-family: Roboto_SemiBold;
    }

    .theme-categories {
        width: 100%;
        flex-wrap: wrap;
        gap: var(--gp-16);
    }

    .category {
        font-size: 20px;
        font-family: Roboto_Medium;
        color: var(--font-primary-35);
        background-color: var(--btn-color-6-25);
        border-radius: 4px;
        padding: 6px 12px;
    }

    .category.active {
        color: var(--font-primary);
        background-color: var(--font-primary-35);
    }

    .create-theme {
        padding-inline: 24px;
        background-color: var(--btn-color-1);
        color: var(--font-primary);
    }

    .sort-row {
        gap: var(--gp-32);
        border-bottom: 2px solid var(--bg-secondary-50);
        padding-bottom: 8px;
    }

    .sort-type {
        position: relative;
        font-size: 24px;
        font-family: Roboto_SemiBold;
        color: var(--font-primary-50);
   }

   .sort-type.active {
        color: var(--font-primary);
   }

   .sort-type.active::after {
        content: '';
        position: absolute;
        top: 100%;
        left: 0;
        right: 0;
        border-bottom: 2px solid var(--font-secondary);
        padding-bottom: 8px;
   }

   .theme-wrapper {
        display: grid;
        grid-template-columns: repeat(3, 1fr);
        gap: var(--gp-24);
        margin-top: 24px;
   }

   @media (max-width:1160px) {
        .theme-wrapper {
            grid-template-columns: repeat(2, 1fr);
        }
        .container {
            border-radius: 0px;
        }
   }

    @media (max-width:600px) {
        .theme-wrapper {
            grid-template-columns: repeat(1, 1fr);
        }
        
        h1 {
            font-size: 24px;
        }

        .category {
            font-size: 18px;
        }

        .theme-categories {
            row-gap: var(--gp-16);
            column-gap: var(--gp-12);
        }

        .sort-row {
            gap: var(--gp-24);
        }
        .container {
            padding: 24px 16px;
        }
    }

    @media (max-width:425px) {
        .category {
            font-size: 16px;
        }
    }

     @media (max-width:375px) {
        .sort-row {
            gap: var(--gp-16);
        }
        .sort-type {
            font-size: 18px;
        }
    }
</style>