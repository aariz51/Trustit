import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Home Screen - Exact match to design 13.png
/// Shows "RevealIt" logo, 3 feature cards with illustrations, Guides section
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),

              // TrustIt Header Logo
              Center(
                child: SizedBox(
                  height: 40,
                  child: Image.asset(
                    'assets/images/app_icon.png',
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Feature Cards
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  children: [
                    // Product Scanner Card
                    _FeatureCard(
                      illustration: _ProductScannerIllustration(),
                      title: 'Product Scanner',
                      subtitle: 'Detect Hidden Chemicals',
                      buttonText: 'Start',
                      buttonIcon: Icons.camera_alt_outlined,
                      buttonColor: const Color(0xFF22C55E),
                      onTap: () => context.push('/camera'),
                    ),
                    const SizedBox(height: 12),

                    // Track History Card
                    _FeatureCard(
                      illustration: _TrackHistoryIllustration(),
                      title: 'Track History',
                      subtitle: 'Track your choices',
                      buttonText: 'Track',
                      buttonIcon: Icons.search,
                      buttonColor: const Color(0xFF22C55E),
                      onTap: () => context.go('/history'),
                    ),
                    const SizedBox(height: 12),

                    // AI Expert Card
                    _FeatureCard(
                      illustration: _AIExpertIllustration(),
                      title: 'AI Expert',
                      subtitle: 'Ask it anything',
                      buttonText: 'Chat',
                      buttonIcon: Icons.chat_bubble_outline,
                      buttonColor: const Color(0xFF22C55E),
                      onTap: () => context.go('/chat'),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Guides Section
              Padding(
                padding: const EdgeInsets.only(left: 16),
                child: const Text(
                  'Guides',
                  style: TextStyle(
                    fontFamily: 'Outfit',
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1A1A1A),
                  ),
                ),
              ),
              const SizedBox(height: 12),

              // Guides Horizontal Scroll
              SizedBox(
                height: 160,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  children: [
                    _GuideCard(
                      title: 'Understanding Labels',
                      bgColor: const Color(0xFFFEF3C7),
                    ),
                    _GuideCard(
                      title: 'Healthy Eating Tips',
                      bgColor: const Color(0xFFDCFCE7),
                    ),
                    _GuideCard(
                      title: 'Cosmetic Safety',
                      bgColor: const Color(0xFFE0E7FF),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 100), // Bottom nav space
            ],
          ),
        ),
      ),
    );
  }
}

/// Feature Card Widget matching the design
class _FeatureCard extends StatelessWidget {
  final Widget illustration;
  final String title;
  final String subtitle;
  final String buttonText;
  final IconData buttonIcon;
  final Color buttonColor;
  final VoidCallback onTap;

  const _FeatureCard({
    required this.illustration,
    required this.title,
    required this.subtitle,
    required this.buttonText,
    required this.buttonIcon,
    required this.buttonColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF9FAFB),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          // Illustration
          SizedBox(
            width: 80,
            height: 80,
            child: illustration,
          ),
          const SizedBox(width: 16),
          // Content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontFamily: 'Outfit',
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1A1A1A),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontFamily: 'Outfit',
                    fontSize: 14,
                    color: Color(0xFF6B7280),
                  ),
                ),
                const SizedBox(height: 12),
                GestureDetector(
                  onTap: onTap,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: buttonColor,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(buttonIcon, color: Colors.white, size: 16),
                        const SizedBox(width: 6),
                        Text(
                          buttonText,
                          style: const TextStyle(
                            fontFamily: 'Outfit',
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Guide Card Widget
class _GuideCard extends StatelessWidget {
  final String title;
  final Color bgColor;

  const _GuideCard({
    required this.title,
    required this.bgColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200,
      margin: const EdgeInsets.only(right: 12),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Stack(
        children: [
          // Background pattern
          Positioned(
            right: 10,
            bottom: 10,
            child: Icon(
              Icons.restaurant_menu,
              size: 60,
              color: Colors.black.withValues(alpha: 0.05),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontFamily: 'Outfit',
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1A1A1A),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Product Scanner Illustration - Woman holding skincare products
class _ProductScannerIllustration extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFFEE2E2).withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(12),
      ),
      child: CustomPaint(
        painter: _ScannerIllustrationPainter(),
      ),
    );
  }
}

class _ScannerIllustrationPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    // Woman silhouette - simple illustration
    final skinTone = Paint()..color = const Color(0xFFFCD5B4);
    final hairColor = Paint()..color = const Color(0xFF4A3728);
    final shirtColor = Paint()..color = const Color(0xFF86EFAC);
    final productColor = Paint()..color = const Color(0xFFE5E7EB);
    
    // Head
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(size.width * 0.5, size.height * 0.25),
        width: size.width * 0.35,
        height: size.height * 0.25,
      ),
      skinTone,
    );
    
    // Hair
    final hairPath = Path();
    hairPath.moveTo(size.width * 0.3, size.height * 0.15);
    hairPath.quadraticBezierTo(
      size.width * 0.5, size.height * 0.05,
      size.width * 0.7, size.height * 0.15,
    );
    hairPath.quadraticBezierTo(
      size.width * 0.75, size.height * 0.35,
      size.width * 0.65, size.height * 0.45,
    );
    hairPath.lineTo(size.width * 0.35, size.height * 0.45);
    hairPath.quadraticBezierTo(
      size.width * 0.25, size.height * 0.35,
      size.width * 0.3, size.height * 0.15,
    );
    canvas.drawPath(hairPath, hairColor);
    
    // Body/Shirt
    final bodyPath = Path();
    bodyPath.moveTo(size.width * 0.35, size.height * 0.4);
    bodyPath.lineTo(size.width * 0.2, size.height * 0.95);
    bodyPath.lineTo(size.width * 0.8, size.height * 0.95);
    bodyPath.lineTo(size.width * 0.65, size.height * 0.4);
    bodyPath.close();
    canvas.drawPath(bodyPath, shirtColor);
    
    // Product bottles
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(
          center: Offset(size.width * 0.75, size.height * 0.7),
          width: size.width * 0.15,
          height: size.height * 0.25,
        ),
        const Radius.circular(4),
      ),
      productColor,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(
          center: Offset(size.width * 0.25, size.height * 0.75),
          width: size.width * 0.12,
          height: size.height * 0.2,
        ),
        const Radius.circular(4),
      ),
      productColor,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// Track History Illustration - Woman on phone with score display
