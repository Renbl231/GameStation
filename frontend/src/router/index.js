import { createRouter, createWebHistory } from 'vue-router';
import { useAuthStore } from '../stores/authStore'
import NotFound from '../views/NotFound.vue'

const router = createRouter({
    history: createWebHistory(),
    routes: [
        { path: '/' , component: () => import('../views/Home.vue') },

        { path: '/games/:filters*', component: () => import('../views/Games.vue')},
        { path: '/game/:id', component: () => import('../views/GamePage.vue')},
        { path: '/games/selections', component: () => import('../views/Selections.vue')},
        { path: '/games/reviews/:filters*', component: () => import('../views/Reviews.vue')},

        { path: '/review/:id', component: () => import('../views/ReviewPage.vue'), meta: {entity_type: 'review'}},
        
        { path: '/selection/data', component: () => import('../views/SelectionPage.vue')},

        { path: '/community/:filters*' , component: () => import('../views/Community.vue') }, // сообщество
        { path: '/theme/:id' , component: () => import('../views/CommunityPage.vue'), meta: {entity_type: 'theme'}}, // стр. темы

        { path: '/discussion', component: () => import('../views/Discussion.vue')},

        { path: '/moderation', component: () => import('../views/ModerationPage.vue')},

        { path: '/help', component: () => import('../views/Help.vue') },
        { path: '/rules', component: () => import('../views/Rules.vue') },
        { path: '/contact', component: () => import('../views/Contact.vue')},

        {
            path: '/user/:nickname',
            component: () => import('../views/UserProfile.vue'),
            children: [
                { path: 'games', component: () => import('../views/UserGames.vue') },
                { path: 'games/p:page', component: () => import('../views/UserGames.vue') },
                { path: 'reviews', component: () => import('../views/UserReviews.vue') },
                { path: 'reviews/p:page', component: () => import('../views/UserReviews.vue') },
                { path: 'comments', component: () => import('../views/UserComments.vue') },
                { path: 'comments/p:page', component: () => import('../views/UserComments.vue') },
                {
                    path: 'requests',
                    component: () => import('../views/UserRequests.vue'),
                    meta: { requiresOwnOrAdmin: true }
                    },
                {
                    path: 'requests/p:page',
                    component: () => import('../views/UserRequests.vue'),
                    meta: { requiresOwnOrAdmin: true }
                }
            ]
        },
        
        { path: '/createNews', component: () => import('../views/NewsCreate.vue')}, // создание новости
        { path: '/createArticle', component: () => import('../views/ArticleCreate.vue')}, // создание статьи
        { path: '/addGame', component: () => import('../views/GameAdd.vue')},
        { path: '/editGame/:id', component: () => import('../views/GameEdit.vue')}, // редакт
        
        { path: '/articles/:filters*', component: () => import('../views/Articles.vue')}, // статьи
        { path: '/article/:id', component: () => import('../views/ArticlePage.vue'), meta: {entity_type: 'article'}}, // стр. новости

        { path: '/news/:filters*', component: () => import('../views/News.vue')}, // новости
        { path: '/newsdata/:id', component: () => import('../views/NewsPage.vue'), meta: {entity_type: 'news'}}, // стр. новости
        
        { 
            path: '/:pathMatch(.*)*', 
            component: NotFound
        }
    ],
    
    scrollBehavior(to, from, savedPosition) {
        if (savedPosition) return savedPosition

            if (to.hash) {
                return {
                el: to.hash
                }
            }

            return { left: 0, top: 0, behavior: 'instant' }
        }
    })

router.beforeEach(async (to, from, next) => {
  const authStore = useAuthStore()

  await authStore.checkAuth()

  const role = authStore.user?.role
  const currentNickname = authStore.user?.nickname

  if (to.matched.some(r => r.meta.requiresOwnOrAdmin)) {
    const routeNickname = to.params.nickname

    if (routeNickname !== currentNickname) {
      return next('/')
    }
  }

  if (to.path === '/createNews' || to.path === '/createArticle') {
    if (!authStore.isAuthenticated || ![2, 4].includes(role)) {
      return next('/')
    }
  }

  if (to.path === '/moderation') {
    if (!authStore.isAuthenticated || ![3, 4].includes(role)) {
      return next('/')
    }
  }

  if (to.path === '/addGame' || to.path.startsWith('/editGame/')) {
    if (!authStore.isAuthenticated || ![4].includes(role)) {
      return next('/')
    }
  }

  next()
})


export default router