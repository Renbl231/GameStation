// composables/useAuth.js
import { reactive, computed } from 'vue';
import api from '../utils/axios';

const state = reactive({
  isAuthenticated: false,
  user: null
});


export function useAuth() {
  const checkAuth = async () => {
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
  };


  const logout = async () => {
    try {
      await api.post('auth/logout');
    } catch (err) {
      console.log('Logout error');
    }
    state.isAuthenticated = false;
    state.user = null;
  };

  return {
    isAuthenticated: computed(() => state.isAuthenticated),
    user: computed(() => state.user),
    checkAuth,
    logout
  };
}
