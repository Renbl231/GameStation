
const express = require('express');
const authController = require('../controllers/authController');
const authMiddleware = require('../middleware/auth');
const router = express.Router();

router.get('/verify', authController.handleVerificationLink) // ген ссылка для подтвержд рег

router.post('/verify-link', authController.verificationRegistationLink)
router.post('/send-verification', authController.saveVerificationData)
router.post('/verify-code', authController.verifyCode)
router.post('/login', authController.loginUser)
router.post('/logout', authController.logoutUser)

router.get('/me', authMiddleware, authController.getCurrentUser); // проверка токена



module.exports = router;
