const db = require('../config/db');

const Rating = {

  // Find ratings for a provider
  async findRatingsForProvider(providerId) {
    try {
      const [rows] = await db.promise().query(
        `SELECT 
    r.rating, 
    r.feedback, 
    DATE_FORMAT(r.created_at, '%y/%c/%e') AS rating_time, 
    r.client_id, 
    r.provider_id, 
    c.username AS client_name, 
    c.profile_picture AS client_profile_picture
FROM ratings r
JOIN clients c ON r.client_id = c.clients_id
WHERE r.provider_id = ?;
`,
        [providerId]
      );
      return rows;
    } catch (error) {
      throw error;
    }
  },

};

module.exports = Rating;
