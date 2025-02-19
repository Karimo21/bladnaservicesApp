const User = require('../models/userModel');
const { uploadProviderDocuments } = require('../middlewares/uploadMiddleware'); // Import the middleware



 
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

    // If everything matches, return the user data and role
    res.json({
      message: "Login successful",
      user: {
        userId: user.user_id,
        phone: user.phone,
        role: user.role,
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
