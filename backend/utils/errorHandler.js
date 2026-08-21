export const HandleError = (res, error, message = '', success = null) => {
    console.log(message, error)
    
    const response = {
        error: error.message || 'Ошибка сервера'
    }
    
    if (success !== null && success !== undefined) {
        response.success = success
    }

    return res.status(error.status || 500).json(response)
}