const User = require('../models/userModel');

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
