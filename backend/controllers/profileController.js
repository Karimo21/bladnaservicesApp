const Profile = require('../models/profileModel');
const path = require('path');
const fs = require('fs');
const { uploadProfilePicture,uploadProviderImages } = require('../middlewares/uploadMiddleware');

exports.uploadProfilePicture = (req, res) => {
    uploadProfilePicture(req, res, (err) => {
         if (err) {
            return res.status(400).json({ message: "Image upload failed", error: err.message });
        }

        const { role, userId } = req.body;
        // Ensure the file was uploaded
        if (!req.files || !req.files['profile_image']) {
            return res.status(400).json({ message: "No image uploaded" });
        }

        // Construct image path
        const profileImageUrl = `/uploads/profile_pictures/${req.files['profile_image'][0].filename}`;

        
        if (role === "provider") {
            Profile.updateProviderProfilePicture(userId, profileImageUrl, (err, result) => {
                if (err) return res.status(500).json({ message: "Database error", error: err });
                return res.json({ message: "Profile of provider updated successfully",profileImageUrl, result });
            });
        } else if (role === "client") { 
            Profile.updateClientProfilePicture(userId, profileImageUrl, (err, result) => {
                if (err) return res.status(500).json({ message: "Database error", error: err });
                return res.json({ message: "Profile of client updated successfully",profileImageUrl, result });
            });
        } else {
            return res.status(400).json({ message: "Invalid role" });
        }
    });
};

//update the profile informations
exports.updateProfileData = (req, res) => {
    const userId = req.params.userId;
    const data = req.body;
    Profile.updateProfileData(userId, data, (err, result) => {
        if (err) {
            return res.status(500).json({ message: "Database error", error: err.message });
        }
        if (result.affectedRows === 0) {
            return res.status(404).json({ message: "User not found or no changes made" });
        }
        return res.json({ message: "Profile updated successfully", result });
    });
};
//get provider work images
exports.getProviderWorkImages = (req, res) => {
    const { providerId } = req.params; // Assuming providerId is passed in the URL params

    Profile.getProviderWorkImages(providerId, (err, result) => {
        if (err) {
            return res.status(500).json({ message: "Error fetching images", error: err.message });
        }
        if (!result || result.length === 0) {
            return res.status(404).json({ message: "No images found for this provider" });
        }
        
        return res.json({ message: "Provider images fetched successfully", images: result });
    });
};
// Upload multiple provider images
exports.uploadProviderImages = (req, res) => {
    uploadProviderImages(req, res, (err) => {
        console.log("got inside");
        const provider_id = req.params.providerId;
        if (err) {
            return res.status(400).json({ message: "Image upload failed", error: err.message });
        }
        console.log("no error after if");
        console.log(req.files);
        if (!req.files || req.files.length === 0) {
            console.log("No files were uploaded", req.files);
            return res.status(400).json({ message: "No files were uploaded." });
        }
        console.log("images existe");// Assuming provider_id is passed in the body
        console.log(provider_id);
        // Map over uploaded files and store the file URLs
        const imageUrls = req.files.map(file => `/uploads/work_images/${file.filename}`);
        console.log(imageUrls);
        // Insert image URLs into the database
        Profile.insertImages(provider_id, imageUrls, (err, result) => {
            if (err) return res.status(500).json({ message: "Database error", error: err });

            return res.json({
                message: "Provider images uploaded successfully",
                imageUrls: imageUrls,
                result
            });
        });
    });
};

// Delete a specific provider image by image ID
exports.deleteProviderImage = (req, res) => {
    const { imageId } = req.params;
    console.log(imageId);
    Profile.deleteImageById(imageId, (err, result) => {
        if (err){
         console.error("Database Error:", err);  
         return res.status(500).json({ message: "Database error", error: err });
        }
        // Optionally delete the image file from the server
       // const imagePath = path.join(__dirname, `../${result.imageUrl}`);
        //console.log(imagePath);
        //fs.unlink(imagePath, (err) => {
            //if (err) return res.status(500).json({ message: "File deletion failed", error: err });
            res.json({ message: "Image deleted successfully", result });
        //});
    });
};