<script setup>
    const props = defineProps({
        label: String,
        btmInfo: {
            type: [Object],
            default: () => ({})
        },
        
    })
    
</script>

<template>
    <div class="label-block flex-column">
        <span class="label-selection">
            {{ props.label }}
        </span>
        
        <div class="bottom-info flex align-c">
            <span>{{ props.btmInfo.date }} |</span>
            <span>{{ props.btmInfo.theme }}</span>
        </div>
    </div>
</template>

<style scoped>
    .label-block {
        gap: var(--gp-16);
    }

    .label-selection {
        font-size: 36px;
        line-height: 48px;
        font-family: Roboto_Bold;
    }

    .bottom-info {
        font-size: 24px;
        color: var(--font-primary-50);
        gap: var(--gp-10);
    }

    @media (max-width:599px) {
        .label-selection {
            font-size: 28px;
            line-height: 38px;
        }

        .bottom-info {
            font-size: 20px;
            gap: var(--gp-8);
        }
    }

    @media (max-width:375px) {
        .label-selection {
            font-size: 24px;
            line-height: 32px;
        }

        .bottom-info {
            font-size: 18px;
        }
    }
</style>