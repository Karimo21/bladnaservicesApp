const SuivieModel = require('../models/suivieModel');

let io; // Store Socket.io instance

// Function to set io (called from server.js)
 setIo = (socketIo) => {
    io = socketIo;
};

// Get reserved reservations (where the provider is already reserved)
 async function getReservedProviderReservations(req, res) {
  const providerId = req.params.providerId;
  try {
    const reservationsbyclient  = await SuivieModel.getReservedProviderReservations(providerId);
    const reservationsbyprovider = await SuivieModel.getProviderReservingProviderReservations(providerId);

    // Merge both results
     const reservations = [...reservationsbyclient, ...reservationsbyprovider];
    res.json({ reservations });
  } catch (error) {
    res.status(500).json({ error: 'Error fetching reserved reservations: ' + error.message });
  }
 }

async function getReservingReservations(req, res) {
  const { role, userId } = req.params; // Get role and userId from params
  try {
    let reservations;

    if (role === 'provider') {
      reservations = await SuivieModel.getReservingReservations('provider', userId);
    } else if (role === 'client') {
      reservations = await SuivieModel.getReservingReservations('client', userId);
    } else {
      return res.status(400).json({ error: 'Invalid role specified' });
    }

    res.json({ reservations });
  } catch (error) {
    res.status(500).json({ error: 'Error fetching reserving reservations: ' + error.message });
  }
}
async function getReservationsHistory(req, res) {
    const { role, userId } = req.params;

    
    try {
        let reservations;

        if (role === 'provider') {
            reservations = await SuivieModel.getProviderReservationHistory(userId);
        } else if (role === 'client') {
            reservations = await SuivieModel.getClientReservationHistory(userId);
        } else {
            return res.status(400).json({ error: 'Invalid role. Use "client" or "provider".' });
        }

        res.json({ reservations });
    } catch (error) {
        res.status(500).json({ error: 'Error fetching reservation history: ' + error.message });
    }
}

// Get all reservation history for the provider (past reservations)
async function updateReservationStatut(req, res) {
  const reservationId=req.body.reservationId;
  const statutId = req.body.statutId;
  const userId =req.body.userId
  const providerId=req.body.providerId;
  console.log(reservationId,statutId,userId,providerId);
  try {
    const updateReservation = await SuivieModel.updateReservationStatut(reservationId,statutId,userId,providerId);
        // Check if the update was successful
        if (updateReservation.affectedRows === 0) {
          return res.status(404).json({ error: "Reservation not found or status unchanged" });
        }

        console.log(updateReservation[0].name);

        if (io) {
          console.log('Emitting reservationStatutUpdated event to userId:'+userId);
          io.to(userId).emit('reservationStatutUpdated', {
            reservationId: reservationId,
            statutName: updateReservation[0].name,
          });
      }
        // Success response
        res.status(200).json({
          message: "Reservation status updated successfully",
          data: updateReservation,
        });
  } catch (error) {
    res.status(500).json({ error: 'Error updating the the statut: ' + error.message });
  }
}

module.exports = {
  setIo,
  getReservedProviderReservations,
  getReservingReservations,
  getReservationsHistory,
  updateReservationStatut,
};
