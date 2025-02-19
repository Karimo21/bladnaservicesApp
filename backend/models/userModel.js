const db = require('../config/db');

const User = {
  getAllUsers: (callback) => {
    db.query("SELECT * FROM users", callback);
  },
  getUserById: (id,callback) => {
    db.query("SELECT * FROM users WHERE user_id = ?", [id], callback);
  },
  createUser: (name, email, callback) => {
    db.query("INSERT INTO users (name, email) VALUES (?, ?)", [name, email], callback);
  },
  
  async getUserByPhone(phone) {
    try {
      const [rows] = await db.promise().query("SELECT * FROM users WHERE phone = ?", [phone]);
      return rows; // Return the rows if successful
    } catch (error) {
      throw error; // Handle errors
    }
  },
  updateClientProfilePicture: (userId, imageUrl, callback) => {
    db.query("UPDATE users u join clients c on u.user_id=c.clients_id SET profile_picture = ? WHERE user_id = ?", [imageUrl, userId], callback);
}


};

module.exports = User;
