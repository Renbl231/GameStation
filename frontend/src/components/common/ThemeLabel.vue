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
    <div class="lable flex-column">
        <span class="lable__span">
            {{ props.label }}
        </span>
        <div class="lable__bottom flex align-c">
            <span>{{ props.btmInfo.date }} |</span>
            <span>{{ props.btmInfo.theme }}</span>
        </div>
    </div>
</template>

<style lang="scss" scoped>
    .lable {
        gap: var(--gp-16);

        &__span {
            color: var(--text-primary);
            font-size: 36px;
            line-height: 1.2;
            font-family: Roboto_Bold;

            @media (max-width:599px) {
                font-size: 28px;
            }

            @media (max-width:375px) {
                font-size: 24px;
            }
        }

        &__bottom {
            font-size: 24px;
            color: var(--text-muted);
            gap: var(--gp-10);

            @media (max-width:599px) {
                font-size: 20px;
                gap: var(--gp-8);
            }

            @media (max-width:375px) {
                font-size: 18px;
            }
        }
    }






</style>