import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../config/app_colors.dart';
import '../../widgets/analysis_notification_overlay.dart';

/// Main Shell with Bottom Navigation Bar
/// Wraps all main screens (Home, History, Chat, Profile)
class MainShell extends StatelessWidget {
  final Widget child;

  const MainShell({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          child,
          // Analysis notification overlay at top
          const AnalysisNotificationOverlay(),
        ],
      ),
      bottomNavigationBar: const _BottomNavBar(),
    );
  }
}

class _BottomNavBar extends StatelessWidget {
  const _BottomNavBar();

  int _getCurrentIndex(BuildContext context) {
    final location = GoRouterState.of(context).uri.toString();
    if (location.startsWith('/home')) return 0;
    if (location.startsWith('/history')) return 1;
    if (location.startsWith('/ai-assistant')) return 3;
    if (location.startsWith('/chat')) return 3; // Chat maps to AI tab
    if (location.startsWith('/guides')) return 4;
    if (location.startsWith('/profile')) return 0; // Profile maps to Home tab
    return 1; // Default to history
  }

  void _onItemTapped(BuildContext context, int index) {
    switch (index) {
      case 0:
        context.go('/home');
        break;
      case 1:
        context.go('/history');
        break;
      case 2:
        // Camera button - navigate to camera screen
        context.push('/camera');
        break;
      case 3:
        context.go('/ai-assistant');
        break;
      case 4:
        context.go('/guides');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentIndex = _getCurrentIndex(context);

    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Home
              _NavItem(
                imagePath: 'assets/images/image copy.png',
                iconSize: 30,
                isActive: currentIndex == 0,
                onTap: () => _onItemTapped(context, 0),
              ),
              // History
              _NavItem(
                imagePath: 'assets/images/image copy 4.png',
                iconSize: 30,
                isActive: currentIndex == 1,
                onTap: () => _onItemTapped(context, 1),
              ),
              // Center Camera/Scan Button - significantly bigger
              GestureDetector(
                onTap: () => _onItemTapped(context, 2),
                child: Container(
                  width: 64,
                  height: 64,
                  decoration: const BoxDecoration(
                    color: Color(0xFF22C55E),
                    shape: BoxShape.circle,
                  ),
                  child: ClipOval(
                    child: Image.asset(
                      'assets/images/image.png',
                      width: 64,
                      height: 64,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              // AI Assistant
              _NavItem(
                imagePath: 'assets/images/image copy 2.png',
                iconSize: 30,
                isActive: currentIndex == 3,
                onTap: () => _onItemTapped(context, 3),
              ),
              // Guides
              _NavItem(
                imagePath: 'assets/images/image copy 3.png',
                iconSize: 30,
                isActive: currentIndex == 4,
                onTap: () => _onItemTapped(context, 4),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final String imagePath;
  final double iconSize;
  final bool isActive;
  final VoidCallback onTap;

  const _NavItem({
    required this.imagePath,
    this.iconSize = 28,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        width: 48,
        height: 48,
        decoration: isActive
            ? BoxDecoration(
                color: const Color(0xFF22C55E).withOpacity(0.12),
                borderRadius: BorderRadius.circular(14),
              )
            : null,
        child: Center(
          child: Opacity(
            opacity: isActive ? 1.0 : 0.45,
            child: Image.asset(
              imagePath,
              width: iconSize,
              height: iconSize,
              fit: BoxFit.contain,
            ),
          ),
        ),
      ),
    );
  }
}
