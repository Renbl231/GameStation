<script setup>
    import RequestGame from '../components/RequestGame.vue'
    import RequestSite from '../components/RequestSite.vue'

    import { ref, onMounted } from 'vue'
    import api from '../utils/axios'

    // Загрузка данных

    const gameRequests = ref([])
    const siteRequests = ref([])
    
    const loadRequests = async () => {
        try {
            const { data } = await api.get('/moderation/requests')
            if (data.result) {
                gameRequests.value = data.result.gameRequests || []
                siteRequests.value = data.result.siteRequests || []
            }
        } catch(error){}
    }

    onMounted(async() => {
        await loadRequests()
    })

</script>

<template>

    <div class="container flex">
        <div class="requestGame-wrapper flex-column">
            <RequestGame
                v-for="request in gameRequests"
                :key="request.idRequest"
                :item="request"
                @update-list="loadRequests"
            />
        </div>
        <div class="requestSite-wrapper flex-column">
            <RequestSite 
                v-for="request in siteRequests"
                :key="request.idQuestion"
                :item="request"
                @update-list="loadRequests"
            />
        </div>
    </div>

</template>

<style scoped>
    
    .container {
        width: 100%;
        gap: var(--gp-16);
    }

    .requestGame-wrapper {
        width: 50%;
        gap: var(--gp-16);
    }

    .requestSite-wrapper {
        width: 50%;
        gap: var(--gp-16);
    }

</style>