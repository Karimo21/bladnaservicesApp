const db = require("../config/db");

const Service = {
  async getAllServices() {
    try {
      const [rows] = await db.promise().query("SELECT * FROM services ORDER BY title ASC");
      return rows;
    } catch (error) {
      throw error;
    }
  },
};

module.exports = Service;
