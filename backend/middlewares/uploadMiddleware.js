const multer = require('multer');
const fs = require('fs');
const path = require('path');

// Allowed file types
const fileFilter = (req, file, cb) => {
    const allowedTypes = ['image/jpeg', 'image/png', 'image/jpg', 'image/webp'];
    if (allowedTypes.includes(file.mimetype)) {
        cb(null, true);
    } else {
        cb(new Error('Only images (JPEG, PNG, JPG, WEBP) are allowed!'), false);
    }
};

// Function to create multer storage dynamically
const storage = (folder) => multer.diskStorage({
    destination: (req, file, cb) => {
        const uploadPath = path.join(__dirname, `../uploads/${folder}`);
        if (!fs.existsSync(uploadPath)) {
            fs.mkdirSync(uploadPath, { recursive: true });
        }
        cb(null, uploadPath);
    },
    filename: (req, file, cb) => {
        cb(null, `${Date.now()}-${file.originalname}`);
    }
});

// Middleware for different upload types
const uploadProfilePicture = multer({ 
    storage: storage('profile_pictures'),
    fileFilter,
    limits: { fileSize: 5 * 1024 * 1024 } // 5MB max
});

const uploadProviderPicture = multer({ 
    storage: storage('provider_pictures'),
    fileFilter,
    limits: { fileSize: 5 * 1024 * 1024 } // 5MB max
});

module.exports = { uploadProfilePicture, uploadProviderPicture };
