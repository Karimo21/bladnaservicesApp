const Service = require("../models/serviceModel");

exports.getAllServices = async (req, res) => {
  try {
    const services = await Service.getAllServices();
    res.json({ services });
  } catch (error) {
    res.status(500).json({ error: "Erreur lors de la récupération des services" });
  }
};
