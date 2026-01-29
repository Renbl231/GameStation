import { createRouter, createWebHistory } from 'vue-router';

const router = createRouter({
    history: createWebHistory(),
    routes: [
        {
            path: '/', component: () => import('../views/Home.vue'),
            path: '/games', component: () => import('../views/Home.vue'),
            path: '/articles', component: () => import('../views/Home.vue'),
            path: '/news', component: () => import('../views/Home.vue'),
            path: '/community', component: () => import('../views/Home.vue'),
            path: '/help', component: () => import('../views/Home.vue')
        }
    ]
})

export default router