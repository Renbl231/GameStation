const express = require('express')
const editorImageController = require('../controllers/editorImageController')
const { News_AdminRole } = require('../middleware/role')
const upload = require('../middleware/upload')
const router = express.Router()

router.delete('/editorImage/delete', News_AdminRole, editorImageController.deleteEditorImage)

router.post('/editorImage/:type/upload', News_AdminRole, upload.fields([{ name: 'image', maxCount: 1 }]), editorImageController.uploadEditorImage)

module.exports = router




