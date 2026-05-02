import { useNotifications } from "../stores/notifications";

// composables/useApi.js
export const useApiNotifications = () => {
    const notifications = useNotifications()

    const shouldShowError = (error) => {
        const status = error.response?.status
        return ![401].includes(status)
    }

    const apiCall = async (requestFn, successMsg = null) => {
        try {

            const response = await requestFn()
        
            if (response.status === 204) {
                if (successMsg) notifications.success(successMsg)
                return { 
                    status: 204, 
                    success: true
                }
            }
            
            const { data } = response
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
            
            throw error;
        }
    }
    
    return { apiCall }
}
