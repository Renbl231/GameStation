<script setup>
    import { ref, } from 'vue'
    import { useNotifications } from '@stores/notifications'
    import { useApiNotifications } from '@composables/useApi'
    import api from '@utils/axios'
    
    const { apiCall } = useApiNotifications()

    const notification = useNotifications()

    const emits = defineEmits(['update:modelValue'])
    const props = defineProps({
        modelValue: {
            type: Boolean,
            default: false
        }
    })

    const requestForm = ref({
        nameGame: '',
        store_url: '',
    })

    const closePopUp = () => {
        requestForm.value.nameGame = ''
        requestForm.value.store_url = ''
        emits('update:modelValue', false)
    }
        
    const sendRequestGame = async () => {
        if(!requestForm.value.nameGame.trim()) {
            notification.warning('Укажите название игры')
            return
        }
        const data = await apiCall(() => api.post('/games/requestAdd', requestForm.value), 'Запрос отправлен')
        if(data.success) {
            closePopUp()
        }
    }


</script>

<template>
    <Transition name="popup-request">
        <div v-if="props.modelValue" class="request flex-center">
            <div class="request__wrapper flex-column">
                <div class="request__header flex align-c justify-sb">
                    <span class="request__label">Добавление игры</span>
                    <button @click="closePopUp" type="button" class="no-border request__closeBtn"></button>
                </div>
                <div class="request__block">
                    <input v-model="requestForm.nameGame" :class="{'active': requestForm.nameGame.length >= 3 }" type="text" class="no-border request__field" placeholder="Название игры"> 
                </div>
                <div class="request__blockk">
                    <input v-model="requestForm.store_url" type="text" class="no-border request__field" placeholder="Ссылка на страницу в магазине (STEAM, GOG, и т.п)"> 
                </div>
                <div class="request__block flex">
                    <button @click="sendRequestGame" type="button" class="no-border request__btn">Предложить игру</button> 
                </div>
            </div>
        </div>
    </Transition>
</template>

<style lang="scss" scoped>
    .request {
        position: fixed;
        top: 0;
        bottom: 0;
        left: 0;
        right: 0;
        width: 100%;
        height: 100%;
        background-color: #00000075;
        z-index: 1000;

        &__wrapper {
            position: absolute;
            max-width: 600px;
            width: 100%;
            padding: 32px;
            background-color: #181B1D;
            border-radius: 8px;
            gap: var(--gp-32);
            border: 1px solid var(--bg-secondary-50);
            top: 50%;
            transform: translateY(-50%)
        }

        &__header, &__block {
            width: 100%;
        }

        &__label {
            font-family: Roboto_SemiBold;
            font-size: 20px;
        }

        &__closeBtn {
            position: relative;
            width: 32px;
            height: 32px;
            cursor: pointer;

            &::before,
            &::after {
                content: '';
                position: absolute;
                top: 16px;
                left: 50%;
                width: 20px;
                height: 2px;
                background-color: var(--font-primary-50);
                transform: translate(-50%, -50%) rotate(45deg);
            }

            
            &:hover::after,
            &:hover::before{ background-color: var(--font-primary);}

            &::after {transform: translate(-50%, -50%) rotate(-45deg);}
        }

        &__btn {
            background-color: var(--color-blue);
            border-radius: 4px;
            padding: 8px 24px;
            font-family: Roboto_Medium;
        }

        &__field {
            width: 100%;
            background-color: var(--bg-secondary-25);
            padding: 10px 16px;
            border-radius: 8px;
            border-left: 3px solid var(--btn-color-2);
            color: var(--font-primary-75);
            font-family: Roboto_Medium;

            &.active {border-left: 3px solid var(--color-blue);}
            &::placeholder{color: var(--font-primary-25);}
        }

        
    }

    /* Анимация попАпа */
    .popup-request-enter-active,
    .popup-request-leave-active {
        transition: all 0.3s ease
    }

    .popup-request-enter-from,
    .popup-request-leave-to {
        opacity: 0;
        transform: translateY(80px);
    }

    .popup-request-enter-to,
    .popup-request-leave-from {
        opacity: 1;
        transform: translateY(0);
    }
</style>