export const ValidateNews = async (data) => {
    let error = ''

    if (!data.title?.trim()) {
        error = 'Заголовок обязателен'
    } else if (!Number(data.category_id)) {
        error = 'Категория обязательна'
    } else if (!data.content?.trim()) {
        error = 'Содержимое обязательно'
    } else if (!data.short_content?.trim()) {
        error = 'Краткое содержимое обязательно'
    } else if (!data.coverImage) {
        error = 'Превью обязательно'
    }

    return {
        isValid: !error,
        error
    }
}