



<template>
    <div class="nav-container">
        <nav class="flex align-c">
            <ul class="flex align-c">
                <li><RouterLink to="/rules" :class="{'active':$route.path.startsWith('/rules')}">Правила сайта</RouterLink></li>
                <li><RouterLink to="/contact" :class="{'active':$route.path.startsWith('/contact')}">Связаться с нами</RouterLink></li>
                <li><RouterLink to="/helpSection" :class="{'active':$route.path.startsWith('/helpSection')}">Для команды портала</RouterLink></li>
            </ul>
        </nav>
    </div>

</template>

<style scoped>
    .nav-container {
        max-width: 1312px;
        width: 100%;
        font-size: 20px;
        font-family: Roboto_SemiBold;
        padding-block: 10px;
    }

    nav {
        width: 100%;
    }

    ul {
        white-space: nowrap;
        gap: var(--gp-24);
    }

    li {
        display: flex;
        align-items: center;
    }

    li a {
        background-color: var(--bg-secondary-25);
        color: var(--font-primary-35);
        border-radius: 4px;
        padding: 10px 30px;
    }

    li a.active, li a:hover {
        background-color: var(--font-secondary);
        color: var(--font-primary);
    }

    @media (max-width:1160px) {
        .nav-container {
            background-color: var(--bg-third-25);
            font-size: 18px;
        }
        nav {
            padding-inline:24px;
        }

        li a {
            background-color: transparent;
            padding: 10px;
        }
    }

     @media (max-width:820px) {
        nav ul {
            overflow-x: auto;
            overflow-y: hidden;
        }

        .nav-container nav ul::-webkit-scrollbar {
            display: none;
        }
    }

    @media (max-width:500px) {
        .nav-container {
            font-size: 16px !important;
        }

        nav {
            padding-inline: 16px;
        }

        ul {
            gap: var(--gp-16);
        }
        
    }
    
</style>