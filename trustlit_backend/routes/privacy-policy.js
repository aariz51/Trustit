const express = require('express');
const router = express.Router();

router.get('/', (req, res) => {
    res.send(`<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Privacy Policy - Trust It</title>
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body { font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif; line-height: 1.6; color: #333; max-width: 800px; margin: 0 auto; padding: 20px; background: #fff; }
        h1 { font-size: 28px; margin-bottom: 8px; color: #111; }
        h2 { font-size: 20px; margin-top: 28px; margin-bottom: 12px; color: #222; }
        p, li { font-size: 15px; margin-bottom: 10px; color: #444; }
        ul { padding-left: 20px; }
        .date { font-size: 13px; color: #888; margin-bottom: 24px; }
        .app-name { color: #22C55E; font-weight: 600; }
    </style>
</head>
<body>
    <h1>Privacy Policy</h1>
    <p class="date">Last updated: February 18, 2026</p>

    <p>This Privacy Policy describes how <span class="app-name">Trust It</span> ("we", "our", or "us") collects, uses, and protects information when you use our mobile application.</p>

    <h2>1. Information We Collect</h2>
    <p><strong>Product Images:</strong> When you scan a product, the front and back images of the product are temporarily sent to our servers for AI-powered ingredient analysis. These images are processed in real-time and are <strong>not stored</strong> on our servers after analysis is complete.</p>
    <p><strong>AI Chat Conversations:</strong> When you use the AI Assistant feature, your messages are sent to our servers to generate responses. These conversations are not permanently stored.</p>
    <p><strong>Purchase Information:</strong> If you subscribe or make a purchase, Apple handles all payment processing. We receive a purchase receipt for verification purposes only. We do not have access to your payment details (credit card, billing address, etc.).</p>

    <h2>2. Information We Do NOT Collect</h2>
    <ul>
        <li>We do not collect personal information (name, email, phone number)</li>
        <li>We do not require account creation or login</li>
        <li>We do not collect location data</li>
        <li>We do not use analytics or tracking tools</li>
        <li>We do not collect device identifiers for advertising</li>
    </ul>

    <h2>3. Third-Party Services</h2>
    <p><strong>OpenAI:</strong> Product images and AI chat messages are processed using OpenAI's API for analysis. OpenAI's usage policies apply to this processing. OpenAI does not use data submitted via API for training purposes. For more information, see <a href="https://openai.com/policies/privacy-policy">OpenAI's Privacy Policy</a>.</p>
    <p><strong>Apple App Store:</strong> In-app purchases and subscriptions are handled entirely by Apple. Apple's terms and privacy policy govern these transactions.</p>

    <h2>4. Data Security</h2>
    <p>All data transmitted between the app and our servers is encrypted using HTTPS/TLS. Product images are processed in memory and are not written to disk or stored permanently.</p>

    <h2>5. Children's Privacy</h2>
    <p>Trust It is not directed at children under the age of 13. We do not knowingly collect information from children under 13.</p>

    <h2>6. Data Retention</h2>
    <p>Product images are processed in real-time and discarded immediately after analysis. Scan history is stored locally on your device only and can be cleared at any time from the app.</p>

    <h2>7. Your Rights</h2>
    <p>Since we do not collect or store personal data, there is no personal data to access, modify, or delete on our servers. Your local scan history can be cleared directly from the app.</p>

    <h2>8. Changes to This Policy</h2>
    <p>We may update this Privacy Policy from time to time. Any changes will be reflected on this page with an updated date.</p>

    <h2>9. Contact Us</h2>
    <p>If you have any questions about this Privacy Policy, please contact us at: <strong>trustit.app.support@gmail.com</strong></p>
</body>
</html>`);
});

module.exports = router;
