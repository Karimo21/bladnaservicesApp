const db = require('../config/db');

const User = {

getProviderDetails: (callback) => {
    const query = `
SELECT p.providers_id,
             CONCAT(p.firstname, ' ', p.lastname) AS provider_name,
             p.profile_picture,
             s.title,
             ROUND(AVG(r.rating), 1) AS rating,
             p.adresse,
             p.description,
             COUNT(DISTINCT rs.reservations_id) AS nbr_res
      FROM providers p
      JOIN services s USING(service_id)
      LEFT JOIN reservations rs ON p.providers_id = rs.provider_id
      JOIN ratings r ON p.providers_id = r.provider_id
      GROUP BY p.providers_id;
    `;

    db.query(query, (err, providers) => {
        if (err) return callback(err, null);
        callback(null, providers); // Retourne toutes les lignes trouvées
    });
},
getMoreProviderDetails(providerId, callback) {
  // First, query to get the images associated with the provider
  const imagesQuery = `
      SELECT pi.image_url
      FROM provider_images pi
      WHERE pi.provider_id = ?;
  `;
  
  // Query to get ratings and feedback for the provider
  const ratingsQuery = `
      SELECT c.firstname, c.lastname, r.feedback, DATE_FORMAT(r.created_at, '%M %d, %Y %l:%i %p') AS created_at, r.rating, c.profile_picture
      FROM clients c
      JOIN ratings r ON c.clients_id = r.client_id
      WHERE r.provider_id = ?;
  `;

  // Execute the image query first
  db.query(imagesQuery, [providerId], (err, images) => {
      if (err) return callback(err, null);

      // Execute the ratings query
      db.query(ratingsQuery, [providerId], (err, ratings) => {
          if (err) return callback(err, null);

          // Combine both results and return them
          callback(null, {
              images: images,   // Array of image URLs
              ratings: ratings  // Array of ratings and feedback
          });
      });
  });
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
                "INSERT INTO clients (clients_id, firstname,lastname) VALUES (?, ?, ?)", 
                [userId,fname,lname], 
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
              "INSERT INTO providers (providers_id, firstname,lastname) VALUES (?, ?, ?)", 
              [userId,fname,lname], 
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

async getClientProfile(userId){
  try{
   const [rows] = await db.promise().query("SELECT * FROM  clients c WHERE c.clients_id = ?", [userId]);
   return rows;
  }catch(error){
  throw error;
 }
},
 async getProviderProfile(userId){
  try{
   const [rows] = await db.promise().query("SELECT * FROM  providers p  WHERE p.providers_id = ?", [userId]);
   return rows;
  }catch(error){
  throw error;
 }
 },
  updateClientProfilePicture: (userId, imageUrl, callback) => {
    db.query("UPDATE users u join clients c on u.user_id=c.clients_id SET profile_picture = ? WHERE user_id = ?", [imageUrl, userId], callback);
 }


};

module.exports = User;
