<script setup>
    import RequestGame from '../components/RequestGame.vue'
    import RequestSite from '../components/RequestSite.vue'

    import { ref, onMounted, watch } from 'vue'
    import api from '../utils/axios'

    import { useRoute, useRouter } from 'vue-router'
    const route = useRoute()
    const router = useRouter()

    import { inject } from 'vue'

    const userId = inject('userId')

    const gameRequests = ref([])
    const siteRequests = ref([])

    const loadRequests = async () => {
        try {
            const { data } = await api.get('/user/requests')
            if (data.result) {
                gameRequests.value = data.result.gameRequests || []
                siteRequests.value = data.result.siteRequests || []
            }
        } catch(error) {}
    }

    onMounted(() => {
        if (userId.value) loadRequests()
    })

    watch(
        () => route.path,
        async () => {
            if (userId.value) await loadRequests()
        }
    )
</script>

<template>

    <div class="requests-wrapper flex-column">
        <RequestGame
            v-for="request in gameRequests"
            :key="request.idRequest"
            :item="request"
        />

        <RequestSite
            v-for="(request, index) in siteRequests"
            :key="index"
            :item="request"
        />
    </div>

    

</template>

<style scoped>
    .requests-wrapper {
        width: 100%;
        gap: var(--gp-16);
    }
</style>