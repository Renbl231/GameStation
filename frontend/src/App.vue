<script setup>
  import Header from './components/Header.vue'
  import { useAuth } from './composables/useAuth.js';
  import { provide, onMounted } from 'vue';

  const { isAuthenticated, user, logout, checkAuth } = useAuth();

  onMounted(async () => {
    await checkAuth();
  });

  provide('auth', {
    isAuthenticated,
    user,
    logout,
    checkAuth
  });

</script>


<template>
  <Header />

  <main>
    <div class="main-container">
      <router-view/>
    </div>
  </main>
  
</template>

<style>

</style>
