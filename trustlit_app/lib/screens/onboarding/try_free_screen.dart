import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Try Free Screen - Shows "You can try TrustIt absolutely free"
/// Displays phone mockup with app preview
class TryFreeScreen extends StatelessWidget {
  const TryFreeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 0),
            
            // Title Text - Smaller font to save space
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 0),
              child: Column(
                children: [
                  RichText(
                    textAlign: TextAlign.center,
                    text: const TextSpan(
                      style: TextStyle(
                        fontFamily: 'Roboto',
                        fontSize: 26, // Reduced from 32
                        fontWeight: FontWeight.w700,
                        height: 1.1,
                      ),
                      children: [
                        TextSpan(
                          text: 'You can try ',
                          style: TextStyle(color: Color(0xFF1A1A1A)),
                        ),
                        TextSpan(
                          text: 'Trust',
                          style: TextStyle(color: Color(0xFF1A1A1A)),
                        ),
                        TextSpan(
                          text: 'It',
                          style: TextStyle(color: Color(0xFF22C55E)),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 2),
                  const Text(
                    'absolutely free',
                    style: TextStyle(
                      fontFamily: 'Roboto',
                      fontSize: 26, // Reduced from 32
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF22C55E),
                      height: 1.1,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            
            // Phone Mockup Image
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 0),
                child: Image.asset(
                  'assets/images/phone_mockup_preview.png',
                  fit: BoxFit.contain,
                  alignment: Alignment.center,
                  errorBuilder: (context, error, stackTrace) {
                    return Image.asset(
                      'assets/images/onboarding_slide_2.png',
                      fit: BoxFit.contain,
                      alignment: Alignment.center,
                    );
                  },
                ),
              ),
            ),
            
            // Bottom Section
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 12),
              child: Column(
                children: [
                  // No Payment Due Now
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.check, color: Colors.grey.shade700, size: 18),
                      const SizedBox(width: 6),
                      Text(
                        'No Payment Due Now',
                        style: TextStyle(
                          fontFamily: 'Roboto',
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                          color: Colors.grey.shade700,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  
                  // Try for $0.00 Button
                  SizedBox(
                    width: double.infinity,
                    height: 50, // Reduced from 56
                    child: ElevatedButton(
                      onPressed: () => context.go('/reminder'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF22C55E),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(28),
                        ),
                        elevation: 0,
                      ),
                      child: const Text(
                        'Try for \$0.00',
                        style: TextStyle(
                          fontFamily: 'Roboto',
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
