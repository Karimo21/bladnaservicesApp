const express = require('express');

const { getReservationsByStatus,getReservationsByservices , getAllCounts} = require('../controllers/chartController');

const router = express.Router();
router.get('/chart-status', getReservationsByStatus); 
router.get('/chart-services', getReservationsByservices);

router.get("/count-stats", getAllCounts);

module.exports = router;
