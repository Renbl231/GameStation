import { ref } from 'vue'

export const showGlobal404 = ref(false)

export const useGlobal404 = () => ({
    set404: () => showGlobal404.value = true
})