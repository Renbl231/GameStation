<script setup>
    const props = defineProps({
        modelValue: Boolean
    })

    const emit = defineEmits(['update:modelValue', 'confirm'])

    const handleBtn = (type) => {
        emit('update:modelValue', false)
        
        if(type === 'confirm') {
            emit('confirm')
        }
    }
</script>

<template>
    <div v-if="modelValue" class="confirm-popup flex-center">
        <div class="confirm-popup__inner flex-column">
            <div class="confirm-popup__title">
                Вы действительно хотите удалить комментарий?
            </div>
            <div class="confirm-popup__buttons flex" style="gap: 10px">
                <button type="button" class="confirm-popup__btn no-border" @click="handleBtn('cancel')">Отмена</button>
                <button type="button" class="confirm-popup__btn no-border" @click="handleBtn('confirm')">Удалить</button>
            </div>
        </div>
    </div>

</template>

<style scoped>
    

    .confirm-popup {
        position: fixed;
        top: 0;
        bottom: 0;
        left: 0;
        right: 0;
        width: 100%;
        height: 100%;
        background-color: #00000075;
        z-index: 1000;
    }

    .confirm-popup__inner {
        max-width: 300px;
        width: 100%;
        padding: 32px 24px;
        background-color: #101010;
        border-radius: 8px;
        position: relative;
        gap: var(--gp-10);
    }

    .confirm-popup__btn {
        background-color: var(--btn-color-1) !important;
        border-radius: 8px;
        padding: 8px 16px;
        font-family: Roboto_SemiBold;
    }

</style>