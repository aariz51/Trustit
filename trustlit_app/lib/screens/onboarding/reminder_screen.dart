import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Reminder Screen - Shows trial reminder message before paywall
/// "We'll send you a reminder before the trial ends"
class ReminderScreen extends StatelessWidget {
  const ReminderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Back Button
            Padding(
              padding: const EdgeInsets.only(left: 8, top: 8),
              child: Align(
                alignment: Alignment.centerLeft,
                child: IconButton(
                  onPressed: () => context.pop(),
                  icon: const Icon(Icons.chevron_left, size: 32),
                ),
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Title Text
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 32),
              child: Text(
                "We'll send you a reminder\nbefore the\ntrial ends",
                style: TextStyle(
                  fontFamily: 'Roboto',
                  fontSize: 28,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF1A1A1A),
                  height: 1.3,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            
            // Bell Icon Section
            Expanded(
              child: Center(
                child: Image.asset(
                  'assets/images/cf55c15a-268b-4dae-b98c-fc293930dd13.png',
                  width: 200,
                  height: 200,
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) {
                    // Fallback to icon if image not found
                    return Stack(
                      alignment: Alignment.center,
                      children: [
                        Icon(
                          Icons.notifications_outlined,
                          size: 180,
                          color: const Color(0xFF22C55E).withValues(alpha: 0.15),
                        ),
                        Positioned(
                          top: 10,
                          right: 30,
                          child: Container(
                            width: 48,
                            height: 48,
                            decoration: const BoxDecoration(
                              color: Color(0xFF22C55E),
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
            
            // Bottom Section
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
              child: Column(
                children: [
                  // No Payment Due Now
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.check, color: Colors.grey.shade700, size: 20),
                      const SizedBox(width: 8),
                      Text(
                        'No Payment Due Now',
                        style: TextStyle(
                          fontFamily: 'Roboto',
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Colors.grey.shade700,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  
                  // Continue for FREE Button
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      onPressed: () => context.go('/paywall'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF22C55E),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(28),
                        ),
                        elevation: 0,
                      ),
                      child: const Text(
                        'Continue for FREE',
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
