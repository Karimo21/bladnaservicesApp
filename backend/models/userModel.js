const db = require('../config/db');

const User = {
  getAllUsers: (callback) => {
    db.query("SELECT * FROM users", callback);
  },
  getUserById: (id, callback) => {
    db.query("SELECT * FROM users WHERE id = ?", [id], callback);
  },
  createUser: (name, email, callback) => {
    db.query("INSERT INTO users (name, email) VALUES (?, ?)", [name, email], callback);
  }
};

module.exports = User;
