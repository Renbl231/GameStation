export const autoResizeTextarea = (event) => {
    const textarea = event.target
    if (textarea) {
        textarea.style.height = '0px'
        textarea.style.height = `${textarea.scrollHeight}px`
    }
}