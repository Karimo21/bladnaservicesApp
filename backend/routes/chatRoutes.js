const express = require('express');
const router = express.Router();;
const {getProviderContacts, getClientContacts,getMessages,createMessage,createContact} = require('../controllers/chatController');


// Add a contact

router.post('/add-contact',createContact)
// Send a message
router.post('/send-message/:senderId/:receiverId',createMessage)
// Get all messages between two users
router.get('/api/messages/:userId/:contactId', getMessages);

// Get contacts for a user
router.get('/api/client-contacts/:userId',getClientContacts);
// Get contacts for a user
router.get('/api/provider-contacts/:userId',getProviderContacts);
 

module.exports = router;

