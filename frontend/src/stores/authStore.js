import { defineStore } from 'pinia'
import api from '../utils/axios'

export const useAuthStore = defineStore('auth', {
  state: () => ({
    isAuthenticated: false,
    user: null
  }),
  
  actions: {
    async checkAuth() {
      console.time('👤 USER LOAD');
      try {
        const { data } = await api.get('auth/me');
        console.log('✅ API DATA:', data);
        
        state.isAuthenticated = data.success;
        state.user = data.user || null;
        console.log('✅ state.user:', state.user);
      } catch (err) {
        console.log('❌ 401/500:', err.response?.status);
        state.isAuthenticated = false;
        state.user = null;
      } finally {
        console.timeEnd('👤 USER LOAD');
      }
    },

    async logout() {
        try {
            await api.post('auth/logout')
        } catch (err) {}
        this.isAuthenticated = false
        this.user = null
    }

}
})
