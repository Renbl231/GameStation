import axios from 'axios'

const http = axios.create({
    baseURL: '/api',
    timeout: 30000,
    withCredentials: true 
})

// добавляем автоматически токен

http.interceptors.request.use((config) => {
  return config
})

http.interceptors.response.use(
  (response) => response,
  (error) => {
    if (error.response?.status === 401) {
      const url = error.config?.url || '';
      
      if (url.includes('/friends/') || url.includes('auth/')) {
        return Promise.reject(error);
      }
      
      // Только для auth роутов делаем logout
      authStore.logout()
      router.push('/') 
      return Promise.reject(error);
    }
    
    return Promise.reject(error);
  }
)


export const api = http
export default http