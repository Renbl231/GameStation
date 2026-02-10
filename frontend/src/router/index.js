import { createRouter, createWebHistory } from 'vue-router';

const router = createRouter({
    history: createWebHistory(),
    routes: [
        { path: '/' , component: () => import('../views/Home.vue') },
        { path: '/news' , component: () => import('../views/News.vue') },
        { path: '/help', component: () => import('../views/Help.vue') },
        { path: '/rules', component: () => import('../views/Rules.vue') },
        { path: '/contact', component: () => import('../views/Contact.vue')},
        { path: '/games/selections', component: () => import('../views/Selections.vue')},
        { path: '/selection/data', component: () => import('../views/SelectionPage.vue')},
        { path: '/news/data', component: () => import('../views/NewsPage.vue')},
        { path: '/discussion', component: () => import('../views/Discussion.vue')},
    ]
})

export default router