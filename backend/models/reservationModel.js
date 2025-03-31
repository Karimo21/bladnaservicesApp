const db = require('../config/db');

const Reservation ={

createReservation: async (role, clientId, providerId, startDate, endDate, statutId,hour,address) => {
   let query="";
    try {
        const notificationQuery = `INSERT INTO notifications (user_id, message, created_at) VALUES (?, ?, NOW())`;

        if(role=="client"){
          query='INSERT INTO reservations (client_id, reserved_provider_id, start_date, end_date, statut_id,hour,address) VALUES (?, ?, ?, ?, ?, ?, ?)';
          const clientNameQuery=`SELECT CONCAT(firstname, ' ', lastname) AS client_name FROM clients WHERE clients_id = ?`;
          const [result] = await db.promise().query(clientNameQuery, [clientId]);
          console.log(result);
          const clientName = result.length > 0 ? result[0].client_name : "Un Client";
          await db.promise().query(notificationQuery, [providerId, `${clientName} a fait une demande de réservation`]);
        }
        

        if(role=="provider"){
          query='INSERT INTO reservations (reserving_provider_id, reserved_provider_id, start_date, end_date, statut_id,hour,address) VALUES (?, ?, ?, ?, ?, ?, ?)';
          const clientNameQuery=`SELECT CONCAT(firstname, ' ', lastname) AS client_name FROM providers WHERE providers_id = ?`;
          const [result] = await db.promise().query(clientNameQuery, [clientId]);
          const clientName = result.length > 0 ? result[0].client_name : "Un Client";
          await db.promise().query(notificationQuery, [providerId, `${clientName} a fait une demande de réservation`]);          
        }
  
        const [result] = await db.promise().execute(
            query,
            [clientId, providerId, startDate, endDate, statutId,hour,address]
        );

        return result; // Return insert result to controller
    } catch (error) {
        throw new Error("Database Error: " + error.message);
    }
},
 getClientInfo : async (role, clientId) => {
  let query = "";
  
  try {
      if (role === "client") {
          query = `
              SELECT 
                  u.phone,
                  ct.city_name,
                  CONCAT(c.firstname, " ", c.lastname) AS client_name,
                  c.profile_picture
              FROM users u
              JOIN clients c ON u.user_id = c.clients_id
              JOIN city ct ON c.city_id = ct.city_id
              WHERE u.user_id = ?;
          `;
      } else if (role === "provider") {
          query = `
              SELECT 
                  u.phone,
                  ct.city_name,
                  CONCAT(p.firstname, " ", p.lastname) AS client_name,
                  p.profile_picture
              FROM users u
              JOIN providers p ON u.user_id = p.providers_id
              JOIN city ct ON p.city_id = ct.city_id
              WHERE u.user_id = ?;
          `;
      } else {
          throw new Error("Invalid role specified");
      }

      // Execute query using prepared statements
      const [result] = await db.promise().execute(query, [clientId]);

      return result; // Return the fetched data
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
       WHERE reserved_provider_id = ? AND statut_id = 2`,
      [providerId]
    );
    return rows;
  } catch (error) {
    throw new Error("Database Error: " + error.message);
  }
},



};
module.exports = Reservation;