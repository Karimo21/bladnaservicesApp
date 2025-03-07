const db = require('../config/db');

const Reservation ={

createReservation: async (clientId, providerId, startDate, endDate, statutId) => {
    try {
        const [result] = await db.promise().execute(
            'INSERT INTO reservations (client_id, provider_id, start_date, end_date, statut_id) VALUES (?, ?, ?, ?, ?)',
            [clientId, providerId, startDate, endDate, statutId]
        );

        return result; // Return insert result to controller
    } catch (error) {
        throw new Error("Database Error: " + error.message);
    }
},
getClientReservations: async (clientId) => {
  try {
    const [rows] = await db.promise().execute(
      `SELECT 
        c.firstname, 
        c.lastname, 
        u.phone, 
        s.name AS statut, 
        DATE_FORMAT(r.start_date, '%d %b %Y %H:%i') AS start_date, 
        DATE_FORMAT(r.end_date, '%d %b %Y %H:%i') AS end_date
      FROM reservations r
      JOIN clients c ON r.client_id = c.clients_id
      JOIN users u ON c.clients_id = u.user_id
      JOIN statut s ON r.statut_id = s.statut_id
      WHERE r.client_id = ?;`, 
      [clientId]
    );
    return rows;
  } catch (error) {
    throw new Error("Database Error: " + error.message);
  }
},
getReservationsDate: async (providerId) => {
  try {
    const [rows] = await db.promise().execute(
      `SELECT
       DATE_FORMAT(start_date, '%Y-%m-%d') AS start_date,
       DATE_FORMAT(end_date, '%Y-%m-%d') AS end_date 
       FROM reservations
       WHERE provider_id = ? AND statut_id = 1`,
      [providerId]
    );
    return rows;
  } catch (error) {
    throw new Error("Database Error: " + error.message);
  }
},



};
module.exports = Reservation;