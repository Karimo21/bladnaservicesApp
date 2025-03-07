const db = require('../config/db');

const Profile = {

updateProfileData: (userId, data, callback) => {
        const providerQuery = `
            UPDATE providers 
            SET firstname = ?, lastname = ?, adresse = ?, description = ?, updated_at = ? 
            WHERE providers_id = ?
        `;
        const clientQuery = `
            UPDATE clients 
            SET firstname = ?, lastname = ?, adresse = ?, updated_at = ? 
            WHERE clients_id = ?
        `;
           const role=data.role;
    
           const firstname= data.firstname;
           const lastname= data.lastname;
           const adresse=data.address;
           const description= data.description;
           const date= new Date();
          
       if(role=="client"){
        db.query(clientQuery, [firstname,lastname,adresse,date,userId], (err, result) => {
            if (err) return callback(err, null);
            callback(null, result);
        });
       }
       if(role=="provider"){
        db.query(providerQuery, [firstname,lastname,adresse,description,date,userId], (err, result) => {
            if (err) return callback(err, null);
            callback(null, result);
        });
       }
},    
updateProviderProfilePicture: (providerId, imageUrl, callback) => {
    const query = "UPDATE providers SET profile_picture = ? WHERE providers_id = ?";
    db.query(query, [imageUrl, providerId], (err, result) => {
        if (err) return callback(err, null);
        callback(null, result);
    });
},
updateClientProfilePicture: (clientId, imageUrl, callback) => {
    const query = "UPDATE clients SET profile_picture = ? WHERE clients_id = ?";
    db.query(query, [imageUrl, clientId], (err, result) => {
        if (err) return callback(err, null);
        callback(null, result);
    });
}, 
getProviderWorkImages: (providerId, callback) => {
    const query = "SELECT id,image_url from provider_images where provider_id=?";
    db.query(query, [providerId], (err, result) => {
        if (err) return callback(err, null);
        callback(null, result);
    });
}, 

insertImages: (providerId, imageUrls, callback) => {
    // Insert each image URL into the provider_images table
    const query = "INSERT INTO provider_images (provider_id, image_url, created_at, updated_at) VALUES ?";
    const values = imageUrls.map(url => [providerId, url, new Date(), new Date()]);
    
    db.query(query, [values], (err, result) => {
        if (err) return callback(err, null);
        callback(null, result);
    });
},
deleteImageById: (imageId, callback) => {
    const query = "SELECT image_url FROM provider_images WHERE id = ?";
    db.query(query, [imageId], (err, result) => {
        if (err) return callback(err, null);

        if (result.length === 0) {
            return callback(new Error("Image not found"), null);
        }

        const imageUrl = result[0].image_url;

        // Delete the image record from the database
        const deleteQuery = "DELETE FROM provider_images WHERE id = ?";
        db.query(deleteQuery, [imageId], (err, deleteResult) => {
            if (err) return callback(err, null);

            // Return the filename to delete the file from the server
            //const filename = imageUrl.split('/').pop();
            callback(null, { deleteResult, imageUrl });
        });
    });
},

}

module.exports = Profile;
