<script setup>
    import { ref } from 'vue'
    import { useNotifications } from '../stores/notifications';
    import { useApiNotifications } from '../composables/useApi';
    import api from '../utils/axios'
    const { apiCall } = useApiNotifications()
    const notification = useNotifications()

    const props = defineProps({
        modelValue: Boolean,
        nickname: String,
        type: String,
        user_id: Number,
        entity_id: {
            type: Number,
            default: null
        },
        text: String,
    })

    const emit = defineEmits(['update:modelValue', 'reloadComments', 'redirectToPage'])

    const handleBtn = (value) => {
        emit('update:modelValue', false)
        emit('reloadComments', value)
        emit('redirectToPage', value)
    }

    // Поля

    const banDays = ref('1')
    const reason = ref("")

    const blockUser = async () => {
        if(banDays.value === null || !reason.value) {
            notification.warning('Заполните все поля')
            return
        }
        const data = await apiCall(() => api.post('/user-restrictions', {
            type: props.type,
            user_id: props.user_id,
            banDays: banDays.value,
            reason: reason.value,
            entity_id: props.entity_id
        }))

        if (data?.success) {
            handleBtn(true)
        } else {
            handleBtn(false)
        }
    }

</script>

<template>
    <Transition name="popup-slide">
        <div v-if="modelValue" class="ban-popup flex-center">
            <div class="ban-popup__inner flex-column">
                <div class="ban-popup__title">
                    Заблокировать пользователю "{{ props.nickname }}" доступ к {{ props.text }}
                </div>
                <div class="confirm-popup-form flex-column">
                    <select v-model="banDays" class="no-border confirm-popup__select" placeholder="Выберите срок блокировки">
                        <option value="1">1 день</option>
                        <option value="3">3 дня</option>
                        <option value="7">7 дней</option>
                        <option value="14">14 дней</option>
                        <option value="30">30 дней</option>
                    </select>

                    <input v-model="reason" placeholder="Причина блокировки" class="no-border confirm-popup__input">
                </div>
                <div class="ban-popup__btns flex align-c">
                    <button type="button" class="ban-popup__btn ban-popup__btn-v2 no-border" @click="handleBtn(false)">
                        Отменить
                    </button>
                    <button type="button" class="ban-popup__btn no-border" @click="blockUser">
                        Заблокировать
                    </button>
                </div>
            </div>
        </div>
    </Transition>
</template>

<style scoped>

     .ban-popup {
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

    .confirm-popup-form {
        width: 100%;
        gap: var(--gp-12);
    }

    .ban-popup__inner {
        max-width: 350px;
        width: 100%;
        padding: 32px 24px;
        background-color: var(--color-2);
        border-radius: 8px;
        gap: var(--gp-24);
        border: 1px solid var(--bg-secondary-50);
    }

    .ban-popup__title {
        font-size: 18px;
        font-family: Roboto_SemiBold;
        color: var(--font-primary-75);
        text-align: center;
    }

    .ban-popup__btns {
        gap: var(--gp-10);
        margin-left: auto;
    }

    .confirm-popup__select {
        background-color: var(--bg-secondary-50);
        border-radius: 4px;
        padding: 6px 8px;
        font-family: Roboto_Medium;
    }

    .confirm-popup__input {
        font-family: Roboto_Medium;
        padding: 6px 8px;
        background-color: var(--bg-secondary-50);
        border-radius: 4px;
    }

    .confirm-popup__select option {
        color: #fff;
        background: #1B1C21;
        font-size: 16px;
    }

    .ban-popup__btn {
        background-color: var(--btn-color-1);
        border-radius: 4px;
        padding: 6px 12px;
        font-family: Roboto_Medium;
        font-size: 14px;
    }
    .ban-popup__btn:hover {
        background-color: var(--btn-color-2);
    }
    .ban-popup__btn-v2 {
        background-color: var(--bg-secondary-50);
    }
     .ban-popup__btn-v2:hover {
        background-color: var(--bg-secondary);
    }

    /* Анимка */
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