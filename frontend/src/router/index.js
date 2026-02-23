import { createRouter, createWebHistory } from 'vue-router';
import { NewsMan_AdminCreateGuard, Moder_AdminCreateGuard, AdminCreateGuard } from '../guards/middleware'

const router = createRouter({
    history: createWebHistory(),
    routes: [
        { path: '/' , component: () => import('../views/Home.vue') },

        { path: '/games/selections', component: () => import('../views/Selections.vue')},
        { path: '/games/reviews', component: () => import('../views/Reviews.vue')},

        { path: '/review/data', component: () => import('../views/ReviewPage.vue')},
        
        { path: '/selection/data', component: () => import('../views/SelectionPage.vue')},

        { path: '/news' , component: () => import('../views/News.vue') },
        { path: '/news/data', component: () => import('../views/NewsPage.vue')},

        { path: '/community' , component: () => import('../views/Community.vue') },
        { path: '/discussion', component: () => import('../views/Discussion.vue')},

        { path: '/help', component: () => import('../views/Help.vue') },
        { path: '/rules', component: () => import('../views/Rules.vue') },
        { path: '/contact', component: () => import('../views/Contact.vue')},


        
        { path: '/createNews', component: () => import('../views/NewsCreate.vue'), beforeEnter: [NewsMan_AdminCreateGuard]},

        
    ]
})

export default router