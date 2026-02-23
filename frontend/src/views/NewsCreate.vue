<script setup>
    import { computed } from 'vue'
    import { useAuthStore } from '../stores/authStore'

    const authStore = useAuthStore()
    const isAuthorized = computed(() => 
    authStore.isAuthenticated && [2, 4].includes(authStore.user?.role)
    )
</script>


<template>
     <div class="container" v-if="isAuthenticated && isAuthorized">
        <div class="wrapper-container flex-column">
            <h1>Добавление новости</h1>
            <input type="text" class="field no-border" placeholder="Заголовок" required>
            <select class="field no-border" required>
                <option value="" disabled hidden selected class="empty-option">Категория новости</option>
                <option value="Release">Release</option>
                <option value="Patch">Patch</option>
            </select>
            <textarea placeholder="Содержимое" class="field field-content no-border" required></textarea>
            <button type="button" class="no-border send-btn">Опубликовать</button>
            
        </div>
    </div>

</template>

<style scoped>
    .container {
        width: 100%;
        padding-inline: 96px;
        padding-block: 64px;
        background-color: var(--bg-third-25);
        border: 1px solid var(--bg-third-100);
        border-radius: 32px;
    }

    .wrapper-container {
        max-width: 736px;
        width: 100%;
        margin: 0 auto;
        gap: var(--gp-32);
        font-family: Roboto_Medium;
        font-size: 20px;
        gap: var(--gp-32);
    }

    .wrapper-container h1 {
        font-size: 32px;
        font-family: Roboto_Bold;
    }

    .field {
        width: 100%;
        background-color: #1B1C21;
        padding: 12px 16px;
        border-radius: 8px;
        border-left: 3px solid var(--btn-color-2);
        color: var(--font-primary-75);
    }

    .field::placeholder {
        color: var(--font-primary-25);
    }

    select {
        width: 100%;
        overflow: hidden;
        text-overflow: ellipsis;
        white-space: nowrap;
        cursor: pointer;
        appearance: none;
        background: url('../assets/icons/arrow.svg') no-repeat right 16px center;
        background-size: 16px;
        padding-right: 36px !important; 
    }

    .field option {
        color: #fff;
        background: #1B1C21;
        font-size: 16px;
    }

    .field-content {
        padding: 16px;
        height: 300px;
        resize: vertical;
        overflow: hidden;
        field-sizing: content;
    }

    .send-btn {
        width: 100%;
        background-color: var(--font-secondary);
        padding-block: 10px;
        border-radius: 8px;
        font-size: 16px;
    }

    @media (max-width: 1160px) {
        .container {
            border-radius: 0px;
        }

    }

     @media (max-width:1024px) {
        .container {
            padding-inline: 48px;
        }
        
    }

    @media (max-width:500px) {
        .container {
            padding-inline: 16px;
            padding-block: 32px;
        }

        .wrapper-container h1 {
            font-size: 28px;
        }

        .wrapper-container {
            font-size: 18px;
        }

        .field-content {
            height: 200px;
        }
    }

</style>