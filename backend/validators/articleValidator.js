const ValidateArticle = (data) => {
    let error = ''

    if(!data.title?.trim()) error = 'Заголовок обязателен';
    else if(!data.category?.trim()) error = 'Категория обязательна';
    else if(!data.content?.trim()) error = 'Содержимое обязательно';
    else if(!data.image?.trim()) error = 'Превью обязательно';
    else if(!data.authorId) error = 'Ошибка авторизации';

    return {
        isValid: !error,
        error
    }
}

module.exports = { ValidateArticle }
