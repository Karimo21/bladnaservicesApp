// models/messages.js
const db = require('../config/db');

const Message = {

  // Find messages between two users
  async findMessagesBetweenUsers(userId, contactId) {
    try {
      const [rows] = await db.promise().query(
        `SELECT m.message, DATE_FORMAT(m.created_at, '%H:%i') AS message_time, m.sender_id, m.receiver_id
         FROM messages m
         WHERE (m.sender_id = ? AND m.receiver_id = ?) 
         OR (m.sender_id = ? AND m.receiver_id = ?)
         ORDER BY m.created_at ASC`,
        [userId, contactId, contactId, userId]
      );
      return rows;
    } catch (error) {
      throw error;
    }
  },

  createMessage: (senderId, receiverId, message,time) => {
    return db.promise().query(
      'INSERT INTO messages (sender_id, receiver_id, message,	created_at) VALUES (?, ?, ?, ?)',
      [senderId, receiverId, message, time]
    );
  },
  
  createContact: async (senderId, receiverId) => {
    try {
      // Check if the sender -> receiver relationship exists
      const [existingContact1] = await db.promise().query(
        `SELECT 1 FROM user_contacts WHERE user_id = ? AND contact_user_id = ?`,
        [senderId, receiverId]
      );
  
      // Check if the receiver -> sender relationship exists
      const [existingContact2] = await db.promise().query(
        `SELECT 1 FROM user_contacts WHERE user_id = ? AND contact_user_id = ?`,
        [receiverId, senderId]
      );
  
      // If no contact exists in both directions, insert them
      if (existingContact1.length === 0 && existingContact2.length === 0) {
        // First insert: sender -> receiver
        const result1 = await db.promise().query(
          `INSERT INTO user_contacts (user_id, contact_user_id) 
           VALUES (?, ?)`,
          [senderId, receiverId]
        );
        console.log('First Insert Result:', result1);
  
        // Second insert: receiver -> sender
        const result2 = await db.promise().query(
          `INSERT INTO user_contacts (user_id, contact_user_id) 
           VALUES (?, ?)`,
          [receiverId, senderId]
        );
        console.log('Second Insert Result:', result2);
  
        return {
          message: "Contact created successfully",
           result1,
           result2,
        };
      } else {
        return { message: "Contact already exists 00" };
      }
    } catch (error) {
      console.error("Error creating contact:", error);
      throw new Error('Error creating contact: ' + error.message);
    }
  },
  
  
  // Mark all messages between two users as read
  markAllAsRead: async (userId, contactId) => {
    try {
      const query = `
        UPDATE messages 
        SET is_read = TRUE 
        WHERE (sender_id = ? AND receiver_id = ?) 
        OR (sender_id = ? AND receiver_id = ?)`;
      await db.promise().query(query, [userId, contactId, contactId, userId]);
    } catch (error) {
      throw error;
    }
  },
};

module.exports = Message;
