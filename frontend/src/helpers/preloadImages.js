export const preloadImage = (src) =>
  new Promise((resolve) => {
    if (!src) return resolve()
    const img = new Image()
    img.onload = resolve
    img.onerror = resolve
    img.src = src
  })

export const preloadImages = async (urls) => {
  await Promise.all(urls.map(preloadImage))
}