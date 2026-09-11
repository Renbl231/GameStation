<script setup>
    import { ref, watch, } from 'vue'
    import { handleCrop } from '@/utils/helpers/cropper';
    import { onImageChange } from '@/utils/validators/validateImage'
    import Cropper from '@/components/common/Cropper.vue'
    
    const props = defineProps({
        currentCover: String,
    })

    const emits = defineEmits(['upload'])

    const isCrop = ref(false)
    const temporaryCrop = ref('')
    const temporaryPhoto = ref('')
    
    const onMainImageChange = (event) => {
        const result = onImageChange(event)
        temporaryCrop.value = result.temporaryPhoto
    }

    const onHandleCrop = (croppedDataUrl) => {
        const result = handleCrop(croppedDataUrl)

        temporaryPhoto.value = result.temporaryPhoto
        emits('upload', result.cover)
    }

    watch(() => temporaryCrop.value, (value) => {
        isCrop.value = true
    })
</script>

<template>
    <Cropper
        v-model="isCrop"
        @crop="onHandleCrop"
        :temporary-photo="temporaryCrop"
        :aspect-ratio="16/9"
    />

    <div class="image-uploader flex flex-center">
        <picture v-if="temporaryPhoto">
            <img :src="temporaryPhoto" class="image-uploader__preview"/>
        </picture>
        <picture v-else-if="props.currentCover">
            <img :src="props.currentCover" class="image-uploader__preview"/>
        </picture>
        <div class="flex-column flex-center" style="gap: var(--gp-16); padding:16px;">
            <label class="image-uploader__btn flex-center">
                <input 
                    type="file"
                    accept="image/*"
                    class="image-uploader__input"
                    @change="onMainImageChange"
                />
                <span class="image-uploader__label">Загрузить превью</span>
            </label>
            <span class="image-uploader__txt">Рекомендуемый размер 16:9, до 5 МБ</span>
        </div>
    </div>
</template>

<style lang="scss" scoped>
    .image-uploader {
        width: fit-content;
        margin: 0 auto;
        border-radius: 16px;

        &__btn {
            cursor: pointer;
            width: fit-content;
            padding: 8px 16px;
            border-radius: 256px;
            background-color: var(--color-gray-200);

            &:hover {
                background-color: var(--color-gray-100);
            }
        }

        &__input {
            display: none;
        }

        &__label {
            font-family: Roboto_Medium;
            font-size: 14px;
            color: var(--text-primary);
        }

        &__preview {
            aspect-ratio: 336 / 186;
            width: 100%;
            max-width: 336px;
            border-radius: 16px;
            border: 1px solid var(--input-2-border);
        }

        &__txt {
            font-size: 12px;
            font-family: Roboto_Regular;
            color: var(--color-gray-200);
        }
    }
</style>