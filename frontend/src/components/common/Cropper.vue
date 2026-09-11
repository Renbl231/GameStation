<script setup>
import { ref, watch, nextTick } from 'vue'
import Cropper from 'cropperjs'
import 'cropperjs/dist/cropper.min.css'

const props = defineProps({
    modelValue: { 
        type: Boolean,
        required: true 
    },
    temporaryPhoto: { 
        type: String, 
        required: true
    },
    aspectRatio: { 
        type: Number,
        default: 16 / 9
    },
    viewMode: {
        type:Number,
        default: 3
    },
    width: Number,
    height: Number,
})

const emits = defineEmits(['update:modelValue', 'crop'])

const imageRef = ref(null)

let cropperInstance = null

const initCropper = () => {
    if (cropperInstance) {
        cropperInstance.destroy()
        cropperInstance = null
    }

    const image = imageRef.value
    if (!image) return

    if (!image.complete) {
        image.onload = () => createCropper(image)
        return
    }
    createCropper(image)
}

const createCropper = (image) => {
    cropperInstance = new Cropper(image, {
        viewMode: 3,
        dragMode: 'move',
        aspectRatio: props.aspectRatio,
        autoCropArea: 1,
        cropBoxMovable: false,
        cropBoxResizable: false,
        guides: true,
        highlight: true,
        responsive: true,
        restore: true,
        checkCrossOrigin: false,
        modal: true,
        wheelZoomRatio: 0.1,
        background: false,
        zoomable: true,
    })
}

const save = () => {
    if (!cropperInstance) return

    try {
        const canvas = cropperInstance.getCroppedCanvas()
        const croppedDataUrl = canvas.toDataURL('image/png', 0.92)
        emits('crop', croppedDataUrl)
        emits('update:modelValue', false)
    } catch (error) {
        console.error('Ошибка обрезки:', error)
    }
}

const zoomRange = ref(0.65)
const updateZoom = () => {
    if (!cropperInstance) return
    cropperInstance.zoomTo(Number(zoomRange.value))
}

const close = () => {
    emits('update:modelValue', false)
}

watch(() => props.modelValue, (val) => {
    if (val) {
        nextTick(() => {
            initCropper()
        })
    } else {
        if (cropperInstance) {
            cropperInstance.destroy()
            cropperInstance = null
        }
    }
})
</script>
<template>
    <Transition name="popup-slide">
        <div v-if="modelValue" class="cropper flex-center">
            <div class="cropper__wrapper flex-column" :class="{active: props?.width}">
                <div class="cropper__image-wrapper" :class="{active: props?.height}" >
                    <img
                        ref="imageRef"
                        :src="temporaryPhoto"
                        alt="crop_image"
                        class="cropper__img"
                        crossorigin="anonymous"
                    />
                </div>
                <div class="cropper__btns flex align-c">
                    <input
                        type="range"
                        step="0.025"
                        min="0.65"
                        max="1"
                        v-model="zoomRange"
                        @input="updateZoom"
                        class="cropper__zoom"
                    />
                    <button class="no-border cropper__btn cropper__btn-v1" @click="close">Отменить</button>
                    <button class="no-border cropper__btn cropper__btn-v2" @click="save">Сохранить</button>
                </div>
            </div>
        </div>
    </Transition>
</template>


<style lang="scss" scoped>
    .cropper {
        position: fixed;
        top: 0;
        left: 0;
        width: 100%;
        height: 100%;
        background-color: var(--popup-bg-1);
        z-index: 1000;

        &__wrapper {
            width: 100%;
            max-width: 800px;
            background-color: var(--popup-modal-1);
            border: 1px solid var(--bg-secondary-border);
            border-radius: 16px;
            overflow: hidden;
            padding: 8px;
            gap: 16px;

            &.active {
                max-width: 1312px;
            }
        }

        &__image-wrapper {
            width: 100%;
            max-height: 500px;
            min-height: 300px;
            background: var(--color-black);
            border-radius: 16px;
            overflow: hidden;
            position: relative;

            &.active {
                max-height: 300px;
            }

            :deep(.cropper-dashed) {
                border-color: rgba(255,255,255,0.75);
                border-style: solid;
            }

            :deep(.cropper-face) {
                background: transparent;
            }

            :deep(.cropper-view-box) {
                outline: none;
            }

            :deep(.cropper-modal) {
                opacity: .3;
            }

        }

        &__img {
            width: 100%;
            display: block;
        }

        &__btns {
            background-color: var(--popup-modal-1);
            gap: 12px;
            justify-content: flex-end;
            padding: 8px 16px;
            font-family: Roboto_Medium;
        }

        &__btn {
            width: fit-content;
            padding: 8px 24px;
            border-radius: 8px;
            font-size: 14px;
            transition: 0.2s;
            border: none;
            cursor: pointer;

            &-v1 {
                background-color: var(--color-gray-600);
                &:hover { background-color: var(--color-gray-500); }
            }

            &-v2 {
                background-color: var(--color-blue);
                color: white;
                &:hover { background-color: var(--color-blue-hover); }
            }
        }

        &__zoom {
            margin-right: auto;
            -webkit-appearance: none;
            appearance: none;
            width: 160px;
            height: 4px;
            border-radius: 2px;
            background: var(--color-gray-600);
            outline: none;
            cursor: pointer;

            &::-webkit-slider-thumb {
                -webkit-appearance: none;
                appearance: none;
                width: 16px;
                height: 16px;
                border-radius: 50%;
                background: #4a90e2;
                cursor: pointer;
                box-shadow: 0 2px 8px rgba(0,0,0,0.3);
            }
        }
    }

</style>