import 'package:flutter/material.dart';

/// Guides Screen - Health and wellness articles
/// Displays cards with article thumbnails, titles, and descriptions
class GuidesScreen extends StatelessWidget {
  const GuidesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.all(20),
              child: Center(
                child: RichText(
                  text: const TextSpan(
                    style: TextStyle(
                      fontFamily: 'Roboto',
                      fontSize: 24,
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
              ),
            ),
            
            // Guide Articles List
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                children: const [
                  _GuideCard(
                    imageAsset: 'assets/images/guide_morning.png',
                    title: 'How to Build a Healthy Morning Routine',
                    description: 'How you start your morning can shape the rest of your day',
                  ),
                  _GuideCard(
                    imageAsset: 'assets/images/guide_sleep.png',
                    title: 'Sleep Hygiene: Habits That Can Improve Your Rest',
                    description: 'Good sleep isn\'t just about getting more hours—it\'s about...',
                  ),
                  _GuideCard(
                    imageAsset: 'assets/images/guide_energy.png',
                    title: 'Foods That May Support Energy Levels Naturally',
                    description: 'If you often feel sluggish or hit an afternoon crash, your diet migh...',
                  ),
                  _GuideCard(
                    imageAsset: 'assets/images/guide_stress.png',
                    title: 'The Science of Stress and What You Can Do About It',
                    description: 'Stress is natural, but when it builds up, it can impact your m...',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _GuideCard extends StatelessWidget {
  final String imageAsset;
  final String title;
  final String description;

  const _GuideCard({
    required this.imageAsset,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Thumbnail Image
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Container(
              width: 100,
              height: 100,
              color: const Color(0xFFF5F5F5),
              child: Image.asset(
                imageAsset,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: const Color(0xFFF0F9F0),
                    child: const Icon(
                      Icons.article_outlined,
                      size: 40,
                      color: Color(0xFF22C55E),
                    ),
                  );
                },
              ),
            ),
          ),
          const SizedBox(width: 12),
          
          // Text Content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontFamily: 'Roboto',
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1A1A1A),
                    height: 1.3,
                  ),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 6),
                Text(
                  description,
                  style: TextStyle(
                    fontFamily: 'Roboto',
                    fontSize: 13,
                    color: Colors.grey.shade600,
                    height: 1.4,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
