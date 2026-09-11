import { useNotifications } from '@stores/notifications'

const notification = useNotifications()

export const validateScore = (isDetail, simpleScore, ratings) => {
    if(!isDetail) {
        if(simpleScore < 1 || simpleScore > 10) {
            notification.warning('Оценка должна быть от 1 до 10')
            return false
        }
        return true
    } else {
        const hasInvalidRating = ratings.some(
            item => !item.hidden && (Number(item.score) < 1 || Number(item.score) > 10)
        )

        if (hasInvalidRating) {
            notification.warning('Оценка должна быть от 1 до 10')
            return false
        }
        return true
    }
}