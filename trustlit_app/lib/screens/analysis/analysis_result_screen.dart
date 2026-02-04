import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Analysis Result Screen - Matches designs 27-37.png
/// Shows product image, scores (Safety/Efficacy/Transparency), Summary, 
/// Ingredients list with risk levels, and expandable sections
class AnalysisResultScreen extends StatefulWidget {
  final String? analysisId;

  const AnalysisResultScreen({super.key, this.analysisId});

  @override
  State<AnalysisResultScreen> createState() => _AnalysisResultScreenState();
}

class _AnalysisResultScreenState extends State<AnalysisResultScreen> {
  // Sample data - will be replaced with real data from API
  final Map<String, dynamic> _analysisData = {
    'productName': 'Great Value Corn Flakes',
    'category': 'Breakfast Cereal',
    'overallScore': 45,
    'scoreColor': const Color(0xFFF59E0B),
    'safety': 45,
    'efficacy': 60,
    'transparency': 90,
    'summary': 'Great Value Corn Flakes is a fortified breakfast cereal that provides quick energy and essential vitamins. The product contains added sugar, riboflavin as a colorant, and the preservative BHT, which contribute to a moderate risk profile. The overall safety score is lowered mainly by sugar, artificial color, and BHT. Nutritional value is decent, but the high sugar content limits its suitability for health-conscious consumers. Transparency is high because the ingredient list is clear, though some ingredients are inferred based on typical brand formulations.',
    'ingredients': [
      {'name': 'Maïs moulu', 'risk': 'Low Risk', 'riskColor': const Color(0xFF22C55E)},
      {'name': 'Extrait d\'orge maltée', 'risk': 'Low Risk', 'riskColor': const Color(0xFF22C55E)},
      {'name': 'Sel', 'risk': 'Low Risk', 'riskColor': const Color(0xFF22C55E)},
      {'name': 'Riboflavine (pour la couleur)', 'risk': 'Low Risk', 'riskColor': const Color(0xFF22C55E)},
      {'name': 'Fer', 'risk': 'Low Risk', 'riskColor': const Color(0xFF22C55E)},
    ],
    'totalIngredients': 15,
    'hiddenChemicals': 1,
  };

