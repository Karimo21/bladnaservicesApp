const db = require("../config/db");

const Notification = {
  // Récupérer les notifications pour un utilisateur spécifique
  async getNotificationsByUserId(userId) {
    try {
      const [rows] = await db.promise().query(
        `SELECT 
            n.notifications_id, 
            n.message, 
            n.is_read, 
            DATE_FORMAT(n.created_at, '%Y/%c/%e %H:%i') AS date 
         FROM notifications n
         WHERE n.user_id = ? 
         ORDER BY n.created_at DESC`,
        [userId]
      );
      return rows;
    } catch (error) {
      throw error;
    }
  },
  async getUnreadNotifications(userId) { 
    try {
      const [rows] = await db.promise().query(
        `SELECT 
            count(n.notifications_id) as count
         FROM notifications n
         WHERE n.user_id = ? AND is_read=0`,
        [userId]
      );
      return rows;
    } catch (error) {
      throw error;
    }
  },
  async markNotificationAsRead(userId) { 
    try {
      const [rows] = await db.promise().query(
        ` update notifications set is_read=1 where user_id=?;`,
        [userId]
      );
      return rows;
    } catch (error) {
      throw error;
    }
  },

  // Marquer une notification comme lue
  async markAsRead(notificationId) {
    try {
      await db.promise().query(
        `UPDATE notifications SET is_read = 1 WHERE notifications_id = ?`,
        [notificationId]
      );
      return { success: true };
    } catch (error) {
      throw error;
    }
  },
};

module.exports = Notification;
