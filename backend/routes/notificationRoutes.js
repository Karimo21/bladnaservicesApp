const express = require('express');
const { unreadNotifications, markNotificationAsRead} = require('../controllers/notificationController');

const router = express.Router();

// Route to send OTP
router.get('/notifications/unread/:userId', unreadNotifications);

router.post('/notifications/read/:userId', markNotificationAsRead);


module.exports = router;
