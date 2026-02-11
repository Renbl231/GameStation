<script setup>
    import SelectionCard from '../components/ArticleCard.vue'
</script>

<template>
    <div class="selections-container flex-column">
        <div class="headline">
            <span>Подборки игр</span>
        </div>
        <div class="selection-wrapper">

            <SelectionCard type="selection" />
            <SelectionCard type="selection" />
            <SelectionCard type="selection" />
            <SelectionCard type="selection" />
            <SelectionCard type="selection" />

        </div>      
    </div>
</template>

<style scoped>
    .selections-container {
        width: 100%;
        gap: var(--gp-24);
        background-color: var(--bg-secondary-25);
        padding: 32px;
        border-radius: 8px;
    }

    .headline {
        font-family: Roboto_SemiBold;
        font-size: 32px;
    }

    .selection-wrapper {
        display: grid;
        grid-template-columns: repeat(3, 1fr);
        gap: var(--gp-32);
    }

    @media (max-width:1160px) {
        .selections-container {
            border-radius: 0px;
        }
    }
    
    @media (max-width:1024px) {
        .selection-wrapper {
            grid-template-columns: repeat(2, 1fr);
        }
    }

    @media (max-width:600px) {  
        .selections-container {
            padding: 16px;
        }  
        .selection-wrapper {
            gap: var(--gp-16);
        }
        .headline { 
            font-size: 24px;
        }
    }

    @media (max-width:425px) {
        .headline {
            font-size: 24px;
        }
    }

    @media (max-width:375px) {
        .headline {
            font-size: 20px;
        }
    }
</style>