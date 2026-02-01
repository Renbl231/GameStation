import { createRouter, createWebHistory } from 'vue-router';

const router = createRouter({
    history: createWebHistory(),
    routes: [
        {
            path: '/', component: () => import('../views/Help.vue'),
            path: '/games', component: () => import('../views/Help.vue'),
            path: '/articles', component: () => import('../views/Help.vue'),
            path: '/news', component: () => import('../views/Help.vue'),
            path: '/community', component: () => import('../views/Help.vue'),
            path: '/help', component: () => import('../views/Help.vue')
        }
    ]
})

export default router