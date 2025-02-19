const express = require('express');
const { getUsers, getUser, createUser, loginUser, uploadProfilePictureController } = require('../controllers/userController');
const { uploadProfilePicture } = require('../middlewares/uploadMiddleware'); // Import the middleware
const router = express.Router();

router.post('/login', loginUser);
router.get('/api/allUsers', getUsers);
router.get('/api/users/:id', getUser);
router.post('/', createUser);
router.post('/upload-profile', uploadProfilePicture.single('profile_picture'), uploadProfilePictureController);

module.exports = router;
