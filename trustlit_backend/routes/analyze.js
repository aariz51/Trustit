/**
 * Product Analysis Route
 * Analyzes product images using OpenAI GPT-4 Vision
 */

const express = require('express');
const router = express.Router();
const OpenAI = require('openai');
const multer = require('multer');
const fs = require('fs');
const path = require('path');

// Configure multer for file uploads
const storage = multer.memoryStorage();
const upload = multer({
    storage: storage,
    limits: { fileSize: 10 * 1024 * 1024 }, // 10MB limit
    fileFilter: (req, file, cb) => {
        const allowedTypes = ['image/jpeg', 'image/png', 'image/jpg', 'image/webp'];
        if (allowedTypes.includes(file.mimetype)) {
            cb(null, true);
        } else {
            cb(new Error('Invalid file type. Only JPEG, PNG, and WebP are allowed.'));
        }
    },
});

// Initialize OpenAI client
const openai = new OpenAI({
    apiKey: process.env.OPENAI_API_KEY,
});

// Analysis prompt template
const ANALYSIS_PROMPT = `You are a professional food and cosmetic product safety analyst. Analyze the product images provided and return a detailed JSON analysis.

IMPORTANT: Only respond with valid JSON, no markdown or additional text.

Analyze the product images and extract:
1. Product name and category
2. All visible ingredients
3. Safety assessment for each ingredient
4. Overall product safety score (0-100)
5. Health impact analysis

For each ingredient, determine:
- Risk Level: "Low", "Medium", or "High"
- Also known as (common name)
- Why this risk level was assigned
- Description of the ingredient

Return a JSON object with this EXACT structure:
{
  "productName": "Product name from label",
  "category": "Food/Cosmetic/Supplement/etc",
  "overallScore": 75,
  "safetyScore": 70,
  "efficacyScore": 80,
  "transparencyScore": 85,
  "summary": "Brief 2-3 sentence summary of the product safety",
  "ingredients": [
    {
      "name": "Ingredient name",
      "riskLevel": "Low|Medium|High",
      "alsoKnownAs": "Common name or null",
      "whyThisRisk": "Explanation of risk level",
      "description": "What this ingredient does"
    }
  ],
  "healthImpact": "Detailed health impact analysis",
  "shortTermEffects": "Potential short-term effects",
  "longTermEffects": "Potential long-term effects",
  "hiddenChemicals": "Any concerning hidden ingredients or null",
  "howToUse": "Recommended usage instructions",
  "goodAndBad": "Summary of pros and cons",
  "whatItDoes": "What the product is designed to do",
  "whatPeopleSay": "General consumer feedback/reputation"
}

Scoring Guidelines:
- 76-100: Excellent (green) - Safe, natural ingredients
- 51-75: Good (yellow) - Generally safe with minor concerns  
- 26-50: Not Great (orange) - Significant concerns, use with caution
- 0-25: Bad (red) - Major health concerns, avoid if possible

Be thorough but concise. Focus on scientifically-backed information.`;

/**
 * POST /api/analyze
 * Analyze product images
 * 
 * Body (multipart/form-data):
 * - frontImage: Front product image
 * - backImage: Back product image (ingredients list)
 * - productType: 'food' or 'cosmetic' (optional)
 * 
 * OR Body (JSON):
 * - frontImageBase64: Base64 encoded front image
 * - backImageBase64: Base64 encoded back image
 * - productType: 'food' or 'cosmetic' (optional)
 */
router.post('/', upload.fields([
    { name: 'frontImage', maxCount: 1 },
    { name: 'backImage', maxCount: 1 },
]), async (req, res) => {
    try {
        let frontImageBase64, backImageBase64;
        const productType = req.body.productType || 'food';

        // Handle file uploads
        if (req.files && req.files.frontImage && req.files.backImage) {
            frontImageBase64 = req.files.frontImage[0].buffer.toString('base64');
            backImageBase64 = req.files.backImage[0].buffer.toString('base64');
        }
        // Handle base64 input
        else if (req.body.frontImageBase64 && req.body.backImageBase64) {
            frontImageBase64 = req.body.frontImageBase64;
            backImageBase64 = req.body.backImageBase64;
        } else {
            return res.status(400).json({
                success: false,
                error: 'Both front and back product images are required',
            });
        }

        // Check for API key
        if (!process.env.OPENAI_API_KEY) {
            return res.status(500).json({
                success: false,
                error: 'OpenAI API key not configured',
            });
        }

        console.log(`Analyzing ${productType} product...`);

        // Call OpenAI GPT-4 Vision
        const response = await openai.chat.completions.create({
            model: 'gpt-4o',
            messages: [
                {
                    role: 'user',
                    content: [
                        {
                            type: 'text',
                            text: `${ANALYSIS_PROMPT}\n\nProduct Type: ${productType}`,
                        },
                        {
                            type: 'image_url',
                            image_url: {
                                url: `data:image/jpeg;base64,${frontImageBase64}`,
                                detail: 'high',
                            },
                        },
                        {
                            type: 'image_url',
                            image_url: {
                                url: `data:image/jpeg;base64,${backImageBase64}`,
                                detail: 'high',
                            },
                        },
                    ],
                },
            ],
            max_tokens: 4096,
            temperature: 0.3,
        });

        // Parse the response
        const content = response.choices[0].message.content;
        console.log('Raw AI response:', content.substring(0, 200) + '...');

        // Extract JSON from response (handle potential markdown wrapping)
        let analysisData;
        try {
            // Try direct parse first
            analysisData = JSON.parse(content);
        } catch (e) {
            // Try to extract JSON from markdown code block
            const jsonMatch = content.match(/```(?:json)?\s*([\s\S]*?)\s*```/);
            if (jsonMatch) {
                analysisData = JSON.parse(jsonMatch[1]);
            } else {
                // Try to find JSON object in the response
                const jsonStart = content.indexOf('{');
                const jsonEnd = content.lastIndexOf('}');
                if (jsonStart !== -1 && jsonEnd !== -1) {
                    analysisData = JSON.parse(content.substring(jsonStart, jsonEnd + 1));
                } else {
                    throw new Error('Could not parse AI response as JSON');
                }
            }
        }

        // Generate unique analysis ID
        const analysisId = `analysis_${Date.now()}_${Math.random().toString(36).substr(2, 9)}`;

        res.json({
            success: true,
            analysisId,
            timestamp: new Date().toISOString(),
            productType,
            data: analysisData,
        });

    } catch (error) {
        console.error('Analysis error:', error);

        // Handle specific OpenAI errors
        if (error.code === 'insufficient_quota') {
            return res.status(429).json({
                success: false,
                error: 'API quota exceeded. Please try again later.',
            });
        }

        if (error.code === 'invalid_api_key') {
            return res.status(401).json({
                success: false,
                error: 'Invalid API key configuration.',
            });
        }

        res.status(500).json({
            success: false,
            error: error.message || 'Failed to analyze product',
        });
    }
});

/**
 * GET /api/analyze/test
 * Test endpoint to verify the route is working
 */
router.get('/test', (req, res) => {
    res.json({
        success: true,
        message: 'Analyze endpoint is working',
        hasApiKey: !!process.env.OPENAI_API_KEY,
    });
});

module.exports = router;
