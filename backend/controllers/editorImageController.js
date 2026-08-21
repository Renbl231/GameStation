const StorageService = require('../services/storageService')
const { HandleError } = require ('../utils/errorHandler.js')

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
        return res.json({ 
            success: true,
            url: uploaded.url, 
            key: uploaded.key
        })
    } catch (error) {
        HandleError(res, error, 'Ошибка загрузки файла', false)
    }
}

exports.deleteEditorImage = async (req, res) => {
    const { key } = req.body

    try {
        await StorageService.deleteFileFromBucket(key)
        return res.json({
            success: true 
        })
    } catch(error) {
        HandleError(res, error, 'Ошибка удаления файла', false)
    }
}
