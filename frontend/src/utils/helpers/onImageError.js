export const createImageErrorHandler = (fallback) => {
  return (event) => {
    const img = event.target
    if (img.dataset.fallback) return
    img.dataset.fallback = 'true'
    img.src = fallback
  }
}

export const onImageError = createImageErrorHandler('/images/plug_img.png')
export const onAvatarError = createImageErrorHandler('/images/plug_avatar.png')
export const onBannerError = createImageErrorHandler('/images/plug_banner.png')