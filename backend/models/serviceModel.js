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

  async deleteService(serviceId) {
    try {
      // Requête SQL pour supprimer le service en fonction de son ID
      const [result] = await db.promise().query("DELETE FROM services WHERE service_id = ?", [serviceId]);
      console.log("Résultat SQL :", result);
      return result; // Vérifie que result contient affectedRows
    } catch (error) {
      console.error("Erreur SQL :", error);
      throw error;
    }
  },

  async addService(serviceData) {
    try {
      // Vérifier que le champ title est fourni
      if (!serviceData.title) {
        throw new Error("Le champ 'title' est requis.");
      }

      // Requête SQL pour insérer un nouveau service
      const [result] = await db.promise().query(
        "INSERT INTO services (title, created_at, updated_at) VALUES (?, NOW(), NOW())",
        [serviceData.title]
      );

      console.log("Résultat SQL de l'insertion :", result);
      return result; // Vérifie que result contient insertId
    } catch (error) {
      console.error("Erreur SQL :", error);
      throw error;
    }
  },

  async addCities(cityName) { 
    try {
        if (!cityName) {
            throw new Error("Le champ 'city_name' est requis.");
        }

        const [result] = await db.promise().query(
            "INSERT INTO city (city_name) VALUES (?)",
            [cityName]  // Passer directement cityName ici
        );

        console.log("Ville ajoutée avec succès :", result);
        return result;
    } catch (error) {
        console.error("Erreur lors de l'ajout de la ville :", error);
        throw error;
    }
},
async  deleteCities(cityId) {
  try {
      const [result] = await db.promise().query(
          "DELETE FROM city WHERE city_id = ?",
          [cityId]
      );

      console.log("Ville supprimée avec succès :", result);
      return result;
  } catch (error) {
      console.error("Erreur lors de la suppression de la ville :", error);
      throw error;
  }
}


};

module.exports = Service;
