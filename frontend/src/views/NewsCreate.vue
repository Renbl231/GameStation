<script setup>
import { computed, ref, nextTick } from 'vue'
import api from '../utils/axios'
import { storeToRefs } from 'pinia'
import { useAuthStore } from '../stores/authStore'

const authStore = useAuthStore()
const { isAuthenticated, user } = storeToRefs(authStore)

const isAuthorized = computed(() => {
  return isAuthenticated.value && [2, 4].includes(user.value?.role)
})

const form = ref({
    title: '',
    category: '',
    image: '',
    content: '<p class="text-content">Начните писать здесь...</p>'
})

const contentArea = ref(null);

const makeBold = () => {
  document.execCommand('bold');
  contentArea.value.focus();
};

const makeItalic = () => {
  document.execCommand('italic');
  contentArea.value.focus();
};

const makeLink = () => {
  const url = prompt('URL ссылки:');
  if (url) {
    document.execCommand('createLink', false, url);
  }
  contentArea.value.focus();
};

const insertImage = () => {
  const url = prompt('URL изображения:');
  if (url) {
    const caption = prompt('Подпись к изображению (опционально):');
    
    const imgHtml = caption 
      ? `<div class="img-block flex-column"><img src="${url}" alt="${caption}"><span class="img-name">${caption}</span></div>`
      : `<div class="img-block flex-column"><img src="${url}"></div>`;
    
    document.execCommand('insertHTML', false, imgHtml);
    contentArea.value.focus();
    newParagraph()
  }
};

const newParagraph = () => {
  const selection = window.getSelection();
  const range = document.createRange();
  range.selectNodeContents(contentArea.value);
  range.collapse(false); 
  selection.removeAllRanges();
  selection.addRange(range);
  
  contentArea.value.insertAdjacentHTML('beforeend', '<p class="text-content"><br></p>');
  
  const newP = contentArea.value.lastElementChild;
  const newRange = document.createRange();
  newRange.selectNodeContents(newP);
  newRange.collapse(false);
  selection.removeAllRanges();
  selection.addRange(newRange);
};

const updateContent = () => {
  form.value.content = contentArea.value.innerHTML;
};

// валидация новости

const error = ref('')

const clearError = () => {
    error.value = ''
}

const validateForm = () => {
    clearError()
    if(!form.value.title.trim()) {
        error.value = 'Заголовок обязателен'
        return false
    }
    if(!form.value.category.trim()) {
        error.value = 'Категория обязательна'
        return false
    }
    if(!form.value.image.trim()) {
        error.value = 'Фото обязательна'
        return false
    }
    if(!form.value.content.trim() || form.value.content === '<p>Начните писать здесь...</p>') {
        error.value = 'Напишите содержимое новости'
        return false
    }

    return true
}

const resetForm = async () => {
  form.value = {
    title: '',
    category: '',
    content: '<p>Начните писать здесь...</p>'
  };
  
  await nextTick();
  if (contentArea.value) {
    contentArea.value.innerHTML = form.value.content;
    contentArea.value.focus();
  }
};
const submitNews = async () => {

  if(!validateForm()) {
    return
  }

  try {
    const { data } = await api.post('/news/createNews', {
      title: form.value.title,
      category: form.value.category,
      image: form.value.image,
      content: form.value.content
    });

    if (data.success) {
      error.value = 'Новость опубликована!';
      await resetForm();
    }
  } catch (err) {
    error.value = err.response?.data?.error || 'Ошибка сервера';
  }
};

</script>



<template>
     <div class="container" v-if="isAuthenticated && isAuthorized">
        <div class="wrapper-container flex-column">
            <h1>Добавление новости</h1>
            <input v-model="form.title" type="text" class="field no-border" placeholder="Заголовок" required>
            <select v-model="form.category" class="field no-border" required>
                <option value="" disabled hidden selected class="empty-option">Категория новости</option>
                <option value="Анонсы">Анонсы</option>
                <option value="Релизы">Релизы</option>
                <option value="Индустрия">Индустрия</option>
                <option value="Слухи">Слухи</option>
                <option value="Патчи">Обновления</option>
                <option value="Консоли">Консоли</option>
                <option value="PC">PC</option>
                <option value="VR">VR</option>
            </select>
            <input v-model="form.image" type="text" class="field no-border" placeholder="URL-фотография" required>
            <div class="editor-container flex-column field field-content">
                <div 
                    ref="contentArea"
                    class="content flex-column"
                    contenteditable="true"
                    @input="updateContent"
                >
                    <p class="text-content">Начните писать здесь...</p>
                </div>


                <div class="editor-toolbar flex align-c">
                    <button @click="makeBold">𝐁</button>
                    <button @click="makeItalic">𝐈</button>
                    <button @click="makeLink">Link</button>
                    <button @click="insertImage">🖼️</button>
                    <button @click="newParagraph">⏎ Новый абзац</button>
                </div>
            </div>
            <div v-if="error" class="error-span">
                {{ error }}
            </div>
            <button @click="submitNews()" type="button" class="no-border send-btn">Опубликовать</button>
            
        </div>
    </div>
    <div v-else class="access-denied">
        <p>ПОШЁЛ НАХ*Й со страницы</p>
    </div>

</template>

<style scoped>

    .error-span {
        font-size: 24px;
        color: var(--btn-color-2);
        text-align: center;
    }

    .container {
        width: 100%;
        padding-inline: 96px;
        padding-block: 64px;
        background-color: var(--bg-third-25);
        border: 1px solid var(--bg-third-100);
        border-radius: 32px;
    }

    .wrapper-container {
        max-width: 736px;
        width: 100%;
        margin: 0 auto;
        gap: var(--gp-32);
        font-family: Roboto_Medium;
        font-size: 20px;
        gap: var(--gp-32);
    }

    .wrapper-container h1 {
        font-size: 32px;
        font-family: Roboto_Bold;
    }

    .field {
        width: 100%;
        background-color: #1B1C21;
        padding: 12px 16px;
        border-radius: 8px;
        border-left: 3px solid var(--btn-color-2);
        color: var(--font-primary-75);
    }

    .field::placeholder {
        color: var(--font-primary-25);
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

    .editor-toolbar {
        gap: var(--gp-8);
        margin-top: auto;
    }

    .editor-toolbar button { 
        padding: 5px 10px; border: 1px solid var(--bg-secondary-50) ; background: var(--bg-secondary-25);
        color: var(--font-primary);
        border-radius: 4px; cursor: pointer; font-size: 16px;
    }

    .editor-content:focus { 
        border-color: #4f46e5; box-shadow: 0 0 0 3px rgba(79, 70, 229, 0.1);
    }

    .field option {
        color: #fff;
        background: #1B1C21;
        font-size: 16px;
    }

    .field-content {
        padding: 16px;
        min-height: 300px;
        resize: vertical;
        overflow: hidden;
        field-sizing: content;
        gap: var(--gp-32);
    }

    .content {
        field-sizing: content;
    }


    .send-btn {
        width: 100%;
        background-color: var(--font-secondary);
        padding-block: 10px;
        border-radius: 8px;
        font-size: 16px;
    }

    @media (max-width: 1160px) {
        .container {
            border-radius: 0px;
        }

    }

     @media (max-width:1024px) {
        .container {
            padding-inline: 48px;
        }
        
    }

    @media (max-width:500px) {
        .container {
            padding-inline: 16px;
            padding-block: 32px;
        }

        .wrapper-container h1 {
            font-size: 28px;
        }

        .wrapper-container {
            font-size: 18px;
        }

        .field-content {
            height: 200px;
        }
    }

</style>