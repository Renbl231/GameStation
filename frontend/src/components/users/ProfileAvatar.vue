<script setup>
    import { ref, watch } from 'vue'
    import { useAuthStore } from '@stores/authStore'
    import { storeToRefs } from 'pinia'
    import { checkColorRole } from '@/utils/checkRole'
    import { onAvatarError } from '@/utils/helpers/onImageError'
    import { handleCrop } from '@/utils/helpers/cropper'
    import { onImageChange } from '@/utils/validators/validateImage'
    import { useModeration } from '@composables/useModeration'
    import { useApiNotifications } from '@composables/useApi'
    import api from '@utils/axios'

    import ConfirmPopUp from '@components/popups/ConfirmPopUp.vue';
    import Cropper from '@/components/common/Cropper.vue'

    const authStore = useAuthStore()
    const { user } = storeToRefs(authStore)
    const { apiCall } = useApiNotifications()
    const { moderateMedia, canModerate } = useModeration()


    const props = defineProps({
        avatar: {
            type: String,
            default: '/images/plug_avatar.png'
        },
        idUser: Number,
        userRole: Number,
        rating: Number,
    })

    const currentAvatar = ref(props.avatar)

    const isCrop = ref(false)
    const isConfirm = ref(false)

    const temporaryCrop = ref('')

    const onHandleCrop = async (croppedDataUrl) => {
        const result = handleCrop(croppedDataUrl)
        await updateAvatar(result.cover)
    }

    const onMainImageChange = (event) => {
        const result = onImageChange(event)
        temporaryCrop.value = result.temporaryPhoto
    }

    const updateAvatar = async (newFile) => {
        const formData = new FormData()
        formData.append('media', newFile)
        formData.append('type', 'avatar')

        const data = await apiCall(() => api.put(`/user/me/media`, formData), 'Изображение сохранено')

        if(data.result) {
            currentAvatar.value = data.result.avatar
        }
    }

    const moderateAvatar = () => {
        if(!canModerate(props.idUser, props.userRole)) return
        if(moderateMedia(props.idUser, 'avatar')) currentAvatar.value = null
    }

    watch(() => temporaryCrop.value, (value) => {
        isCrop.value = true
    })

</script>

<template>
    <div class="profile-avatar">
        <div class="profile-avatar__block flex-center" :style="`outline: 2px solid ${checkColorRole(props.userRole)}`" :class="{isOwner: user?.id === props.idUser || canModerate(props?.idUser, props?.userRole)}">
            <img :src="currentAvatar || '/images/plug_avatar.png'" @error="onAvatarError" class="profile-avatar__img">
            <div class="profile-avatar__rating">{{ '+' + props.rating }}</div>
            <label v-if="user?.id === props.idUser" class="profile-avatar__label flex-center"">
                <div class="flex-column flex-center" style="font-size: 16px; font-family: Roboto_Regular; gap: var(--gp-8);">
                    <svg class="profile-avatar__icon"><use href="#icon-download"></use></svg>
                    Изменить аватар
                </div>
                <input type="file" 
                    accept="image/*" 
                    @change="onMainImageChange"
                    class="profile-avatar__input hidden">
            </label>
            <button v-else-if="canModerate(props.idUser, props.userRole)" type="button" 
                @click="isConfirm = true"
                class="no-border profile-avatar__label flex-center">
                Удалить аватар
            </button> 
        </div>
    </div>

    <ConfirmPopUp 
        v-model="isConfirm"
        :label="'медиа'"
        @confirm="moderateAvatar"
    />

    <Cropper
        v-model="isCrop"
        @crop="onHandleCrop"
        :temporary-photo="temporaryCrop"
        :aspect-ratio="1/1"
    />
</template>

<style lang="scss" scoped>

    .profile-avatar {
        width: fit-content;

        &::before {
            content: '';
            width: 160px;
            flex-shrink: 0;

            @media (max-width:900px) {
                width: 0;
            }
        }

        &__block {
            position: relative;
            width: 160px;
            height: 160px;
            border-radius: 50%;
            outline-offset: 4px;

            &:hover.isOwner .profile-avatar__img {
                filter: brightness(0.5);
            }
            &.isOwner:hover .profile-avatar__label { 
                position: absolute;
                display: flex;
                width: 100%;
                height: 100%;
            }
        }

        &__img {
            width: 100%;
            height: 100%;
            border-radius: 50%;
        }

        &__label {
            display: none;
            font-family: Roboto_Medium; 
        }

        &__rating {
            position: absolute;
            bottom: -11px;
            left: 50%;
            transform: translateX(-50%);
            background-color: var(--color-green);
            border-radius: 4px;
            padding: 0px 8px;
            font-family: Roboto_Medium;
            font-size: 16px;
        }

        &__icon {
            stroke-width: 4px;
            stroke-color: var(--color-white);
            width: 32px;
            height: 32px;
        }
    }




</style>