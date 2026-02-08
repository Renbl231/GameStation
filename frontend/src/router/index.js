import { createRouter, createWebHistory } from 'vue-router';

const router = createRouter({
    history: createWebHistory(),
    routes: [
        { path: '/' , component: () => import('../views/Home.vue') },
        { path: '/news' , component: () => import('../views/News.vue') },
        { path: '/help', component: () => import('../views/Help.vue') },
        { path: '/rules', component: () => import('../views/Rules.vue') },
        { path: '/contact', component: () => import('../views/Contact.vue')}
    ]
})

export default router