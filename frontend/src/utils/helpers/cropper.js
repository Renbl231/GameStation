import { useNotifications } from '@stores/notifications'
const notification = useNotifications()

const dataURLtoFile = (dataURL) => {
    const arr = dataURL.split(',')
    const mime = arr[0].match(/:(.*?);/)[1]
    const bstr = atob(arr[1])
    let n = bstr.length
    const u8arr = new Uint8Array(n)
    while (n--) {
        u8arr[n] = bstr.charCodeAt(n)
    }
    
    const filename = `cropped-${Date.now()}.png`
    
    return new File([u8arr], filename, { type: mime })
}

export const handleCrop = (croppedDataUrl) => {
    const MAX_FILE_SIZE = 3 * 1024 * 1024
    const base64Size = croppedDataUrl.length * 0.75

    if (base64Size > MAX_FILE_SIZE) {
        notification.warning('Изображение слишком большое после обрезки')
        return
    }

    const file = dataURLtoFile(croppedDataUrl, 'cropped-image.png')

    return {
        temporaryPhoto: croppedDataUrl,
        cover: file
    }
}
