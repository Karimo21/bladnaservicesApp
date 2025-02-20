const express = require('express');
const { createClientUser,createProviderUser, getUsers, getUser, createUser, loginUser } = require('../controllers/userController');
const { getProviderRatings,createRating, getRatingsBetweenUsers } = require('../controllers/reviewController');
const { getUserNotifications, markNotificationAsRead } = require("../controllers/notificationController");

const { uploadImages } = require('../middlewares/uploadMiddleware'); // Import the middleware
const router = express.Router();

router.post('/login', loginUser);
router.post("/create-client", createClientUser);
router.post("/create-provider", createProviderUser);
router.post('/', createUser);
router.get('/api/provider-ratings/:providerId', getProviderRatings);
router.get("/api/notifications/:userId", getUserNotifications);




module.exports = router;
