const express = require('express');
const path = require('path');

const router = express.Router();

// Middleware pour vérifier si l'utilisateur est connecté
const isAuthenticated = (req, res, next) => {
    if (req.session && req.session.user) {
        next(); // L'utilisateur est connecté
    } else {
        res.redirect('/login/login.html'); // Redirection si non connecté
    }
};
router.get('/interface/tableauBord.html', (req, res) => {
  res.sendFile(path.join(__dirname, '../public/deshbord_bladnaservice/interface/tableauBord.html'));
});
// Route pour afficher le dashboard
router.get('/dashboard', isAuthenticated, (req, res) => {
    res.sendFile(path.join(__dirname, '../public/deshbord_bladnaservice/dashboard.html'));
});

// Route vers la page de login
router.get('/login/login.html', (req, res) => {
    res.sendFile(path.join(__dirname, '../public/deshbord_bladnaservice/login/login.html'));
});
router.get('/interface/prestatire.html', (req, res) => {
  res.sendFile(path.join(__dirname, '../public/deshbord_bladnaservice/interface/prestatire.html'));
});
router.get('/interface/client.html', (req, res) => {
  res.sendFile(path.join(__dirname, '../public/deshbord_bladnaservice/interface/client.html'));
});

router.get('/interface/reservation.html', (req, res) => {
  res.sendFile(path.join(__dirname, '../public/deshbord_bladnaservice/interface/reservation.html'));
});

router.get('/interface/image.html', (req, res) => {
  res.sendFile(path.join(__dirname, '../public/deshbord_bladnaservice/interface/image.html'));
});

router.get('/interface/demandeValidation.html', (req, res) => {
  res.sendFile(path.join(__dirname, '../public/deshbord_bladnaservice/interface/demandeValidation.html'));
});

router.get('/interface/services.html', (req, res) => {
  res.sendFile(path.join(__dirname, '../public/deshbord_bladnaservice/interface/services.html'));
});
router.get('/interface/city.html', (req, res) => {
  res.sendFile(path.join(__dirname, '../public/deshbord_bladnaservice/interface/city.html'));
  
});
router.get('/interface/srch.css', (req, res) => {
  res.sendFile(path.join(__dirname, '../public/deshbord_bladnaservice/interface/srch.css'));
});
router.get('/interface/logo.png', (req, res) => {
  res.sendFile(path.join(__dirname, '../public/deshbord_bladnaservice/interface/logo.png'));
});


module.exports = router;