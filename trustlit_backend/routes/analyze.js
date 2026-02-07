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

        // Validate base64 images
        const isValidBase64 = (str) => {
            try {
                // Check if it's a valid base64 string
                return str && str.length > 1000 && /^[A-Za-z0-9+/=]+$/.test(str.substring(0, 100));
            } catch (e) {
                return false;
            }
        };

        if (!isValidBase64(frontImageBase64) || !isValidBase64(backImageBase64)) {
            console.log('Invalid base64 format detected');
            console.log('Front starts with:', frontImageBase64?.substring(0, 50));
            console.log('Back starts with:', backImageBase64?.substring(0, 50));
            return res.status(400).json({
                success: false,
                error: 'Invalid image data format',
            });
        }

        console.log(`Analyzing ${productType} product...`);
        console.log(`Front image base64 length: ${frontImageBase64.length}`);
        console.log(`Back image base64 length: ${backImageBase64.length}`);

        // Call OpenAI GPT-4o Vision
        const response = await openai.chat.completions.create({
            model: 'gpt-4o',
            messages: [
                {
                    role: 'system',
                    content: 'You are a product safety analyst. You MUST analyze the images provided and return ONLY valid JSON. Do not include any explanation text, markdown formatting, or code blocks. Just the raw JSON object.'
                },
                {
                    role: 'user',
                    content: [
                        {
                            type: 'text',
                            text: `Analyze these ${productType} product images. The first image is the front of the product, and the second image shows the ingredients/nutrition label on the back.

CRITICAL SCORING RULES - YOU MUST FOLLOW THESE STRICTLY:

PROCESSED FOOD PENALTY (MANDATORY):
- Chips, crackers, cookies, candy, sodas, instant noodles, frozen pizzas, and similar processed snacks MUST have LOW scores
- If product contains seed oils (sunflower, canola, vegetable), sugar, artificial flavors, or preservatives = Safety score MUST be below 40
- Ultra-processed foods should NEVER score above 40 for safety
- Natural/organic whole foods can score 70-100

SAFETY SCORING (Health Impact):
- 70-100: Only for whole foods like fruits, vegetables, nuts, eggs, pure dairy with no additives
- 40-70: Minimally processed with some concerns (like bread with preservatives)  
- 20-40: Processed snacks, chips, sugary drinks, foods with seed oils and additives
- 0-20: Highly processed with multiple harmful chemicals

EFFICACY SCORING (Nutritional Value):
- Does it provide genuine nutrition or just empty calories?
- Chips and candy = 30-50 (low nutritional value)
- Whole foods with vitamins/minerals = 70-100

TRANSPARENCY SCORING (Brand Honesty):
- Does the brand clearly disclose all ingredients?
- Are there hidden "natural flavors" or unclear additives?

Return a JSON object with this EXACT structure (no markdown, no code blocks, just JSON):
{
  "productName": "Name visible on product",
  "category": "Food/Cosmetic/Supplement/etc",
  "overallScore": 30,
  "safetyScore": 25,
  "efficacyScore": 40,
  "transparencyScore": 50,
  "summary": "2-3 sentence product safety summary - BE HONEST about processed food concerns",
  "ingredients": [
    {
      "name": "Ingredient name",
      "riskLevel": "Low|Medium|High",
      "alsoKnownAs": "Common name or null",
      "whyThisRisk": "Risk explanation",
      "description": "What this ingredient does"
    }
  ],
  "healthImpact": "Health impact analysis - be critical of processed foods",
  "shortTermEffects": "Short-term effects",
  "longTermEffects": "Long-term effects",
  "hiddenChemicals": "Hidden ingredients or null",
  "howToUse": "Usage instructions",
  "goodAndBad": "Pros and cons",
  "whatItDoes": "Product purpose",
  "whatPeopleSay": "General reputation"
}

REMEMBER: Chips like SunChips, Lay's, Doritos should get Safety 25-35, NOT 70+!`,
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
            temperature: 0.2,
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
