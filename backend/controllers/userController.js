const User = require('../models/userModel');
const { uploadProviderDocuments } = require('../middlewares/uploadMiddleware'); // Import the middleware



exports.getProviderProfile = (req, res) => {
  User.getProviderDetails((err, data) => {
      if (err){
        console.log(err);
        return res.status(500).json({ message: "Database error", error: err });
      } 

      res.json(data); // Retourne une liste de providers
  });
};
exports.getMoreProviderDetails = (req, res) => {
  const providerId = req.params.providerId; // Get provider ID from request parameterss

  User.getMoreProviderDetails(providerId, (err, providerDetails) => {
    if (err) return res.status(500).json({ message: "Database error", error: err });

    res.json(providerDetails); // Return the provider details (images and reviews)
  });
};

exports.createClientUser = (req, res) => {

  uploadProviderDocuments(req, res, (err) => {

     const { fname, lname, phone, password, role } = req.body;
     console.log(fname, lname, phone, password, role);
     User.createClientUser(fname, lname, phone, password, role, (err, result) => {
       if (err) return res.status(500).json({ message: "Database error", error: err });
     res.json({ message: "Client user created successfully", result });
    });
  });
};
exports.createProviderUser = (req, res) => {

  // Handle image upload
  uploadProviderDocuments(req, res, (err) => {
      if (err) {
          //console.log('Error uploading files:', err.message);
          return res.status(400).json({ message: "Image upload failed", error: err.message });
      }
      const { fname, lname, phone, password, role } = req.body;
      

      // Create provider user
      User.createProviderUser(fname, lname, phone, password, role, (err, result) => {
          if (err) return res.status(500).json({ message: "Database error", error: err });

          const providerId = result.userId; // Get the provider ID
          console.log(providerId);
          console.log("outside");
          // Check if all images are provided
          if (req.files && req.files['front_image'] && req.files['back_image'] && req.files['diploma_image']) {
              const frontImageUrl = `/uploads/provider_documents/${req.files['front_image'][0].filename}`;
              const backImageUrl = `/uploads/provider_documents/${req.files['back_image'][0].filename}`;
              const diplomatImageUrl = `/uploads/provider_documents/${req.files['diploma_image'][0].filename}`;
              console.log("inside");
              console.log(frontImageUrl);
              // Save image paths in the database
              User.saveProviderDocuments(providerId, frontImageUrl, backImageUrl, diplomatImageUrl, (err, imageResult) => {
                  if (err) return res.status(500).json({ message: "Error saving document URLs", error: err },
                    console.log(err.message)
                  );
                  

                  res.json({ 
                      message: "Provider user created successfully", 
                      result, 
                      frontImageUrl, 
                      backImageUrl, 
                      diplomatImageUrl 
                  });
              });
          } else {
              res.json({ message: "Provider user created successfully without images", result });
          }
      });
  });
};
exports.getUsers = (req, res) => {
  User.getAllUsers((err, results) => {
    if (err) return res.status(500).send(err);
    res.json(results);
  });
};
exports.getUser = (req, res) => {
  User.getUserById(req.params.id, (err, results) => {
    if (err) return res.status(500).send(err);
    res.json(results[0]);
  });
};
exports.loginUser = async (req, res) => {
  const { phone, password } = req.body;

  try {
    // Get user by phone using the async method
    const results = await User.getUserByPhone(phone);
    
    // Check if user exists
    if (results.length === 0) {
      return res.status(404).json({ message: "User not found" });
    }

    // Check if the password matches (simple comparison for now)
    const user = results[0];
    console.log(user);
    if (user.password !== password) {
      
      console.log(user.password,password);
      return res.status(401).json({ message: "Incorrect password" });
    }
    let profile="";
    if(user.role==="client"){
       profile =await User.getClientProfile(user.user_id);
       res.json({
        message: "Login successful",
        user: {
          userId: user.user_id,
          fname:profile[0].firstname,
          lname:profile[0].lastname,
          phone: user.phone,
          role: user.role,
          adresse:profile[0].adresse,
          description:profile[0].description,
          profile:profile[0]['profile_picture'],
          rate:"",
          city:"",
          availability:0,
          service:"",
          totalreservations:0
        },
      });
    }
    if(user.role==="provider"){
       profile =await User.getProviderProfile(user.user_id);
       res.json({
        message: "Login successful",
        user: {
          userId: user.user_id,
          fname:profile[0].firstname,
          lname:profile[0].lastname,
          phone: user.phone,
          role: user.role,
          adresse:profile[0].adresse,
          description:profile[0].description,
          profile:profile[0]['profile_picture'],
          rate:profile[0].rate,
          city:profile[0].city_name,
          service:profile[0].service,
          availability:profile[0].availability,
          totalreservations:profile[0].total_reservation
        },
      });
    }
    if(user.role==="admin"){
      profile =await User.getAdminProfile(user.user_id);
   }
    

    
  } catch (error) {
    console.error(error);
    res.status(500).json({ message: "Internal server error" });
  }
};
exports.uploadProfilePictureController = (req, res) => {
  if (!req.file) {
      return res.status(400).json({ message: "No file uploaded" });
  }

  const userId = req.body.user_id; // Make sure this is sent in the request
  const imageUrl = `/uploads/profile_pictures/${req.file.filename}`;

  // Save image URL in database
  User.updateClientProfilePicture(userId, imageUrl, (err, results) => {
      if (err) return res.status(500).json({ message: "Database error", error: err });
      res.json({ message: "Profile picture uploaded successfully", imageUrl });
  });
};
exports.updateProviderAvailiblity = (req, res) => {

  const { providerId, value } = req.body;
  
  // Save image URL in database
  User.updateProviderAvailiblity(providerId,value,(err, results) => {
      if (err) return res.status(500).json({ message: "Database error", error: err });
      res.json({ message: "Provider availiblity updated successfully" });
  });
};
exports.createUser = (req, res) => {
  const { name, email } = req.body;
  User.createUser(name, email, (err, results) => {
    if (err) return res.status(500).send(err);
    res.json({ message: "User created successfully", userId: results.insertId });
  });
};
exports.getAllClients = (req, res) => {
  User.getAllClients((err, results) => {
    if (err) {
      console.error("Erreur lors de la récupération des clients:", err);
      return res.status(500).json({ message: "Erreur interne du serveur", error: err });
    }
    res.json(results);
  });
};
exports.getAllValidatedProvider = (req, res) => {
  User.getAllValidatedProvider((err, results) => {
    if (err) {
      console.error("Erreur lors de la récupération des prestataires:", err);
      return res.status(500).json({ message: "Erreur interne du serveur", error: err });
    }
    res.json(results);
  });
}
exports.getAllNonValidatedProviders = (req, res) => {
  User.getAllNonValidatedProviders((err, results) => {
    if (err) {
      console.error("Erreur lors de la récupération des prestataires:", err);
      return res.status(500).json({ message: "Erreur interne du serveur", error: err });
    }
    res.json(results);
  });
  
  exports.validerPrestataire = (req, res) => {
    const providerId = req.params.id;

    User.validerPrestataire(providerId, (err, result) => {
        if (err) {
            console.error("Erreur lors de la validation du prestataire:", err);
            return res.status(500).json({ message: "Erreur interne du serveur", error: err });
        }

        if (result.affectedRows === 0) {
            return res.status(404).json({ message: "Prestataire non trouvé" });
        }

        res.json({ message: "Prestataire validé avec succès" });
    });
};



const suppremerPrestataire = (req, res) => {
  const providerId = req.params.id;

  // Vérifier si l'ID est valide
  if (!providerId) {
    return res.status(400).json({ message: "ID du prestataire requis" });
  }

  const sql = "DELETE FROM providers WHERE providers_id = ?";

  db.query(sql, [providerId], (err, result) => {
    if (err) {
      console.error("Erreur lors de la suppression du prestataire:", err);
      return res.status(500).json({ message: "Erreur interne du serveur", error: err });
    }

    if (result.affectedRows === 0) {
      return res.status(404).json({ message: "Prestataire non trouvé" });
    }

    res.json({ message: "Prestataire supprimé avec succès" });
  });
};

}
exports.validerPrestataire = (req, res) => {
  const providerId = req.params.id;

  User.validerPrestataire(providerId, (err, result) => {
      if (err) {
          console.error("Erreur lors de la validation du prestataire:", err);
          return res.status(500).json({ message: "Erreur interne du serveur", error: err });
      }

      if (result.affectedRows === 0) {
          return res.status(404).json({ message: "Prestataire non trouvé" });
      }

      res.json({ message: "Prestataire validé avec succès" });
  });
  
}
exports.suppremerPrestataire = (req, res) => {
  const providerId = req.params.id;

  User.supprimerPrestataire(providerId, (err, result) => {
      if (err) {
          console.error("Erreur lors de la validation du prestataire:", err);
          return res.status(500).json({ message: "Erreur interne du serveur", error: err });
      }

      if (result.affectedRows === 0) {
          return res.status(404).json({ message: "Prestataire non trouvé" });
      }

      res.json({ message: "Prestataire validé avec succès" });
  });
  
};

exports.getDocumentsImage = (req, res) => {
  const providerId = req.params.providerId;

  User.getDocumentsImage(providerId, (err, results) => {
      if (err) {
          console.error("Erreur lors de la affichage du image :", err);
          return res.status(500).json({ message: "Erreur interne du serveur", error: err });
      }

      res.json(results);
  });
  
};
exports.getAllreservation = (req, res) => {
  User.getAllreservation((err, results) => {
    if (err) {
      console.error("Erreur lors de la récupération des reservation :", err);
      return res.status(500).json({ message: "Erreur interne du serveur", error: err });
    }
    res.json(results);
  });
};
