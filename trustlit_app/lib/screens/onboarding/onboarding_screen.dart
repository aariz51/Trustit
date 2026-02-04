import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Onboarding Screen - 2 Swipeable Slides
/// Solid white background to prevent any overlap from previous screens
class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<String> _slideImages = [
    'assets/images/onboarding_bg.png',   // 4.png - Philadelphia slide
    'assets/images/onboarding_2.png',    // 5.png - Mr. Noodles slide
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,  // Solid white background
      body: Container(
        color: Colors.white,  // Ensure no transparency
        child: Stack(
          children: [
            // Solid white background layer to block anything behind
            Container(
              width: double.infinity,
              height: double.infinity,
              color: Colors.white,
            ),

            // PageView for swipeable slides
            PageView.builder(
              controller: _pageController,
              onPageChanged: (index) {
                setState(() {
                  _currentPage = index;
                });
              },
              itemCount: _slideImages.length,
              itemBuilder: (context, index) {
                return Container(
                  color: Colors.white,  // Each slide has white background
                  child: Image.asset(
                    _slideImages[index],
                    width: double.infinity,
                    height: double.infinity,
                    fit: BoxFit.contain,  // Changed to contain to show properly
                  ),
                );
              },
            ),

            // Page indicators
            Positioned(
              left: 0,
              right: 0,
              bottom: 140,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  _slideImages.length,
                  (index) => AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    width: _currentPage == index ? 10 : 8,
                    height: _currentPage == index ? 10 : 8,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: _currentPage == index
                          ? const Color(0xFF22C55E)
                          : const Color(0xFFD1D5DB),
                    ),
                  ),
                ),
              ),
            ),

            // Get Started button at bottom
            Positioned(
              left: 48,
              right: 48,
              bottom: 60,
              child: GestureDetector(
                onTap: () => context.go('/paywall'),
                child: Container(
                  height: 56,
                  decoration: BoxDecoration(
                    color: const Color(0xFF22C55E),
                    borderRadius: BorderRadius.circular(28),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Get Started',
                        style: TextStyle(
                          fontFamily: 'Outfit',
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(width: 8),
                      Icon(Icons.arrow_forward, color: Colors.white, size: 20),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
