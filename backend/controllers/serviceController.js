const Service = require("../models/serviceModel");

exports.getAllServices = async (req, res) => {
  try {
    const services = await Service.getAllServices();
    res.json({ services });
  } catch (error) {
    res.status(500).json({ error: "Erreur lors de la récupération des services" });
  }
};
// Controller pour supprimer un service
exports.deleteService = async (req, res) => { 
  const serviceId = req.params.id; // Récupérer l'ID du service à partir de l'URL
  console.log("ID du service reçu :", serviceId);

  try {
    // Appel à la fonction du modèle pour supprimer le service
    const result = await Service.deleteService(serviceId);
    console.log("Résultat de la suppression :", result);

    if (result.affectedRows === 0) {
      return res.status(404).json({ message: "Service non trouvé" });
    }

    res.json({ message: "Service supprimé avec succès" });
  } catch (error) {
    console.error("Erreur lors de la suppression :", error);
    res.status(500).json({ error: "Erreur lors de la suppression du service" });
  }
};

exports.addService = async (req, res) => {
  const { title } = req.body; // Récupérer les données du service
  console.log("Données reçues pour l'ajout :", { title });

  try {
    // Vérifier que le champ obligatoire est fourni
    if (!title) {
      return res.status(400).json({ message: "Le champ 'title' est requis" });
    }

    // Appel à la fonction du modèle pour ajouter le service
    const result = await Service.addService({ title });
    console.log("Résultat de l'ajout :", result);

    res.status(201).json({ message: "Service ajouté avec succès", serviceId: result.insertId });
  } catch (error) {
    console.error("Erreur lors de l'ajout du service :", error);
    res.status(500).json({ error: "Erreur lors de l'ajout du service" });
  }
};


exports.deleteCities = async (req, res) => { 
  const serviceId = req.params.id; // Récupérer l'ID du service à partir de l'URL
  console.log("ID du service reçu :", serviceId);

  try {
    // Appel à la fonction du modèle pour supprimer le service
    const result = await Service.deleteCities(serviceId);
    console.log("Résultat de la suppression :", result);

    if (result.affectedRows === 0) {
      return res.status(404).json({ message: "Service non trouvé" });
    }

    res.json({ message: "Service supprimé avec succès" });
  } catch (error) {
    console.error("Erreur lors de la suppression :", error);
    res.status(500).json({ error: "Erreur lors de la suppression du service" });
  }
};

// Contrôleur pour ajouter une ville
exports.addCities = async (req, res) => {
  const { city_name } = req.body; // Récupérer le nom de la ville depuis le corps de la requête
  console.log("Données reçues pour l'ajout :", { city_name });

  try {
    // Vérifier que le champ obligatoire est fourni
    if (!city_name) {
      return res.status(400).json({ message: "Le champ 'city_name' est requis" });
    }

    // Appel à la fonction du modèle pour ajouter la ville
    const result = await Service.addCities(city_name);  // Passer uniquement city_name
    console.log("Résultat de l'ajout :", result);

    // Si l'ajout a réussi, renvoyer une réponse avec l'ID de la ville ajoutée
    res.status(201).json({ message: "Ville ajoutée avec succès", cityId: result.insertId });
  } catch (error) {
    console.error("Erreur lors de l'ajout de la ville :", error);
    res.status(500).json({ error: "Erreur lors de l'ajout de la ville" });
  }
};

