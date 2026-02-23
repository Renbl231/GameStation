import { useAuthStore } from '../stores/authStore'

export const NewsMan_AdminCreateGuard = async (to, from, next) => {
  const authStore = useAuthStore()

  if (!authStore.isAuthenticated || ![2, 4].includes(authStore.user?.role)) {
    return next('/')
  }
  next()
}

export const Moder_AdminCreateGuard = async (to, from, next) => {
  const authStore = useAuthStore()

  if (!authStore.isAuthenticated || ![3, 4].includes(authStore.user?.role)) {
    return next('/')
  }
  next()
}

export const AdminCreateGuard = async (to, from, next) => {
  const authStore = useAuthStore()
  if (!authStore.isAuthenticated || authStore.user?.role !== 4) {
    return next('/')
  }
  next()
}
