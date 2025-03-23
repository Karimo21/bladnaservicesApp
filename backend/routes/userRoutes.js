const express = require('express');
const { createClientUser,createProviderUser,getMoreProviderDetails, getProviderProfile, createUser, loginUser,updateProviderAvailiblity } = require('../controllers/userController');
const { getProviderRatings,createRating, getRatingsBetweenUsers } = require('../controllers/reviewController');
const { getUserNotifications, markNotificationAsRead } = require("../controllers/notificationController");
const {uploadProfilePicture,uploadProviderImages,deleteProviderImage,getProviderWorkImages,updateProfileData } = require('../controllers/profileController');



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
router.post('/update-provider-availiblity', updateProviderAvailiblity);

router.post('/delete-provider-image/:imageId',deleteProviderImage);

router.post('/', createUser);
router.get('/api/provider-ratings/:providerId', getProviderRatings);
router.get("/api/notifications/:userId", getUserNotifications);

// Route to create a new ratings
router.post('/api/ratings', createRating);



router.get('/clients', getAllClients);
router.get('/prestataires', getAllValidatedProvider);
router.get('/prestatairesNoval', getAllNonValidatedProviders);

router.post('/prestatairs/valider/:id', validerPrestataire);
 
//router.delete('/prestatairs/suppremer/:id', suppremerPrestataire);

router.get('/prestatairs/documents-image/:providerId',getDocumentsImage);

router.get('/reservation', getAllreservation);


module.exports = router;