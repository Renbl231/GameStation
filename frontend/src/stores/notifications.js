import { defineStore } from 'pinia'
import { ref } from 'vue'

export const useNotifications = defineStore('notifications', () => {
    const notifications = ref([])

    const add = (type, message, duration = 4000) => {
        const id = Date.now() + Math.random()
        notifications.value.unshift({
            id,
            type,
            message,
            duration
        })

        setTimeout(() => remove(id), duration)
    }

    const remove = (id) => {
        notifications.value = notifications.value.filter(n => n.id !== id)
    }

    const success = (msg) => {
        add('success', msg)
    }

    const error = (msg) => {
        add('error', msg)
    }

    const warning = (msg) => {
        add('warning', msg)
    }

    return {
        notifications,
        success,
        error,
        warning,
        remove
    }
})