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
      LEFT JOIN reservations rs ON p.providers_id = rs.reserved_provider_id 
      JOIN ratings r ON p.providers_id = r.provider_id
      where p.availability=1
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

  // Execute the image query firsts
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
   const [rows] = await db.promise().query("SELECT * FROM  clients c join city using(city_id) WHERE c.clients_id = ?", [userId]);
   return rows;
  }catch(error){
  throw error;
 }
},
async getProviderProfile(userId) {
    try {
      // Query to get provider's profile along with total reservations
      const query = `
        SELECT 
          firstname, 
          lastname, 
          adresse, 
          description, 
          profile_picture, 
          city_name, 
          availability,
          title AS service, 
          ROUND(AVG(rt.rating), 1) AS rate,
          COALESCE(COUNT(reservations_id), 0) AS total_reservation
        FROM 
          services 
        JOIN 
          providers p USING(service_id) 
        LEFT JOIN
          ratings rt on rt.provider_id=p.providers_id
        LEFT JOIN 
          reservations r ON p.providers_id = r.reserved_provider_id 
        JOIN 
          city USING(city_id) 
        WHERE 
          p.providers_id = ?
        AND (r.statut_id = 4 OR r.reservations_id IS NULL)
        GROUP BY 
          p.providers_id;
      `;
      
      // Execute the query and pass the userId as a parameter to prevent SQL injection
      const [rows] = await db.promise().query(query, [userId]);
  
      // Return the results (provider profile and reservation count)
      return rows;
    } catch (error) {
      throw error;
    }
  },
  
  updateClientProfilePicture: (userId, imageUrl, callback) => {
    db.query("UPDATE users u join clients c on u.user_id=c.clients_id SET profile_picture = ? WHERE user_id = ?", [imageUrl, userId], callback);
 },

 updateProviderAvailiblity: (providerId, value, callback) => {
    db.query("UPDATE providers SET availability = ? WHERE providers_id = ?", [value, providerId], callback);
},


 getAllClients: (callback) => {
  const query = `
    SELECT c.clients_id, c.firstname, c.lastname, c.adresse, u.phone
    FROM clients c
    JOIN users u ON c.clients_id = u.user_id;
  `;
  db.query(query, callback);
},
getAllValidatedProvider: (callback) => {
  const query = `
  SELECT 
    p.providers_id, 
    p.firstname, 
    p.lastname, 
    p.adresse, 
    s.title,
    p.description, 
    u.phone 
    
FROM providers p
JOIN users u ON p.providers_id = u.user_id
JOIN services s ON p.service_id = s.service_id
WHERE p.is_validated = 1;

  `;
  db.query(query, callback);
},

getAllNonValidatedProviders: (callback) => {
  const query = `
  SELECT 
    p.providers_id, 
    p.firstname, 
    p.lastname, 
    p.adresse, 
    s.title,
    p.description, 
    u.phone 
    
FROM providers p
JOIN users u ON p.providers_id = u.user_id
JOIN services s ON p.service_id = s.service_id
WHERE p.is_validated = 0;

  `;
  db.query(query, callback);
},
validerPrestataire: (providerId, callback) => {  
  const sql = 'UPDATE providers SET is_validated = 1 WHERE providers_id = ?';
  db.query(sql, [providerId], (err, result) => {
    if (err) {
      return callback(err, null);
    }
    return callback(null, result);
  });
},

supprimerPrestataire : (providerId, callback) => {
  const sql = "DELETE FROM providers WHERE providers_id = ?";
  db.query(sql, [providerId], (err, result) => {
    if (err) {
      return callback(err, null);
    }
    return callback(null, result);
  });
},

getDocumentsImage :  (providerId , callback) => {
  const query = ` select back_card_image , diplomat_image ,front_card_image from provider_documents where provider_id =?`;
  db.query(query, [providerId], callback);;
},
async getAdminProfile(userId){
  try{
   const [rows] = await db.promise().query("SELECT * FROM  users u  WHERE u.user_id = ?", [userId]);
   return rows;
  }catch(error){
  throw error;
 }
 },
 getAllreservation: (callback) => { 
  const query = `
    SELECT 
    c.firstname AS nom_client, 
    c.lastname AS prenom_client, 
    p.firstname AS nom_prestataire, 
    p.lastname AS prenom_prestataire, 
    s.start_date, 
    s.end_date, 
    st.name AS statut
FROM reservations s
JOIN clients c ON s.client_id = c.clients_id
JOIN providers p ON s.reserved_provider_id = p.providers_id 
JOIN statut st ON s.statut_id = st.statut_id;
>>>>>>> 56e511c3202a2429d8684b1dffc1842b574b7d20


  `;
  db.query(query, (err, result) => {
      if (err) return callback(err, null);
      callback(null, result);
  });
}
};
module.exports = User;
