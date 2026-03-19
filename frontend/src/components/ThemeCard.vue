<script setup>
    import { useFormatDate} from '../composables/useFormatDate';
    import { ref, watch } from 'vue'

    const { formatDate } = useFormatDate()

    const props = defineProps({
        id: Number,           
        title: String,        
        description: String,
        nickname: String,
        avatar: String,
        comments: Number,
        status: String,
        created_at: [String, Date]
    })

    const authorAvatar = ref(props.avatar || null)

    watch(() => props.avatar, (newAvatar) => {
        authorAvatar.value = newAvatar || null
    })
</script>

<template>
    <div class="card flex-column">
        <span class="label">{{ title }}</span>
        <div class="author-wrapper flex align-c">
            <RouterLink :to="`/user/${nickname}`">
                <div class="author-info flex align-c">
                    <img v-if="authorAvatar"
                        @error="authorAvatar = null"
                        :src="authorAvatar" 
                        class="author-avatar"
                    >
                    <span class="author-name">{{ nickname }} |</span>
                </div>
            </RouterLink>
            <span class="date-publish">{{ formatDate(created_at) }}</span>
        </div>
        <p class="description-theme">{{ description }}</p>
        <div class="bottom-info flex align-c justify-sb">
            <span class="comment flex-center"><svg><use href="#icon-comment"></use></svg>Комментарии ({{ comments }})</span>
            <span>{{ status }}</span>
        </div>
    </div>
</template>

<style scoped>
    .card {
        width: 100%;
        padding: 16px;
        border-radius: 4px;
        background-color: var(--bg-secondary-25);
        gap: var(--gp-12);
        font-family: Roboto_Medium;
    }

    .label {
        font-size: 18px;
        font-family: Roboto_SemiBold;
    }

    .author-wrapper {
        gap: var(--gp-4);
    }

    .author-avatar {
        width: 32px !important;
        height: 32px !important;
        border-radius: 50%;
    }

    .author-info {
        gap: var(--gp-8);
        color: var(--font-primary-50);
    }

    .author-name {
        font-size: 16px;
    }

    .date-publish {
        font-size: 14px;
        color: var(--font-primary-50);
    }

    p {
        font-size: 16px;
        line-height: 24px;
        color: var(--font-primary-75);
    }
    
    .bottom-info {
        margin-top: 4px;
        font-size: 14px;
    }
    
    .comment {
        color: var(--font-primary-50);
        gap: var(--gp-8);
    }

    .comment svg {
        width: 20px;
        height: 20px;
    }

</style>