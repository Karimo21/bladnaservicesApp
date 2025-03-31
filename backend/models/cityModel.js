const db = require("../config/db");

const City = {
  // Récupérer toutes les villes
  async getAllCities() {
    try {
      const [rows] = await db.promise().query("SELECT * FROM city ORDER BY city_name ASC");
      return rows;
    } catch (error) {
      throw error;
    }
    
  },
};

module.exports = City;
