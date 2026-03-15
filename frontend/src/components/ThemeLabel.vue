<script setup>
    const props = defineProps({
        label: String,
        btmInfo: {
            type: [Object],
            default: () => ({})
        },
        isEditable: Boolean

    })
    
</script>

<template>
    <div class="label-block flex-column">
        <span v-if="!props.isEditable" class="label-selection">
            {{ label }}
        </span>
        
        <span 
            v-else
            class="label-selection"
            contenteditable="true"
            spellcheck="false"
            @input="$emit('update:label', $event.target.textContent)"
            @keydown.enter.exact.prevent="$emit('save', $event.target.textContent)"
            @blur="$emit('save', $event.target.textContent)"
        >
            {{ label }}
        </span>
        <div class="bottom-info flex align-c">
            <span>{{ btmInfo.date }} |</span>
            <span>{{ btmInfo.theme }}</span>
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