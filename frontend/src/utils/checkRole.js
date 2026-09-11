export const checkColorRole = (role) => {
    switch(role) {
        case 4: return '#FF0037'
        case 3: return '#006FFF'
        case 2: return '#44986a'
        default: return 'transparent'
    }
}

export const checkNameRole = (role) => {
    switch(role) {
        case 4: return 'Администратор'
        case 3: return 'Модератор'
        case 2: return 'Новостник'
        default: return null
    }
}
