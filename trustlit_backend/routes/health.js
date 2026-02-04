/**
 * Health Check Route
 * Returns server status and configuration info
 */

const express = require('express');
const router = express.Router();

router.get('/', (req, res) => {
    res.json({
        success: true,
        status: 'healthy',
        timestamp: new Date().toISOString(),
        uptime: process.uptime(),
        config: {
            aiProvider: process.env.AI_PROVIDER || 'openai',
            hasOpenAIKey: !!process.env.OPENAI_API_KEY,
            hasGeminiKey: !!process.env.GEMINI_API_KEY,
        },
    });
});

module.exports = router;
