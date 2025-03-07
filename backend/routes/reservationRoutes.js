const express = require('express');
const { createReservation,getClientReservations,getReservationsDate } = require('../controllers/reservationController');
const router = express.Router();

router.post("/create-reservation", createReservation);
router.get("/client-reservations/:clientId", getClientReservations);
router.get("/reservations-date/:providerId", getReservationsDate);

module.exports = router;