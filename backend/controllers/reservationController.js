const Reservation = require('../models/reservationModel');
let io; // Store Socket.io instance

// Function to set io (called from server.js)
exports.setIo = (socketIo) => {
    io = socketIo;
};
// Send a message
exports.createReservation = async (req,res) => {
    try {
        const {role, clientId, providerId, startDate, endDate, statutId,hour,address } = req.body;

        // Enregistrer le message dans la base de données
        const result = await Reservation.createReservation(role,clientId, providerId, startDate, endDate,statutId,hour,address);
        // Emit event to client for real-time updates
        const clientInfo = await Reservation.getClientInfo(role,clientId);
        
             // Emit event to notify clients in real time
             if (io) {
                console.log('Emitting reservationCreated event to providerId:'+providerId);
                io.to(providerId).emit('reservationCreated', {
                    reservationId: result.insertId,  // Assuming result contains an ID
                    clientId,
                    providerId,
                    startDate,
                    endDate,
                    client_name:clientInfo[0].client_name,
                    city_name:clientInfo[0].city_name,
                    profile_picture:clientInfo[0].profile_picture,
                    phone:clientInfo[0].phone,
                    statut:"En attente",
                    hour,
                    address
                });
            }
  
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

