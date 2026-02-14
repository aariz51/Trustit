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

        // Retry up to 3 times with different prompts
        let analysisData = null;
        let lastError = null;

        // Define different prompts for each attempt
        const systemPrompts = [
            // Attempt 1: Full detailed prompt
            'You are TrustIt, a consumer product ingredient and safety analysis assistant built for a mobile app. Users take photos of food, beverage, cosmetic, supplement, and household product packaging. Your job is to read the product label and ingredients list from the photos, then analyze each ingredient for safety. You MUST always analyze whatever product is shown — food, drink, skincare, shampoo, cleaning product, supplement, snack, candy, or anything else. You MUST respond with ONLY valid JSON. No markdown, no explanation text, no code blocks — just the raw JSON object. Never refuse to analyze a product.',
            // Attempt 2: Simpler, more direct
            'You are a product label reader. Read the product name and ingredients from these images and return a JSON analysis. Always respond with valid JSON only. Never refuse.',
            // Attempt 3: Minimal
            'Read the label in these product photos. Return JSON with productName, category, overallScore (0-100), safetyScore, efficacyScore, transparencyScore, summary, and ingredients array. JSON only, no other text.',
        ];

        const userPrompts = [
            // Attempt 1: Full scoring rules
            `Analyze these consumer product images. The first image is the front of the product, and the second image shows the ingredients list on the back.

Identify what type of product this is (food, cosmetic, supplement, household, beverage, etc.) and analyze ALL ingredients shown on the label.

SCORING RULES:

FOR FOOD & BEVERAGE PRODUCTS:
Safety (Health Impact):
- 70-100: Only for whole foods like fruits, vegetables, nuts, eggs, pure dairy with no additives
- 40-70: Minimally processed with some concerns (like bread with preservatives)
- 20-40: Processed snacks, chips, sugary drinks, foods with seed oils and additives
- 0-20: Highly processed with multiple harmful chemicals
- MANDATORY: Chips, crackers, cookies, candy, sodas = Safety MUST be below 40
- If product contains seed oils (sunflower, canola, vegetable), sugar, artificial flavors = Safety below 40

Efficacy (Nutritional Value):
- Chips and candy = 30-50 (empty calories)
- Whole foods = 70-100

FOR COSMETIC & SKINCARE PRODUCTS:
Safety: Rate based on ingredient toxicity, irritation potential, known carcinogens
- Products with parabens, phthalates, formaldehyde = Safety below 40
- Clean/natural products = 70-100
Efficacy: Does it deliver on its claims?

FOR ALL PRODUCTS:
Transparency: Are all ingredients clearly disclosed? Vague terms like "fragrance" or "natural flavors" = lower score.

Return a JSON object with this EXACT structure (no markdown, no code blocks, just raw JSON):
{
  "productName": "Name visible on product",
  "category": "Food/Cosmetic/Supplement/Beverage/Household/etc",
  "overallScore": 30,
  "safetyScore": 25,
  "efficacyScore": 40,
  "transparencyScore": 50,
  "summary": "2-3 sentence product safety summary",
  "ingredients": [
    {
      "name": "Ingredient name",
      "riskLevel": "Low|Medium|High",
      "alsoKnownAs": "Common name or null",
      "whyThisRisk": "Risk explanation",
      "description": "What this ingredient does"
    }
  ],
  "healthImpact": "Health/safety impact analysis",
  "shortTermEffects": "Short-term effects",
  "longTermEffects": "Long-term effects",
  "hiddenChemicals": "Hidden ingredients or null",
  "howToUse": "Usage instructions",
  "goodAndBad": "Pros and cons",
  "whatItDoes": "Product purpose",
  "whatPeopleSay": "General reputation"
}

REMEMBER: Chips like SunChips, Lay's, Doritos should get Safety 25-35, NOT 70+!
You MUST analyze this product regardless of what type it is.`,

            // Attempt 2: Simplified prompt
            `These are photos of a consumer product (front and back). Please read the product name from the front image and list all ingredients from the back image.

Return ONLY this JSON (no other text):
{
  "productName": "product name from label",
  "category": "Food/Cosmetic/Supplement/Beverage/Household",
  "overallScore": 50,
  "safetyScore": 50,
  "efficacyScore": 50,
  "transparencyScore": 50,
  "summary": "Brief product summary",
  "ingredients": [{"name": "ingredient", "riskLevel": "Low", "alsoKnownAs": null, "whyThisRisk": "explanation", "description": "what it does"}],
  "healthImpact": "impact description",
  "shortTermEffects": "effects",
  "longTermEffects": "effects",
  "hiddenChemicals": null,
  "howToUse": "instructions",
  "goodAndBad": "pros and cons",
  "whatItDoes": "purpose",
  "whatPeopleSay": "reputation"
}

Score processed foods/junk food below 40 for safety. Score natural/whole foods 70+.`,

            // Attempt 3: Most minimal
            `Look at these two product photos. Tell me the product name and list the ingredients. Return as JSON with keys: productName, category, overallScore (number 0-100), safetyScore, efficacyScore, transparencyScore, summary, ingredients (array of objects with name, riskLevel, alsoKnownAs, whyThisRisk, description), healthImpact, shortTermEffects, longTermEffects, hiddenChemicals, howToUse, goodAndBad, whatItDoes, whatPeopleSay. JSON only.`,
        ];

        for (let attempt = 1; attempt <= 3; attempt++) {
            try {
                console.log(`Analysis attempt ${attempt}...`);
                const promptIndex = attempt - 1;

                // Call OpenAI GPT-4o Vision
                const response = await openai.chat.completions.create({
                    model: 'gpt-4o',
                    messages: [
                        {
                            role: 'system',
                            content: systemPrompts[promptIndex]
                        },
                        {
                            role: 'user',
                            content: [
                                {
                                    type: 'text',
                                    text: userPrompts[promptIndex],
                                },
                                {
                                    type: 'image_url',
                                    image_url: {
                                        url: `data:image/jpeg;base64,${frontImageBase64}`,
                                        detail: attempt === 1 ? 'high' : 'low',
                                    },
                                },
                                {
                                    type: 'image_url',
                                    image_url: {
                                        url: `data:image/jpeg;base64,${backImageBase64}`,
                                        detail: attempt === 1 ? 'high' : 'low',
                                    },
                                },
                            ],
                        },
                    ],
                    max_tokens: 4096,
                    temperature: attempt === 1 ? 0.2 : 0.4,
                });

                // Parse the response
                const content = response.choices[0].message.content;
                console.log('Raw AI response:', content.substring(0, 300) + '...');

                // Check for refusal responses
                if (content.includes("I'm sorry") || content.includes("I can't assist") || content.includes("I cannot") || content.includes("I'm unable") || content.includes("I'm not able") || content.includes("I apologize")) {
                    console.log(`Attempt ${attempt}: AI refused to analyze. Response: ${content.substring(0, 200)}`);
                    lastError = new Error(`AI refused to analyze the product: ${content.substring(0, 100)}`);
                    if (attempt < 3) {
                        console.log(`Retrying with different prompt (attempt ${attempt + 1})...`);
                        await new Promise(resolve => setTimeout(resolve, 1000));
                        continue;
                    }
                    break;
                }

                // Extract JSON from response (handle potential markdown wrapping)
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

                // Success - break out of retry loop
                console.log(`Analysis successful on attempt ${attempt}: ${analysisData.productName}, score: ${analysisData.overallScore}`);
                break;

            } catch (innerError) {
                console.error(`Attempt ${attempt} failed:`, innerError.message);
                lastError = innerError;
                if (attempt < 3) {
                    console.log(`Retrying with different prompt (attempt ${attempt + 1})...`);
                    await new Promise(resolve => setTimeout(resolve, 1000));
                }
            }
        }

        // If all attempts failed
        if (!analysisData) {
            console.error('All 3 analysis attempts failed. Last error:', lastError?.message);
            return res.status(500).json({
                success: false,
                error: lastError?.message || 'Failed to analyze product after multiple attempts',
            });
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
