import { createRouter, createWebHistory } from 'vue-router';
import { useAuthStore } from '../stores/authStore'
import NotFound from '../views/NotFound.vue'

const router = createRouter({
    history: createWebHistory(),
    routes: [
        { path: '/' , component: () => import('../views/Home.vue') },

        { path: '/games/:filters*', component: () => import('../views/Games.vue')},
        { path: '/games/selections', component: () => import('../views/Selections.vue')},
        { path: '/games/reviews', component: () => import('../views/Reviews.vue')},

        { path: '/review/data', component: () => import('../views/ReviewPage.vue')},
        
        { path: '/selection/data', component: () => import('../views/SelectionPage.vue')},

        { path: '/community/:filters*' , component: () => import('../views/Community.vue') }, // сообщество
        { path: '/theme/:id' , component: () => import('../views/CommunityPage.vue'), meta: {entity_type: 'theme'}}, // стр. темы

        { path: '/discussion', component: () => import('../views/Discussion.vue')},

        { path: '/help', component: () => import('../views/Help.vue') },
        { path: '/rules', component: () => import('../views/Rules.vue') },
        { path: '/contact', component: () => import('../views/Contact.vue')},

        { path: '/user/:nickname', component: () => import('../views/UserProfile.vue')},
        
        { path: '/createNews', component: () => import('../views/NewsCreate.vue')}, // создание новости
        { path: '/createArticle', component: () => import('../views/ArticleCreate.vue')}, // создание статьи
        { path: '/addGame', component: () => import('../views/GameAdd.vue')}, // добавление игр
        
        { path: '/articles/:filters*', component: () => import('../views/Articles.vue')}, // статьи
        { path: '/article/:id', component: () => import('../views/ArticlePage.vue'), meta: {entity_type: 'article'}}, // стр. новости

        { path: '/news/:filters*', component: () => import('../views/News.vue')}, // новости
        { path: '/newsdata/:id', component: () => import('../views/NewsPage.vue'), meta: {entity_type: 'news'}}, // стр. новости
        
        { 
            path: '/:pathMatch(.*)*', 
            component: NotFound
        }
    ],
    // скролл вверх после перехода на новый route
    // scrollBehavior() {
    //     return { left: 0, top: 0 }
    // }
    scrollBehavior(to, from, savedPosition) {
    if (savedPosition) return savedPosition
    return { left: 0, top: 0, behavior: 'instant' }
  }
})

router.beforeEach(async (to, from, next) => {
    const authStore = useAuthStore()
    
    await authStore.checkAuth()
    const protectedRoutes = ['/createNews', '/createArticle']
    
    if (protectedRoutes.includes(to.path)) { // проверка на новостник/админ
        if (!authStore.isAuthenticated || ![2, 4].includes(authStore.user?.role)) {
            return next('/')
        }
    }

    if (to.path === '/addGame') {  // проверка на админ
        if (!authStore.isAuthenticated || ![4].includes(authStore.user?.role)) {
            return next('/')
        }
    }

    
    next()
})


export default router