  final Map<String, bool> _expandedSections = {
    'healthImpact': false,
    'possibleHiddenChemicals': false,
    'howToUse': false,
    'goodAndBad': false,
    'whatItDoes': false,
    'whatPeopleSaying': false,
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF1A1A1A)),
          onPressed: () => context.pop(),
        ),
        centerTitle: true,
        title: RichText(
          text: const TextSpan(
            style: TextStyle(
              fontFamily: 'Outfit',
              fontSize: 22,
              fontWeight: FontWeight.w600,
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
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product Image
            Center(
              child: Container(
                margin: const EdgeInsets.all(16),
                height: 200,
                decoration: BoxDecoration(
                  color: const Color(0xFFF9FAFB),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Center(
                  child: Icon(
                    Icons.inventory_2_outlined,
                    size: 80,
                    color: Color(0xFF9CA3AF),
                  ),
                ),
              ),
            ),

            // Product Name and Category
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _analysisData['productName'],
                    style: const TextStyle(
                      fontFamily: 'Outfit',
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1A1A1A),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _analysisData['category'],
                    style: const TextStyle(
                      fontFamily: 'Outfit',
                      fontSize: 16,
                      color: Color(0xFF6B7280),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Score Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Overall Score Circle
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: _analysisData['scoreColor'],
                        width: 4,
                      ),
                    ),
                    child: Center(
                      child: Text(
                        '${_analysisData['overallScore']}',
                        style: TextStyle(
                          fontFamily: 'Outfit',
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: _analysisData['scoreColor'],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 24),
                  // Score Breakdown
                  Expanded(
                    child: Column(
                      children: [
                        _ScoreRow(label: 'Safety', score: _analysisData['safety']),
                        _ScoreRow(label: 'Efficacy', score: _analysisData['efficacy']),
                        _ScoreRow(label: 'Transparency', score: _analysisData['transparency']),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Summary Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Summary',
                    style: TextStyle(
                      fontFamily: 'Outfit',
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF1A1A1A),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _analysisData['summary'],
                    style: const TextStyle(
                      fontFamily: 'Outfit',
                      fontSize: 14,
                      color: Color(0xFF4B5563),
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Ingredients Section
            _IngredientsSection(
              ingredients: List<Map<String, dynamic>>.from(_analysisData['ingredients']),
              totalIngredients: _analysisData['totalIngredients'],
            ),
            const SizedBox(height: 16),

            // Expandable Sections
            _ExpandableSection(
              title: 'Health Impact',
              subtitle: 'Great Value Corn Flakes is a fortified breakfast cereal that provides quick energy and essential vitamins. Th...',
              isExpanded: _expandedSections['healthImpact']!,
              onTap: () => setState(() {
                _expandedSections['healthImpact'] = !_expandedSections['healthImpact']!;
              }),
            ),
            _ExpandableSection(
              title: 'Possible Hidden Chemicals',
              subtitle: '${_analysisData['hiddenChemicals']} hidden chemical detected',
              isExpanded: _expandedSections['possibleHiddenChemicals']!,
              onTap: () => setState(() {
                _expandedSections['possibleHiddenChemicals'] = !_expandedSections['possibleHiddenChemicals']!;
              }),
            ),
            _ExpandableSection(
              title: 'How to Use',
              subtitle: 'Pour desired portion into a bowl, add milk or a non-dairy alternative, and serve immediately.',
              isExpanded: _expandedSections['howToUse']!,
              onTap: () => setState(() {
                _expandedSections['howToUse'] = !_expandedSections['howToUse']!;
              }),
            ),
            _ExpandableSection(
              title: 'The Good & Bad',
              subtitle: 'Good as a quick breakfast option, but high in sugar and contains a preservative.',
              isExpanded: _expandedSections['goodAndBad']!,
              onTap: () => setState(() {
                _expandedSections['goodAndBad'] = !_expandedSections['goodAndBad']!;
              }),
            ),
            _ExpandableSection(
              title: 'What it does?',
              subtitle: 'Provides rapid energy from carbohydrates and supplies fortified vitamins and minerals.',
              isExpanded: _expandedSections['whatItDoes']!,
              onTap: () => setState(() {
                _expandedSections['whatItDoes'] = !_expandedSections['whatItDoes']!;
              }),
            ),
            _ExpandableSection(
              title: 'What People Are Saying',
              subtitle: 'Generally well-liked for taste and convenience, though some consumers note the high sugar content and pre...',
              isExpanded: _expandedSections['whatPeopleSaying']!,
              onTap: () => setState(() {
                _expandedSections['whatPeopleSaying'] = !_expandedSections['whatPeopleSaying']!;
              }),
            ),

            // Scoring Method Link
            GestureDetector(
              onTap: () => _showScoringMethodModal(context),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Scoring Method',
                      style: TextStyle(
                        fontFamily: 'Outfit',
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF1A1A1A),
                      ),
                    ),
                    const Icon(
                      Icons.chevron_right,
                      color: Color(0xFF9CA3AF),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  void _showScoringMethodModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => const _ScoringMethodModal(),
    );
  }
}

/// Score Row Widget
class _ScoreRow extends StatelessWidget {
  final String label;
  final int score;

  const _ScoreRow({required this.label, required this.score});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontFamily: 'Outfit',
              fontSize: 14,
              color: Color(0xFF6B7280),
            ),
          ),
          Text(
            '$score',
            style: const TextStyle(
              fontFamily: 'Outfit',
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Color(0xFF1A1A1A),
            ),
          ),
        ],
      ),
    );
  }
}

/// Ingredients Section Widget - Matches design with yellow/green background
class _IngredientsSection extends StatelessWidget {
  final List<Map<String, dynamic>> ingredients;
  final int totalIngredients;

  const _IngredientsSection({
    required this.ingredients,
    required this.totalIngredients,
  });

  @override
  Widget build(BuildContext context) {
    final remainingCount = totalIngredients - ingredients.length;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFFEF9C3),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Ingredients',
                style: TextStyle(
                  fontFamily: 'Outfit',
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF1A1A1A),
                ),
              ),
              GestureDetector(
                onTap: () {
                  // Navigate to full ingredients list
                },
                child: const Text(
                  'See All',
                  style: TextStyle(
                    fontFamily: 'Outfit',
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF22C55E),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ...ingredients.map((ingredient) => _IngredientRow(
                name: ingredient['name'],
                risk: ingredient['risk'],
                riskColor: ingredient['riskColor'],
              )),
          if (remainingCount > 0) ...[
            const SizedBox(height: 8),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF22C55E),
                  foregroundColor: Colors.white,
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                ),
                child: Text(
                  '+ $remainingCount more Ingredients',
                  style: const TextStyle(
                    fontFamily: 'Outfit',
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

/// Individual Ingredient Row
class _IngredientRow extends StatelessWidget {
  final String name;
  final String risk;
  final Color riskColor;

  const _IngredientRow({
    required this.name,
    required this.risk,
    required this.riskColor,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    fontFamily: 'Outfit',
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF1A1A1A),
                  ),
                ),
                const SizedBox(height: 2),
                Row(
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: riskColor,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      risk,
                      style: TextStyle(
                        fontFamily: 'Outfit',
                        fontSize: 12,
                        color: riskColor,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const Icon(
            Icons.info_outline,
            size: 20,
            color: Color(0xFF9CA3AF),
          ),
        ],
      ),
    );
  }
}

