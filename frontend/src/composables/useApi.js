import { useNotifications } from "../stores/notifications";

// composables/useApi.js
export const useApiNotifications = () => {
    const notifications = useNotifications()

    const shouldShowError = (error) => {
        const status = error.response?.status
        return ![401, 403].includes(status)
    }

    const apiCall = async (requestFn, successMsg = null) => {
        try {
            const { data } = await requestFn()
            if (successMsg && data.success !== false) {
                notifications.success(successMsg)
            }
            else if (data.message && data.success !== false) {
                notifications.success(data.message)
            } 

            return data
        } catch (error) {
            if (shouldShowError(error)) {
                notifications.error(
                    error.response?.data?.error || 
                    error.message || 
                    'Произошла ошибка'
                )
            }
            
            return null
        }
    }
    
    return { apiCall }
}
