<script setup>
  import Header from './components/Header.vue'
  import { onMounted } from 'vue'
  import { useAuthStore } from './stores/authStore'

  const authStore = useAuthStore()

  onMounted(async () => {
    await authStore.checkAuth()
  })
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
