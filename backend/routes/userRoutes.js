const express = require('express');
const { createClientUser,createProviderUser, getUsers, getUser, createUser, loginUser } = require('../controllers/userController');
const { uploadImages } = require('../middlewares/uploadMiddleware'); // Import the middleware
const router = express.Router();

router.post('/login', loginUser);
router.post("/create-client", createClientUser);
router.post("/create-provider", createProviderUser);
router.get('/api/allUsers', getUsers);
router.get('/api/users/:id', getUser);
router.post('/', createUser);


module.exports = router;
