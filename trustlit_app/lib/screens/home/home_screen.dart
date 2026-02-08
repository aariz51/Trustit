import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Home Screen - Main dashboard with feature cards
/// Based on exact Figma design with Food Scanner, Track History, AI Expert
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header with TrustIt logo and profile
              _buildHeader(context),
              
              const SizedBox(height: 16),
              
              // Feature Cards
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Food Scanner Card
                    _FeatureCard(
                      imagePath: 'assets/images/food scanner.png',
                      title: 'Food Scanner',
                      subtitle: 'Detect Hidden Additives',
                      buttonLabel: 'Start',
                      buttonIcon: Icons.camera_alt,
                      onButtonTap: () => context.push('/camera'),
                    ),
                    
                    const SizedBox(height: 12),
                    
                    // Track History Card
                    _FeatureCard(
                      imagePath: 'assets/images/track history.png',
                      title: 'Track History',
                      subtitle: 'Track your choices',
                      buttonLabel: 'Track',
                      buttonIcon: Icons.search,
                      onButtonTap: () => context.go('/history'),
                    ),
                    
                    const SizedBox(height: 12),
                    
                    // AI Expert Card
                    _FeatureCard(
                      imagePath: 'assets/images/ai expert.png',
                      title: 'AI Expert',
                      subtitle: 'Ask it anything',
                      buttonLabel: 'Chat',
                      buttonIcon: Icons.chat_bubble,
                      onButtonTap: () => context.go('/ai-assistant'),
                    ),
                    
                    const SizedBox(height: 24),
                    
                    // Guides Section Header
                    const Text(
                      'Guides',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF1A1A1A),
                      ),
                    ),
                    
                    const SizedBox(height: 12),
                    
                    // Guides horizontal scroll
                    SizedBox(
                      height: 160,
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        physics: const BouncingScrollPhysics(),
                        children: [
                          _GuidePreviewCard(
                            imagePath: 'assets/images/paywall_1.png',
                            onTap: () => context.go('/guides'),
                          ),
                          const SizedBox(width: 12),
                          _GuidePreviewCard(
                            imagePath: 'assets/images/paywall_2.png',
                            onTap: () => context.go('/guides'),
                          ),
                          const SizedBox(width: 12),
                          _GuidePreviewCard(
                            imagePath: 'assets/images/paywall_3.png',
                            onTap: () => context.go('/guides'),
                          ),
                        ],
                      ),
                    ),
                    
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // TrustIt Logo
          RichText(
            text: const TextSpan(
              style: TextStyle(
                fontFamily: 'Roboto',
                fontSize: 28,
                fontWeight: FontWeight.w700,
              ),
              children: [
                TextSpan(
                  text: 'Trust',
                  style: TextStyle(color: Color(0xFF1A1A1A)),
                ),
                TextSpan(
                  text: 'It',
                  style: TextStyle(color: Color(0xFF22C55E)),
                ),
              ],
            ),
          ),
          
          // Profile Avatar
          GestureDetector(
            onTap: () => context.push('/paywall'),
            child: Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: const Color(0xFFE8D5F0),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Center(
                child: Text(
                  'AO',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF7C3AED),
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

/// Feature Card Widget - for Food Scanner, Track History, AI Expert
class _FeatureCard extends StatelessWidget {
  final String imagePath;
  final String title;
  final String subtitle;
  final String buttonLabel;
  final IconData buttonIcon;
  final VoidCallback onButtonTap;

  const _FeatureCard({
    required this.imagePath,
    required this.title,
    required this.subtitle,
    required this.buttonLabel,
    required this.buttonIcon,
    required this.onButtonTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFFAFAFA),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: const Color(0xFFE8E8E8),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          // Feature Image
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Container(
              width: 100,
              height: 100,
              color: Colors.white,
              child: Image.asset(
                imagePath,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: const Color(0xFFF0F9F0),
                    child: const Icon(
                      Icons.image,
                      size: 40,
                      color: Color(0xFF22C55E),
                    ),
                  );
                },
              ),
            ),
          ),
          
          const SizedBox(width: 16),
          
          // Text and Button
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF1A1A1A),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey.shade600,
                  ),
                ),
                const SizedBox(height: 12),
                
                // Action Button
                GestureDetector(
                  onTap: onButtonTap,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFF22C55E),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          buttonIcon,
                          color: Colors.white,
                          size: 16,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          buttonLabel,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
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

/// Guide Preview Card - horizontal scrolling guides section
class _GuidePreviewCard extends StatelessWidget {
  final String imagePath;
  final VoidCallback onTap;

  const _GuidePreviewCard({
    required this.imagePath,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Container(
          width: 200,
          height: 160,
          color: const Color(0xFFF5F5F5),
          child: Image.asset(
            imagePath,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return Container(
                color: const Color(0xFFF0F9F0),
                child: const Center(
                  child: Icon(
                    Icons.article_outlined,
                    size: 40,
                    color: Color(0xFF22C55E),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
