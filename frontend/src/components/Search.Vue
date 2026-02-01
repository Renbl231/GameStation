<script setup>
    import { onMounted, ref} from 'vue'

    const props = defineProps(['closeFn'])
    const inputRef = ref(null)

    onMounted(() => {
        setTimeout(() => {
            isActive.value = true
        }, 30)
    })

    const close = () => {
        isActive.value = false
        setTimeout(() => props.closeFn(), 300)
    }
    const isActive = ref(false);


</script>


<template>
 <div class="search-block" :class="{activeSearch: isActive}">
    <div class="search-container flex-column align-c">
        <div class="label-block flex align-c">
            <h1>Поиск</h1>
            <button type="button" class="btn-close no-border" @click="close()" aria-label="Закрыть"></button>
        </div>
        <div class="search-field">
            <form action="#" class="search-form">
                <svg class="icon-search" @click="inputRef.focus()">
                    <use href="#icon-search"/>
                </svg>
                <input type="search" ref="inputRef" placeholder="Название игры" aria-label="Поиск">
            </form>
        </div>
    </div>    
 </div>
</template>

<style scoped>
    .search-block {
        position: fixed;
        z-index: 1001;
        bottom: 0;
        width: 100vw;
        height: 100vh;
        background-color: var(--hdr-primary);

        font-size: 20px;
        font-family: Roboto_SemiBold;

        transform: translateY(100%);
        transition: transform 0.4s cubic-bezier(0.25, 0.46, 0.45, 0.94);
    }

    .search-block.activeSearch {
        transform: translateY(0%);
    }

    .search-container {
        max-width: 1348px;
        width: 100vw;
        margin: 0 auto;
        padding: 32px 16px;
        gap: var(--gp-32);
    }

    .label-block {
        width: 100%;
        justify-content: space-between;
    }

    .search-field, .search-field input {
        width: 100%;
    }

    .search-form {
        position: relative;
    }

    .search-field input {
        border-radius: 8px;
        padding: 10px 16px 10px 54px;
        background-color: var(--bg-secondary-25);
        color: var(--font-primary-50);
        font-family: Roboto_Medium;
    }

    
    .search-field input::placeholder {
        color: var(--font-primary-50);
    }
    
    .icon-search {
        position: absolute;
        width: 22px;
        height: 22px;
        color: var(--font-primary-50);
        top: 50%;
        transform: translateY(-50%);
        left: 16px;
    }

    .btn-close {
        position: relative;
        width: 32px;
        height: 32px;
    }

    .btn-close::before,
    .btn-close::after {
        content: '';
        position: absolute;
        top: 50%;
        left: 50%;
        width: 20px;
        height: 2px;
        background: var(--font-primary-50);
        transform: translate(-50%, -50%) rotate(45deg);
    }

    .btn-close::after {
        transform: translate(-50%, -50%) rotate(-45deg);
    }

    .btn-close:hover::before,
    .btn-close:hover::after {
        background-color: var(--font-primary);
    }


</style>