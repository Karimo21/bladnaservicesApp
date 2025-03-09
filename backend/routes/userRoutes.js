const express = require('express');
const { createClientUser,createProviderUser,getMoreProviderDetails, getProviderProfile, createUser, loginUser } = require('../controllers/userController');
const { getProviderRatings,createRating, getRatingsBetweenUsers } = require('../controllers/reviewController');
const { getUserNotifications, markNotificationAsRead } = require("../controllers/notificationController");
const {uploadProfilePicture,uploadProviderImages,deleteProviderImage,getProviderWorkImages,updateProfileData } = require('../controllers/profileController');
const SuivieController = require('../controllers/suivieController');


const router = express.Router();

router.post('/login', loginUser);
router.post("/create-client", createClientUser);
router.post("/create-provider", createProviderUser);


router.get('/providers',getProviderProfile);
router.get('/provider/:providerId',getMoreProviderDetails);
router.post('/profile/picture',uploadProfilePicture);
router.post('/profile-edit/:userId',updateProfileData);
router.get('/providers-work-images/:providerId',getProviderWorkImages);
router.post('/upload-provider-images/:providerId', uploadProviderImages);

router.post('/delete-provider-image/:imageId',deleteProviderImage);

router.post('/', createUser);
router.get('/api/provider-ratings/:providerId', getProviderRatings);
router.get("/api/notifications/:userId", getUserNotifications);

// Route to create a new rating
router.post('/api/ratings', createRating);

// Récupérer toutes les réservations
router.get('/api/reservations', SuivieController.getReservations);

module.exports = router;
