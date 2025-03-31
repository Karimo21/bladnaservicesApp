const City = require("../models/cityModel");

// Récupérer toutes les villes
exports.getAllCities = async (req, res) => {
  try {
    const cities = await City.getAllCities(); 
    console.log(cities);

    res.json({ cities });
  } catch (error) {
    res.status(500).json({ error: "Erreur lors de la récupération des villes" });
  }
};
