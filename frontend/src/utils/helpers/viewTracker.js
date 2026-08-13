export const checkViewEntity = (entity_id, entity_type) => {
    const coolDownHours = 1;
    const coolDownMs = coolDownHours * 60 * 60 * 1000

    const now = Date.now()
    const sessionKey = `${entity_type}_view_${entity_id}`
    const lastView = localStorage.getItem(sessionKey)
    
    const shouldIncrement = !lastView || (now - parseInt(lastView)) >= coolDownMs
    
    if (shouldIncrement) {
        localStorage.setItem(sessionKey, now.toString())
        return true
    }

    return false
}