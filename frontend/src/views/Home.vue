<script setup>
    import { ref } from 'vue'
    import NewsSlider from '@components/Home/Slider.vue'
    import ArticlesSection from '@components/Home/ArticlesSection.vue'

    const isLoading = ref(true)
    const articleLoaded = ref(false)
    const sliderLoaded = ref(false)

    const isArticleLoaded = () => {
        articleLoaded.value = true
        isLoaded()
    }

    const isSliderLoaded = () => {
        sliderLoaded.value = true
        isLoaded()
    }

    const isLoaded = () => {
        if(articleLoaded.value && sliderLoaded.value)
            isLoading.value = false
    }
    
    
</script>

<template>
    <Transition name="fade">
        <div v-show="!isLoading" class="container flex-column">
            <NewsSlider @loaded="isSliderLoaded"/>
            <ArticlesSection @loaded="isArticleLoaded"/>
        </div>
    </Transition>
</template>


<style lang="scss" scoped>
    .container {
        width: 100%;
        gap: var(--gp-32);

        @media(max-width:1024px) {
            gap: var(--gp-16);
        }
    }
</style>
