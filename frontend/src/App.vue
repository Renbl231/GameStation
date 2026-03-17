<script setup>
  import Header from './components/Header.vue'
  import FriendPopUp from './components/FriendPopUp.vue'
  import Notification from './components/Notification.vue'

  import { showGlobal404 } from './composables/useGlobal404'


</script>

<template>
  <div id="app" v-cloak :class="{ 'global-404-active': showGlobal404 }">
    <Header />
    <FriendPopUp />
    <main>
      <div class="main-container">
        <router-view/>
        
        <Teleport to="body">
          <div v-if="showGlobal404" class="global-404-overlay">
              <div class="not-found-box">
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

  /* 3. 404 = скрыть всё */
  #app.global-404-active * { 
      display: none !important; 
  }

  .global-404-overlay {
      position: fixed; top: 0; left: 0;
      width: 100vw; height: 100vh;
      z-index: 99999;
      display: flex;
      align-items: center;
      justify-content: center;
  }

  .not-found-box {
      padding: 3rem;
      border-radius: 12px;
      text-align: center;
  }

  .not-found-box h1 { font-size: 5rem; color: #ff6b6b; margin: 0 0 1rem; }
</style>
