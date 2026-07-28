<script setup>
    import { ref } from 'vue'
    import { autoResizeTextarea } from '@utils/dom/textareaAutoresize'
    import { useInteractions } from '@composables/useInteractions';

    const { editComment } = useInteractions()

    const props = defineProps({
        idComment: Number,
        author_id: Number,
        content: String
    })

    const emits = defineEmits(['edited', 'closed'])

    const editedContent = ref(props.content)

    const handleEdit = async () => {
        const success = await editComment(props.idComment, editedContent.value.trim())
        if(success) emits('edited', editedContent)
    }
</script>

<template>
    <div class="editBlock flex-column">
        <textarea v-model="editedContent"
            class="no-border editBlock__field" 
            @input="autoResizeTextarea"
            placeholder="Ваш комментарий">
        </textarea>
        <div class="editBlock__btns flex align-c">
            <button class="no-border editBlock__btn editBlock__btn-edit" @click="handleEdit()">Редактировать</button>
            <button class="no-border editBlock__btn editBlock__btn-reject" @click="emits('closed')">Отменить</button>
        </div>
    </div>
</template>

<style lang="scss" scoped>
    .editBlock {
        padding: 16px;
        border-radius: 8px;
        border: 2px solid var(--btn-color-4);
        gap: var(--gp-4);

        &__field {
            width: 100%;
            height: 32px;
            min-height: 32px;
            resize: none;
            overflow: hidden;
            font-size: 16px;
        }

        &__btns {
            gap: var(--gp-10);
        }

        &__btn {
            width: fit-content;
            font-size: 14px;
            background-color: var(--btn-color-4);
            border-radius: 8px;
            padding: 8px 12px;

            &:hover {background-color: var(--font-primary-25);}

            @media (max-width:599px) {
                font-size: 13px;
            }

            @media (max-width:375px) {
                font-size: 12px;
            }
        }
    }
</style>