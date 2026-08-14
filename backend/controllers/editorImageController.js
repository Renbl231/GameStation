const StorageService = require('../services/storageService')
const { getPublicMinioUrl } = require('../helpers/minioUrl')

exports.uploadEditorImage = async (req, res) => {
    const file = req.files?.image?.[0]
    const { type } = req.params

    if (!file) {
        return res.status(400).json({ 
            error: 'Файл не передан'
         })
    } 

    try {
        const tempPath = `temp/${type}/content`

        const uploaded = await StorageService.uploadFileToBucket(file, tempPath)
        const publicUrl = getPublicMinioUrl(uploaded.key)
        return res.json({ 
            success: true,
            url: publicUrl, 
            key: uploaded.key
        })
    } catch (error) {
        console.error('Ошибка загрузки editor image:', error)
        return res.status(500).json({
            success: false, 
            error: 'Ошибка загрузки файла' 
        })
    }
}

exports.deleteEditorImage = async (req, res) => {
    const { key } = req.body
    await StorageService.deleteFileFromBucket(key)
    return res.json({
        success: true 
    })
}
