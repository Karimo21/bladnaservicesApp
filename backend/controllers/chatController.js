const UserContact = require('../models/userContactsModel');
const Message = require('../models/messageModel');

//fetch clients contacts
exports.getClientContacts = async (req, res) => {
  const userId = req.params.userId;
  const contacts = await UserContact.findClientContactsById(userId);
  res.json(contacts);
};

//fetch provider contacts
exports.getProviderContacts = async (req, res) => {
  const userId = req.params.userId;
  const contacts = await UserContact.findProviderContactById(userId);
  res.json(contacts);
};

// Send a message
exports.createMessage = async (senderId, receiverId, message, time) => {
  try {
      // Enregistrer le message dans la base de données
      const result = await Message.createMessage(senderId, receiverId, message, time);
      return result; // Retourner le résultat si nécessaire
  } catch (error) {
      throw new Error('Error saving message: ' + error.message);
  }
};

//mark messages as read
exports.markAllMessagesAsRead = async (userId, contactId) => {
  try {
    
    const result = await Message.markAllAsRead(userId, contactId);
    return result; 
} catch (error) {
    throw new Error('Error marking messages as read: ' + error.message);
}
};


// Fetch messages between two users
exports.getMessages = async (req, res) => {
  const userId = req.params.userId;
  const contactId = req.params.contactId;

  try {

    // Mark all messages between the user and contact as read
    await Message.markAllAsRead(userId, contactId);   
     
    const messages = await Message.findMessagesBetweenUsers(userId, contactId);
    res.json(messages);
  } catch (error) {
    res.status(500).json({ message: 'Error fetching messages', error });
  }
};
