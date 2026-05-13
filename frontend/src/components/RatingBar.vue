<script setup>
    import { ref, computed } from 'vue'
    const props = defineProps({
        name: {
            type: String,
            default: ''
        },
        score: {
            type: Number,
            default: 0
        }
    })

    const progressWidth = computed(() => 
    `${props.score * 10}%`
    )
</script>


<template>
    <div class="rating-bar flex-column">
        <div class="parametr-block flex align-c justify-sb">
            <span class="name-parametr">{{ props.name }}</span>
            <span class="score-parametr">{{ props.score }}</span>
        </div>
        <div class="rating-bottom">
            <div class="bar-progress" :style="{ width: progressWidth }"></div>
        </div>
    </div>
</template>


<style scoped>
    .rating-bar {
        padding: 10px 8px 16px 8px;
        background-color: rgba(0, 0, 0, 0.5);
        border-radius: 8px;
        gap: var(--gp-12);
        border-top: 2px solid var(--font-secondary)
 
    }

    .name-parametr {
        font-size: 16px;
        font-family: Roboto_Medium;
    }

    .score-parametr {
        font-size: 20px;
        font-family: Roboto_Bold;
        color: var(--font-secondary);
        text-shadow: 0px 0px 4px rgba(0, 111, 255, 0.5);
    }

    .rating-bottom {
        width: 100%;
        background-color: var(--btn-color-6-25);
        border-radius: 256px;
        height: 8px;
    }

    .bar-progress {
        width: 50%;
        background: linear-gradient(to right, #006FFF 0%, #4B99FF 100%);
        border-radius: 256px;
        height: inherit;
    }

    @media (max-width:600px) {
        .name-parametr {
            font-size: 14px;
        }

        .score-parametr {
            font-size: 16px;
        }

        .rating-bar {
            gap: var(--gp-8);
        }
    }

</style>