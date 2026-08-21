<script setup>
    import { ref, onMounted } from 'vue'
    import { useRoute } from 'vue-router'
    import { checkViewEntity } from '@utils/helpers/viewTracker'
    import { useGlobal404 } from '@composables/useGlobal404'
    import { formatDate } from '@/utils/date/formatDate';
    import api from '@utils/axios'

    import AuthorBlock from '@components/common/AuthorBlock.vue'
    import ThemeLabel from '@components/common/ThemeLabel.vue'
    import EntityActions from '@components/common/EntityActions.vue';
    import EditArticle from '@components/articles/EditArticle.vue';
    import CommentWrapper from '@components/comments/CommentWrapper.vue';
    
    const { set404 } = useGlobal404()
    const { formatRelativeDate } = formatDate()
    const route = useRoute()

    const article = ref({})
    const isLoading = ref(true);
    const entity_type = route.meta.entity_type

    const loadArticle = async () => {
        try {
            const idArticle = route.params.id
            const shouldIncrement = checkViewEntity(idArticle, entity_type)
            
            const { data } = await api.get(`/article/${idArticle}${shouldIncrement ? '?incrementView=true' : ''}`)
            
            if (!data) {
                set404()
                return
            }
            article.value = data
        } catch (error) {
            set404()
        } finally {
            isLoading.value = false
        }
    }

    // Редактирование
    
    const isEditing = ref(false)

    onMounted(async () => {
        await loadArticle()
    });


</script>

<template>
    <Transition name="fade">
        <div v-if="article && !isLoading" class="article flex-column">
            <div class="label-wrapper flex justify-sb">
                <ThemeLabel 
                    :label="article.title"
                    :btm-info="{date: formatRelativeDate(article.created_at), theme: article.category}"
                />
                <EntityActions
                    :entity="entity_type"
                    @isEdit="isEditing = true"
                />
            </div>

            <AuthorBlock
                :author="{name: article.author_name, avatar: article.author_avatar, role: article.author_role}"
                :views="article.views"
                :comments="article.comments"
            />

            <EditArticle v-if="isEditing"
                :article="article"
                @close="isEditing = false"
                @edit="loadArticle"
            />

            <div v-if="!isEditing" v-html="article.content" class="content-block flex-column"></div>

            <CommentWrapper
                :counter="article.comments"
                id="comments-section"
            />
        </div>
    </Transition>

</template>

<style lang="scss" scoped>

    .article {
        width: 100%;
        font-family: Roboto_Medium;
        background-color: var(--bg-tertiary);
        border-radius: 8px;
        padding: 32px;
        gap: var(--gp-24);

        .label-wrapper {
            width: 100%;
            gap: var(--gp-16);
        } 

        
        @media (max-width:1160px) {
            border-radius: 0px;
            padding: 32px 24px;
        }

        @media (max-width:599px) {
            padding: 24px 16px;
        }

    }

    /* Контент новости */

    .content-block {
        &:deep(.img-block img) {
            border-radius: 8px;
            width: 100%;
            max-height: 542px;
        }

        &:deep(.text-content) {
            font-size: 20px;
            line-height: 32px;
            color: var(--font-primary-75);

            @media (max-width:600px) {
                font-size: 16px;
                line-height: 24px;
                color: var(--font-primary-75);
            }
        }
    }

</style>