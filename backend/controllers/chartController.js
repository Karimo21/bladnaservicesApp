const chart = require('../models/chartModel');

exports.getReservationsByStatus = (req, res) => {
    chart.getReservationsByStatus((err, total) => {
        if (err) {
            console.error("Erreur lors de la récupération des réservations:", err);
            return res.status(500).json({ message: "Erreur interne du serveur", error: err });
        }
        res.json({ total });
    });
};
exports.getReservationsByservices = (req, res) => {
  chart.getReservationsByservices((err, total) => {
      if (err) {
          console.error("Erreur lors de la récupération des réservations:", err);
          return res.status(500).json({ message: "Erreur interne du serveur", error: err });
      }
      res.json({ total });
  });
};


exports.getAllCounts = (req, res) => {
  chart.getAllCounts((err, results) => {  // Remplace statsModel par chart
      if (err) {
          console.error("Erreur lors de la récupération des statistiques :", err);
          return res.status(500).json({ message: "Erreur interne du serveur", error: err });
      }
      res.json({
          prestataires: results[0].total_prestataires,
          clients: results[0].total_clients,
          reservations: results[0].total_reservations
      });
  });
  
};
