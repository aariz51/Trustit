const express = require('express');
const axios = require('axios');
const router = express.Router();

// Apple endpoints
const APPLE_SANDBOX_URL = 'https://sandbox.itunes.apple.com/verifyReceipt';
const APPLE_PRODUCTION_URL = 'https://buy.itunes.apple.com/verifyReceipt';

/**
 * Verify Apple App Store receipt
 * POST /api/verify-receipt
 * 
 * Body:
 * - receiptData: Base64 encoded receipt from StoreKit
 * - productId: Product ID being purchased
 * - platform: 'ios' (for future Android support)
 */
router.post('/', async (req, res) => {
    try {
        const { receiptData, productId, platform } = req.body;

        if (!receiptData) {
            return res.status(400).json({
                valid: false,
                error: 'Missing receipt data'
            });
        }

        if (platform !== 'ios') {
            return res.status(400).json({
                valid: false,
                error: 'Only iOS platform supported currently'
            });
        }

        // Get shared secret from environment
        const sharedSecret = process.env.APPLE_SHARED_SECRET;
        if (!sharedSecret) {
            console.error('APPLE_SHARED_SECRET not configured');
            return res.status(500).json({
                valid: false,
                error: 'Server configuration error'
            });
        }

        // Verify with Apple
        const result = await verifyReceiptWithApple(receiptData, sharedSecret);

        if (result.valid) {
            // Additional validation for the specific product
            const purchaseInfo = validatePurchase(result.latestReceipt, productId);

            return res.json({
                valid: purchaseInfo.valid,
                productId: productId,
                expiresDate: purchaseInfo.expiresDate,
                isTrialPeriod: purchaseInfo.isTrialPeriod,
                subscriptionStatus: purchaseInfo.status
            });
        }

        return res.json({
            valid: false,
            error: result.error
        });

    } catch (error) {
        console.error('Receipt verification error:', error);
        return res.status(500).json({
            valid: false,
            error: 'Internal server error'
        });
    }
});

/**
 * Verify receipt with Apple's servers
 * First tries production, falls back to sandbox if needed
 */
async function verifyReceiptWithApple(receiptData, sharedSecret) {
    const payload = {
        'receipt-data': receiptData,
        'password': sharedSecret,
        'exclude-old-transactions': true
    };

    try {
        // Try production first
        let response = await axios.post(APPLE_PRODUCTION_URL, payload);

        // Status 21007 means receipt is from sandbox - retry with sandbox URL
        if (response.data.status === 21007) {
            console.log('Receipt is from sandbox, retrying with sandbox URL');
            response = await axios.post(APPLE_SANDBOX_URL, payload);
        }

        const data = response.data;

        // Check Apple's response status
        // https://developer.apple.com/documentation/appstorereceipts/status
        switch (data.status) {
            case 0:
                // Valid receipt
                return {
                    valid: true,
                    latestReceipt: data.latest_receipt_info || data.receipt?.in_app || [],
                    environment: data.environment
                };

            case 21000:
                return { valid: false, error: 'App Store could not read receipt' };
            case 21002:
                return { valid: false, error: 'Receipt data was malformed' };
            case 21003:
                return { valid: false, error: 'Receipt could not be authenticated' };
            case 21004:
                return { valid: false, error: 'Shared secret mismatch' };
            case 21005:
                return { valid: false, error: 'Apple server unavailable' };
            case 21006:
                return { valid: false, error: 'Subscription has expired' };
            case 21008:
                return { valid: false, error: 'Receipt is from production but sent to sandbox' };
            default:
                return { valid: false, error: `Unknown status: ${data.status}` };
        }

    } catch (error) {
        console.error('Apple API error:', error.message);
        return { valid: false, error: 'Failed to verify with Apple' };
    }
}

/**
 * Validate specific purchase from receipt info
 */
function validatePurchase(latestReceiptInfo, productId) {
    if (!Array.isArray(latestReceiptInfo) || latestReceiptInfo.length === 0) {
        return { valid: false, status: 'no_purchases' };
    }

    // Find the most recent transaction for this product
    const productReceipts = latestReceiptInfo
        .filter(receipt => receipt.product_id === productId)
        .sort((a, b) => {
            const dateA = parseInt(a.purchase_date_ms || 0);
            const dateB = parseInt(b.purchase_date_ms || 0);
            return dateB - dateA;
        });

    if (productReceipts.length === 0) {
        return { valid: false, status: 'product_not_found' };
    }

    const latestReceipt = productReceipts[0];
    const now = Date.now();

    // For non-consumable (lifetime), just check if it exists
    if (productId === 'com.trustlit.lifetime') {
        return {
            valid: true,
            status: 'active',
            expiresDate: null,
            isTrialPeriod: false
        };
    }

    // For subscriptions, check expiry
    const expiresDateMs = parseInt(latestReceipt.expires_date_ms);
    const isExpired = now > expiresDateMs;
    const isTrialPeriod = latestReceipt.is_trial_period === 'true';
    const isInIntroOfferPeriod = latestReceipt.is_in_intro_offer_period === 'true';

    return {
        valid: !isExpired,
        status: isExpired ? 'expired' : 'active',
        expiresDate: new Date(expiresDateMs).toISOString(),
        isTrialPeriod: isTrialPeriod || isInIntroOfferPeriod,
        purchaseDate: latestReceipt.purchase_date
    };
}

module.exports = router;
