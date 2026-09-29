<script setup>
    import { ref } from 'vue'
    import { storeToRefs } from 'pinia'
    import { useAuthStore } from '@stores/authStore'
    import { useModeration } from '@composables/useModeration'

    const authStore = useAuthStore()
    const { user } = storeToRefs(authStore)
    const { canModerate, moderateRole, moderateUnblock } = useModeration()

    const props = defineProps({
        idUser: Number
    })

    const emits = defineEmits(['change', 'ban'])

    const unblockCategory = ref('')
    const blockCategory = ref('')
    const newUserRole = ref(null)

    const handleChangeUserRole = async () => {
        if(!canModerate(props.idUser)) return

        const role = await moderateRole(props.idUser, newUserRole.value)
        emits('change', role)
        
    }

    const handleUnblockUser = async () => {
        if(!canModerate(props.idUser)) return
        await moderateUnblock(props.idUser, unblockCategory.value)
    }

    const handleBanUser = async () => {
        if(!canModerate(props.idUser) || !blockCategory.value) return
        emits('ban', blockCategory.value)
    }

   
</script>

<template>
    <div class="moderation-panel flex-center">
        <div class="mod-card mod-card--success flex-column">
            <div class="mod-card__header flex align-c">
                <span class="mod-card__icon flex-center">🔓</span>
                <span class="mod-card__title">Разблокировать</span>
            </div>

            <div class="mod-card__body flex align-c">
                <select v-model="unblockCategory" class="mod-card__select">
                    <option value="" disabled hidden>Категория</option>
                    <option value="profile">Медиа профиля</option>
                    <option value="comment">Комментарии</option>
                    <option value="review">Рецензии</option>
                    <option value="question">Обсуждения</option>
                </select>

                <button @click="handleUnblockUser" class="mod-card__btn flex-center mod-card__btn--success">
                    Разблокировать
                </button>
            </div>
        </div>

        <div v-if="user.role === 4" class="mod-card mod-card--primary flex-column">
            <div class="mod-card__header flex align-c">
                <span class="mod-card__icon flex-center">👑</span>
                <span class="mod-card__title">Изменить роль</span>
            </div>

            <div class="mod-card__body flex align-c">
                <select v-model="newUserRole" class="mod-card__select">
                    <option value="null" disabled hidden>Роль</option>
                    <option value="1">Пользователь</option>
                    <option value="2">Новостник</option>
                    <option value="3">Модератор</option>
                    <option value="4">Администратор</option>
                </select>

                <button @click="handleChangeUserRole" class="mod-card__btn flex-center mod-card__btn--primary">
                    Применить
                </button>
            </div>
        </div>

        <div class="mod-card mod-card--danger flex-column">
            <div class="mod-card__header flex align-c">
                <span class="mod-card__icon flex-center">🚫</span>
                <span class="mod-card__title">Заблокировать</span>
            </div>

            <div class="mod-card__body flex align-c">
                <select v-model="blockCategory" class="mod-card__select">
                    <option value="" disabled hidden>Категория</option>
                    <option value="profile">Медиа профиля</option>
                    <option value="comment">Комментарии</option>
                    <option value="review">Рецензии</option>
                    <option value="question">Обсуждения</option>
                </select>

                <button @click="handleBanUser" type="button" class="mod-card__btn flex-center mod-card__btn--danger">
                    Заблокировать
                </button>
            </div>
        </div>
    </div>
</template>

