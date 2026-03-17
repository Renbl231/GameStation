<template>
     <div class="global-404-overlay">
        <div class="not-found-box">
            <h1>404</h1>
            <h2>Страница не найдена</h2>
            <router-link to="/" class="btn-home">На главную</router-link>
        </div>
    </div>
</template>

<style scoped>
  .global-404-overlay {
      position: absolute;
      bottom: 50%;
      z-index: 9999;
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
