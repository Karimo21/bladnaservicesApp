
const db = require('../config/db');

const SuivieModel = {
  // Get reservations where the provider is reserved (provider as the reserved one)
  async getReservedProviderReservations(providerId) {
    try {
      const query = `
        SELECT r.reservations_id,
               DATE_FORMAT(r.start_date, '%Y-%m-%d') AS start_date, 
               DATE_FORMAT(r.end_date, '%Y-%m-%d') AS end_date, 
               s.name AS status, 
               u.phone, 
               r.address,
               r.hour,
               ct.city_name,
               CONCAT(cl.firstname, ' ', cl.lastname) AS client_name,
               cl.clients_id as client_id,
               cl.profile_picture,
               'client' AS role
        FROM reservations r
        JOIN clients cl ON r.client_id = cl.clients_id
        join city ct on cl.city_id=ct.city_id
        JOIN users u ON cl.clients_id = u.user_id
        JOIN statut s ON r.statut_id = s.statut_id
        WHERE r.reserved_provider_id = ? AND r.statut_id != 3 AND r.statut_id != 4 AND r.statut_id !=5;  
      `;
      const [rows] = await db.promise().query(query, [providerId]);
      return rows;
    } catch (error) {
      throw error;
    }
  },
  async getProviderReservingProviderReservations(providerId) {
    try {
      const query = `
        SELECT 
            r.reservations_id,
            DATE_FORMAT(r.start_date, '%Y-%m-%d') AS start_date,
            DATE_FORMAT(r.end_date, '%Y-%m-%d') AS end_date,
            s.name AS status,
            u.phone,
            r.address,
            r.hour,
            ct.city_name,
            CONCAT(pr.firstname, ' ', pr.lastname) AS client_name,
            pr.providers_id as client_id,
            pr.profile_picture,
            'provider' AS role
        FROM reservations r
        JOIN providers pr ON r.reserving_provider_id = pr.providers_id
        JOIN users u ON pr.providers_id = u.user_id
        join city ct on pr.city_id=ct.city_id
        JOIN statut s ON r.statut_id = s.statut_id
        WHERE r.reserved_provider_id = ? and r.client_id is null
          AND r.statut_id != 3 AND r.statut_id != 4 AND r.statut_id !=5;
      `;
      const [rows] = await db.promise().query(query, [providerId]);
      return rows;
    } catch (error) {
      throw error;
    }
  },
  //update reservation statut
  async updateReservationStatut(reservationId,statutId,userId,providerId) {
    try {
      const query = `
         update reservations set statut_id=? where reservations_id=?;
      `;
      
      if(statutId==2){
       const providerNameQuery = `SELECT CONCAT(firstname, ' ', lastname) AS provider_name FROM providers WHERE providers_id = ?`;
       const [providerRows] = await db.promise().query(providerNameQuery, [providerId]);
       const providerName = providerRows.length > 0 ? providerRows[0].provider_name : "un prestataire";  // Handle case if provider is not found
       const notificationQuery = `INSERT INTO notifications (user_id, message, created_at) VALUES (?, ?, NOW())`;
       const [notificationResult] = await db.promise().query(notificationQuery, [userId, `Votre demande a été acceptée par ${providerName}`]);
      }
      if(statutId==5){
        const providerNameQuery = `SELECT CONCAT(firstname, ' ', lastname) AS provider_name FROM providers WHERE providers_id = ?`;
        const [providerRows] = await db.promise().query(providerNameQuery, [providerId]);
        const providerName = providerRows.length > 0 ? providerRows[0].provider_name : "un prestataire";  // Handle case if provider is not found
        const notificationQuery = `INSERT INTO notifications (user_id, message, created_at) VALUES (?, ?, NOW())`;
        const [notificationResult] = await db.promise().query(notificationQuery, [userId, `Votre demande a été refusée par ${providerName}`]);
       }
      const statutName = `select name from statut where statut_id= ? `;
      // Insert the notification
      
      const [rows] = await db.promise().query(query, [statutId,reservationId]);
      const [name] = await db.promise().query(statutName, [statutId]);
      return name;
    } catch (error) {
      throw error;
    }
  },

  // Get reservations where the provider is making the reservation (provider as the reserving one)
  async getReservingReservations(role, userId) {
    try {
      let query;
      
      if (role === 'provider') {
        // For provider, use reserving_provider_id
        query = `
          SELECT 
              r.reservations_id,
              DATE_FORMAT(r.start_date, '%Y-%m-%d') AS start_date,
              DATE_FORMAT(r.end_date, '%Y-%m-%d') AS end_date,
              s.name AS status,
              u.phone,
              CONCAT(p.firstname, ' ', p.lastname) AS provider_name,
              p.profile_picture,
              r.hour,
              ct.city_name,
              r.address
          FROM reservations r
          JOIN providers p ON r.reserved_provider_id = p.providers_id
          JOIN users u ON p.providers_id = u.user_id
          JOIN statut s ON r.statut_id = s.statut_id
          Join city ct on ct.city_id=p.providers_id
          WHERE r.reserving_provider_id = ?
          AND r.statut_id IN (1, 2);
        `;
      } else if (role === 'client') {
        // For client, use client_id
        query = `
          SELECT
              r.reservations_id,
              DATE_FORMAT(r.start_date, '%Y-%m-%d') AS start_date,
              DATE_FORMAT(r.end_date, '%Y-%m-%d') AS end_date,
              s.name AS status,
              u.phone,
              ct.city_name,
              CONCAT(p.firstname, ' ', p.lastname) AS provider_name,
              p.profile_picture,
              r.hour,
              r.address
          FROM reservations r
          JOIN providers p ON r.reserved_provider_id = p.providers_id
          JOIN users u ON p.providers_id = u.user_id
          Join city ct on ct.city_id=p.providers_id
          JOIN statut s ON r.statut_id = s.statut_id
          WHERE r.client_id = ?
          AND r.statut_id IN (1, 2);
        `;
      } else {
        throw new Error('Invalid role');
      }
  
      // Execute the query
      const [rows] = await db.promise().query(query, [userId]);
      return rows;
    } catch (error) {
      throw error;
    }
  },
  


 // Get all reservation history for the provider
async getProviderReservationHistory(providerId) {
  try {
    const query = `
   SELECT 
    DATE_FORMAT(r.start_date, '%M %d, %Y') AS start_date, 
    DATE_FORMAT(r.end_date, '%M %d, %Y') AS end_date, 
    s.name AS status, 
    CASE 
        WHEN r.client_id IS NOT NULL THEN u_client.phone  -- Get client's phone if it exists
        WHEN r.reserving_provider_id = ? THEN u_reserved.phone -- If reserving, get reserved provider’s phone
        WHEN r.reserved_provider_id = ? THEN u_reserving.phone -- If reserved, get reserving provider’s phone
    END AS phone,
    CASE 
        WHEN r.reserving_provider_id = ? THEN 'Reserving' 
        WHEN r.reserved_provider_id = ? THEN 'Reserved' 
    END AS reservation_type, 
    CASE 
        WHEN r.reserving_provider_id = ? THEN CONCAT(p_reserved.firstname, ' ', p_reserved.lastname) 
        WHEN r.reserved_provider_id = ? THEN 
            CASE 
                WHEN r.client_id IS NOT NULL THEN CONCAT(cl.firstname, ' ', cl.lastname)
                ELSE CONCAT(p_reserving.firstname, ' ', p_reserving.lastname)
            END 
    END AS reserver_name ,
    CASE
        WHEN r.client_id IS NOT NULL THEN cl.profile_picture
        WHEN r.reserving_provider_id = ? THEN  p_reserved.profile_picture
        WHEN r.reserved_provider_id = ? THEN p_reserving.profile_picture  
        ELSE NULL
    END AS profile_picture
    FROM reservations r
    JOIN statut s ON r.statut_id = s.statut_id
    LEFT JOIN providers p_reserved ON r.reserved_provider_id = p_reserved.providers_id
    LEFT JOIN users u_reserved ON p_reserved.providers_id = u_reserved.user_id  
    LEFT JOIN providers p_reserving ON r.reserving_provider_id = p_reserving.providers_id
    LEFT JOIN users u_reserving ON p_reserving.providers_id = u_reserving.user_id  
    LEFT JOIN clients cl ON r.client_id = cl.clients_id
    LEFT JOIN users u_client ON cl.clients_id = u_client.user_id  -- Join clients with users to get phone number
    WHERE (r.reserved_provider_id = ? OR r.reserving_provider_id = ?) 
    AND r.statut_id IN (3, 4, 5);
    `;

    const [rows] = await db.promise().query(query, [providerId, providerId, providerId, providerId, providerId, providerId, providerId, providerId, providerId, providerId]);
    return rows;
  } catch (error) {
    throw error;
  }
},
async getClientReservationHistory(clientId) {
  try {
      const query = `
          SELECT 
              r.reservations_id,
              DATE_FORMAT(r.start_date, '%M %d, %Y') AS start_date,
              DATE_FORMAT(r.end_date, '%M %d, %Y') AS end_date,
              s.name AS status,
              u.phone,
              CONCAT(p.firstname, ' ', p.lastname) AS provider_name,
              p.profile_picture
          FROM reservations r
          JOIN providers p ON r.reserved_provider_id = p.providers_id
          JOIN users u ON p.providers_id = u.user_id
          JOIN statut s ON r.statut_id = s.statut_id
          WHERE r.client_id = ?
          AND r.statut_id IN (3, 4);
      `;

      const [rows] = await db.promise().query(query, [clientId]);
      return rows;
  } catch (error) {
      throw error;
  }
}

};

module.exports = SuivieModel;