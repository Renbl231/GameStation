<script setup>
    import { ref, onMounted, onUnmounted, nextTick } from 'vue';

    const isVisible = ref(false)

    let scrollTimeout = null

    const scrollToTop = () => {
        window.scrollTo({
            top: 0,
            behavior: 'smooth'
        })
    }

    const handleScroll = () => {
        if(scrollTimeout) return

        scrollTimeout = setTimeout(() => {
            isVisible.value = window.scrollY > 300
            scrollTimeout = null
        }, 50)
    }

    onMounted(() => {
        nextTick(() => {
            window.addEventListener('scroll', handleScroll)
        })
    })

    onUnmounted(() => {
        window.removeEventListener('scroll', handleScroll)
    })


</script>

<template>
    <div v-if="isVisible" class="scroll-block flex">
        <button @click="scrollToTop" type="button" class="no-border scroll-block__btn flex">
                            <svg class="scroll-icon flex-center"><use href="#icon-arrow"></use></svg>
            <span class="span-text">
                Наверх
            </span>
        </button>
    </div>
</template>

<style scoped>
    .scroll-block {
        width: 80px;
        height: 100vh;
        position: fixed;
    }

    .scroll-block__btn {
        width: fit-content;
        padding: 24px 16px;
        gap: var(--gp-12);
    }

    .scroll-block__btn:hover {
        background-color: var(--bg-primary);
        filter: brightness(1.2);
    }

    .span-text {
        font-family: Roboto_Regular;
        font-size: 14px;
    }

    .scroll-icon {
        max-width: 16px;
        min-width: 16px;
        height: 16px;
        stroke: var(--font-primary-25);
        transform: rotate(180deg);
    }

    @media (max-width:1024px) {
        .scroll-block {
            height: fit-content;
            bottom: 8px;
            z-index: 150;
        }
        .scroll-block__btn {
            background-color: var(--bg-primary);
            border-radius: 4px;
            padding: 16px;

        }
    }

</style>