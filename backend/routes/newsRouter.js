const express = require('express');
const newsController = require('../controllers/newsController');
const authMiddleware = require('../middleware/auth');
const { News_AdminRole } = require('../middleware/role')
const upload = require('../middleware/upload')
const router = express.Router();

router.post(
  '/news/createNews',
  News_AdminRole,
  upload.fields([{ name: 'image', maxCount: 1 }]),
  newsController.createNews
)


router.post(
  '/news/upload-editor-image',
  News_AdminRole,
  upload.fields([{ name: 'image', maxCount: 1 }]),  // ← fields!
  newsController.uploadEditorImage
)


router.delete('/news/delete-editor-image', News_AdminRole, newsController.deleteEditorImage)

router.put(
  '/news/:id/edit',
  News_AdminRole,
  upload.fields([{ name: 'image', maxCount: 1 }]),
  newsController.updateNews
)


router.get('/news', newsController.getNewsPaginated);
router.get('/news/slides', newsController.getNewsSlides);
router.get('/newsdata/:id', newsController.getNewsById)
router.delete('/news/:id/delete', News_AdminRole, newsController.deleteNews)
router.put('/news/slider-mode', News_AdminRole, newsController.changeSliderMode)



module.exports = router;
