import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../config/app_colors.dart';

/// Home Screen - Based on 7.png, 8.png
/// Shows "RevealIt" logo, 3 feature cards, and bottom navigation
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),

                // Header - RevealIt Logo
                Center(
                  child: RichText(
                    text: TextSpan(
                      style: const TextStyle(
                        fontFamily: 'Outfit',
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                      children: [
                        TextSpan(
                          text: 'Reveal',
                          style: TextStyle(color: AppColors.textBlack),
                        ),
                        TextSpan(
                          text: 'It',
                          style: TextStyle(color: AppColors.primaryGreen),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Center(
                  child: Text(
                    'Your health companion',
                    style: TextStyle(
                      fontFamily: 'Outfit',
                      fontSize: 14,
                      color: AppColors.textGray,
                    ),
                  ),
                ),
                const SizedBox(height: 40),

                // Feature Cards
                _buildFeatureCard(
                  context,
                  icon: Icons.camera_alt,
                  title: 'Product Scanner',
                  description:
                      'Scan any food or cosmetic product to analyze its ingredients',
                  color: AppColors.primaryGreen,
                  onTap: () => context.push('/camera'),
                ),
                const SizedBox(height: 16),
                _buildFeatureCard(
                  context,
                  icon: Icons.history,
                  title: 'Track History',
                  description:
                      'View all your previously scanned products and their analysis',
                  color: Colors.blue,
                  onTap: () => context.go('/history'),
                ),
                const SizedBox(height: 16),
                _buildFeatureCard(
                  context,
                  icon: Icons.auto_awesome,
                  title: 'AI Expert',
                  description:
                      'Ask our AI about any ingredient or health-related question',
                  color: Colors.purple,
                  onTap: () => context.go('/chat'),
                ),
                const SizedBox(height: 40),

                // Quick Stats Section
                Text(
                  'Your Stats',
                  style: TextStyle(
                    fontFamily: 'Outfit',
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textBlack,
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: _buildStatCard(
                        icon: Icons.qr_code_scanner,
                        value: '0',
                        label: 'Products Scanned',
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildStatCard(
                        icon: Icons.shield_outlined,
                        value: '0',
                        label: 'Safe Products',
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFeatureCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String description,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.06),
              blurRadius: 16,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            // Icon Container
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(
                icon,
                size: 28,
                color: color,
              ),
            ),
            const SizedBox(width: 16),
            // Text Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontFamily: 'Outfit',
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textBlack,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: TextStyle(
                      fontFamily: 'Outfit',
                      fontSize: 13,
                      color: AppColors.textGray,
                    ),
                  ),
                ],
              ),
            ),
            // Arrow
            Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: AppColors.textLightGray,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard({
    required IconData icon,
    required String value,
    required String label,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.lightGray,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Icon(
            icon,
            size: 28,
            color: AppColors.primaryGreen,
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontFamily: 'Outfit',
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: AppColors.textBlack,
            ),
          ),
          Text(
            label,
            style: TextStyle(
              fontFamily: 'Outfit',
              fontSize: 12,
              color: AppColors.textGray,
            ),
          ),
        ],
      ),
    );
  }
}
