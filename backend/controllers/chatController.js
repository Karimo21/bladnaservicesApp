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
// Send a message
// Send a message
exports.createContact = async (req, res) => {
  try {
    const { senderId, receiverId } = req.body;
    console.log(senderId, receiverId);

    // Call the database function to insert the contact
    const result = await Message.createContact(senderId, receiverId);
    const result1 = result.result1[0];
    const result2 = result.result2[0];  
    console.log(result1,result2);
    // Check if the rows were affected (both insertions should have affected rows)
    if (result1.affectedRows > 0 && result2.affectedRows > 0) {
      return res.status(201).json({ message: "Contact created successfully" });
    } else {
      return res.status(200).json({ message: "Contact already exists 01" });
    }
  } catch (error) {
    console.error("Error creating contact:", error);
    return res.status(500).json({ message: "Error creating contact", error: error.message });
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
    //await Message.markAllAsRead(userId, contactId);   
     
    const messages = await Message.findMessagesBetweenUsers(userId, contactId);
    res.json(messages);
  } catch (error) {
    res.status(500).json({ message: 'Error fetching messages', error });
  }
};
