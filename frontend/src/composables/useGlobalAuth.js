import { inject } from 'vue';

export function useGlobalAuth() {
  const auth = inject('auth');
  
  if (!auth) {
    console.error('useGlobalAuth не доступен вне App.vue!');
  }
  
  return auth;
}
