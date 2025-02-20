const Notification = require("../models/notificationModel");

// Récupérer les notifications d'un utilisateur
exports.getUserNotifications = async (req, res) => {
  try {
    const userId = req.params.userId;
    const notifications = await Notification.getNotificationsByUserId(userId);
    res.json({ notifications });
  } catch (error) {
    res.status(500).json({ error: "Erreur lors de la récupération des notifications" });
  }
};

// Marquer une notification comme lue
exports.markNotificationAsRead = async (req, res) => {
  try {
    const notificationId = req.params.notificationId;
    await Notification.markAsRead(notificationId);
    res.json({ success: true, message: "Notification marquée comme lue" });
  } catch (error) {
    res.status(500).json({ error: "Erreur lors de la mise à jour de la notification" });
  }
};
