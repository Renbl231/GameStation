<script setup>
    import { ref, watch } from 'vue'
    import { storeToRefs } from 'pinia'
    import { useAuthStore } from '@/stores/authStore'
    import { onBannerError } from '@/utils/helpers/onImageError'
    import { handleCrop } from '@/utils/helpers/cropper'
    import { onImageChange } from '@/utils/validators/validateImage'
    import { useApiNotifications } from '@composables/useApi'
    import { useModeration } from '@composables/useModeration'
    import api from '@utils/axios'

    import ConfirmPopUp from '@components/popups/ConfirmPopUp.vue';
    import Cropper from '@/components/common/Cropper.vue'

    const authStore = useAuthStore()
    const { user } = storeToRefs(authStore)
    const { apiCall } = useApiNotifications()
    const { moderateMedia, canModerate } = useModeration()

    const props = defineProps({
        banner: {
            type: String,
            default: '/images/plug_baner.png'
        },
        idUser: Number,
        roleUser: Number,
    })

    const currentBanner = ref(props.banner)

    const isConfirm = ref(false)
    const isCrop = ref(false)

    const temporaryCrop = ref('')

    const onHandleCrop = async (croppedDataUrl) => {
        const result = handleCrop(croppedDataUrl)
        await updateBanner(result.cover)
    }

    const onMainImageChange = (event) => {
        const result = onImageChange(event)
        temporaryCrop.value = result.temporaryPhoto
    }

    const updateBanner = async (newFile) => {
        const formData = new FormData()
        formData.append('media', newFile)
        formData.append('type', 'banner')

        const data = await apiCall(() => api.put(`/user/me/media`, formData), 'Изображение сохранено')

        if(data.result) {
            currentBanner.value = data.result.banner
        }
    }

    const moderateBanner = () => {
        if(!canModerate(props.idUser, props.roleUser)) return
        if(moderateMedia(props.idUser, 'banner')) currentBanner.value = null
    }


    watch(() => temporaryCrop.value, (value) => {
        isCrop.value = true
    })

</script>

<template>
    <div class="profile-banner">
        <picture>
            <img :src="currentBanner || '/images/plug_baner.png'" @error="onBannerError" class="profile-banner__img">
        </picture>
        <label v-if="user?.id === props?.idUser" class="profile-banner__label flex-center">
            <svg class="profile-banner__icon"><use href="#icon-download"></use></svg>
            <input type="file"
                accept="image/*" 
                @change="onMainImageChange"
                class="profile-header__input hidden"
            >
        </label>
        <button v-else-if="canModerate(props.idUser, props.roleUser)" type="button" 
            @click="isConfirm = true"
            class="no-border profile-banner__label flex-center">
            Удалить банер
        </button> 
    </div>

    <ConfirmPopUp 
        v-model="isConfirm"
        :label="'медиа'"
        @confirm="moderateBanner"
    />

    <Cropper
        v-model="isCrop"
        @crop="onHandleCrop"
        :width="1312"
        :height="300"
        :temporary-photo="temporaryCrop"
        :aspect-ratio="1312/300"
    />


</template>

<style lang="scss" scoped>
    .profile-banner {
        position: relative;
        width: 100%;
        height: 300px;
        overflow: hidden;

       

        @media (max-width: 900px) {
            display: none;
        }

        &__img {
            width: 100%;
            height: 100%;
            display: block;
            border-radius: 8px;
        }

        &__label {
            position: absolute;
            z-index: 10;
            bottom: 16px;
            right: 16px;
            background-color: rgba(0, 0, 0, 0.5);
            border-radius: 4px;
            color: var(--color-gray-100);
            padding: 4px 4px;
            font-family: Roboto_Regular;

            &:hover {
                color: var(--color-white);
                background-color: var(--color-black);
            }
        }

        &__icon {
            stroke-width: 4px;
            stroke-color: var(--color-white);
            width: 24px;
            height: 24px;
        }
    }

</style>