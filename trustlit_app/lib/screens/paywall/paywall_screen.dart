import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../config/app_colors.dart';
import '../../providers/subscription_provider.dart';

/// Paywall Screen - Based on 2.png, 3.png, 4.png, 5.png, 6.png
/// Vertically scrollable with value proposition, trial timeline, testimonials,
/// trust badges, and subscription options
class PaywallScreen extends StatefulWidget {
  const PaywallScreen({super.key});

  @override
  State<PaywallScreen> createState() => _PaywallScreenState();
}

class _PaywallScreenState extends State<PaywallScreen> {
  bool _isYearlySelected = true; // Yearly selected by default

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Header with Restore button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: _handleRestore,
                    child: Text(
                      'Restore',
                      style: TextStyle(
                        fontFamily: 'Outfit',
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: AppColors.primaryGreen,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Scrollable Content
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Logo Icon
                      _buildLogoSection(),
                      const SizedBox(height: 24),

                      // Value Proposition with Phone Mockups
                      _buildValueProposition(),
                      const SizedBox(height: 32),

                      // Trial Timeline
                      _buildTrialTimeline(),
                      const SizedBox(height: 32),

                      // Social Proof
                      _buildSocialProof(),
                      const SizedBox(height: 24),

                      // Testimonials
                      _buildTestimonials(),
                      const SizedBox(height: 32),

                      // Trust Badges
                      _buildTrustBadges(),
                      const SizedBox(height: 32),

                      // Subscription Options
                      _buildSubscriptionOptions(),
                      const SizedBox(height: 24),

                      // CTA Button
                      _buildCTAButton(),
                      const SizedBox(height: 16),

                      // Footer
                      _buildFooter(),
                      const SizedBox(height: 24),
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

  Widget _buildLogoSection() {
    return Column(
      children: [
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            color: AppColors.primaryGreen.withValues(alpha: 0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(
            Icons.search,
            size: 40,
            color: AppColors.primaryGreen,
          ),
        ),
        const SizedBox(height: 16),
        RichText(
          text: TextSpan(
            style: const TextStyle(
              fontFamily: 'Outfit',
              fontSize: 28,
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
      ],
    );
  }

  Widget _buildValueProposition() {
    return Column(
      children: [
        Text(
          'Unlock Premium Features',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontFamily: 'Outfit',
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: AppColors.textBlack,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Get unlimited scans, detailed ingredient analysis, and personalized health insights',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontFamily: 'Outfit',
            fontSize: 14,
            color: AppColors.textGray,
          ),
        ),
        const SizedBox(height: 24),
        // Phone mockups row
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildPhoneMockup('📸', 'Scan Products'),
            const SizedBox(width: 12),
            _buildPhoneMockup('🔍', 'Analyze'),
            const SizedBox(width: 12),
            _buildPhoneMockup('✅', 'Get Results'),
          ],
        ),
      ],
    );
  }

  Widget _buildPhoneMockup(String emoji, String label) {
    return Column(
      children: [
        Container(
          width: 80,
          height: 140,
          decoration: BoxDecoration(
            color: AppColors.lightGray,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.border),
          ),
          child: Center(
            child: Text(
              emoji,
              style: const TextStyle(fontSize: 32),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: TextStyle(
            fontFamily: 'Outfit',
            fontSize: 12,
            color: AppColors.textGray,
          ),
        ),
      ],
    );
  }

  Widget _buildTrialTimeline() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.lightGray,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Text(
            'How Your Free Trial Works',
            style: TextStyle(
              fontFamily: 'Outfit',
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppColors.textBlack,
            ),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildTimelineItem(
                icon: Icons.lock_open,
                title: 'Today',
                subtitle: 'Full Access',
                isActive: true,
              ),
              _buildTimelineConnector(),
              _buildTimelineItem(
                icon: Icons.notifications,
                title: 'In 2 Days',
                subtitle: 'Reminder',
                isActive: false,
              ),
              _buildTimelineConnector(),
              _buildTimelineItem(
                icon: Icons.payment,
                title: 'In 3 Days',
                subtitle: 'Billing Starts',
                isActive: false,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTimelineItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool isActive,
  }) {
    return Column(
      children: [
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: isActive
                ? AppColors.primaryGreen
                : AppColors.primaryGreen.withValues(alpha: 0.2),
            shape: BoxShape.circle,
          ),
          child: Icon(
            icon,
            size: 24,
            color: isActive ? AppColors.white : AppColors.primaryGreen,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          title,
          style: TextStyle(
            fontFamily: 'Outfit',
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: AppColors.textBlack,
          ),
        ),
        Text(
          subtitle,
          style: TextStyle(
            fontFamily: 'Outfit',
            fontSize: 10,
            color: AppColors.textGray,
          ),
        ),
      ],
    );
  }

  Widget _buildTimelineConnector() {
    return Container(
      width: 30,
      height: 2,
      color: AppColors.primaryGreen.withValues(alpha: 0.3),
    );
  }

  Widget _buildSocialProof() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Row(
          children: List.generate(
            5,
            (index) => Icon(
              Icons.star,
              size: 20,
              color: AppColors.primaryGreen,
            ),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          '4.9',
          style: TextStyle(
            fontFamily: 'Outfit',
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: AppColors.textBlack,
          ),
        ),
        const SizedBox(width: 8),
        Text(
          '(10K+ Reviews)',
          style: TextStyle(
            fontFamily: 'Outfit',
            fontSize: 12,
            color: AppColors.textGray,
          ),
        ),
      ],
    );
  }

