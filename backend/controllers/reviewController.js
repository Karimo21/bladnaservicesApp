const db = require('../config/db');
const Rating = require('../models/reviewModel');
const express = require('express');

// Fetch provider ratings
exports.getProviderRatings = async (req, res) => {
  try {
    const providerId = req.params.providerId;
    const ratings = await Rating.findRatingsForProvider(providerId);
    res.json(ratings);
  } catch (error) {
    res.status(500).json({ error: 'Failed to fetch ratings' });
  }
};

// Create a new rating
exports.createRating = async (clientId, providerId, rating, feedback) => {
  try {
    const result = await db.promise().query(
      `INSERT INTO ratings (client_id, provider_id, rating, feedback, created_at) VALUES (?, ?, ?, ?, NOW())`,
      [clientId, providerId, rating, feedback]
    );
    return result;
  } catch (error) {
    throw new Error('Error saving rating: ' + error.message);
  }
};

// Fetch all ratings between a client and a provider
exports.getRatingsBetweenUsers = async (req, res) => {
  try {
    const clientId = req.params.clientId;
    const providerId = req.params.providerId;
    const ratings = await db.promise().query(
      `SELECT * FROM ratings WHERE client_id = ? AND provider_id = ? ORDER BY created_at ASC`,
      [clientId, providerId]
    );
    res.json(ratings[0]);
  } catch (error) {
    res.status(500).json({ error: 'Error fetching ratings' });
  }
};


