import axios from 'axios'

const http = axios.create({
    baseURL: '/api',
    timeout: 10000,
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
      window.location.href = '/'
    }
    return Promise.reject(error)
  }
)
export const api = http
export default http