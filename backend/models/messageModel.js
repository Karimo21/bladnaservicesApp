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
