/**
 * TrustLit Backend Server
 * Express server with OpenAI GPT-4 Vision integration for product analysis
 */

require('dotenv').config();
const express = require('express');
const cors = require('cors');
const multer = require('multer');
const path = require('path');
const fs = require('fs');

// Import routes
const analyzeRoute = require('./routes/analyze');
const healthRoute = require('./routes/health');

const app = express();
const PORT = process.env.PORT || 3000;

// Middleware
app.use(cors());
app.use(express.json({ limit: '50mb' }));
app.use(express.urlencoded({ extended: true, limit: '50mb' }));

// Request logging middleware
app.use((req, res, next) => {
  console.log(`${new Date().toISOString()} - ${req.method} ${req.path}`);
  next();
});

// Routes
app.use('/api/health', healthRoute);
app.use('/api/analyze', analyzeRoute);

// Root route
app.get('/', (req, res) => {
  res.json({
    name: 'TrustLit API',
    version: '1.0.0',
    status: 'running',
    endpoints: {
      health: '/api/health',
      analyze: '/api/analyze (POST)',
    },
  });
});

// 404 handler
app.use((req, res) => {
  res.status(404).json({
    success: false,
    error: 'Endpoint not found',
  });
});

// Error handler
app.use((err, req, res, next) => {
  console.error('Error:', err.message);
  res.status(500).json({
    success: false,
    error: process.env.NODE_ENV === 'development' ? err.message : 'Internal server error',
  });
});

// Start server
app.listen(PORT, () => {
  console.log(`
╔═══════════════════════════════════════════════════════╗
║         TrustLit Backend Server Started               ║
╠═══════════════════════════════════════════════════════╣
║  Port: ${PORT}                                            ║
║  Environment: ${process.env.NODE_ENV || 'development'}                        ║
║  AI Provider: ${process.env.AI_PROVIDER || 'openai'}                          ║
╚═══════════════════════════════════════════════════════╝
  `);
});

module.exports = app;
