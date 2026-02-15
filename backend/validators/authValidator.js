const ValidateRegister = (data) => {
    const errors = {}

    if(!data.email.trim()) {
        errors.email = 'Email обязателен'
    } else if (data.email.length > 254) {
        errors.email = 'Email слишком длинный';
    } else {
        const emailRegex = /^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$/
        if(!emailRegex.test(data.email)) {
            errors.email = 'Некорректный Email'
        }
    }

    if(!data.password) {
        errors.password = 'Пароль обязателен'
    } else if (data.password.length < 6) {
        errors.password = 'Пароль должен содержать минимум 6 символов'
    }

    return {
        isValid: Object.keys(errors).length === 0,
        errors
    }
}

module.exports = { ValidateRegister }