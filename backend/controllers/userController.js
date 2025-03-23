const db = require('../config/db'); // Import the database connection
const User = require('../models/userModel');
const { uploadProviderDocuments } = require('../middlewares/uploadMiddleware'); // Import the middleware




// Update provider's latitude and longitude
exports.updateProviderPosition = (req, res) => {
  const { providers_id } = req.params;
  const { latitude, longitude } = req.body;

  // Call the model function to update the provider's position
  User.updateProviderPosition(providers_id, latitude, longitude, (err, results) => {
    if (err) {
      console.error('Error updating provider position:', err);
      return res.status(500).json({ message: 'Internal server error' });
    }

    if (results.affectedRows === 0) {
      return res.status(404).json({ message: 'Provider not found' });
    }

    res.status(200).json({ message: 'Provider position updated successfully' });
  });
};
//
// Get all providers  
exports.getAllProviders = (req, res) => {
  User.getAllProviders((err, providers) => {
    if (err) {
      console.error('Error fetching providers:', err);
      return res.status(500).json({ message: 'Internal server error' });
    }

    // Format the data to match the structure of _prestataires
    const formattedProviders = providers.map((provider) => ({
      lat: parseFloat(provider.lat),
      lng: parseFloat(provider.lng),
      image: provider.image,
      nom: provider.nom,
    }));

    res.status(200).json(formattedProviders);
  });
};
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
  const providerId = req.params.providerId; // Get provider ID from request parameters

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
    if (user.password !== password) {
      return res.status(401).json({ message: "Incorrect password" });
    }
    let profile="";
    if(user.role==="client"){
       profile =await User.getClientProfile(user.user_id);
    }
    if(user.role==="provider"){
       profile =await User.getProviderProfile(user.user_id);
    }
    
    // If everything matches, return the user data and role
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
      },
    });
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
exports.createUser = (req, res) => {
  const { name, email } = req.body;
  User.createUser(name, email, (err, results) => {
    if (err) return res.status(500).send(err);
    res.json({ message: "User created successfully", userId: results.insertId });
  });
};


//MAP
exports.updateProviderPosition = (req, res) => {
  const { providers_id } = req.params;
  const { latitude, longitude } = req.body;

  // SQL query to update latitude and longitude
  const query = `
    UPDATE providers 
    SET latitude = ?, longitude = ?, updated_at = NOW() 
    WHERE providers_id = ?
  `;

  // Execute the query
  db.query(query, [latitude, longitude, providers_id], (err, results) => {
    if (err) {
      console.error('Error updating provider position:', err);
      return res.status(500).json({ message: 'Internal server error' });
    }

    if (results.affectedRows === 0) {
      return res.status(404).json({ message: 'Provider not found' });
    }

    res.status(200).json({ message: 'Provider position updated successfully' });
  });
};