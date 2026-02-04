import 'package:flutter/material.dart';
import '../config/app_colors.dart';

/// Scoring Modal - Based on 38.png, 39.png
/// Explains the scoring methodology
class ScoringModal extends StatelessWidget {
  const ScoringModal({super.key});

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.85,
      maxChildSize: 0.95,
      minChildSize: 0.5,
      builder: (context, scrollController) {
        return Container(
          decoration: const BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Column(
            children: [
              // Handle bar
              Padding(
                padding: const EdgeInsets.only(top: 12, bottom: 8),
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppColors.divider,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),

              // Header
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Scoring Method',
                      style: TextStyle(
                        fontFamily: 'Outfit',
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textBlack,
                      ),
                    ),
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: const Icon(Icons.close, color: AppColors.textGray),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),

              // Content
              Expanded(
                child: SingleChildScrollView(
                  controller: scrollController,
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Our scoring system is designed to help you understand how safe and effective a product really is.',
                        style: TextStyle(
                          fontFamily: 'Outfit',
                          fontSize: 14,
                          color: AppColors.textGray,
                          height: 1.5,
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Safety Levels Section
                      _buildSectionCard(
                        'Safety Levels',
                        Column(
                          children: [
                            _buildSafetyLevelRow(
                              'Excellent',
                              '(76 - 100)',
                              AppColors.scoreExcellent,
                            ),
                            const SizedBox(height: 8),
                            _buildSafetyLevelRow(
                              'Good',
                              '(51 - 75)',
                              AppColors.scoreGood,
                            ),
                            const SizedBox(height: 8),
                            _buildSafetyLevelRow(
                              'Not great',
                              '(26 - 50)',
                              AppColors.scoreNotGreat,
                            ),
                            const SizedBox(height: 8),
                            _buildSafetyLevelRow(
                              'Bad',
                              '(0 - 25)',
                              AppColors.scoreBad,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),

                      // How Total Score is Calculated
                      const Text(
                        'How Total Score is Calculated',
                        style: TextStyle(
                          fontFamily: 'Outfit',
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textBlack,
                        ),
                      ),
                      const SizedBox(height: 12),
                      _buildBulletPoint(
                        'Safety (40%)',
                        'Evaluates the risk level of each ingredient based on scientific data.',
                      ),
                      _buildBulletPoint(
                        'Efficacy (40%)',
                        'Measures how well the product\'s active ingredients support its intended benefits.',
                      ),
                      _buildBulletPoint(
                        'Transparency (20%)',
                        'Reflects how clearly a brand lists its ingredients and formulation details.',
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        'Together, these determine the overall score out of 100.',
                        style: TextStyle(
                          fontFamily: 'Outfit',
                          fontSize: 14,
                          color: AppColors.textDarkGray,
                          height: 1.5,
                        ),
                      ),
                      const SizedBox(height: 24),

                      // How Ingredient Scoring Works
                      const Text(
                        'How Ingredient Scoring Works',
                        style: TextStyle(
                          fontFamily: 'Outfit',
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textBlack,
                        ),
                      ),
                      const SizedBox(height: 12),
                      _buildBulletPoint(
                        'Allergy Risk',
                        'Estimates probability of allergic reactions from known sensitizers or irritants.',
                      ),
                      _buildBulletPoint(
                        'High-Concentration Allergen',
                        'Evaluates whether an ingredient becomes unsafe at higher usage levels.',
                      ),
                      _buildBulletPoint(
                        'Carcinogenicity',
                        'Measures potential risk of contributing to cancer formation.',
                      ),
                      _buildBulletPoint(
                        'Endocrine Disruptor Risk',
                        'Assesses hormonal toxicity or interference.',
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        'Each factor contributes to an ingredient\'s risk level (None, Low, Medium, High).',
                        style: TextStyle(
                          fontFamily: 'Outfit',
                          fontSize: 14,
                          color: AppColors.textDarkGray,
                          height: 1.5,
                        ),
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        'Ingredient risks directly influence the product\'s Safety Score — one of the most important parts of the overall rating.',
                        style: TextStyle(
                          fontFamily: 'Outfit',
                          fontSize: 14,
                          color: AppColors.textDarkGray,
                          height: 1.5,
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Footer
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: AppColors.primaryGreen.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Text(
                          'Our goal is to make ingredient science simple so you can choose products that are safe and effective.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontFamily: 'Outfit',
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: AppColors.primaryGreen,
                            height: 1.5,
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSectionCard(String title, Widget content) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.lightGray,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontFamily: 'Outfit',
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppColors.textBlack,
            ),
          ),
          const SizedBox(height: 16),
          content,
        ],
      ),
    );
  }

  Widget _buildSafetyLevelRow(String label, String range, Color color) {
    return Row(
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 12),
        Text(
          label,
          style: const TextStyle(
            fontFamily: 'Outfit',
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: AppColors.textBlack,
          ),
        ),
        const SizedBox(width: 8),
        Text(
          range,
          style: const TextStyle(
            fontFamily: 'Outfit',
            fontSize: 14,
            color: AppColors.textGray,
          ),
        ),
      ],
    );
  }

  Widget _buildBulletPoint(String title, String description) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 6),
            child: Icon(
              Icons.circle,
              size: 6,
              color: AppColors.textBlack,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: RichText(
              text: TextSpan(
                style: const TextStyle(
                  fontFamily: 'Outfit',
                  fontSize: 14,
                  color: AppColors.textDarkGray,
                  height: 1.5,
                ),
                children: [
                  TextSpan(
                    text: '$title – ',
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                  TextSpan(text: description),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