<style lang="scss" scoped>
    .moderation-panel {
        gap: var(--gp-16);
        max-width: 1072px;
        padding: 20px;
        background-color: var(--bg-tertiary);
        border: 1px solid var(--bg-secondary-border);
        border-radius: 16px;
        margin: 0 auto;
    }

    .mod-card {
        position: relative;
        gap: var(--gp-12);
        padding: 16px;
        background-color: var(--bg-secondary);
        border: 1px solid var(--bg-secondary-border);
        border-radius: 14px;
        overflow: hidden;
        transition: all 0.35s cubic-bezier(0.4, 0, 0.2, 1);

        &::after {
            content: '';
            position: absolute;
            top: -40%;
            left: -10%;
            width: 200px;
            height: 200px;
            border-radius: 50%;
            filter: blur(60px);
            opacity: 0.15;
            pointer-events: none;
            transition: opacity 0.35s ease;
            z-index: 0;
        }

        &:hover::after {
            opacity: 0.3;
        }

        &--success {
            &::after  { 
                background: radial-gradient(circle, var(--color-green), transparent 70%);
            }

            &:hover {
                border-color: rgba(46, 204, 113, 0.3);
                box-shadow:
                    0 0 0 1px rgba(46, 204, 113, 0.15),
                    0 8px 24px rgba(46, 204, 113, 0.12);
            }

            .mod-card__icon {
                background: rgba(46, 204, 113, 0.15);
                color: var(--color-green)
            }

            .mod-card__title { 
                color: var(--color-green);
            }
        }


        &--primary {
            &::after  { background: radial-gradient(circle, var(--color-blue), transparent 70%); }

            &:hover {
                border-color: rgba(74, 144, 226, 0.3);
                box-shadow:
                    0 0 0 1px rgba(74, 144, 226, 0.15),
                    0 8px 24px rgba(74, 144, 226, 0.12);
            }

            .mod-card__icon {
                background: rgba(74, 144, 226, 0.15);
                color: var(--color-blue)
            }

            .mod-card__title { 
                color: var(--color-blue)
            }
        }

        &--danger {
            &::after  { background: radial-gradient(circle, #e74c3c, transparent 70%); }

            &:hover {
                border-color: rgba(231, 76, 60, 0.3);
                box-shadow:
                    0 0 0 1px rgba(231, 76, 60, 0.15),
                    0 8px 24px rgba(231, 76, 60, 0.15);
            }

            .mod-card__icon {
                background: rgba(231, 76, 60, 0.15);
                color: #e74c3c
            }

            .mod-card__title { 
                color: #e74c3c
            }
        }

        &__header {
            gap: var(--gp-10);
            position: relative;
            z-index: 1;
        }

        &__icon {
            width: 32px;
            height: 32px;
            font-size: 15px;
            border-radius: 8px;
            transition: all 0.3s ease;
        }

        &__title {
            font-family: Roboto_Medium, sans-serif;
            font-size: 14px;
            letter-spacing: 0.3px;
            transition: color 0.3s ease;
        }

        &__body {
            gap: var(--gp-12);
            position: relative;
            z-index: 1;

            @media (max-width: 600px) {
                flex-direction: column;
                align-items: stretch;
            }
        }

        &__select {
            flex: 1;
            min-width: 160px;
            padding: 10px 36px 10px 14px;

            background: rgba(0, 0, 0, 0.25);
            border: 1px solid rgba(255, 255, 255, 0.08);
            border-radius: 10px;

            color: var(--color-white);
            font-family: Roboto_Regular, sans-serif;
            font-size: 14px;

            cursor: pointer;
            outline: none;
            appearance: none;
            transition: all 0.25s ease;

            background-image: url("data:image/svg+xml;utf8,<svg xmlns='http://www.w3.org/2000/svg' width='20' height='20' viewBox='0 0 24 24' fill='none' stroke='%23FFF' stroke-width='2'><polyline points='6 9 12 15 18 9'/></svg>");
            background-repeat: no-repeat;
            background-position: right 12px center;

            &:hover {
                border-color: rgba(255, 255, 255, 0.15);
            }

            &:focus {
                background-color: rgba(0, 0, 0, 0.4);
            }

            option {
                background: var(--bg-secondary);
                color: var(--text-primary);
                padding: 8px;
            }
        }

        &__btn {
            position: relative;
            padding: 10px 22px;
            border-radius: 10px;
            overflow: hidden;
            font-family: Roboto_Medium, sans-serif;
            font-size: 13px;
            color: var(--color-white);
            border: none;
            cursor: pointer;
            transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);


            &--success {
                background: linear-gradient(0deg, var(--color-green), var(--color-green-hover));
                box-shadow:
                    0 4px 12px rgba(46, 204, 113, 0.3),
                    inset 0 1px 0 rgba(255, 255, 255, 0.2);

                &:hover {
                    transform: translateY(-2px);
                    box-shadow:
                        0 8px 24px rgba(46, 204, 113, 0.5),
                        inset 0 1px 0 rgba(255, 255, 255, 0.3);
                }
            }

            &--primary {
                background: linear-gradient(135deg, var(--color-blue), var(--color-blue-hover));
                box-shadow:
                    0 4px 12px rgba(74, 144, 226, 0.3),
                    inset 0 1px 0 rgba(255, 255, 255, 0.2);

                &:hover {
                    transform: translateY(-2px);
                    box-shadow:
                        0 8px 24px rgba(74, 144, 226, 0.5),
                        inset 0 1px 0 rgba(255, 255, 255, 0.3);
                }
            }

            &--danger {
                background: linear-gradient(135deg, #e74c3c, #c0392b);
                box-shadow:
                    0 4px 12px rgba(231, 76, 60, 0.3),
                    inset 0 1px 0 rgba(255, 255, 255, 0.2);

                &:hover {
                    transform: translateY(-2px);
                    box-shadow:
                        0 8px 24px rgba(231, 76, 60, 0.5),
                        inset 0 1px 0 rgba(255, 255, 255, 0.3);
                }
            }
        }
    }
</style>