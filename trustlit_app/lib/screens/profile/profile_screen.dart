import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../config/app_colors.dart';
import '../../providers/subscription_provider.dart';
import '../../providers/scan_history_provider.dart';

/// Profile Screen - Based on 21.png, 30.png
/// Shows user profile, subscription status, and settings
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'Profile',
          style: TextStyle(
            fontFamily: 'Outfit',
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: AppColors.textBlack,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Profile Avatar
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  color: AppColors.primaryGreen.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.person,
                  size: 48,
                  color: AppColors.primaryGreen,
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'TrustLit User',
                style: TextStyle(
                  fontFamily: 'Outfit',
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textBlack,
                ),
              ),
              const SizedBox(height: 32),

              // Subscription Status
              _buildSubscriptionCard(context),
              const SizedBox(height: 24),

              // Stats Card
              _buildStatsCard(context),
              const SizedBox(height: 24),

              // Settings List
              _buildSettingsSection(context),
              const SizedBox(height: 24),

              // App Info
              _buildAppInfo(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSubscriptionCard(BuildContext context) {
    return Consumer<SubscriptionProvider>(
      builder: (context, subscription, _) {
        final isActive = subscription.isActive;

        return Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: isActive
                  ? [AppColors.primaryGreen, AppColors.primaryGreenDark]
                  : [AppColors.textGray, AppColors.textDarkGray],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    isActive ? Icons.verified : Icons.lock_outline,
                    color: AppColors.white,
                    size: 24,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    isActive ? 'Premium Member' : 'Free User',
                    style: const TextStyle(
                      fontFamily: 'Outfit',
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.white,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                isActive
                    ? (subscription.isLifetime
                        ? 'Lifetime Access'
                        : 'Valid until ${_formatDate(subscription.expiryDate)}')
                    : 'Upgrade to unlock all features',
                style: TextStyle(
                  fontFamily: 'Outfit',
                  fontSize: 14,
                  color: AppColors.white.withValues(alpha: 0.9),
                ),
              ),
              if (!isActive) ...[
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      // TODO: Navigate to paywall
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.white,
                      foregroundColor: AppColors.primaryGreen,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'Upgrade Now',
                      style: TextStyle(
                        fontFamily: 'Outfit',
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ],
          ),
        );
      },
    );
  }

  Widget _buildStatsCard(BuildContext context) {
    return Consumer<ScanHistoryProvider>(
      builder: (context, historyProvider, _) {
        return Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: AppColors.lightGray,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildStatItem(
                icon: Icons.qr_code_scanner,
                value: historyProvider.count.toString(),
                label: 'Scans',
              ),
              Container(
                width: 1,
                height: 50,
                color: AppColors.divider,
              ),
              _buildStatItem(
                icon: Icons.history,
                value: 'All',
                label: 'Saved',
              ),
              Container(
                width: 1,
                height: 50,
                color: AppColors.divider,
              ),
              _buildStatItem(
                icon: Icons.schedule,
                value: '∞',
                label: 'Access',
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildStatItem({
    required IconData icon,
    required String value,
    required String label,
  }) {
    return Column(
      children: [
        Icon(
          icon,
          color: AppColors.primaryGreen,
          size: 24,
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: const TextStyle(
            fontFamily: 'Outfit',
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppColors.textBlack,
          ),
        ),
        Text(
          label,
          style: const TextStyle(
            fontFamily: 'Outfit',
            fontSize: 12,
            color: AppColors.textGray,
          ),
        ),
      ],
    );
  }

  Widget _buildSettingsSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Settings',
          style: TextStyle(
            fontFamily: 'Outfit',
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: AppColors.textBlack,
          ),
        ),
        const SizedBox(height: 12),
        _buildSettingsItem(
          icon: Icons.restore,
          title: 'Restore Purchases',
          onTap: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Restoring purchases...')),
            );
          },
        ),
        _buildSettingsItem(
          icon: Icons.notifications_outlined,
          title: 'Notifications',
          trailing: Switch(
            value: true,
            onChanged: (value) {},
            activeColor: AppColors.primaryGreen,
          ),
        ),
        _buildSettingsItem(
          icon: Icons.privacy_tip_outlined,
          title: 'Privacy Policy',
          onTap: () {},
        ),
        _buildSettingsItem(
          icon: Icons.description_outlined,
          title: 'Terms of Service',
          onTap: () {},
        ),
        _buildSettingsItem(
          icon: Icons.help_outline,
          title: 'Help & Support',
          onTap: () {},
        ),
        _buildSettingsItem(
          icon: Icons.star_outline,
          title: 'Rate the App',
          onTap: () {},
        ),
      ],
    );
  }

  Widget _buildSettingsItem({
    required IconData icon,
    required String title,
    VoidCallback? onTap,
    Widget? trailing,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: const BoxDecoration(
          border: Border(
            bottom: BorderSide(color: AppColors.divider, width: 0.5),
          ),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: AppColors.textGray,
              size: 22,
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  fontFamily: 'Outfit',
                  fontSize: 15,
                  color: AppColors.textBlack,
                ),
              ),
            ),
            trailing ??
                const Icon(
                  Icons.arrow_forward_ios,
                  size: 14,
                  color: AppColors.textLightGray,
                ),
          ],
        ),
      ),
    );
  }

  Widget _buildAppInfo() {
    return Column(
      children: [
        RichText(
          text: const TextSpan(
            style: TextStyle(
              fontFamily: 'Outfit',
              fontSize: 16,
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
        const SizedBox(height: 4),
        const Text(
          'Version 1.0.0',
          style: TextStyle(
            fontFamily: 'Outfit',
            fontSize: 12,
            color: AppColors.textGray,
          ),
        ),
        const SizedBox(height: 4),
        const Text(
          'Made with ❤️ for your health',
          style: TextStyle(
            fontFamily: 'Outfit',
            fontSize: 12,
            color: AppColors.textLightGray,
          ),
        ),
      ],
    );
  }

  String _formatDate(DateTime? date) {
    if (date == null) return 'N/A';
    return '${date.day}/${date.month}/${date.year}';
  }
}
