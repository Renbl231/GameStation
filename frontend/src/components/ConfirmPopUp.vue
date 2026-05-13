<script setup>
    const props = defineProps({
        modelValue: Boolean,
        label: String
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
    <Transition name="popup-slide">
        <div v-if="modelValue" class="confirm-popup flex-center">
            <div class="confirm-popup__inner flex-column">
                <div class="confirm-popup__title">
                    Удалить {{ label }} ?
                </div>
                <div class="confirm-popup__btns flex align-c">
                    <button type="button" class="confirm-popup__btn confirm-popup__btn-v1 no-border" @click="handleBtn('cancel')">
                        Отмена
                    </button>
                    <button type="button" class="confirm-popup__btn confirm-popup__btn-v2 no-border" @click="handleBtn('confirm')">
                        Удалить
                    </button>
                </div>
            </div>
        </div>
    </Transition>
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
        max-width: 350px;
        width: 100%;
        padding: 32px 24px;
        background-color: var(--color-2);
        border-radius: 8px;
        gap: var(--gp-24);
        border: 1px solid var(--bg-secondary-50);
    }

    .confirm-popup__title {
        font-size: 18px;
        font-family: Roboto_SemiBold;
        color: var(--font-primary-75);
    }

    .confirm-popup__btns {
        gap: var(--gp-10);
        margin-left: auto;
    }

    .confirm-popup__btn {
        background-color: var(--btn-color-1);
        border-radius: 4px;
        padding: 6px 12px;
        font-family: Roboto_Medium;
        font-size: 14px;
    }

    .confirm-popup__btn:nth-of-type(1) {
        background-color: var(--btn-color-6-25);
    }

    .confirm-popup__btn-v1:hover {
        background-color: var(--font-primary-25);
    }

    .confirm-popup__btn-v2:hover {
        filter: brightness(1.1);
    }

    .popup-slide-enter-active,
    .popup-slide-leave-active {
        transition: all 0.3s ease
    }

    .popup-slide-enter-from,
    .popup-slide-leave-to {
        opacity: 0;
        transform: translateY(80px);
    }

    .popup-slide-enter-to,
    .popup-slide-leave-from {
        opacity: 1;
        transform: translateY(0);
    }

</style>