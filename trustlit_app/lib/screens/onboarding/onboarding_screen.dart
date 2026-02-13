import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Onboarding Screen - 2 Swipeable Slides with TrustIt Header
/// Shows product analysis examples with sliding animation
class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  // Slide images - user-provided onboarding examples
  final List<String> _slideImages = [
    'assets/images/onboarding_slide_1.png',  // Bolthouse Farms carrots - Score 100
    'assets/images/onboarding_slide_2.png',  // Mr. Noodles - Score 7
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // TrustIt Header at top
            Padding(
              padding: const EdgeInsets.only(top: 0, bottom: 0),
              child: RichText(
                text: const TextSpan(
                  style: TextStyle(
                    fontFamily: 'Roboto',
                    fontSize: 24, // Reduced from 28
                    fontWeight: FontWeight.w700,
                  ),
                  children: [
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
            ),

            // Sliding Content Area - image fits entirely within available space
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: (index) {
                  setState(() {
                    _currentPage = index;
                  });
                },
                itemCount: _slideImages.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 0),
                    child: Image.asset(
                      _slideImages[index],
                      fit: BoxFit.contain,
                      alignment: Alignment.center,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          decoration: BoxDecoration(
                            color: const Color(0xFFF3F4F6),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.image_outlined,
                                size: 80,
                                color: Colors.grey[400],
                              ),
                              const SizedBox(height: 16),
                              Text(
                                'Slide ${index + 1}',
                                style: TextStyle(
                                  fontFamily: 'Outfit',
                                  fontSize: 18,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
            ),

            // Page indicators
            Padding(
              padding: const EdgeInsets.only(top: 0, bottom: 4),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  _slideImages.length,
                  (index) => AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    width: _currentPage == index ? 24 : 8,
                    height: 8,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4),
                      color: _currentPage == index
                          ? const Color(0xFF22C55E)
                          : const Color(0xFFD1D5DB),
                    ),
                  ),
                ),
              ),
            ),

            // Get Started button at bottom
            Padding(
              padding: const EdgeInsets.fromLTRB(48, 4, 48, 8),
              child: GestureDetector(
                onTap: () => context.go('/try-free'),
                child: Container(
                  width: double.infinity,
                  height: 48, // Reduced from 52
                  decoration: BoxDecoration(
                    color: const Color(0xFF22C55E),
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Get Started',
                        style: TextStyle(
                          fontFamily: 'Roboto',
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(width: 8),
                      Icon(Icons.arrow_forward, color: Colors.white, size: 18),
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
