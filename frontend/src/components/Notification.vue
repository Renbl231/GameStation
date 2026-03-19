<script setup>
    import { useNotifications } from '../stores/notifications';

    const notifications = useNotifications()
</script>

<template>
    <div class="notifications-container">
        <TransitionGroup 
            name="notification-list" 
            tag="div"
            class="notifications-list flex-column"
        >
            <div 
                v-for="notification in notifications.notifications" 
                :key="notification.id"
                class="notification flex align-c justify-sb"
                :class="`notification--${notification.type}`"
            >
                <span class="notification__message">{{ notification.message }}</span>
                <button 
                    @click="notifications.remove(notification.id)" 
                    class="notification__close no-border flex-center"
                >×</button>
                
                <div class="progress-bar"></div>
            </div>
        </TransitionGroup>
    </div>
</template>


<style scoped>
    .notifications-container {
        position: fixed;
        top: 88px;
        right: 20px;
        z-index: 9999;
        max-width: 350px;
        min-width: 220px;
        font-family: Roboto_Regular;
    }

    .notifications-list {
        gap: var(--gp-8)
    }

    .notification {
        padding: 4px 16px;
        border-radius: 4px;
        gap: var(--gp-8);
        box-shadow: 0 8px 16px rgba(0, 0, 0, 0.25);
        animation: slideIn 0.4s cubic-bezier(0.25, 0.46, 0.45, 0.94);
    }

    .notification--success {
        background: linear-gradient(135deg, #10b981 0%, #059669 100%);
    }

    .notification--error {
        background: linear-gradient(135deg, #ef4444 0%, #dc2626 100%);
    }

    .notification--warning {
        background: linear-gradient(135deg, #f59e0b 0%, #d97706 100%);
    }

    .notification__close {
        padding: 4px 8px;
        font-size: 22px;
        color: var(--font-primary-75);
    }

    .notification__close:hover {
        color: var(--font-primary);
    }


    .notification-list-enter-active {
        animation: notificationSlideIn 0.4s cubic-bezier(0.25, 0.46, 0.45, 0.94);
    }

    .notification-list-leave-active {
        position: absolute;
        transition: all 0.3s cubic-bezier(0.55, 0.085, 0.68, 0.53);
        width: 100%;
    }

    .notification-list-enter-from,
    .notification-list-leave-to {
        opacity: 0;
        transform: translateX(120%);
    }

    .notification-list-leave-active {
        animation: notificationSlideOut 0.3s cubic-bezier(0.55, 0.085, 0.68, 0.53) forwards;
    }

    @keyframes notificationSlideIn {
        from {
            opacity: 0;
            transform: translateX(120%);
        }
        to {
            opacity: 1;
            transform: translateX(0);
        }
    }

    @keyframes notificationSlideOut {
        from {
            opacity: 1;
            transform: translateX(0);
        }
        to {
            opacity: 0;
            transform: translateX(120%);
        }
    }

    .progress-bar {
        position: absolute;
        bottom: 0;
        left: 0;
        height: 3px;
        background: var(--font-primary);
        animation: progress 4s linear infinite;
    }

    @keyframes progress {
        from { width: 100%; }
        to { width: 0%; }
    }

</style>