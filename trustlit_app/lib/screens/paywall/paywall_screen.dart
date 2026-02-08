import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../services/subscription_service.dart';

/// Paywall Screen - Exact Figma Design with In-App Purchase Integration
/// Supports:
/// - 3-day free trial that converts to yearly subscription
/// - Yearly subscription ($29.99/year)
/// - Lifetime purchase ($59.99 one-time)
class PaywallScreen extends StatefulWidget {
  const PaywallScreen({super.key});

  @override
  State<PaywallScreen> createState() => _PaywallScreenState();
}

class _PaywallScreenState extends State<PaywallScreen> {
  bool isYearlySelected = true;
  bool _isLoading = false;
  final SubscriptionService _subscriptionService = SubscriptionService();
  StreamSubscription<bool>? _purchaseCompleteSubscription;

  @override
  void initState() {
    super.initState();
    _initializeSubscriptionService();
    
    // Listen for purchase completion and redirect to home
    _purchaseCompleteSubscription = _subscriptionService.purchaseCompleteStream.listen((success) {
      if (success && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Purchase successful!')),
        );
        context.go('/home');
      }
    });
  }

  @override
  void dispose() {
    _purchaseCompleteSubscription?.cancel();
    super.dispose();
  }

  Future<void> _initializeSubscriptionService() async {
    await _subscriptionService.initialize();
    if (mounted) setState(() {});
  }


  /// Restore previous purchases
  Future<void> _restorePurchases() async {
    setState(() => _isLoading = true);

    try {
      await _subscriptionService.restorePurchases();
      
      // Check if subscription was restored
      await Future.delayed(const Duration(seconds: 2));
      
      if (mounted) {
        if (_subscriptionService.hasActiveSubscription()) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Purchases restored successfully!')),
          );
          context.go('/home');
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('No purchases found to restore')),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Restore failed: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  /// Start free trial and navigate to home
  Future<void> _startFreeTrial() async {
    setState(() => _isLoading = true);

    try {
      if (isYearlySelected) {
        // For yearly plan, initiate purchase (Apple handles the trial)
        final success = await _subscriptionService.purchaseYearly();
        if (success && mounted) {
          // Purchase initiated, wait for result
        }
      } else {
        // For lifetime, just purchase (no trial)
        final success = await _subscriptionService.purchaseLifetime();
        if (success && mounted) {
          // Purchase initiated, wait for result
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

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
                    const SizedBox(height: 8),
                    // App Logo - much larger
                    SizedBox(
                      width: 90,
                      height: 90,
                      child: Image.asset(
                        'assets/images/app_icon.png',
                        fit: BoxFit.contain,
                      ),
                    ),
                    const SizedBox(height: 12),
                    // Title - much larger
                    const Text(
                      'How free trial works',
                      style: TextStyle(
                        fontSize: 32,
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
                        'With TrustIt, committed users saw a 90% reduction in health problems',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.black54,
                          height: 1.3,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    // Phone Mockups - pulled up for timeline visibility
                    SizedBox(
                      height: 240, 
                      child: ClipRect(
                        child: Align(
                          alignment: Alignment.topCenter,
                          heightFactor: 0.45, // Show top part
                          child: Image.asset(
                            'assets/images/paywall_mockups.png',
                            fit: BoxFit.fitWidth,
                          ),
                        ),
                      ),
                    ),
                    // Timeline Section - using image for exact design
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Image.asset(
                        'assets/images/timeline_section.png',
                        fit: BoxFit.contain,
                      ),
                    ),
                    // Gap before studies section
                    const SizedBox(height: 20),
                    // Studies Section - compact
                    SizedBox(
                      height: 320, 
                      child: ClipRect(
                        child: Align(
                          alignment: Alignment.topCenter,
                          heightFactor: 0.85, // Show more content, less whitespace
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
            onTap: _isLoading ? null : _restorePurchases,
            child: Text(
              'Restore',
              style: TextStyle(
                fontSize: 15, 
                color: _isLoading ? Colors.grey.shade300 : Colors.grey.shade400,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStickyFooter(BuildContext context) {
    // Get prices from subscription service
    final yearlyPrice = _subscriptionService.getYearlyPrice();
    final lifetimePrice = _subscriptionService.getLifetimePrice();
    
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
            // Pricing cards row - added top margin for badge overflow
            Padding(
              padding: const EdgeInsets.only(top: 14),
              child: Row(
                children: [
                  // Lifetime card
                  Expanded(
                    child: _buildPricingCard(
                      title: 'Lifetime',
                      price: lifetimePrice,
                      isSelected: !isYearlySelected,
                      onTap: () => setState(() => isYearlySelected = false),
                    ),
                  ),
                  const SizedBox(width: 10),
                  // Yearly card with badge
                  Expanded(
                    child: _buildPricingCard(
                      title: 'YEARLY',
                      price: yearlyPrice,
                      isSelected: isYearlySelected,
                      showBadge: true,
                      onTap: () => setState(() => isYearlySelected = true),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 14),
            // No Payment Due Now
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.check, color: Colors.grey.shade800, size: 20),
                const SizedBox(width: 6),
                Text(
                  isYearlySelected 
                      ? 'No Payment Due Now' 
                      : 'One-time Payment',
                  style: const TextStyle(
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
                onPressed: _isLoading ? null : _startFreeTrial,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF22C55E),
                  foregroundColor: Colors.white,
                  disabledBackgroundColor: Colors.grey.shade300,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30), // Pill shape
                  ),
                  elevation: 0,
                ),
                child: _isLoading
                    ? const SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                    : Text(
                        isYearlySelected ? 'Try for \$0.00' : 'Buy Lifetime Access',
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
              ),
            ),
            const SizedBox(height: 10),
            // Disclaimer text
            Text(
              isYearlySelected 
                  ? '3 days FREE, then $yearlyPrice/year'
                  : 'One-time purchase, unlimited access',
              style: const TextStyle(
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
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        price,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
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