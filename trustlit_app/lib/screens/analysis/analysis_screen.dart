import 'dart:io';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../config/app_colors.dart';
import '../../models/analysis_result_model.dart';
import '../../models/ingredient_model.dart';
import '../../widgets/scoring_modal.dart';

/// Analysis Screen - Based on 12-16.png, 27-39.png
/// Shows product analysis with score, ingredients, and collapsible sections
class AnalysisScreen extends StatefulWidget {
  final String analysisId;

  const AnalysisScreen({
    super.key,
    required this.analysisId,
  });

  @override
  State<AnalysisScreen> createState() => _AnalysisScreenState();
}

class _AnalysisScreenState extends State<AnalysisScreen> {
  bool _showAllIngredients = false;
  final Map<String, bool> _expandedSections = {};

  // Mock data - will be replaced with actual API data
  late AnalysisResultModel _analysis;

  @override
  void initState() {
    super.initState();
    _loadMockData();
  }

  void _loadMockData() {
    _analysis = AnalysisResultModel(
      productName: 'Great Value Corn Flakes',
      category: 'Breakfast Cereal',
      overallScore: 45,
      safetyScore: 45,
      efficacyScore: 60,
      transparencyScore: 90,
      summary:
          'Great Value Corn Flakes is a fortified breakfast cereal that provides quick energy and essential vitamins. The product contains added sugar, riboflavin as a colorant, and the preservative BHT, which contribute to a moderate risk profile. The overall safety score is lowered mainly by sugar, artificial color, and BHT. Nutritional value is decent, but the high sugar content limits its suitability for health-conscious consumers. Transparency is high because the ingredient list is clear, though some ingredients are inferred based on typical brand formulations.',
      ingredients: [
        IngredientModel(
          name: 'Maïs moulu',
          riskLevel: 'Low',
          description: 'Ground corn, the base ingredient',
        ),
        IngredientModel(
          name: 'Extrait d\'orge maltée',
          riskLevel: 'Low',
          description: 'Malted barley extract for flavor',
        ),
        IngredientModel(
          name: 'Sel',
          riskLevel: 'Low',
          alsoKnownAs: 'Salt',
          whyThisRisk: 'Sodium intake',
        ),
        IngredientModel(
          name: 'Riboflavine (pour la couleur)',
          riskLevel: 'Low',
          alsoKnownAs: 'Vitamin B2',
          description: 'Used as a colorant',
        ),
        IngredientModel(
          name: 'Fer',
          riskLevel: 'Low',
          alsoKnownAs: 'Iron',
          description: 'Added for nutritional fortification',
        ),
        IngredientModel(
          name: 'Sugar',
          riskLevel: 'Medium',
          whyThisRisk: 'High sugar intake can lead to health issues',
        ),
        IngredientModel(
          name: 'BHT',
          riskLevel: 'Medium',
          alsoKnownAs: 'Butylated hydroxytoluene',
          whyThisRisk: 'Preservative with potential health concerns',
        ),
      ],
      healthImpact:
          'Great Value Corn Flakes is a fortified breakfast cereal that provides quick energy and essential vitamins. The product contains added sugar, riboflavin as a colorant, and the preservative BHT, which contribute to a moderate risk profile. The overall safety score is lowered mainly by sugar, artificial color, and BHT. Nutritional value is decent, but the high sugar content limits its suitability for health-conscious consumers. Transparency is high because the ingredient list is clear, though some ingredients are inferred based on typical brand formulations.',
      shortTermEffects:
          'High sugar intake can lead to rapid spikes in blood glucose and potential weight gain.',
      longTermEffects:
          'Chronic consumption may increase the risk of type 2 diabetes, cardiovascular disease, and potential endocrine disruption from BHT.',
      hiddenChemicals: 'BHT',
      howToUse:
          'Pour desired portion into a bowl, add milk or a non-dairy alternative, and serve immediately.',
      goodAndBad:
          'Good as a quick breakfast option, but high in sugar and contains a preservative.',
      whatItDoes:
          'Provides rapid energy from carbohydrates and supplies fortified vitamins and minerals.',
      whatPeopleSay:
          'Generally well-liked for taste and convenience, though some consumers note the high sugar content and presence of artificial additives.',
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        leading: IconButton(
          onPressed: () => context.go('/home'),
          icon: Icon(Icons.arrow_back, color: AppColors.textBlack),
        ),
        centerTitle: true,
        title: RichText(
          text: const TextSpan(
            style: TextStyle(
              fontFamily: 'Outfit',
              fontSize: 20,
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
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product Image
            _buildProductImage(),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Product Name & Category
                  Text(
                    _analysis.productName,
                    style: const TextStyle(
                      fontFamily: 'Outfit',
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textBlack,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _analysis.category,
                    style: const TextStyle(
                      fontFamily: 'Outfit',
                      fontSize: 14,
                      color: AppColors.textGray,
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Score Circle & Breakdown
                  _buildScoreSection(),
                  const SizedBox(height: 24),

                  // Summary Section
                  _buildSummarySection(),
                  const SizedBox(height: 24),

                  // Ingredients Section
                  _buildIngredientsSection(),
                  const SizedBox(height: 16),

                  // Collapsible Sections
                  _buildCollapsibleSection(
                    'Health Impact',
                    _analysis.healthImpact ?? '',
                    showHealthDetails: true,
                  ),
                  _buildCollapsibleSection(
                    'Possible Hidden Chemicals',
                    _analysis.hiddenChemicals ?? 'No hidden chemicals detected',
                    subtitle: _analysis.hiddenChemicals != null
                        ? '1 hidden chemical detected'
                        : null,
                  ),
                  _buildCollapsibleSection(
                    'How to Use',
                    _analysis.howToUse ?? '',
                  ),
                  _buildCollapsibleSection(
                    'The Good & Bad',
                    _analysis.goodAndBad ?? '',
                  ),
                  _buildCollapsibleSection(
                    'What it does?',
                    _analysis.whatItDoes ?? '',
                  ),
                  _buildCollapsibleSection(
                    'What People Are Saying',
                    _analysis.whatPeopleSay ?? '',
                  ),

                  // Scoring Method Link
                  _buildScoringMethodLink(),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProductImage() {
    return Container(
      height: 200,
      width: double.infinity,
      margin: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.lightGray,
        borderRadius: BorderRadius.circular(16),
      ),
      child: _analysis.productImagePath != null
          ? ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Image.file(
                File(_analysis.productImagePath!),
                fit: BoxFit.contain,
              ),
            )
          : const Icon(
              Icons.shopping_bag,
              size: 64,
              color: AppColors.textLightGray,
            ),
    );
  }

  Widget _buildScoreSection() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Score Circle
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: AppColors.getScoreColor(_analysis.overallScore),
              width: 6,
            ),
          ),
          child: Center(
            child: Text(
              _analysis.overallScore.toString(),
              style: TextStyle(
                fontFamily: 'Outfit',
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: AppColors.getScoreColor(_analysis.overallScore),
              ),
            ),
          ),
        ),
        const SizedBox(width: 24),
        // Score Breakdown
        Expanded(
          child: Column(
            children: [
              _buildScoreRow('Safety', _analysis.safetyScore),
              const SizedBox(height: 8),
              _buildScoreRow('Efficacy', _analysis.efficacyScore),
              const SizedBox(height: 8),
              _buildScoreRow('Transparency', _analysis.transparencyScore),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildScoreRow(String label, int score) {
    return Row(
      children: [
        Expanded(
          flex: 2,
          child: Text(
            label,
            style: const TextStyle(
              fontFamily: 'Outfit',
              fontSize: 13,
              color: AppColors.textDarkGray,
            ),
          ),
        ),
        Expanded(
          flex: 3,
          child: Stack(
            children: [
              Container(
                height: 6,
                decoration: BoxDecoration(
                  color: AppColors.lightGray,
                  borderRadius: BorderRadius.circular(3),
                ),
              ),
              FractionallySizedBox(
                widthFactor: score / 100,
                child: Container(
                  height: 6,
                  decoration: BoxDecoration(
                    color: AppColors.getScoreColor(score),
                    borderRadius: BorderRadius.circular(3),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 12),
        SizedBox(
          width: 30,
          child: Text(
            score.toString(),
            textAlign: TextAlign.right,
            style: const TextStyle(
              fontFamily: 'Outfit',
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: AppColors.textBlack,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSummarySection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Summary',
          style: TextStyle(
            fontFamily: 'Outfit',
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: AppColors.textBlack,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          _analysis.summary,
          style: const TextStyle(
            fontFamily: 'Outfit',
            fontSize: 14,
            color: AppColors.textDarkGray,
            height: 1.5,
          ),
        ),
      ],
    );
  }

  Widget _buildIngredientsSection() {
    final displayCount = _showAllIngredients ? _analysis.ingredients.length : 5;
    final ingredients = _analysis.ingredients.take(displayCount).toList();
    final remainingCount = _analysis.ingredients.length - 5;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.ingredientCardBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.ingredientCardBorder),
      ),
      child: Column(
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Ingredients',
                style: TextStyle(
                  fontFamily: 'Outfit',
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textBlack,
                ),
              ),
              if (_showAllIngredients)
                GestureDetector(
                  onTap: () => setState(() => _showAllIngredients = false),
                  child: const Text(
                    'See Less',
                    style: TextStyle(
                      fontFamily: 'Outfit',
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: AppColors.primaryGreen,
                    ),
                  ),
                )
              else
                const Text(
                  'See All',
                  style: TextStyle(
                    fontFamily: 'Outfit',
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: AppColors.primaryGreen,
                  ),
                ),
            ],
          ),
          const SizedBox(height: 12),

          // Ingredients List
          ...ingredients.map((ingredient) => _buildIngredientItem(ingredient)),

          // Show More Button
          if (!_showAllIngredients && remainingCount > 0) ...[
            const SizedBox(height: 8),
            SizedBox(
              width: double.infinity,
              height: 44,
              child: ElevatedButton(
                onPressed: () => setState(() => _showAllIngredients = true),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryGreen,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  '+ $remainingCount more Ingredients',
                  style: const TextStyle(
                    fontFamily: 'Outfit',
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.white,
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildIngredientItem(IngredientModel ingredient) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(color: AppColors.divider, width: 0.5),
        ),
      ),
      child: Row(
        children: [
          // Risk Level Indicator
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.getRiskColor(ingredient.riskLevel),
            ),
          ),
          const SizedBox(width: 12),
          // Ingredient Name & Risk Level
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  ingredient.name,
                  style: const TextStyle(
                    fontFamily: 'Outfit',
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textBlack,
                  ),
                ),
                Text(
                  '${ingredient.riskLevel} Risk',
                  style: TextStyle(
                    fontFamily: 'Outfit',
                    fontSize: 12,
                    color: AppColors.getRiskColor(ingredient.riskLevel),
                  ),
                ),
              ],
            ),
          ),
          // Info Button
          GestureDetector(
            onTap: () => _showIngredientDetails(ingredient),
            child: Container(
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                color: AppColors.primaryGreen.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.info_outline,
                size: 16,
                color: AppColors.primaryGreen,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showIngredientDetails(IngredientModel ingredient) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        decoration: const BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Handle bar
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.divider,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Close button
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  ingredient.name,
                  style: const TextStyle(
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
            const SizedBox(height: 16),

            // Risk Level Badge
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color:
                    AppColors.getRiskColor(ingredient.riskLevel).withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                ingredient.riskLevel,
                style: TextStyle(
                  fontFamily: 'Outfit',
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: AppColors.getRiskColor(ingredient.riskLevel),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Also Known As
            if (ingredient.alsoKnownAs != null) ...[
              Row(
                children: [
                  const Icon(Icons.check_circle,
                      size: 18, color: AppColors.primaryGreen),
                  const SizedBox(width: 8),
                  const Text(
                    'Also known as: ',
                    style: TextStyle(
                      fontFamily: 'Outfit',
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: AppColors.textDarkGray,
                    ),
                  ),
                  Text(
                    ingredient.alsoKnownAs!,
                    style: const TextStyle(
                      fontFamily: 'Outfit',
                      fontSize: 14,
                      color: AppColors.textGray,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
            ],

            // Why This Risk
            if (ingredient.whyThisRisk != null) ...[
              const Text(
                'Why this risk?',
                style: TextStyle(
                  fontFamily: 'Outfit',
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textBlack,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                ingredient.whyThisRisk!,
                style: const TextStyle(
                  fontFamily: 'Outfit',
                  fontSize: 14,
                  color: AppColors.textDarkGray,
                  height: 1.5,
                ),
              ),
            ],

            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildCollapsibleSection(
    String title,
    String content, {
    String? subtitle,
    bool showHealthDetails = false,
  }) {
    final isExpanded = _expandedSections[title] ?? false;

    return Column(
      children: [
        GestureDetector(
          onTap: () {
            setState(() {
              _expandedSections[title] = !isExpanded;
            });
          },
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 16),
            decoration: const BoxDecoration(
              border: Border(
                bottom: BorderSide(color: AppColors.divider, width: 0.5),
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
                          fontFamily: 'Outfit',
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textBlack,
                        ),
                      ),
                      if (subtitle != null && !isExpanded) ...[
                        const SizedBox(height: 4),
                        Text(
                          subtitle,
                          style: const TextStyle(
                            fontFamily: 'Outfit',
                            fontSize: 13,
                            color: AppColors.textGray,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                      if (!isExpanded && subtitle == null) ...[
                        const SizedBox(height: 4),
                        Text(
                          content,
                          style: const TextStyle(
                            fontFamily: 'Outfit',
                            fontSize: 13,
                            color: AppColors.textGray,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ],
                  ),
                ),
                Icon(
                  isExpanded
                      ? Icons.keyboard_arrow_up
                      : Icons.keyboard_arrow_down,
                  color: AppColors.textGray,
                ),
              ],
            ),
          ),
        ),
        if (isExpanded)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.only(bottom: 16),
            child: showHealthDetails
                ? _buildHealthImpactContent()
                : Text(
                    content,
                    style: const TextStyle(
                      fontFamily: 'Outfit',
                      fontSize: 14,
                      color: AppColors.textDarkGray,
                      height: 1.6,
                    ),
                  ),
          ),
      ],
    );
  }

  Widget _buildHealthImpactContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          _analysis.healthImpact ?? '',
          style: const TextStyle(
            fontFamily: 'Outfit',
            fontSize: 14,
            color: AppColors.textDarkGray,
            height: 1.6,
          ),
        ),
        if (_analysis.shortTermEffects != null) ...[
          const SizedBox(height: 16),
          const Text(
            'Short-Term Health Effects:',
            style: TextStyle(
              fontFamily: 'Outfit',
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppColors.textBlack,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            _analysis.shortTermEffects!,
            style: const TextStyle(
              fontFamily: 'Outfit',
              fontSize: 14,
              color: AppColors.textDarkGray,
              height: 1.6,
            ),
          ),
        ],
        if (_analysis.longTermEffects != null) ...[
          const SizedBox(height: 16),
          const Text(
            'Long-Term Health Effects:',
            style: TextStyle(
              fontFamily: 'Outfit',
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppColors.textBlack,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            _analysis.longTermEffects!,
            style: const TextStyle(
              fontFamily: 'Outfit',
              fontSize: 14,
              color: AppColors.textDarkGray,
              height: 1.6,
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildScoringMethodLink() {
    return GestureDetector(
      onTap: () => _showScoringModal(),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    'Scoring Method',
                    style: TextStyle(
                      fontFamily: 'Outfit',
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textBlack,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Our scoring system is designed to help you understand how safe and effective a product really is.',
                    style: TextStyle(
                      fontFamily: 'Outfit',
                      fontSize: 13,
                      color: AppColors.textGray,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: AppColors.textGray,
            ),
          ],
        ),
      ),
    );
  }

  void _showScoringModal() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const ScoringModal(),
    );
  }
}
