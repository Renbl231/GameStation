<script setup>
    import NavBar from '../components/HelpBar.vue'
</script>

<template>
    <div class="container flex-column">
        <NavBar />
        <div class="wrapper-container flex">
            <div class="form-container flex-column">
                <h1>Связаться с нами</h1>
                <select class="field no-border">
                    <option value="" disabled hidden selected class="empty-option">Тема сообщения</option>
                    <option value="">Размещение рекламы</option>
                    <option value="">Работа сайта (баги, предложения)</option>
                    <option value="">Другой вопрос</option>
                </select>
                <input type="text" name="" id="" placeholder="Заголовок сообщения" class="field no-border">
                <textarea placeholder="Сообщение" class="field field-message no-border"></textarea>
                <button type="button" class="no-border send-btn">Отправить сообщение</button>
            </div>
        </div>
    </div>
</template>


<style scoped>

    .icon {
        width: 24px;
        height: 24px;
        margin-right: 8px;
    }

    .container {
        width: 100%;
        gap: var(--gp-32);
    }

    .wrapper-container {
        width: 100%;
        padding-inline: 96px;
        padding-block: 64px;
        margin: 0 auto;
        background-color: var(--bg-third-25);
        border: 1px solid var(--bg-third-100);
        border-radius: 32px;
    }

    .wrapper-container h1 {
        font-size: 32px;
        font-family: Roboto_Bold;
    }


    .form-container {
        max-width: 736px;
        width: 100%;
        margin: 0 auto;
        gap: var(--gp-32);
        font-family: Roboto_Medium;
        font-size: 20px;
    }

    .field {
        background-color: #1B1C21;
        padding: 12px 16px;
        border-radius: 8px;
        border-left: 3px solid var(--btn-color-2);
        color: var(--font-primary-75);
    }

    .field::placeholder {
        color: var(--font-primary-25);
    }

    
    .field-message {
        padding: 16px;
        height: 300px;
        resize: none;
    }
    
    select {
        width: 100%;
        overflow: hidden;
        text-overflow: ellipsis;
        white-space: nowrap;
        cursor: pointer;
        appearance: none;
        background: url('../assets/icons/arrow.svg') no-repeat right 16px center;
        background-size: 16px;
        padding-right: 36px !important; 
    }

    .send-btn {
        width: 100%;
        background-color: var(--font-secondary);
        padding-block: 10px;
        border-radius: 8px;
        font-size: 16px;
    }

    .field option {
        color: #fff;
        background: #1B1C21;
        font-size: 16px;
    }

    @media (max-width: 1160px) {
        .wrapper-container {
            border-radius: 0px;
        }

    }

     @media (max-width:1024px) {
        .wrapper-container {
            padding-inline: 48px;
        }
        
    }

    @media (max-width:500px) {
        .wrapper-container {
            padding-inline:16px;
            padding-block: 32px;
        }

        .wrapper-container h1 {
            font-size: 28px;
        }

        .form-container {
            font-size: 18px;
        }

        .field-message {
            height: 200px;
        }
    }

</style>