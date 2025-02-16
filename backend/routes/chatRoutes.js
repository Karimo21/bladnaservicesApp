const express = require('express');
const router = express.Router();;
const {getProviderContacts, getClientContacts,getMessages,createMessage} = require('../controllers/chatController');

// Send a message
router.post('/send-message/:senderId/:receiverId',createMessage)

// Get all messages between two users
router.get('/api/messages/:userId/:contactId', getMessages);

// Mark a message as read



// Add a contact



// Get contacts for a user
router.get('/api/client-contacts/:userId',getClientContacts);
// Get contacts for a user
router.get('/api/provider-contacts/:userId',getProviderContacts);
 

module.exports = router;

