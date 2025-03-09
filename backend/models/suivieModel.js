const db = require('../config/db'); // Assurez-vous que le chemin est correct

const SuivieModel = {
  // Récupérer toutes les réservations avec les détails nécessaires
  async getReservations() {
    try {
      const query = `
      SELECT  DATE_FORMAT(r.start_date, '%M %d, %Y %l:%i %p') AS start_date,  DATE_FORMAT(r.end_date, '%M %d, %Y %l:%i %p') AS end_date, s.name AS statut, u.phone ,CONCAT(cl.firstname, ' ', cl.lastname) 
      AS client_name
      FROM reservations r 
      JOIN clients cl 
      ON r.client_id = cl.clients_id 
      JOIN users u 
      ON cl.clients_id = u.user_id 
      JOIN statut s 
      ON r.statut_id = s.statut_id
      where provider_id = ?;
      `;
      const [rows] = await db.promise().query(query);
      return rows;
    } catch (error) {
      throw error;
    }
  },
 
};

module.exports = SuivieModel;