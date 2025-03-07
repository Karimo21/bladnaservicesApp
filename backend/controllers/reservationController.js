const Reservation = require('../models/reservationModel');

// Send a message
exports.createReservation = async (req,res) => {
    try {
        const { clientId, providerId, startDate, endDate, statutId } = req.body;
        // Enregistrer le message dans la base de données
        const result = await Reservation.createReservation(clientId, providerId, startDate, endDate,statutId);
          // Retourner le résultat si nécessaire
        res.json({
            message: "Reservation created successfully",
            reservationId: result.insertId});
    } catch (error) {
        throw new Error('Error creating reservation: ' + error.message);
    }
  };
  // Fetch reservations for a specific client
exports.getClientReservations = async (req, res) => {
    try {
      const { clientId } = req.params; // Get clientId from request parameters
  
      if (!clientId) {
        return res.status(400).json({ error: "Client ID is required" });
      }
  
      const reservations = await Reservation.getClientReservations(clientId);
  
      res.json({ reservations });
    } catch (error) {
      res.status(500).json({ error: "Error fetching reservations: " + error.message });
    }
  };
  // Fetch reservations for a specific provider
exports.getReservationsDate = async (req, res) => {
  try {
    const { providerId } = req.params;

    const reservations = await Reservation.getReservationsDate(providerId);
    res.json({ reservations });
  } catch (error) {
    res.status(500).json({ error: "Error fetching reservations date: " + error.message });
  }
};