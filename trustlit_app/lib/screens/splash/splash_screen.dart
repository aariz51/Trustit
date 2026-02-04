import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import '../../config/app_colors.dart';

/// Splash Screen - Based on 1.png
/// White background, TrustLit logo, app name with "It" in green, tagline
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    // Set status bar to transparent
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
      ),
    );

    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
      ),
    );

    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
      ),
    );

    _controller.forward();

    // Navigate to paywall after 2.5 seconds
    // Capture router before async gap to satisfy lint rules
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future.delayed(const Duration(milliseconds: 2500), () {
        if (mounted) {
          GoRouter.of(context).go('/paywall');
        }
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: Center(
          child: AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              return Opacity(
                opacity: _fadeAnimation.value,
                child: Transform.scale(
                  scale: _scaleAnimation.value,
                  child: child,
                ),
              );
            },
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Logo - Magnifying glass with vegetables
                Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    color: AppColors.primaryGreen.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      // Magnifying glass icon
                      Icon(
                        Icons.search,
                        size: 60,
                        color: AppColors.primaryGreen,
                      ),
                      // Small vegetable icons around
                      Positioned(
                        top: 20,
                        right: 25,
                        child: Icon(
                          Icons.eco,
                          size: 20,
                          color: AppColors.primaryGreen.withValues(alpha: 0.8),
                        ),
                      ),
                      Positioned(
                        bottom: 20,
                        left: 25,
                        child: Icon(
                          Icons.restaurant,
                          size: 18,
                          color: AppColors.primaryGreen.withValues(alpha: 0.8),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),

                // App Name - "TrustIt" with "It" in green
                RichText(
                  text: TextSpan(
                    style: const TextStyle(
                      fontFamily: 'Outfit',
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                    ),
                    children: [
                      TextSpan(
                        text: 'Trust',
                        style: TextStyle(color: AppColors.textBlack),
                      ),
                      TextSpan(
                        text: 'It',
                        style: TextStyle(color: AppColors.primaryGreen),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),

                // Tagline
                Text(
                  '90% reduction in health problems',
                  style: TextStyle(
                    fontFamily: 'Outfit',
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: AppColors.textGray,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
