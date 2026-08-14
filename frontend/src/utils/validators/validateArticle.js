import { useNotifications } from '@stores/notifications'

const notification = useNotifications()

export const validateArticle = (form) => {
    if(!form.title.trim()) {
        notification.warning('Заголовок обязателен')
        return false
    }
    if(!Number(form.category_id)) {
        notification.warning('Категория обязательна')
        return false
    }
    if(!form.cover) {
        notification.warning('Превью обязательно')
        return false
    }
    if(!form.content.trim() || form.content === '<p class="text-content">Начните писать здесь...</p>') {
        notification.warning('Напишите содержимое новости')   
        return false
    }

    return true
}