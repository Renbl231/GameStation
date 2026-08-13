import { useNotifications } from '@stores/notifications'

const notification = useNotifications()
const MAX_FILE_SIZE = 3 * 1024 * 1024

export const onImageChange = (event) => {
    const file = event.target.files?.[0]
    
    if (!file) {
        notification.warning('Нету файла')
        return null
    }

    if (!file.type?.startsWith('image/')) {
        notification.warning('Только изображения')
        event.target.value = ''
        return null
    }

    if (file.size > MAX_FILE_SIZE) {
        notification.warning('Файл слишком большой — максимум 3 МБ')
        event.target.value = ''
        return null
    }

    return {
        file,
        temporaryPhoto: URL.createObjectURL(file)
    }
}