/// Expandable Section Widget
class _ExpandableSection extends StatelessWidget {
  final String title;
  final String subtitle;
  final bool isExpanded;
  final VoidCallback onTap;

  const _ExpandableSection({
    required this.title,
    required this.subtitle,
    required this.isExpanded,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: const BoxDecoration(
          border: Border(
            bottom: BorderSide(color: Color(0xFFE5E7EB)),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                Icon(
                  isExpanded ? Icons.expand_less : Icons.expand_more,
                  color: const Color(0xFF9CA3AF),
                ),
              ],
            ),
            if (!isExpanded) ...[
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: const TextStyle(
                  fontFamily: 'Outfit',
                  fontSize: 14,
                  color: Color(0xFF6B7280),
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
            if (isExpanded) ...[
              const SizedBox(height: 8),
              Text(
                subtitle,
                style: const TextStyle(
                  fontFamily: 'Outfit',
                  fontSize: 14,
                  color: Color(0xFF6B7280),
                  height: 1.5,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// Scoring Method Modal - Matches design 38-39.png
class _ScoringMethodModal extends StatelessWidget {
  const _ScoringMethodModal();

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.9,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      expand: false,
      builder: (context, scrollController) {
        return SingleChildScrollView(
          controller: scrollController,
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Scoring Method',
                    style: TextStyle(
                      fontFamily: 'Outfit',
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF1A1A1A),
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              const Text(
                'Our scoring system is designed to help you understand how safe and effective a product really is.',
                style: TextStyle(
                  fontFamily: 'Outfit',
                  fontSize: 14,
                  color: Color(0xFF6B7280),
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 24),

              // Safety Levels Box
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFFF9FAFB),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Safety Levels',
                      style: TextStyle(
                        fontFamily: 'Outfit',
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF1A1A1A),
                      ),
                    ),
                    const SizedBox(height: 12),
                    _SafetyLevelRow(
                      color: const Color(0xFF22C55E),
                      label: 'Excellent',
                      range: '(76 - 100)',
                    ),
                    _SafetyLevelRow(
                      color: const Color(0xFFFBBF24),
                      label: 'Good',
                      range: '(51 - 75)',
                    ),
                    _SafetyLevelRow(
                      color: const Color(0xFFF59E0B),
                      label: 'Not great',
                      range: '(26 - 50)',
                    ),
                    _SafetyLevelRow(
                      color: const Color(0xFFEF4444),
                      label: 'Bad',
                      range: '(0 - 25)',
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
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF1A1A1A),
                ),
              ),
              const SizedBox(height: 12),
              _BulletPoint(text: 'Safety (40%) – Evaluates the risk level of each ingredient based on scientific data.'),
              _BulletPoint(text: 'Efficacy (40%) – Measures how well the product\'s active ingredients support its intended benefits.'),
              _BulletPoint(text: 'Transparency (20%) – Reflects how clearly a brand lists its ingredients and formulation details.'),
              const SizedBox(height: 8),
              const Text(
                'Together, these determine the overall score out of 100.',
                style: TextStyle(
                  fontFamily: 'Outfit',
                  fontSize: 14,
                  color: Color(0xFF6B7280),
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
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF1A1A1A),
                ),
              ),
              const SizedBox(height: 12),
              _BulletPoint(text: 'Allergy Risk – Estimates probability of allergic reactions from known sensitizers or irritants.'),
              _BulletPoint(text: 'High-Concentration Allergen – Evaluates whether an ingredient becomes unsafe at higher usage levels.'),
              _BulletPoint(text: 'Carcinogenicity – Measures potential risk of contributing to cancer formation.'),
              _BulletPoint(text: 'Endocrine Disruptor Risk – Assesses hormonal toxicity or interference.'),
              const SizedBox(height: 32),
            ],
          ),
        );
      },
    );
  }
}

class _SafetyLevelRow extends StatelessWidget {
  final Color color;
  final String label;
  final String range;

  const _SafetyLevelRow({
    required this.color,
    required this.label,
    required this.range,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 8),
          Text(
            label,
            style: const TextStyle(
              fontFamily: 'Outfit',
              fontSize: 14,
              color: Color(0xFF1A1A1A),
            ),
          ),
          const SizedBox(width: 4),
          Text(
            range,
            style: const TextStyle(
              fontFamily: 'Outfit',
              fontSize: 14,
              color: Color(0xFF6B7280),
            ),
          ),
        ],
      ),
    );
  }
}

class _BulletPoint extends StatelessWidget {
  final String text;

  const _BulletPoint({required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('• ', style: TextStyle(fontSize: 14)),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                fontFamily: 'Outfit',
                fontSize: 14,
                color: Color(0xFF4B5563),
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
