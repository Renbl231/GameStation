<script setup>
    import BanModal from '@components/BanModal.vue';

    import { ref, onMounted, watch, provide, computed} from 'vue'
    import { storeToRefs } from 'pinia'
    import { useAuthStore } from '@stores/authStore'
    import { useRoute, } from 'vue-router'
    import api from '@utils/axios'
    import { useGlobal404 } from '@composables/useGlobal404'

    import { useModeration } from '@composables/useModeration';
    import { checkColorRole, checkNameRole } from '@/utils/checkRole';

    import ProfileBanner from '@/components/users/ProfileBanner.vue';
    import ProfileAvatar from '@/components/users/ProfileAvatar.vue';
    import ProfileNavigation from '@/components/users/ProfileNavigation.vue';
    import ProfileEdit from '@/components/users/ProfileEdit.vue';
    import ProfileModeration from '@/components/users/ProfileModeration.vue';

    const { canModerate } = useModeration()

    const { set404 } = useGlobal404()

    const authStore = useAuthStore()
    const { user } = storeToRefs(authStore)

    const route = useRoute()

    const isEdit = ref(false)
    const isLoading = ref(true)

    const userData = ref({})

    const userId = ref(null)
    provide('userId', userId)

    const collectionGames = ref([])

    const favoriteGames = computed(() => 
        collectionGames.value.filter(game => game.collection_type === 'Любимые')
    )

    const currentGames = computed(() => 
        collectionGames.value.filter(game => game.collection_type === 'Сейчас играю')
    )

    const requestData = async () => {
        isLoading.value = true
        try {
            const { data } = await api.get(`/user/${route.params.nickname}`)
            if(data.success && data.userData) {
                userData.value = data.userData || null
                userId.value = data.userData.idUser
                collectionGames.value = data.userData.games
            } else {
                set404()
            }
        } catch(error) {
            userData.value = null
            set404()
        } finally {
            isLoading.value = false
        }
    }

    watch(
        () => route.params.nickname,
        async (newNickname) => {
            if (newNickname) await requestData()
        }
    )


    onMounted(async () => {
        await requestData()
    })

    const isModerate = ref(false)

    // Блокировка

    const isBanModal = ref(false)
    const banModalType = ref(null)


    const handleBlock = (value) => {
        banModalType.value = value
        isBanModal.value = true
    } 


</script>

<template>

    <Transition name="fade">

        <div v-if="userData && Object.keys(userData).length > 0 && !isLoading" class="profile flex-column">
            
            <ProfileBanner 
                :banner="userData.banner"
                :id-user="userData.idUser"
            />

            <BanModal
                v-model="isBanModal"
                :nickname="userData.nickname"
                :user_id="userData.idUser"
                :type="banModalType"
            />
            
            <div class="profile__header flex-column">
                <div class="flex align-c" style="gap: var(--gp-24);">
                    <ProfileAvatar
                        :avatar="userData.avatar"
                        :id-user="userData.idUser"
                        :user-role="userData.role"
                        :rating="userData.rating"
                    />
                    <div class="profile__header-info flex-column">
                        <div class="flex align-c" style="gap: var(--gp-16); width: 100%;">
                            <span class="profile__nickname">{{ userData.nickname }}</span>
                            <div class="profile__btns flex align-c">
                                <button v-if="user?.id !== userData.idUser && canModerate(userData.idUser)" @click="isModerate = !isModerate" type="button" class="no-border profile__btn">
                                    Модерировать
                                </button>
                                <button v-if="user?.id === userData.idUser" @click="isEdit = !isEdit" type="button" class="no-border profile__btn">
                                    Настройки
                                </button>
                            </div>
                        </div>
                        <span v-show="checkNameRole(userData.role)" class="profile__role" :style="`color: ${checkColorRole(userData.role)}`">{{ checkNameRole(userData.role) }}</span>
                        <ProfileNavigation 
                            :counters="userData.counters"
                        />
                    </div>
                </div>
                <hr>
            </div>

            <ProfileModeration 
                v-if="isModerate && canModerate(userData.idUser)" 
                :id-user="userData.idUser" 
                @change="(role) => userData.role = role"
                @ban="handleBlock"
            />

            <ProfileEdit v-if="isEdit" @close="isEdit = false"/>

            <RouterView />
        </div>
    </Transition>
</template>

<style lang="scss" scoped>

    .profile {
        width: 100%;
        gap: var(--gp-32);

        &__wrapper {
            width: 100%;
            padding-inline: 32px;
            padding-bottom: 32px;
        }

        &__header {
            width: 100%;
            gap: var(--gp-24);

            &-info {
                width: 100%;
                gap: var(--gp-16);
            }
        }

        &__nickname {
            font-family: Roboto_SemiBold;
            font-size: 36px;
            color: var(--text-primary);
            line-height: 1;

            @media(max-width:600px) {
                font-size: 20px;;
            }
        }

        &__role {
            width: fit-content;
            font-family: Roboto_Medium;
            font-size: 18px;
            padding: 4px 12px;
            border-radius: 16px;
            background-color: var(--bg-secondary);
        }

        &__btns {
            margin-left: auto;
            gap: var(--gp-8);
        }

        &__btn {
            width: fit-content;
            height: fit-content;
            font-size: 16px;
            font-family: Roboto_Medium;
            background-color: var(--bg-secondary);
            padding: 8px;
            border-radius: 4px; 
            color: var(--text-primary);

            &:hover {
                background-color: var(--bg-secondary-hover);
            }
        }
    }


    </style>