import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../config/app_colors.dart';
import '../../widgets/analysis_notification_overlay.dart';

/// Main Shell with Bottom Navigation Bar
class MainShell extends StatelessWidget {
  final Widget child;

  const MainShell({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          child,
          const AnalysisNotificationOverlay(),
        ],
      ),
      bottomNavigationBar: _BottomNavBar(),
    );
  }
}

class _BottomNavBar extends StatelessWidget {
  _BottomNavBar();

  int _getCurrentIndex(BuildContext context) {
    final location = GoRouterState.of(context).uri.toString();
    if (location.startsWith('/home')) return 0;
    if (location.startsWith('/history')) return 1;
    if (location.startsWith('/ai-assistant')) return 3;
    if (location.startsWith('/chat')) return 3;
    if (location.startsWith('/guides')) return 4;
    if (location.startsWith('/profile')) return 0;
    return 1;
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
    final bottomPad = MediaQuery.of(context).padding.bottom;

    // Height of the nav bar area (excluding the overlapping scan button part)
    const double navBarHeight = 70;
    // How much the scan button rises above the nav bar
    const double scanOverlap = 28;
    // Total height including the overlap area
    const double totalHeight = navBarHeight + scanOverlap;

    return SizedBox(
      height: totalHeight + bottomPad,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // White nav bar background at the bottom
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            height: navBarHeight + bottomPad,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.06),
                    blurRadius: 8,
                    offset: const Offset(0, -2),
                  ),
                ],
              ),
            ),
          ),

          // Nav items row — aligned at the bottom
          Positioned(
            left: 0,
            right: 0,
            bottom: bottomPad,
            height: navBarHeight,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Home
                  _NavItem(
                    imagePath: 'assets/images/image copy.png',
                    iconSize: 52,
                    isActive: currentIndex == 0,
                    onTap: () => _onItemTapped(context, 0),
                  ),
                  // History
                  _NavItem(
                    imagePath: 'assets/images/image copy 4.png',
                    iconSize: 42,
                    isActive: currentIndex == 1,
                    onTap: () => _onItemTapped(context, 1),
                  ),
                  // Placeholder for scan button space
                  const SizedBox(width: 80),
                  // AI Assistant
                  _NavItem(
                    imagePath: 'assets/images/image copy 2.png',
                    iconSize: 68,
                    isActive: currentIndex == 3,
                    onTap: () => _onItemTapped(context, 3),
                  ),
                  // Guides
                  _NavItem(
                    imagePath: 'assets/images/image copy 3.png',
                    iconSize: 68,
                    isActive: currentIndex == 4,
                    onTap: () => _onItemTapped(context, 4),
                  ),
                ],
              ),
            ),
          ),

          // Scan button — overlapping the top border
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Center(
              child: GestureDetector(
                onTap: () => _onItemTapped(context, 2),
                child: Container(
                  width: 72,
                  height: 72,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.08),
                        blurRadius: 6,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(3),
                    child: ClipOval(
                      child: Image.asset(
                        'assets/images/image.png',
                        width: 66,
                        height: 66,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
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
    this.iconSize = 32,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Icon - turns green when active, grey when inactive
          isActive
              ? ColorFiltered(
                  colorFilter: const ColorFilter.mode(
                    Color(0xFF22C55E),
                    BlendMode.srcIn,
                  ),
                  child: Image.asset(
                    imagePath,
                    width: iconSize,
                    height: iconSize,
                    fit: BoxFit.contain,
                  ),
                )
              : Opacity(
                  opacity: 0.45,
                  child: Image.asset(
                    imagePath,
                    width: iconSize,
                    height: iconSize,
                    fit: BoxFit.contain,
                  ),
                ),
          const SizedBox(height: 4),
          // Green dot for active
          if (isActive)
            Container(
              width: 6,
              height: 6,
              decoration: const BoxDecoration(
                color: Color(0xFF22C55E),
                shape: BoxShape.circle,
              ),
            )
          else
            const SizedBox(height: 6),
        ],
      ),
    );
  }
}
