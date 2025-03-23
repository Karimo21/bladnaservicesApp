const db = require('../config/db');

const chart = {
  getReservationsByStatus: (callback) => {
        const query = 'select s.name,count(r.statut_id) as total from reservations r join statut s using(statut_id)  group by r.statut_id';
        db.query(query, callback);
    },
    getReservationsByservices: (callback) => {
      const query = 'select s.title,count(p.providers_id) as total_provider from services s join providers p using(service_id) group by s.title;';
      db.query(query, callback);
  },
  getAllCounts: (callback) => { 
    const query = `
        SELECT 
            (SELECT COUNT(providers_id) FROM providers) AS total_prestataires,
            (SELECT COUNT(clients_id) FROM clients) AS total_clients,
            (SELECT COUNT(reservations_id) FROM reservations) AS total_reservations
    `;
    db.query(query, (err, result) => {
        if (err) return callback(err, null);
        callback(null, result);
    });
}

};

module.exports = chart;
