import { createApp } from 'vue'
import App from './App.vue'
import router from './router'

import './assets/styles/main.css'
import './assets/styles/fonts.css'
import './assets/styles/normalization.css'
import './assets/styles/styles.css'

const app = createApp(App)
app.use(router)

app.mount('#app')
