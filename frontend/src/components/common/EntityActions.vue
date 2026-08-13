<script setup>
    import { ref, onMounted, onUnmounted } from 'vue'
    import { storeToRefs } from 'pinia';
    import { useAuthStore } from '@stores/authStore'
    import { useApiNotifications } from '@composables/useApi';
    import { useRoute, useRouter } from 'vue-router'
    import api from '@utils/axios'

    import ConfirmPopUp from '@components/popups/ConfirmPopUp.vue';

    const authStore = useAuthStore() 
    const { user } = storeToRefs(authStore)
    const { apiCall } = useApiNotifications()
    const route = useRoute()
    const router = useRouter()

    const props = defineProps({
        entity: {
            type: String,
            required: true,
            validator: v => ['article', 'news'].includes(v),
        }
    })

    const emits = defineEmits(['isEdit'])

    const redirectUrl = props.entity === 'article' ? 'articles' : 'news'
    const label = props.entity === 'article' ? 'статью' : 'новость'

    const isMenu = ref(false)
    const toggleMenu = () => isMenu.value = !isMenu.value

    const closeMenu = (event) => {
        if (!event.target.closest('.action')) {
            isMenu.value = false
        }
    }

    const isVisiblePopup = ref(false)
    
    const onConfirmDelete = () => isVisiblePopup.value = true

    const handleDelete = async() => {   
        const data = await apiCall(() => api.delete(`${props.entity}/${route.params.id}/delete`), 'Запись удалена')
        if(data.status === 204) {
            await router.push(`/${redirectUrl}`)
        }           
    }
    
    onUnmounted(() => {
        document.removeEventListener('click', closeMenu)
    })

    onMounted(() => {
        document.addEventListener('click', closeMenu)
    })
</script>

<template>
    <div v-if="user?.role === 2 || user?.role === 4" class="action flex">
        <button type="button" class="no-border action__btn" @click="toggleMenu">
            ...
        </button>
        <div v-if="isMenu" class="dropdown-menu">
            <button class="dropdown-menu__item no-border" @click="emits('isEdit')">Редактировать</button>
            <button class="dropdown-menu__item danger no-border" @click="onConfirmDelete">Удалить</button>
        </div>
        <ConfirmPopUp 
            v-model="isVisiblePopup"
            :label="label" 
            @confirm="handleDelete"
        />
    </div>
</template>

<style lang="scss" scoped>

    .action {
        position: relative;
        width: fit-content;
        height: fit-content;
        background-color: #1B1C21;
        justify-content: right;
        align-items: flex-start;

        &__btn {
            width: 32px;
            height: 32px;
            background-color: var(--color-1);
            border-radius:4px;

            &:hover {
                filter: brightness(1.25);
            }
        }
    }

    .dropdown-menu {
        width: fit-content;
        position: absolute;
        top: 0%;
        right: 48px;
        background-color: var(--color-1);
        border-radius: 4px;
        z-index: 1000;
        opacity: 0;
        transform: translateX(48px);
        animation: slideDown 0.3s ease forwards;

        @keyframes slideDown {
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }

        &__item {
            width: 100%;
            padding: 12px 16px;
            color: #fff;
            text-align: left;
            font-size: 14px;
            font-family: Roboto_Regular;
            transition: background-color 0.2s;

            &:hover {background-color: #40444b;}
            &.danger {
                border-top: 1px solid #40444b;
                color: #ff6b6b;

                &:hover {
                    background-color: #ff6b6b;
                    color: #fff;
                }
            }
        }
    }


</style>