const { query } = require('express');
const db = require('../config/db');

const UserContact = {
  async findClientContactsById(userId) {
    try {
      const [rows] = await db.promise().query(
        `SELECT
        p.business_name AS contact_name,
        uc.contact_user_id,
        uc.user_id,
        m.message AS last_message,
        m.created_at AS message_time,
        u.role,
        -- Count unread messages
        (SELECT COUNT(*) FROM messages m2
          WHERE m2.receiver_id = uc.user_id
          AND m2.sender_id = uc.contact_user_id
          AND m2.is_read = 0) AS unread_message_count
      FROM user_contacts uc
      JOIN users u ON uc.contact_user_id = u.user_id
      LEFT JOIN providers p ON uc.contact_user_id = p.providers_id
      LEFT JOIN messages m
        ON (m.sender_id = uc.contact_user_id AND m.receiver_id = uc.user_id)
        OR (m.sender_id = uc.user_id AND m.receiver_id = uc.contact_user_id)
      WHERE uc.user_id = ?
      AND m.created_at = (
        SELECT MAX(m2.created_at)
        FROM messages m2
        WHERE (m2.sender_id = uc.contact_user_id AND m2.receiver_id = uc.user_id)
           OR (m2.sender_id = uc.user_id AND m2.receiver_id = uc.contact_user_id)
      )
      ORDER BY message_time DESC;`,
        [userId] // Pass userId as a parameter to the query
      );
      
      return rows;
    } catch (error) {
      throw error; // Handle errors properly
    }
  },
  async findProviderContactById(userId) {
    try {
      const [rows] = await db.promise().query(
        `SELECT 
    COALESCE(c.username, p.business_name) AS contact_name,
    uc.contact_user_id,
    uc.user_id,
    m.message AS last_message,
    m.created_at AS message_time,
    u.role,
    -- Count unread messages for each contact
    (SELECT COUNT(*)
     FROM messages m2
     WHERE (m2.receiver_id = uc.user_id AND m2.sender_id = uc.contact_user_id)
       AND m2.is_read = 0) AS unread_message_count
FROM user_contacts uc
JOIN users u ON uc.contact_user_id = u.user_id
LEFT JOIN clients c ON uc.contact_user_id = c.clients_id
LEFT JOIN providers p ON uc.contact_user_id = p.providers_id
LEFT JOIN messages m 
    ON m.created_at = (
        SELECT MAX(m2.created_at)
        FROM messages m2
        WHERE (m2.sender_id = uc.contact_user_id AND m2.receiver_id = uc.user_id)
           OR (m2.sender_id = uc.user_id AND m2.receiver_id = uc.contact_user_id)
    )
WHERE uc.user_id = ?
ORDER BY message_time DESC;`,
        [userId] // Pass userId as a parameter to the query
      );
      return rows;
    } catch (error) {
      throw error; // Handle errors properly
    }
  }
};

module.exports = UserContact;
