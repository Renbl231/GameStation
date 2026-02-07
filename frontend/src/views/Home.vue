<script setup>

</script>


<template>
    <div class="container flex-column">

        <div class="headline-bar flex justify-sb">
            <div class="headline-home flex align-c">
                <svg>
                    <use href="#icon-rule"></use>
                </svg>
                <h1 class="label-home">Главное сегодня</h1>
            </div>
            <div class="switch-btn-block flex align-c">
                <button type="button" class="no-border switch-slide-btn flex-center"><svg><use href="#icon-btn-slider-1"></use></svg></button>
                <button type="button" class="no-border switch-slide-btn flex-center"><svg><use href="#icon-btn-slider-1"></use></svg></button>
            </div>
        </div>
        <div class="slider-container flex">
            <div class="main-section">
                <div class="main-slide">
                    <picture>
                        <img src="/images/2.jpeg" class="zoom-image">
                    </picture>
                    <div class="top-info flex align-c">
                        <span class="category-slider">release</span>
                        <button type="button" aria-label="Оценить новость" class="no-border counter-slider flex-center"><svg><use href="#icon-like"></use></svg>14633</button>
                    </div>
                    <div class="slider-dots flex-column">
                        <span class="dot active" data-slide="0"></span>
                        <span class="dot" data-slide="1"></span>
                        <span class="dot" data-slide="2"></span>
                        <span class="dot" data-slide="3"></span>
                    </div>
                    <div class="bottom-info flex-column">
                        <span class="label-slider">Провальный релиз Escape From Tarkov</span>
                        <p class="description-slider">Почему релиз EFT настолько был плох ? Сколько был пиковый онлайн игр в день релиза и как игроки оценили игру</p>
                    </div>
                </div>
                    <div class="switch-btn-block-mob flex justify-sb align-c hidden">
                        <button type="button" class="no-border switch-slide-btn flex-center"><svg><use href="#icon-btn-slider-1"></use></svg></button>
                        <div class="slider-dots-mob flex-center">
                            <span class="dot active" data-slide="0"></span>
                            <span class="dot" data-slide="1"></span>
                            <span class="dot" data-slide="2"></span>
                            <span class="dot" data-slide="3"></span>
                        </div>
                        <button type="button" class="no-border switch-slide-btn flex-center"><svg><use href="#icon-btn-slider-1"></use></svg></button>
                    </div>
            </div>

            <div class="secondary-sections flex-column">
                <div class="secondary-slides">
                    <picture class="zoom-image">
                        <img src="/images/orig.webp" class="zoom-image">
                    </picture>
                    <span class="category-slider">update</span>
                    <div class="bottom-info flex-column">
                        <span class="label-slider">Обновление v2.31</span>
                        <span class="createDate-slider">13 часов назад</span>
                    </div>
                </div>

                <div class="secondary-slides">
                    <picture>
                        <img src="/images/1.webp" class="zoom-image">
                    </picture>
                    <span class="category-slider">update</span>
                    <div class="bottom-info flex-column">
                        <span class="label-slider">Обновление v2.31</span>
                        <span class="createDate-slider">13 часов назад</span>
                    </div>
                </div>

                <div class="secondary-slides">
                    <picture>
                        <img src="/images/2.jpeg" class="zoom-image">
                    </picture>
                    <span class="category-slider">update</span>
                    <div class="bottom-info flex-column">
                        <span class="label-slider">Обновление v2.31</span>
                        <span class="createDate-slider">13 часов назад</span>
                    </div>
                </div>
            </div>
        </div>

        <div class="headline">
            <span>Игровая статистика друзей</span>
        </div>
        
        <div class="friends-activity-wrapper flex-column">
            <div class="activity-card flex-column">
                <div class="friend-profile flex">
                    <img src="/images/12.jpg" class="friend-avatar">
                    <div class="banner-container">
                        <img src="/images/5.jpg" class="friend-banner">
                        <span class="friend-name">Cl0WN1CH</span>
                    </div>
                </div>
                <div class="activity flex">
                    <img src="/images/2.jpeg" class="game-img">
                    <div class="activity-content flex-column">
                        <span class="date-activity">18 сентребря 2025</span>
                        <span class="type-activity">Добавил(а) <span class="name-game">Dishonored</span> в Любимые игры</span>
                    </div>
                </div>
                <div class="activity flex">
                    <img src="/images/6.jpg" class="game-img">
                    <div class="activity-content flex-column">
                        <span class="date-activity">18 сентребря 2025</span>
                        <span class="type-activity">Добавил(а) <span class="name-game">Dishonored</span> в Любимые игры</span>
                    </div>
                </div>
                <div class="activity flex">
                    <img src="/images/5.jpg" class="game-img">
                    <div class="activity-content flex-column">
                        <span class="date-activity">18 сентребря 2025</span>
                        <span class="type-activity">Добавил(а) <span class="name-game">Dishonored</span> в Любимые игры</span>
                    </div>
                </div>
                <button type="button" class="no-border show-more-activity">Подробнее...</button>
                <div class="statistic-wrapper flex align-c">
                    <div class="completed-game stat-block flex align-c">
                        <span>пройдено:</span>
                        <span class="quantity-stat">1500</span>
                    </div>
                    <div class="rated stat-block flex align-c">
                        <span>оценено:</span>
                        <span class="quantity-stat">131</span>
                    </div>
                    <div class="played stat-block flex align-c">
                        <span>сыграно:</span>
                        <span class="quantity-stat">32</span>
                    </div>
                </div>
            </div>
        </div>

        <div class="reviews-container flex-column">
            <div class="headline">
                <span>Обзоры от нас</span>
            </div>
            <div class="review-wrapper">
                <div class="review-card">
                    <span class="rating">10</span>
                    <picture>
                        <img src="/images/4.jpg">
                    </picture>
                    <div class="type-review flex align-c">
                        <svg><use href="#icon-review"></use></svg>
                        <span>Обзор</span>
                    </div>
                    <div class="review-content flex-column">
                        <div class="top-content">
                            Мы поиграли в CyberPunk 2077 и DLC
                        </div>
                        <div class="bottom-content flex align-c justify-sb">
                            <span class="datePublish">1 января</span>
                            <span class="counter-comment flex align-c"><svg><use href="#icon-comment"></use></svg>128</span>
                        </div>
                    </div>
                </div>

                <div class="review-card">
                    <span class="rating">10</span>
                    <picture>
                        <img src="/images/5.jpg">
                    </picture>
                    <div class="type-review flex align-c">
                        <svg><use href="#icon-review"></use></svg>
                        <span>Обзор</span>
                    </div>
                    <div class="review-content flex-column">
                        <div class="top-content">
                            Мы поиграли в CyberPunk 2077 и DLC
                        </div>
                        <div class="bottom-content flex align-c justify-sb">
                            <span class="datePublish">1 января</span>
                            <span class="counter-comment flex align-c"><svg><use href="#icon-comment"></use></svg>128</span>
                        </div>
                    </div>
                </div>

                <div class="review-card">
                    <span class="rating">10</span>
                    <picture>
                        <img src="/images/6.jpg">
                    </picture>
                    <div class="type-review flex align-c">
                        <svg><use href="#icon-review"></use></svg>
                        <span>Обзор</span>
                    </div>
                    <div class="review-content flex-column">
                        <div class="top-content">
                            Мы поиграли в CyberPunk 2077 и DLC
                        </div>
                        <div class="bottom-content flex align-c justify-sb">
                            <span class="datePublish">1 января</span>
                            <span class="counter-comment flex align-c"><svg><use href="#icon-comment"></use></svg>128</span>
                        </div>
                    </div>
                </div>

                <div class="review-card">
                    <span class="rating">10</span>
                    <picture>
                        <img src="/images/7.jpg">
                    </picture>
                    <div class="type-review flex align-c">
                        <svg><use href="#icon-review"></use></svg>
                        <span>Обзор</span>
                    </div>
                    <div class="review-content flex-column">
                        <div class="top-content">
                            Мы поиграли в CyberPunk 2077 и DLC
                        </div>
                        <div class="bottom-content flex align-c justify-sb">
                            <span class="datePublish">1 января</span>
                            <span class="counter-comment flex align-c"><svg><use href="#icon-comment"></use></svg>128</span>
                        </div>
                    </div>
                </div>

            </div>
        </div>
    </div>
