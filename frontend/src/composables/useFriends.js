import { ref, watch } from 'vue'
import { api } from '@utils/axios'
import { useApiNotifications } from '@composables/useApi'
import { storeToRefs } from 'pinia'
import { useAuthStore } from '@stores/authStore'

export const useFriends = () => {
    const { apiCall } = useApiNotifications()
    const authStore = useAuthStore()
    const { isAuthenticated } = storeToRefs(authStore)

    const foundUsers = ref([])
    const queryNickname = ref('')
    const searchUsers = async (query) => {
        try {
            const { data } = await api.get('/friends/searchUsers', {
                params: {
                    nickname: query.value
                }
            })
            foundUsers.value = data.users || []
        } catch(error) {
            foundUsers.value = []
        }
    }

    // Добавление

    const addbtnState = ref({})

    const addUser = async (user) => {
        const response = await apiCall(
            () => api.post('/friends/add', { idUser: user.idUser })
        ,'Заявка в друзья отправлена');
        
        if (response.success) {
            addbtnState.value[user.idUser] = 'remove';
        }
    };

    // Удаление

    const removeUser = async (user) => {
        const response = await apiCall(() => api.delete(`/friends/${user.idUser}/delete`), 'Заявка отменена')
        if(response.success) {
            addbtnState.value[user.idUser] = null
        }
    } 

    // Входящие

    const incomingUsers = ref([])
    const totalIncoming = ref(0)

    const loadIncomingUsers = async () => {
        try {
            const { data } = await api.get('/friends/incoming')
            incomingUsers.value = data.result.users || []
            totalIncoming.value = data.result.totalIncoming || 0
        } catch(error) {
            incomingUsers.value = []
            totalIncoming.value = 0
        }
    }

    const handleIncoming = async(action, incoming) => {
        const response = await apiCall(() => api.put('/friends/handleIncoming', {
                action: action,
                user_id: incoming.idUser
            }))
            
        if(response.success) {
            await Promise.all([
                loadIncomingUsers(),
                loadFriends()
            ])
        }
    }

    // загрузка друзей

    const friendList = ref([])

    const loadFriends = async () => {
        try {
            const { data } = await api.get('/friends')
            friendList.value = data.friends || []
        } catch(error) {
            friendList.value = []
        }
    }

    // Удаление друга

    const contextUser = ref(null)

    const removeFriend = async () => {
        if(!contextUser.value) return 
        const response = await apiCall(() => api.delete(`/friends/${contextUser.value.idUser}/delete`), 'Пользователь удалён из друзей')   
        if(response.success) {
            await loadFriends()
        }
    }

// общий метод

    const loadFriendsData = async () => {
        try {
            await Promise.all([
                loadIncomingUsers(),
                loadFriends()
            ])
        } catch(error) {
            console.log('Ошибка загрузки:', error)
        }
    }


    const debounceTimer = ref(null)

    watch(queryNickname, async (newValue) => {
        if(debounceTimer.value) {
            clearTimeout(debounceTimer.value)
        }
        
        debounceTimer.value = setTimeout(async () => {
            if(newValue.trim().length >= 5) {
                await searchUsers(queryNickname)
            } else {
                foundUsers.value = []
            }
        }, 300)
    })

    watch(isAuthenticated, async (auth) => {
        if(auth) {
            await loadFriendsData()
        }
    })


    
    return {
        contextUser,
        friendList,
        foundUsers,
        queryNickname,
        addbtnState,
        totalIncoming,
        incomingUsers,
        addUser,
        removeUser,
        searchUsers,
        loadIncomingUsers,
        handleIncoming,
        loadFriends,
        removeFriend,
        loadFriendsData,
    }
}
