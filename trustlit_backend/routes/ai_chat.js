const express = require('express');
const router = express.Router();
const OpenAI = require('openai');

// Initialize OpenAI client
const openai = new OpenAI({
    apiKey: process.env.OPENAI_API_KEY,
});

/**
 * POST /api/ai-chat
 * AI Assistant chat endpoint for food/ingredient queries
 */
router.post('/', async (req, res) => {
    try {
        const { message } = req.body;

        if (!message || typeof message !== 'string') {
            return res.status(400).json({
                success: false,
                error: 'Message is required',
            });
        }

        // System prompt for food/ingredient AI assistant
        const systemPrompt = `You are TrustIt's AI assistant, specialized in food safety, ingredients, and product analysis. 
    
Your expertise includes:
- Explaining food ingredients and their purposes
- Identifying potentially harmful additives and preservatives
- Providing nutritional information
- Explaining food labels and claims
- Recommending healthier alternatives
- Discussing allergens and dietary restrictions

CRITICAL FORMATTING RULES:
- NEVER use asterisks (*) or markdown formatting
- Write in plain text only
- To emphasize something, use capitalization or write it as a clear sentence
- Use numbered lists with "1." format, not bullet points
- Be concise but informative
- Use simple language that anyone can understand
- Always prioritize user safety
- If unsure, recommend consulting a professional
- Focus on evidence-based information`;

        const completion = await openai.chat.completions.create({
            model: 'gpt-4o-mini',
            messages: [
                { role: 'system', content: systemPrompt },
                { role: 'user', content: message }
            ],
            max_tokens: 500,
            temperature: 0.7,
        });

        // Get response and strip any remaining markdown formatting
        let response = completion.choices[0]?.message?.content || 'I apologize, I could not generate a response.';

        // Remove markdown bold/italic formatting (asterisks)
        response = response.replace(/\*\*([^*]+)\*\*/g, '$1'); // Remove **bold**
        response = response.replace(/\*([^*]+)\*/g, '$1'); // Remove *italic*
        response = response.replace(/__([^_]+)__/g, '$1'); // Remove __bold__
        response = response.replace(/_([^_]+)_/g, '$1'); // Remove _italic_

        res.json({
            success: true,
            response: response,
        });

    } catch (error) {
        console.error('AI Chat Error:', error);

        // Handle specific OpenAI errors
        if (error.code === 'insufficient_quota') {
            return res.status(429).json({
                success: false,
                error: 'Service temporarily unavailable. Please try again later.',
            });
        }

        res.status(500).json({
            success: false,
            error: 'Failed to process your request. Please try again.',
        });
    }
});

module.exports = router;
