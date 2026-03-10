<script setup>
  import Header from './components/Header.vue'
  import FriendPopUp from './components/FriendPopUp.vue'
</script>

<template>
  <Header />
  <FriendPopUp />

  <main>
    <div class="main-container">
      <router-view/>
    </div>
  </main>
  
</template>

<style>

</style>