</template>


<style scoped>
    .container {
        width: 100%;
        gap: var(--gp-32);
    }

    .headline-home {
        gap: var(--gp-10);
    }

    .headline-home svg {
        width: 28px;
        height: 26px;
    }

    .label-home {
        font-size: 32px;
        font-family: Montserrat_SemiBold;
    }

    .switch-btn-block {
        gap: var(--gp-16);
    }

    .switch-slide-btn {
        position: relative;
        width: 36px;
        height: 36px;
        border: 2px solid var(--font-secondary);
    }

    .switch-btn-block button:nth-child(1), .switch-btn-block-mob button:nth-child(1) svg {
        transform: rotate(180deg);
    }

    .switch-btn-block button:nth-child(2) svg, .switch-btn-block-mob button:nth-child(2) svg  {
        transform: rotate(0deg);
    }

    .switch-slide-btn svg {
        width: 16px;
        height: 16px;
    }

    .slider-container {
        width: 100%;
        gap: var(--gp-32);
        margin-bottom: 32px;
    }

    .main-section {
       max-width: 928px;
       width: 100%;
    }

    .main-slide {
        position: relative;
        width: 100%;
        border-radius: 8px;
        overflow: hidden;
        box-shadow: 0 8px 64px 0 rgba(69, 171, 255, 0.25);
        will-change: transform;
    }

    .main-slide img {
        width: 100%;
        height: 522px;
        border-radius: 8px;
    }

    .main-slide::before {
        content: '';
        position: absolute;
        top: 0;
        left: 0;
        right: 0;
        bottom: 0;

        background: linear-gradient(
            to bottom,
            transparent 0%,
            transparent 40%,
            rgba(0,0,0,0.6) 70%,
            rgba(0,0,0,0.9) 100%
        );

        z-index: 1;
    }

    .counter-slider {
        position: absolute;
        top: 16px;
        right: 16px;
        z-index: 10;
        gap: var(--gp-8);
        font-size: 14px;
        font-family: Roboto_SemiBold;
        padding: 8px;
        background-color: var(--btn-color-3);
        border-radius: 4px;
        color: var(--font-primary-25);
    }

    .counter-slider svg {
        width: 24px;
        height: 24px;
    }

    .bottom-info {
        max-width: 90%;
        position: absolute;
        bottom: 16px;
        left: 16px;
        z-index: 10;
        gap: var(--gp-8);
    }

    .label-slider {
        font-family: Montserrat_Bold;
        font-size: 32px;
        line-height: 42px;
    }

    .description-slider, .createDate-slider {
        font-size: 20px;
        font-family: Montserrat_Medium;
        line-height: 32px;
        color: var(--font-primary-50);
    }

    .category-slider {
        position: absolute;
        top: 16px;
        left: 16px;
        z-index: 10;
        font-size: 16px;
        font-family: Montserrat_SemiBold;
        text-transform: uppercase;
        padding: 8px 12px;
        background-color: rgba(0, 0, 0, 0.5);
        border-radius: 4px;
        backdrop-filter: blur(4px);
    }

    .slider-dots, .slider-dots-mob {
        position: absolute;
        top: 50%;
        right: 16px;
        gap: var(--gp-20);
        z-index: 30;
        transform: translateY(-50%);
    }

    .dot {
        width: 20px;
        height: 20px;
        border-radius: 50%;
        border: 2px solid var(--font-primary-50);
        cursor: pointer;
    }

    .dot.active {
        background-color: var(--font-secondary);
        border-color: var(--font-secondary);
    }

    .secondary-sections {
        max-width: 352px;
        width: 100%;
        gap: var(--gp-20);
    }

    .secondary-slides {
        position: relative;
        width: 100%;
        box-shadow: 0 8px 64px 0 rgba(69, 171, 255, 0.25);
        border-radius: 4px;
        will-change: transform;
        overflow: hidden;
    }

    .secondary-slides::before {
        content: '';
        position: absolute;
        top: 0;
        left: 0;
        right: 0;
        bottom: 0;

        background: linear-gradient(
            to bottom,
            transparent 0%,
            transparent 40%,
            rgba(0,0,0,0.6) 70%,
            rgba(0,0,0,0.9) 100%
        );

        z-index: 1;
        border-radius: 4px;
    }

    .secondary-slides img {
        width: 100%;
        height: 160px;
        border-radius: 4px;
    }

    .secondary-slides .bottom-info {
        gap: var(--gp-4);
        left: 8px;
        bottom: 8px;
    }

    .secondary-slides .label-slider {
        max-width: none;
        font-size: 18px;
        line-height: 22px;
    }

    .secondary-slides .category-slider {
        font-size: 10px;
        padding: 4px 8px;
        border-radius: 4px;
    }

    .secondary-slides .createDate-slider {
        font-size: 14px;
        line-height: 17px;
    }

    .secondary-slides .category-slider {
        top: 8px;
        left: 8px;
    }


    /* Отзывы */

    .reviews-container {
        width: 100%;
        gap: var(--gp-24);
    }

    .headline {
        padding-left: 24px;
        font-family: Roboto_SemiBold;
        font-size: 32px;
    }

    .headline span {
        border-bottom: 2px solid var(--font-secondary);
        padding-bottom: 8px;
    }

    .review-wrapper {
        background-color: var(--bg-secondary-25);
        padding: 32px 24px;
        border-radius: 16px;
        display: grid;
        grid-template-columns: repeat(3, 1fr);
        gap: var(--gp-32);
    }

    .review-card {
        max-width: 396px;
        width: 100%;
        position: relative;
        background-color: var(--bg-secondary-25);
        border: 1.5px solid var(--btn-color-4);
        font-family: Roboto_Medium;
        font-size: 20px;
        border-radius: 8px;
    }

    .review-card img {
        width: 100%;
        height: auto;
        border-radius: 8px 8px 0 0;
    }

    .rating {
        position: absolute;
        top: 8px;
        left: 8px;
        font-size: 16px;
        font-family: Roboto_SemiBold;
        padding: 0px 16px;
        background-color: var(--btn-color-5);
        border-radius: 16px;
    }

    .type-review, .review-content{
        padding: 16px;
    }

    .type-review {
        border-bottom: 2px solid var(--bg-secondary-50);
        color: var(--font-primary-50);
        gap: var(--gp-8);
    }

    .type-review svg {
        width: 20px;
        height: 20px;
    }

    .review-content {
        gap: var(--gp-16);
    }

    .top-content {
        font-size: 24px;
    }

    .bottom-content {
        color: var(--font-primary-35);
    }

    .counter-comment {
        gap:var(--gp-8)
    }

    .counter-comment svg {
        width: 24px;
        height: 24px;
    }

    .switch-btn-block-mob {
        position: relative;
        width: 100%;
        padding: 16px;
        border-bottom: 2px solid var(--bg-secondary-25)
    }

    .slider-dots-mob {
        position: absolute;
        top: 50%;
        left: 50%;
        gap: var(--gp-20);
        z-index: 30;
        transform: translate(-50%, -50%);
    }





    .friends-activity-wrapper {
        max-width: 768px;
        width: 100%;
        gap: var(--gp-32);
        background-color: var(--bg-secondary-25);
        border-radius: 8px;
    }

    .activity-card {
        width: 100%;
        padding: 24px;
        gap: var(--gp-32);
        font-family: Roboto_Medium;
    }

    .friend-profile {
        width: 100%;
        height: 90px;
    }

    .friend-avatar {
        width: 90px;
        height: 90px;
        border-radius: 8px 0px 0px 8px;
    }

    .friend-banner {
        width: 100%;
        height: 90px;
        border-radius: 0px 8px 8px 0px;
    }

    .banner-container {
        width: 100%;
        position: relative;
        border-radius: 8px;
    }

    .friend-name {
        position: absolute;
        top: 50%;
        transform: translateY(-50%);
        padding-left: 32px;
        font-size: 32px;
        font-family: Roboto_SemiBold;
        overflow: hidden;
    }

    .activity {
        gap: var(--gp-24);
    }

    .date-activity {
        font-size: 16px;
        color: var(--font-primary-50);
        margin-bottom: auto;
    }

    .type-activity {
        font-size: 20px;
        color: var(--font-primary-75);
    }

    .name-game {
        color: var(--font-primary);
    }

    .game-img {
        width: 60px;
        height: 60px;
        border-radius: 8px;
    }

    .show-more-activity {
        width: fit-content;
        padding: 0px;
        color: var(--font-secondary);
        border-bottom: 1px solid var(--font-secondary);
        font-size: 20px;
    }

    .statistic-wrapper {
        width: 100%;
        padding-block: 10px;
        background-color: var(--btn-color-6-25);
        justify-content: space-around;
    }

    .stat-block {
        gap: var(--gp-8);
    }

    .quantity-stat {
        font-size: 14px;
        color: var(--font-primary-50);
    }



