<script setup>
    import { ref, onMounted } from 'vue'
    import { checkViewEntity } from '@utils/helpers/viewTracker'
    import { useRoute } from 'vue-router'
    import { useGlobal404 } from '@composables/useGlobal404'
    import { formatDate } from '@/utils/date/formatDate';
    import api from '@utils/axios'

    import AuthorBlock from '@components/common/AuthorBlock.vue'
    import ThemeLabel from '@components/common/ThemeLabel.vue'
    import Advertisment from '@components/common/Advertisment.vue';
    import CommentWrapper from '@components/comments/CommentWrapper.vue';
    import EntityActions from '@components/common/EntityActions.vue';
    import EditNews from '@/components/news/EditNews.vue';

    const { set404 } = useGlobal404()
    const { formatRelativeDate } = formatDate()

    const route = useRoute()

    const news = ref({})
    const isLoading = ref(true);
    const entity_type = route.meta.entity_type

    const loadNews = async () => {
        
        try {
            const idNews = route.params.id            
            const shouldIncrement = checkViewEntity(idNews, entity_type)

            const { data } = await api.get(`/newsdata/${idNews}${shouldIncrement ? '?incrementView=true' : ''}`)
            
            if (!data) {
                set404()
                return
            }
            
            news.value = data
        } catch (error) {
            set404()
        } finally {
            isLoading.value = false
        }
    }


    const isEditing = ref(false)

    onMounted(async () => {
        await loadNews()
    });


</script>

<template>
    <Transition name="fade">
        <div v-if="news && !isLoading" class="container flex">
            <div class="news-container flex-column">

                <div class="label-wrapper flex justify-sb">
                    <ThemeLabel 
                        :label="news.title"
                        :btm-info="{date: formatRelativeDate(news.created_at), theme: news.category}"
                    />
                    <EntityActions
                        :entity="entity_type"
                        @isEdit="isEditing = true"
                    />
                </div>
                
                <AuthorBlock
                    :author="{name: news.author_name, avatar: news.author_avatar, role: news.author_role}"
                    :views="news.views"
                    :comments="news.comments"
                />

                <EditNews v-if="isEditing"
                    :news="news"
                    @close="isEditing = false"
                    @edit="loadNews"
                />

                <div v-if="!isEditing" v-html="news.content" class="content-block flex-column">
                </div>

                <!-- <CommentWrapper
                    :counter="news.comments"
                    id="comments-section"
                /> -->

            </div>

            <Advertisment />

        </div>
    </Transition>

</template>

<style lang="scss" scoped>

    .container {
        width: 100%;
        font-family: Roboto_Medium;
        background-color: var(--bg-tertiary);
        border-radius: 8px;
        padding: 32px;
        gap: var(--gp-32);

        @media (max-width:1160px) {
            border-radius: 0px;
            padding: 32px 24px;
        }

        @media (max-width:599px) {
            padding: 24px 16px;
        }
    }

    .news-container {
        width: 100%;
        gap: var(--gp-24);
    }

    .content-block {
        gap: var(--gp-32);
    }

    :deep(.text-content) {
        font-family: Roboto_Regular;
    }

    :deep(.img-block) {
        gap: var(--gp-8) !important;
    }

    :deep(.img-block img) {
        aspect-ratio: 843/474;
        border-radius: 8px;
        width: 100%;
        max-height: 480px;
    }
    ::v-deep(.text-content a) {
        color: var(--color-blue);
        text-decoration: underline;
    }

    :deep(.ulist) {
        list-style-type: disc;
    }
</style>