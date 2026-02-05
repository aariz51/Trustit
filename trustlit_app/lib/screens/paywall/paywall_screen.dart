import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Paywall Screen - Exact Figma Design with NO white spaces
/// Images cropped aggressively to remove all padding
class PaywallScreen extends StatefulWidget {
  const PaywallScreen({super.key});

  @override
  State<PaywallScreen> createState() => _PaywallScreenState();
}

class _PaywallScreenState extends State<PaywallScreen> {
  bool isYearlySelected = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            // SCROLLABLE CONTENT
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  children: [
                    // Top bar
                    _buildTopBar(context),
                    const SizedBox(height: 12),
                    // App Logo
                    SizedBox(
                      width: 52,
                      height: 52,
                      child: Image.asset(
                        'assets/images/logo.png',
                        fit: BoxFit.contain,
                      ),
                    ),
                    const SizedBox(height: 10),
                    // Title
                    const Text(
                      'How free trial works',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w800,
                        color: Colors.black,
                        letterSpacing: -0.5,
                      ),
                    ),
                    const SizedBox(height: 6),
                    // Subtitle
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: Text(
                        'With Reveal It, committed users saw a 90% reduction in health problems',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.black54,
                          height: 1.3,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    // Phone Mockups - LARGER, fully visible
                    SizedBox(
                      height: 300, 
                      child: ClipRect(
                        child: Align(
                          alignment: Alignment.topCenter,
                          heightFactor: 0.5, // Show 50% of image (more content)
                          child: Image.asset(
                            'assets/images/paywall_mockups.png',
                            fit: BoxFit.fitWidth,
                          ),
                        ),
                      ),
                    ),
                    // NO gap - Timeline starts immediately
                    _buildTimeline(),
                    // Studies Section - LARGER, fully visible
                    SizedBox(
                      height: 450, 
                      child: ClipRect(
                        child: Align(
                          alignment: Alignment.topCenter,
                          heightFactor: 0.75, // Show 75% of image (more content)
                          child: Image.asset(
                            'assets/images/institution_logos.png',
                            fit: BoxFit.fitWidth,
                          ),
                        ),
                      ),
                    ),
                    // Small padding before footer
                    const SizedBox(height: 8),
                  ],
                ),
              ),
            ),
            // STICKY FOOTER
            _buildStickyFooter(context),
          ],
        ),
      ),
    );
  }

  Widget _buildTopBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 6, 16, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: () => Navigator.of(context).pop(),
            child: Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.close, size: 16, color: Colors.grey.shade500),
            ),
          ),
          GestureDetector(
            onTap: () {},
            child: Text(
              'Restore',
              style: TextStyle(fontSize: 15, color: Colors.grey.shade400),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimeline() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          _buildTimelineItem(
            icon: Icons.lock_open_rounded,
            bgColor: const Color(0xFFDCFCE7),
            iconColor: const Color(0xFF22C55E),
            title: 'Today',
            subtitle: "Unlock all the app's features like product scanning, AI expert, and more.",
            showLine: true,
          ),
          _buildTimelineItem(
            icon: Icons.notifications_none_rounded,
            bgColor: const Color(0xFFDCFCE7),
            iconColor: const Color(0xFF22C55E),
            title: 'In 2 Days',
            subtitle: "We'll send you a reminder that your trial is ending soon.",
            showLine: true,
          ),
          _buildTimelineItem(
            icon: Icons.workspace_premium_rounded,
            bgColor: const Color(0xFFFEF3C7),
            iconColor: const Color(0xFFF59E0B),
            title: 'In 3 Days - Billing Starts',
            subtitle: "You'll be charged on January 05, 2026 unless you cancel anytime before.",
            showLine: false,
          ),
        ],
      ),
    );
  }

  Widget _buildTimelineItem({
    required IconData icon,
    required Color bgColor,
    required Color iconColor,
    required String title,
    required String subtitle,
    required bool showLine,
  }) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 42,
            child: Column(
              children: [
                Container(
                  width: 38,
                  height: 38,
                  decoration: BoxDecoration(color: bgColor, shape: BoxShape.circle),
                  child: Icon(icon, color: iconColor, size: 20),
                ),
                if (showLine)
                  Expanded(
                    child: Container(
                      width: 2,
                      margin: const EdgeInsets.symmetric(vertical: 3),
                      color: Colors.grey.shade200,
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 14, top: 2),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: Colors.black),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    subtitle,
                    style: TextStyle(fontSize: 13, color: Colors.grey.shade600, height: 1.35),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStickyFooter(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Color(0xFFEEEEEE), width: 1)),
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Pricing cards row
            Row(
              children: [
                // Lifetime card
                Expanded(
                  child: _buildPricingCard(
                    title: 'Lifetime',
                    price: '\$119.00',
                    isSelected: !isYearlySelected,
                    onTap: () => setState(() => isYearlySelected = false),
                  ),
                ),
                const SizedBox(width: 10),
                // Yearly card with badge
                Expanded(
                  child: _buildPricingCard(
                    title: 'YEARLY',
                    price: '\$3.33 /mo',
                    isSelected: isYearlySelected,
                    showBadge: true,
                    onTap: () => setState(() => isYearlySelected = true),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            // No Payment Due Now
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.check, color: Colors.grey.shade800, size: 20),
                const SizedBox(width: 6),
                const Text(
                  'No Payment Due Now',
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.black87,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            // Try for $0.00 button - pill shape
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: () => context.go('/history'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF22C55E),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30), // Pill shape
                  ),
                  elevation: 0,
                ),
                child: const Text(
                  'Try for \$0.00',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),
            // Disclaimer text
            const Text(
              '3 days FREE, then \$39.99 per year (\$3.33/month)',
              style: TextStyle(
                fontSize: 13,
                color: Colors.black54,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPricingCard({
    required String title,
    required String price,
    required bool isSelected,
    required VoidCallback onTap,
    bool showBadge = false,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: isSelected ? const Color(0xFF22C55E) : const Color(0xFFE0E0E0),
                width: isSelected ? 2.5 : 1.5,
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w800,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      price,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
                // Radio circle
                Container(
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isSelected ? const Color(0xFF22C55E) : Colors.white,
                    border: Border.all(
                      color: isSelected ? const Color(0xFF22C55E) : const Color(0xFFCCCCCC),
                      width: 2.5,
                    ),
                  ),
                  child: isSelected
                      ? const Icon(Icons.check, color: Colors.white, size: 18)
                      : null,
                ),
              ],
            ),
          ),
          // 3-DAY FREE TRIAL badge
          if (showBadge)
            Positioned(
              top: -12,
              right: 8,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: const Color(0xFF22C55E),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: const Text(
                  '3-DAY FREE TRIAL',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.3,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}