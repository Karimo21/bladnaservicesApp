const db = require('../config/db');

const User = {
  getAllUsers: (callback) => {
    db.query("SELECT * FROM users", callback);
  },
  getUserById: (id,callback) => {
    db.query("SELECT * FROM users WHERE user_id = ?", [id], callback);
  },


  createClientUser: (fname, lname, phone, password, role, callback) => {
    db.query(
        "INSERT INTO users (phone, password, role) VALUES (?, ?, ?)", 
        [phone, password, role], 
        (err, result) => {
            if (err) return callback(err, null);

            const userId = result.insertId; // Get the generated user ID

            // Now, insert the user_id into the clients table
            db.query(
                "INSERT INTO clients (clients_id, username) VALUES (?, ?)", 
                [userId, `${fname} ${lname}`], 
                (err, clientResult) => {
                    if (err) return callback(err, null);

                    // Successfully created user and client
                    callback(null, { userId, clientId: userId }); // Send back userId as clientId
                }
            );
        }
    );
},
createProviderUser: (fname, lname, phone, password, role, callback) => {
  db.query(
      "INSERT INTO users (phone, password, role) VALUES (?, ?, ?)", 
      [phone, password, role], 
      (err, result) => {
          if (err) return callback(err, null);

          const userId = result.insertId; // Get the generated user ID

          // Now, insert the user_id into the clients table
          db.query(
              "INSERT INTO providers (providers_id, business_name) VALUES (?, ?)", 
              [userId, `${fname} ${lname}`], 
              (err, clientResult) => {
                  if (err) return callback(err, null);

                  // Successfully created user and client
                  callback(null, { userId, clientId: userId }); // Send back userId as clientId
              }
          );
      }
  );
},
saveProviderDocuments: (providerId, frontImageUrl, backImageUrl, diplomatImageUrl, callback) => {
  const query = "INSERT INTO provider_documents (provider_id, front_card_image, back_card_image, diplomat_image) VALUES (?, ?, ?, ?)";
  const values = [providerId, frontImageUrl, backImageUrl, diplomatImageUrl];
  console.log(providerId, frontImageUrl, backImageUrl, diplomatImageUrl)
  db.query(query, values, callback);
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
