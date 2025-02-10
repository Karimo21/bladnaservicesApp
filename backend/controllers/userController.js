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

exports.createUser = (req, res) => {
  const { name, email } = req.body;
  User.createUser(name, email, (err, results) => {
    if (err) return res.status(500).send(err);
    res.json({ message: "User created successfully", userId: results.insertId });
  });
};
