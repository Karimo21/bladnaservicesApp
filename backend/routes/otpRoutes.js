const express = require('express');
const { sendOTP, verifyOTP } = require('../controllers/otpController');

const router = express.Router();

// Route to send OTP
router.post('/send', sendOTP);

// Route to verify OTP
router.post('/verify', verifyOTP);

module.exports = router;
