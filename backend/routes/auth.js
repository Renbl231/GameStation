const express = require('express');
const authController = require('../controllers/authController');
const router = express.Router();


router.get('/verify', authController.handleVerificationLink); // ген ссылка для подтвержд рег

router.post('/verify-link', authController.verificationRegistationLink);
router.post('/send-verification', authController.saveVerificationData);
router.post('/verify-code', authController.verifyCode)

module.exports = router;
