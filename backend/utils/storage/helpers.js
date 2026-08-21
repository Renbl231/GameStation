import StorageService from '../../services/storageService.js'

export const moveTempImages = async (content, tempPath, realPath) => {
    const tempMatches = [...content.matchAll(new RegExp(`data-minio-key="${tempPath}([^"]+)"`, 'g'))]
    const tempImgKeys = Array.from(tempMatches).map(m => `${tempPath}${m[1]}`)

    let updatedContent = content

    for (const tempKey of tempImgKeys) {
        const realKey = tempKey.replace(tempPath, realPath)
        const success = await StorageService.copyFile(tempKey, realKey)
        if (success) {
            await StorageService.deleteFileFromBucket(tempKey)
            updatedContent = updatedContent.replaceAll(tempKey, realKey)
        }
    }

    return updatedContent
}

export const deleteUnusedImages = async (oldContent, newContent, pathPrefix) => {
    const oldImgKeys = [...oldContent.matchAll(/data-minio-key="([^"]+)"/g)]
        .map(m => m[1])
        .filter(k => k.startsWith(pathPrefix))

    const newImgKeys = [...newContent.matchAll(/data-minio-key="([^"]+)"/g)]
        .map(m => m[1])
        .filter(k => k.startsWith(pathPrefix))

    const deletedImgKeys = oldImgKeys.filter(oldKey => !newImgKeys.includes(oldKey))

    for (const deletedKey of deletedImgKeys) {
        await StorageService.deleteFileFromBucket(deletedKey)
    }
}

export const deleteAllImagesFromContent = async (content, pathPrefix) => {
    if (!content) return

    const imgKeys = [...content.matchAll(/data-minio-key="([^"]+)"/g)]
        .map(match => match[1]?.trim())
        .filter(key => key && key.startsWith(pathPrefix))

    for (const key of imgKeys) {
        await StorageService.deleteFileFromBucket(key)
    }
}