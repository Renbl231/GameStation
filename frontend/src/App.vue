<script setup>
  import Header from '@components/Header/Header.vue'

  


  
  import FriendPopUp from './components/FriendPopUp.vue'
  import Notification from './components/Notification.vue'
  import ScrollToTop from './components/ScrollToTop.vue'
  import { watch } from 'vue'
  import { useRoute } from 'vue-router'
  import { showGlobal404 } from './composables/useGlobal404'

  const route = useRoute()

  watch(() => route.fullPath, () => {
      showGlobal404.value = false
  }, { immediate: true })


</script>

<template>
  <div id="app" v-cloak :class="{ 'global-404-active': showGlobal404 }">
    <Header />
    <ScrollToTop />
    <FriendPopUp />
    <main>
      <div class="main-container">
        <router-view/>
        
        <Teleport to="body">
          <div v-if="showGlobal404" class="global-404-overlay flex-center">
              <div class="not-found-box flex-column">
                  <h1>404</h1>
                  <h2>Страница не найдена</h2>
                  <router-link to="/" class="btn-home">На главную</router-link>
              </div>
          </div>
        </Teleport>
        
        
        <Notification/>
      </div>
    </main>
  </div>
</template>

<style>



  /* 1. v-cloak = ДО Vue.js (0мс) */
  [v-cloak] { 
      display: none !important; 
  }

  #app.global-404-active main { 
      display: none !important; 
  }

  .global-404-overlay {
      position: absolute;
      top: 0;
      bottom: 0;
      left: 0;
      right: 0;
      z-index: 1;
      text-align: center;
  }

  .global-404-overlay h1 {
      font-size: 164px !important;
      font-family: Roboto_Regular;
      color: var(--btn-color-2);
      margin: 0;
      line-height: normal;
  }

  .global-404-overlay h2 {
      font-size: 28px;
      font-family: Roboto_Regular;
  }

  .not-found-box {
      text-align: center;
  }

  .btn-home {
      margin-top: 16px;
      width: auto;
      font-family: Roboto_Medium;
      border-radius: 4px;
      background-color: var(--btn-color-1);
      padding: 4px 8px;
  }

  .btn-home:hover {
    background-color: var(--font-secondary);
  }

</style>