  Widget _buildTestimonials() {
    return Column(
      children: [
        _buildTestimonialCard(
          name: 'Sarah M.',
          review:
              'This app changed how I shop! I discovered hidden ingredients in products I\'ve used for years.',
          rating: 5,
        ),
        const SizedBox(height: 12),
        _buildTestimonialCard(
          name: 'John D.',
          review:
              'Finally an app that explains ingredients in plain English. Worth every penny!',
          rating: 5,
        ),
      ],
    );
  }

  Widget _buildTestimonialCard({
    required String name,
    required String review,
    required int rating,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 18,
                backgroundColor: AppColors.primaryGreen.withValues(alpha: 0.2),
                child: Text(
                  name[0],
                  style: TextStyle(
                    fontFamily: 'Outfit',
                    fontWeight: FontWeight.bold,
                    color: AppColors.primaryGreen,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: TextStyle(
                      fontFamily: 'Outfit',
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textBlack,
                    ),
                  ),
                  Row(
                    children: List.generate(
                      rating,
                      (index) => Icon(
                        Icons.star,
                        size: 14,
                        color: AppColors.primaryGreen,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            '"$review"',
            style: TextStyle(
              fontFamily: 'Outfit',
              fontSize: 13,
              fontStyle: FontStyle.italic,
              color: AppColors.textDarkGray,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTrustBadges() {
    return Column(
      children: [
        Text(
          'Trusted By Experts',
          style: TextStyle(
            fontFamily: 'Outfit',
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: AppColors.textBlack,
          ),
        ),
        const SizedBox(height: 16),
        Wrap(
          spacing: 20,
          runSpacing: 12,
          alignment: WrapAlignment.center,
          children: [
            _buildBadge('Cambridge'),
            _buildBadge('NIH'),
            _buildBadge('Mayo Clinic'),
            _buildBadge('Harvard'),
            _buildBadge('WHO'),
            _buildBadge('FDA'),
          ],
        ),
      ],
    );
  }

  Widget _buildBadge(String name) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.lightGray,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        name,
        style: TextStyle(
          fontFamily: 'Outfit',
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: AppColors.textGray,
        ),
      ),
    );
  }

  Widget _buildSubscriptionOptions() {
    return Row(
      children: [
        // Lifetime Option
        Expanded(
          child: GestureDetector(
            onTap: () => setState(() => _isYearlySelected = false),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: !_isYearlySelected
                      ? AppColors.primaryGreen
                      : AppColors.border,
                  width: !_isYearlySelected ? 2 : 1,
                ),
              ),
              child: Column(
                children: [
                  Text(
                    'Lifetime',
                    style: TextStyle(
                      fontFamily: 'Outfit',
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textBlack,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '\$119.00',
                    style: TextStyle(
                      fontFamily: 'Outfit',
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textBlack,
                    ),
                  ),
                  Text(
                    'One-time',
                    style: TextStyle(
                      fontFamily: 'Outfit',
                      fontSize: 12,
                      color: AppColors.textGray,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        // Yearly Option
        Expanded(
          child: GestureDetector(
            onTap: () => setState(() => _isYearlySelected = true),
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: _isYearlySelected
                          ? AppColors.primaryGreen
                          : AppColors.border,
                      width: _isYearlySelected ? 2 : 1,
                    ),
                  ),
                  child: Column(
                    children: [
                      Text(
                        'Yearly',
                        style: TextStyle(
                          fontFamily: 'Outfit',
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textBlack,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '\$39.99',
                        style: TextStyle(
                          fontFamily: 'Outfit',
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textBlack,
                        ),
                      ),
                      Text(
                        '/year',
                        style: TextStyle(
                          fontFamily: 'Outfit',
                          fontSize: 12,
                          color: AppColors.textGray,
                        ),
                      ),
                    ],
                  ),
                ),
                // Free Trial Badge
                Positioned(
                  top: -10,
                  right: 10,
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.primaryGreen,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      '3-DAY FREE TRIAL',
                      style: TextStyle(
                        fontFamily: 'Outfit',
                        fontSize: 9,
                        fontWeight: FontWeight.bold,
                        color: AppColors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCTAButton() {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: _handlePurchase,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primaryGreen,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        child: Text(
          _isYearlySelected ? 'Try for \$0.00' : 'Get Lifetime Access',
          style: TextStyle(
            fontFamily: 'Outfit',
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: AppColors.white,
          ),
        ),
      ),
    );
  }

  Widget _buildFooter() {
    return Column(
      children: [
        Text(
          _isYearlySelected
              ? 'After 3-day free trial, \$39.99/year. Cancel anytime.'
              : 'One-time payment. Lifetime access.',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontFamily: 'Outfit',
            fontSize: 12,
            color: AppColors.textGray,
          ),
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextButton(
              onPressed: () => _launchURL('https://trustlit.app/terms'),
              child: Text(
                'Terms',
                style: TextStyle(
                  fontFamily: 'Outfit',
                  fontSize: 12,
                  color: AppColors.textGray,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
            Text(
              ' • ',
              style: TextStyle(color: AppColors.textGray),
            ),
            TextButton(
              onPressed: () => _launchURL('https://trustlit.app/privacy'),
              child: Text(
                'Privacy',
                style: TextStyle(
                  fontFamily: 'Outfit',
                  fontSize: 12,
                  color: AppColors.textGray,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  void _handleRestore() {
    final subscriptionProvider = context.read<SubscriptionProvider>();
    subscriptionProvider.restorePurchases();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Restoring purchases...')),
    );
  }

  Future<void> _launchURL(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  Future<void> _handlePurchase() async {
    final subscriptionProvider = context.read<SubscriptionProvider>();
    
    // Show loading indicator
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: CircularProgressIndicator(color: AppColors.primaryGreen),
      ),
    );

    bool success;
    if (_isYearlySelected) {
      success = await subscriptionProvider.purchaseYearly();
    } else {
      success = await subscriptionProvider.purchaseLifetime();
    }

    // Close loading dialog
    if (mounted) Navigator.of(context).pop();

    if (success) {
      // Purchase successful, navigate to home
      if (mounted) context.go('/home');
    } else {
      // Purchase failed or was cancelled
      if (mounted && subscriptionProvider.error != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(subscriptionProvider.error!)),
        );
      }
    }
  }
}
