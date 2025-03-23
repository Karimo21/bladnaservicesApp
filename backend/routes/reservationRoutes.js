const express = require('express');
const { createReservation,getClientReservations,getReservationsDate } = require('../controllers/reservationController');
const { getReservedProviderReservations, getReservingReservations, getReservationsHistory, updateReservationStatut } = require('../controllers/suivieController');
const {getAllCities} = require('../controllers/cityController');
const {getAllServices} = require('../controllers/serviceController');
const router = express.Router();

router.post("/create-reservation", createReservation);
router.get("/cities",getAllCities);
router.get("/services",getAllServices);

router.get("/client-reservations/:clientId", getClientReservations);

router.get("/reservations-date/:providerId", getReservationsDate);

// Route to get reservations for a provider where they are "reserved"
router.get('/api/reservations/reserved/:providerId', getReservedProviderReservations);

// Route to get reservations for a client or provider based on their role
router.get('/api/reservations/reserving/:role/:userId', getReservingReservations);

// Route to get the history of all reservations for a provider
router.get('/api/reservations/history/:role/:userId', getReservationsHistory);

//Route to update the statut of reservation
router.post('/api/reservations/update_status',updateReservationStatut);


module.exports = router;