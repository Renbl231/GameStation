<script setup>
    import NavBar from '../components/HelpBar.vue'
    import { ref } from 'vue'
    import api from '../utils/axios'

    import { useNotifications } from '../stores/notifications'
    import { useApiNotifications } from '../composables/useApi'
    const { apiCall } = useApiNotifications()
    const notification = useNotifications()

    import { storeToRefs } from 'pinia'
    import { useAuthStore } from '../stores/authStore'
    const authStore = useAuthStore()
    const { isAuthenticated } = storeToRefs(authStore)
    

    const sectionTypeArray = ref([
        { text: 'Размещение рекламы', value: 1},
        { text: 'Работа сайта (баги, предложения)', value: 2},
        { text: 'Вакансии на сайте', value: 3},
        { text: 'Другой вопрос', value: 5}
    ])

    const feedbackForm = ref({
        selectedType: null,
        title: '',
        description: ''
    })

    const sendFeedBack = async () => {
        if(!isAuthenticated.value) {
            notification.warning('Сначало авторизируйтесь')
            return
        }
        if(!feedbackForm.value.selectedType) {
            notification.warning('Выберите тему сообщения')
            return
        }
        if(feedbackForm.value.title.trim().length <= 3) {
            notification.warning('Слишком короткий заголовок')
            return
        }
        if(feedbackForm.value.description.trim().length <= 5) {
            notification.warning('Слишком короткое сообщение')
            return
        }
        const data = await apiCall(() => api.post('/community/feedback', feedbackForm.value),'Обращение отправлено')
        if(data.success) {
            Object.assign(feedbackForm.value, {
                selectedType: null,
                title: '',
                description: '',
            })
        }
    }
</script>

<template>
    <div class="container flex-column">
        <NavBar />
        <div class="wrapper-container flex">
            <div class="form-container flex-column">
                <h1>Связаться с нами</h1>
                <select v-model="feedbackForm.selectedType" class="field no-border" :class="{'active': feedbackForm.selectedType}">
                    <option value="null" disabled hidden selected class="empty-option">Тема сообщения</option>
                    <option v-for="section in sectionTypeArray" :value="section.value" :key="section.value" >
                        {{ section.text }}
                    </option>
                </select>
                <input v-model="feedbackForm.title" :class="{'active': feedbackForm.title.trim().length > 3}" placeholder="Заголовок сообщения" class="field no-border">
                <textarea v-model="feedbackForm.description" :class="{'active': feedbackForm.description.trim().length > 5}" placeholder="Сообщение" class="field field-message no-border"></textarea>
                <button @click="sendFeedBack" type="button" class="no-border send-btn">Отправить сообщение</button>
            </div>
        </div>
    </div>
</template>


<style scoped>


    .container {
        width: 100%;
        gap: var(--gp-32);
    }

    .wrapper-container {
        width: 100%;
        padding-inline: 96px;
        padding-block: 64px;
        margin: 0 auto;
        background-color: var(--bg-third-25);
        border: 1px solid var(--bg-third-100);
        border-radius: 32px;
    }

    .wrapper-container h1 {
        font-size: 32px;
        font-family: Roboto_Bold;
    }


    .form-container {
        max-width: 736px;
        width: 100%;
        margin: 0 auto;
        gap: var(--gp-32);
        font-family: Roboto_Medium;
        font-size: 20px;
    }

    .field {
        background-color: #1B1C21;
        padding: 12px 16px;
        border-radius: 8px;
        border-left: 3px solid var(--btn-color-2);
        color: var(--font-primary-75);
    }

    .field.active {
        border-left-color: var(--font-secondary);
    }

    .field::placeholder {
        color: var(--font-primary-25);
    }

    
    .field-message {
        padding: 16px;
        height: 300px;
        resize: none;
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

    .send-btn {
        width: 100%;
        background-color: var(--font-secondary);
        padding-block: 10px;
        border-radius: 8px;
        font-size: 16px;
    }

    .field option {
        color: #fff;
        background: #1B1C21;
        font-size: 16px;
    }

    @media (max-width: 1160px) {
        .wrapper-container {
            border-radius: 0px;
        }

    }

     @media (max-width:1024px) {
        .wrapper-container {
            padding-inline: 48px;
        }
        
    }

    @media (max-width:500px) {
        .wrapper-container {
            padding-inline:16px;
            padding-block: 32px;
        }

        .wrapper-container h1 {
            font-size: 28px;
        }

        .form-container {
            font-size: 18px;
        }

        .field-message {
            height: 200px;
        }
    }

</style>