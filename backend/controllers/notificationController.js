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

// Récupérer les notifications d'un utilisateur 
exports.unreadNotifications = async (req, res) => {
  try {
    const userId = req.params.userId;
    const unreadNotifications = await Notification.getUnreadNotifications(userId);
  
    res.json({ count:unreadNotifications[0].count });
  } catch (error) {
    res.status(500).json({ error: "Erreur lors de la récupération des notifications non lus" });
  }
};
exports.markNotificationAsRead = async (req, res) => {
  try {
    const userId = req.params.userId;
    await Notification.markNotificationAsRead(userId);
  
    res.json({ message: "Notification marquée comme lue"});
  } catch (error) {
    res.status(500).json({ error: "Erreur  notifications non lus" });
  }
};