/* Эффект на фотки */

.zoom-image {
  transition: transform 3s ease-in-out;
  transform-origin: center center;
}

.main-slide:hover .zoom-image, .secondary-slides:hover .zoom-image {
  transform: scale(1.25);
}

@media (max-width:1160px) {

    .secondary-sections {
        display: none;
    }

    .main-section {
        max-width: none;
    }

    .main-slide, .main-slide img, .review-wrapper  {
        border-radius: 0px;
    }

    .headline-bar, .headline {
        padding-inline: 32px;
    }

    .review-wrapper {
        gap: var(--gp-24);
    }

    .main-slide img {
        height: auto;
        max-height: 522px;
    }
}

@media (max-width:1024px) {
    .review-wrapper {
        grid-template-columns: repeat(2, 1fr);
    }

    .review-card {
        max-width: none;
    }
}

@media (max-width:900px) {
    .top-content {
        font-size: inherit;
    }
}

@media (max-width:767px) {
    .label-slider {
        font-size: 24px;
        line-height: 29px;
    }
    .description-slider {
        font-size: 16px;
        line-height: 20px;
    }
}

@media (max-width:600px) {
    .headline-bar, .headline {
       padding-inline: 16px; 
    }
    .switch-btn-block, .slider-dots {
        display: none;
    }
    .label-slider {
        font-size: 20px;
        line-height: 26px;
    }
    .description-slider {
        font-size: 12px;
        line-height: 18px;
    }
    .category-slider {
        font-size: 14px;
        top: 8px;
        left: 8px;
    }
    .counter-slider {
        font-size: 12px;
        top: 8px;
        right: 8px;
    }
    .counter-slider svg {
        width: 20px;
        height: 20px;
    }
    .bottom-info {
        max-width:none;
        bottom: 8px;
        left: 8px;
        gap: var(--gp-4);
        padding-right: 8px;
    }

    .switch-btn-block-mob {
        display: flex;
    }

    .review-wrapper {
        padding: 16px;
        gap: var(--gp-16);
    }

    .slider-container {
        margin-bottom: 0px;
    }

    .rating {
        font-size: 12px;
        padding-inline: 12px;
    }

    .type-review, .review-content {
        padding: 10px 8px;
    }

    .type-review svg {
        width: 14px;
        height: 14px;
    }

    .counter-comment svg {
        width: 16px;
        height: 16px;
    }

    .counter-comment {
        gap: var(--gp-6);
    }

    .review-card {
        font-size: 14px;
    }

    .top-content {
        font-size: 14px;
    }

    .label-home {
        font-size: 28px;
    }

    .headline-home svg {
        width: 24px;
        height: 22px;
    }
}

@media (max-width:425px) {
    .headline {
        font-size: 24px;
    }
    .category-slider {
        font-size: 10px;
        padding: 6px 8px;
    }
    .counter-slider {
        font-size: 12px;
        padding: 6px;
    }
    .counter-slider svg {
        width: 16px;
        height: 16px;
    }
    .label-slider {
        font-size: 18px;
        line-height: 22px;
    }
    .description-slider {
        font-size: 10px;
        line-height: 14px;
    }
    .rating {
        left: 4px;
        top: 4px;
        font-size: 10px;
    }

    .review-card img {
        height: 105px;
    }
}

@media (max-width:375px) {
    .dot {
        width: 16px;
        height: 16px;
    }
    .label-slider {
        font-size: 14px;
        line-height: 18px;
    }

} 

@media (max-width:320px) {
    .switch-slide-btn {
        width: 32px;
        height: 32px;
    }
    .review-card, .top-content {
        font-size: 12px;
    }
    .type-review svg {
        width: 12px;
        height: 12px;
    }
    .type-review {
        gap: var(--gp-6);
    }
    .bottom-content {
        font-size: 10px;
    }
    .counter-comment {
        gap: var(--gp-4);
    }
    .review-card img {
        height: 87px;
    }
} 

</style>
