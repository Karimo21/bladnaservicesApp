const SuivieModel = require('../models/suivieModel');

const SuivieController = {
  // Récupérer toutes les réservations
  async getReservations(req, res) {
    try {
      const reservations = await SuivieModel.getReservations();
      res.json({ reservations });
    } catch (error) {
      res.status(500).json({ error: "Erreur lors de la récupération des réservations: " + error.message });
    }
  },
};

module.exports = SuivieController;