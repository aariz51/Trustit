import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Paywall Screen - Uses EXACT Figma design images with scrollable content
/// and fixed pricing footer
class PaywallScreen extends StatefulWidget {
  const PaywallScreen({super.key});

  @override
  State<PaywallScreen> createState() => _PaywallScreenState();
}

class _PaywallScreenState extends State<PaywallScreen> {
  bool _isYearlySelected = true;

  // Calculate the height to clip from each image (footer section height ratio)
  // Based on 1792px total height, footer takes approximately 350px
  static const double _footerHeightRatio = 350 / 1792;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    // Original image dimensions: 828 x 1792
    // Content height without footer: 1792 - 350 = 1442
    final contentHeightRatio = 1442 / 828;
    final imageHeight = screenWidth * contentHeightRatio;
    
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // Scrollable content using actual Figma design images
          SingleChildScrollView(
            child: Column(
              children: [
                // Image 8.png - Header, phones, "How free trial works", Today, In 2 Days
                _buildScrollableImage(
                  'assets/images/paywall_content_1.png',
                  screenWidth,
                  imageHeight,
                ),
                
                // Image 9.png - continuation with In 3 Days, rating, badges
                _buildScrollableImage(
                  'assets/images/paywall_content_2.png',
                  screenWidth,
                  imageHeight,
                  // Clip top portion that overlaps with previous image
                  topClipRatio: 0.35,
                ),
                
                // Image 11.png - Based on 100,000+ studies section with institutions
                // Skip image 10.png (reviews section)
                _buildScrollableImage(
                  'assets/images/paywall_content_3.png',
                  screenWidth,
                  imageHeight,
                  // Clip top portion (reviews heading)
                  topClipRatio: 0.25,
                ),
                
                // Bottom padding to account for fixed footer
                const SizedBox(height: 280),
              ],
            ),
          ),
          
          // Close button overlay (on top of scrollable content)
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: SafeArea(
              bottom: false,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () => context.go('/home'),
                      child: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.95),
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.1),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: const Icon(Icons.close, size: 20, color: Colors.black54),
                      ),
                    ),
                    // Invisible restore button - just for spacing
                    // The actual "Restore" text is in the image
                    const SizedBox(width: 40),
                  ],
                ),
              ),
            ),
          ),
          
          // Fixed footer with pricing
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: _buildFixedFooter(context),
          ),
        ],
      ),
    );
  }

  Widget _buildScrollableImage(
    String imagePath,
    double width,
    double height, {
    double topClipRatio = 0,
    double bottomClipRatio = 0,
  }) {
    // Calculate clipping values
    final originalRatio = 1792 / 828;
    final fullHeight = width * originalRatio;
    final topClip = fullHeight * topClipRatio;
    final bottomClip = fullHeight * (bottomClipRatio + _footerHeightRatio);
    final visibleHeight = fullHeight - topClip - bottomClip;

    return SizedBox(
      width: width,
      height: visibleHeight,
      child: ClipRect(
        child: OverflowBox(
          alignment: Alignment.topCenter,
          maxWidth: width,
          maxHeight: fullHeight,
          child: Transform.translate(
            offset: Offset(0, -topClip),
            child: Image.asset(
              imagePath,
              width: width,
              height: fullHeight,
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFixedFooter(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 16,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Pricing options
            Row(
              children: [
                // Lifetime option
                Expanded(
                  child: GestureDetector(
                    onTap: () => setState(() => _isYearlySelected = false),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: !_isYearlySelected
                              ? const Color(0xFF22C55E)
                              : Colors.grey.shade300,
                          width: !_isYearlySelected ? 2 : 1.5,
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Lifetime',
                                style: TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.grey.shade800,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                '\$119.00',
                                style: TextStyle(
                                  fontSize: 15,
                                  color: Colors.grey.shade600,
                                ),
                              ),
                            ],
                          ),
                          Container(
                            width: 24,
                            height: 24,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: !_isYearlySelected
                                    ? const Color(0xFF22C55E)
                                    : Colors.grey.shade400,
                                width: 2,
                              ),
                              color: !_isYearlySelected
                                  ? const Color(0xFF22C55E)
                                  : Colors.transparent,
                            ),
                            child: !_isYearlySelected
                                ? const Icon(
                                    Icons.check,
                                    color: Colors.white,
                                    size: 16,
                                  )
                                : null,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                
                // Yearly option
                Expanded(
                  child: GestureDetector(
                    onTap: () => setState(() => _isYearlySelected = true),
                    child: Stack(
                      clipBehavior: Clip.none,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                          decoration: BoxDecoration(
                            color: _isYearlySelected
                                ? const Color(0xFFECFDF5)
                                : Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: _isYearlySelected
                                  ? const Color(0xFF22C55E)
                                  : Colors.grey.shade300,
                              width: _isYearlySelected ? 2 : 1.5,
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'YEARLY',
                                    style: TextStyle(
                                      fontSize: 17,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.grey.shade800,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    '\$3.33 /mo',
                                    style: TextStyle(
                                      fontSize: 15,
                                      color: Colors.grey.shade600,
                                    ),
                                  ),
                                ],
                              ),
                              Container(
                                width: 24,
                                height: 24,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: _isYearlySelected
                                      ? const Color(0xFF22C55E)
                                      : Colors.transparent,
                                  border: Border.all(
                                    color: _isYearlySelected
                                        ? const Color(0xFF22C55E)
                                        : Colors.grey.shade400,
                                    width: 2,
                                  ),
                                ),
                                child: _isYearlySelected
                                    ? const Icon(
                                        Icons.check,
                                        color: Colors.white,
                                        size: 16,
                                      )
                                    : null,
                              ),
                            ],
                          ),
                        ),
                        // 3-DAY FREE TRIAL badge
                        Positioned(
                          top: -10,
                          right: 12,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFF22C55E),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Text(
                              '3-DAY FREE TRIAL',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 9,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 0.3,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            
            // No payment due now
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.check, color: Colors.grey.shade700, size: 18),
                const SizedBox(width: 6),
                Text(
                  'No Payment Due Now',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey.shade700,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            
            // Try for $0.00 button
            SizedBox(
              width: double.infinity,
              height: 54,
              child: ElevatedButton(
                onPressed: () {
                  // TODO: Handle subscription
                  context.go('/home');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF22C55E),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(27),
                  ),
                  elevation: 0,
                ),
                child: const Text(
                  'Try for \$0.00',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),
            
            // Disclaimer text
            Text(
              '3 days FREE, then \$39.99 per year (\$3.33/month)',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey.shade600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
