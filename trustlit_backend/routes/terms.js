const express = require('express');
const router = express.Router();

router.get('/', (req, res) => {
    res.send(`<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Terms of Use - Trust It</title>
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
    <h1>Terms of Use</h1>
    <p class="date">Last updated: February 18, 2026</p>

    <p>Please read these Terms of Use ("Terms") carefully before using the <span class="app-name">Trust It</span> mobile application ("App"). By downloading, installing, or using the App, you agree to be bound by these Terms.</p>

    <h2>1. Description of Service</h2>
    <p>Trust It is a consumer product analysis application that uses artificial intelligence to scan product labels and analyze ingredients for safety information. The App provides ingredient analysis, safety scores, and general health information based on AI-powered image recognition.</p>

    <h2>2. Not Medical Advice</h2>
    <p><strong>Important:</strong> The information provided by Trust It is for general informational purposes only and is NOT intended as medical advice, diagnosis, or treatment. Always consult with a qualified healthcare professional before making decisions about your health, diet, or product usage. The AI analysis may contain errors or inaccuracies.</p>

    <h2>3. Subscriptions and Payments</h2>
    <p>Trust It offers the following purchase options:</p>
    <ul>
        <li><strong>Yearly Subscription:</strong> $39.99 per year with a 3-day free trial. The subscription automatically renews at the end of each billing period unless cancelled at least 24 hours before the end of the current period.</li>
        <li><strong>Lifetime Access:</strong> $119.00 one-time purchase for unlimited access.</li>
    </ul>
    <p><strong>Free Trial:</strong> The 3-day free trial is available for new subscribers only. If you do not cancel before the trial ends, you will be automatically charged the annual subscription fee.</p>
    <p><strong>Cancellation:</strong> You can cancel your subscription at any time through your Apple ID account settings. Cancellation takes effect at the end of the current billing period. No refunds are provided for partial subscription periods.</p>
    <p><strong>Payment:</strong> All payments are processed by Apple through the App Store. Apple's terms and conditions apply to all transactions.</p>

    <h2>4. Acceptable Use</h2>
    <p>You agree to use the App only for its intended purpose of analyzing consumer products. You agree not to:</p>
    <ul>
        <li>Use the App for any unlawful purpose</li>
        <li>Attempt to reverse engineer or modify the App</li>
        <li>Upload content that is harmful, offensive, or violates any third-party rights</li>
        <li>Use the App in any manner that could damage or impair its functionality</li>
    </ul>

    <h2>5. Intellectual Property</h2>
    <p>The App, including its design, features, and content, is owned by Trust It and is protected by intellectual property laws. You may not copy, modify, distribute, or create derivative works without our prior written consent.</p>

    <h2>6. Disclaimer of Warranties</h2>
    <p>The App is provided "as is" without warranties of any kind, either express or implied. We do not guarantee the accuracy, completeness, or reliability of any analysis or information provided by the App. AI-generated analysis may contain errors.</p>

    <h2>7. Limitation of Liability</h2>
    <p>To the maximum extent permitted by law, Trust It shall not be liable for any indirect, incidental, special, or consequential damages arising out of your use of the App, including but not limited to health-related decisions made based on the App's analysis.</p>

    <h2>8. Privacy</h2>
    <p>Your use of the App is also governed by our <a href="https://trustlt.onrender.com/privacy-policy">Privacy Policy</a>, which is incorporated into these Terms by reference.</p>

    <h2>9. Changes to Terms</h2>
    <p>We reserve the right to modify these Terms at any time. Changes will be posted on this page. Your continued use of the App after changes constitutes acceptance of the updated Terms.</p>

    <h2>10. Governing Law</h2>
    <p>These Terms are governed by and construed in accordance with the laws of the United States, without regard to conflict of law principles.</p>

    <h2>11. Contact</h2>
    <p>If you have questions about these Terms, contact us at: <strong>trustit.app.support@gmail.com</strong></p>

    <h2>12. Apple's Standard EULA</h2>
    <p>In addition to these Terms, your use of the App is subject to Apple's Standard End User License Agreement (EULA), available at: <a href="https://www.apple.com/legal/internet-services/itunes/dev/stdeula/">https://www.apple.com/legal/internet-services/itunes/dev/stdeula/</a></p>
</body>
</html>`);
});

module.exports = router;