class _TrackHistoryIllustration extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFFEF3C7).withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(12),
      ),
      child: CustomPaint(
        painter: _HistoryIllustrationPainter(),
      ),
    );
  }
}

class _HistoryIllustrationPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final skinTone = Paint()..color = const Color(0xFFFCD5B4);
    final hairColor = Paint()..color = const Color(0xFF1A1A1A);
    final shirtColor = Paint()..color = const Color(0xFFFDE047);
    final phoneColor = Paint()..color = const Color(0xFF1A1A1A);
    
    // Head
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(size.width * 0.4, size.height * 0.25),
        width: size.width * 0.3,
        height: size.height * 0.22,
      ),
      skinTone,
    );
    
    // Hair bun
    canvas.drawCircle(
      Offset(size.width * 0.4, size.height * 0.12),
      size.width * 0.12,
      hairColor,
    );
    
    // Body
    final bodyPath = Path();
    bodyPath.moveTo(size.width * 0.3, size.height * 0.38);
    bodyPath.lineTo(size.width * 0.15, size.height * 0.95);
    bodyPath.lineTo(size.width * 0.65, size.height * 0.95);
    bodyPath.lineTo(size.width * 0.5, size.height * 0.38);
    bodyPath.close();
    canvas.drawPath(bodyPath, shirtColor);
    
    // Phone
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(
          center: Offset(size.width * 0.75, size.height * 0.5),
          width: size.width * 0.25,
          height: size.height * 0.4,
        ),
        const Radius.circular(4),
      ),
      phoneColor,
    );
    
    // Score circle on phone
    final scoreCircle = Paint()
      ..color = const Color(0xFFEF4444)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    canvas.drawCircle(
      Offset(size.width * 0.75, size.height * 0.5),
      size.width * 0.08,
      scoreCircle,
    );
    
    // Score text
    final textPainter = TextPainter(
      text: const TextSpan(
        text: '32',
        style: TextStyle(
          fontSize: 8,
          fontWeight: FontWeight.bold,
          color: Color(0xFFEF4444),
        ),
      ),
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();
    textPainter.paint(
      canvas,
      Offset(size.width * 0.71, size.height * 0.46),
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// AI Expert Illustration - Woman with lightbulb/idea
class _AIExpertIllustration extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFDCFCE7).withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(12),
      ),
      child: CustomPaint(
        painter: _AIExpertIllustrationPainter(),
      ),
    );
  }
}

class _AIExpertIllustrationPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final skinTone = Paint()..color = const Color(0xFFFCD5B4);
    final hairColor = Paint()..color = const Color(0xFF4A3728);
    final shirtColor = Paint()..color = const Color(0xFF86EFAC);
    
    // Head
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(size.width * 0.5, size.height * 0.35),
        width: size.width * 0.35,
        height: size.height * 0.25,
      ),
      skinTone,
    );
    
    // Hair
    final hairPath = Path();
    hairPath.moveTo(size.width * 0.25, size.height * 0.25);
    hairPath.quadraticBezierTo(
      size.width * 0.5, size.height * 0.1,
      size.width * 0.75, size.height * 0.25,
    );
    hairPath.lineTo(size.width * 0.7, size.height * 0.5);
    hairPath.lineTo(size.width * 0.3, size.height * 0.5);
    hairPath.close();
    canvas.drawPath(hairPath, hairColor);
    
    // Body
    final bodyPath = Path();
    bodyPath.moveTo(size.width * 0.35, size.height * 0.5);
    bodyPath.lineTo(size.width * 0.2, size.height * 0.95);
    bodyPath.lineTo(size.width * 0.8, size.height * 0.95);
    bodyPath.lineTo(size.width * 0.65, size.height * 0.5);
    bodyPath.close();
    canvas.drawPath(bodyPath, shirtColor);
    
    // AI Badge
    final badgeBg = Paint()..color = const Color(0xFF22C55E);
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(
          center: Offset(size.width * 0.25, size.height * 0.7),
          width: size.width * 0.2,
          height: size.height * 0.12,
        ),
        const Radius.circular(4),
      ),
      badgeBg,
    );
    
    // Lightbulb
    final bulbColor = Paint()..color = const Color(0xFFFBBF24);
    canvas.drawCircle(
      Offset(size.width * 0.8, size.height * 0.2),
      size.width * 0.1,
      bulbColor,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
