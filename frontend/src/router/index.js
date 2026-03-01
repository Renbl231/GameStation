import { createRouter, createWebHistory } from 'vue-router';
import { useAuthStore } from '../stores/authStore'

const router = createRouter({
    history: createWebHistory(),
    routes: [
        { path: '/' , component: () => import('../views/Home.vue') },

        { path: '/games/selections', component: () => import('../views/Selections.vue')},
        { path: '/games/reviews', component: () => import('../views/Reviews.vue')},

        { path: '/review/data', component: () => import('../views/ReviewPage.vue')},
        
        { path: '/selection/data', component: () => import('../views/SelectionPage.vue')},

        { path: '/news', redirect: '/news/all/p1'},

        { path: '/community' , component: () => import('../views/Community.vue') },
        { path: '/discussion', component: () => import('../views/Discussion.vue')},

        { path: '/help', component: () => import('../views/Help.vue') },
        { path: '/rules', component: () => import('../views/Rules.vue') },
        { path: '/contact', component: () => import('../views/Contact.vue')},


        
        { path: '/createNews', component: () => import('../views/NewsCreate.vue')},

        // пагинация

        { path: '/news/all/:page?', component: () => import('../views/News.vue')},
        { path: '/newsdata/:id', component: () => import('../views/NewsPage.vue'), meta: {entity_type: 'news'}}
        
    ]
})

router.beforeEach(async (to, from, next) => {
  const authStore = useAuthStore()
  
  await authStore.checkAuth()
  
  if (to.path === '/createNews') {
    if (!authStore.isAuthenticated || ![2, 4].includes(authStore.user?.role)) {
      return next('/')
    }
  }
  
  next()
})

export default router