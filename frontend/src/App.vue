<script setup>
  import Header from './components/Header.vue'
  import { onMounted } from 'vue'
  import { useAuthStore } from './stores/authStore'


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
