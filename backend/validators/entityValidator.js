export const validateNews = async (data) => {
    let error = ''
    if (!data.title?.trim()) {
        error = 'Заголовок обязателен'
    } else if (!Number(data.category_id)) {
        error = 'Категория обязательна'
    } else if (!data.content?.trim()) {
        error = 'Содержимое обязательно'
    } else if (!data.short_content?.trim()) {
        error = 'Краткое содержимое обязательно'
    }

    return {
        isValid: !error,
        error
    }
}

export const validateArticle = async (data) => {
    let error = ''

    if (!data.title?.trim()) {
        error = 'Заголовок обязателен'
    } else if (!Number(data.category_id)) {
        error = 'Категория обязательна'
    } else if (!data.content?.trim()) {
        error = 'Содержимое обязательно'
    }

    return {
        isValid: !error,
        error
    }
}