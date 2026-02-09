<script setup>

</script>

<template>
    <div class="activity flex">
        <img src="/images/2.jpeg" class="game-img">
        <div class="activity-content flex-column">
            <span class="date-activity">18 сентребря 2025</span>
            <span class="type-activity">Добавил(а) <span class="name-game">Dishonored</span> в Любимые игры</span>
        </div>
    </div>
</template>

<style scoped>
    .activity {
        gap: var(--gp-24);
    }
    .game-img {
        width: 60px;
        height: 60px;
        border-radius: 8px;
    }
    .date-activity {
        font-size: 16px;
        color: var(--font-primary-50);
        margin-bottom: auto;
    }
    .type-activity {
        font-size: 20px;
        color: var(--font-primary-75);
    }
    .name-game {
        color: var(--font-primary);
    }

    @media (max-width:600px) {
        .activity {
            gap: var(--gp-12);
        }
        .game-img {
            width: 48px;
            height: 48px;
        }
        .type-activity {
            font-size: 16px;
        }
        .date-activity {
            font-size: 14px;
        }
    }

    @media (max-width:425px) {
        .date-activity {
            font-size: 12px;
        }
        .type-activity {
            font-size: 14px;
        }
    }

    @media (max-width:320px) {
        .type-activity {
            font-size: 12px;
        }
    }
</style>