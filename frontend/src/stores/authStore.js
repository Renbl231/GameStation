import { defineStore } from 'pinia'
import api from '../utils/axios'

export const useAuthStore = defineStore('auth', {
  state: () => ({
    isAuthenticated: false,
    user: null
  }),
  
  actions: {
    async checkAuth() {
      try {
        const { data } = await api.get('auth/me')
        this.isAuthenticated = data.success
        this.user = data.user || null
      } catch (err) {
        this.isAuthenticated = false
        this.user = null
      }
    },

    async logout() {
        try {
            await api.post('auth/logout')
        } catch (err) {
        }
        this.isAuthenticated = false
        this.user = null
        console.log('✅ LOGOUT COMPLETED')
    }
}
})
