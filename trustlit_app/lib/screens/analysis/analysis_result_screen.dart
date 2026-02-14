import 'dart:io';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../widgets/animated_score_widgets.dart';
import '../../services/storage_service.dart';

/// Analysis Result Screen - Matches designs 27-37.png
/// Shows product image, scores (Safety/Efficacy/Transparency), Summary, 
/// Ingredients list with risk levels, and expandable sections
class AnalysisResultScreen extends StatefulWidget {
  final String? analysisId;
  final Map<String, dynamic>? analysisData;

  const AnalysisResultScreen({
    super.key, 
    this.analysisId,
    this.analysisData,
  });

  @override
  State<AnalysisResultScreen> createState() => _AnalysisResultScreenState();
}

class _AnalysisResultScreenState extends State<AnalysisResultScreen> {
  final StorageService _storageService = StorageService();
  Map<String, dynamic> _analysisData = {};
  bool _isLoading = true;
  bool _hasValidImage = false; // Cache file existence check to avoid blocking I/O in build

  final Map<String, bool> _expandedSections = {
    'healthImpact': false,
    'possibleHiddenChemicals': false,
    'howToUse': false,
    'goodAndBad': false,
    'whatItDoes': false,
    'whatPeopleSaying': false,
  };

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() {
    // If analysis data was passed via navigation, use it
    if (widget.analysisData != null && widget.analysisData!.isNotEmpty) {
      final imagePath = widget.analysisData!['imagePath'] as String?;
      setState(() {
        _analysisData = widget.analysisData!;
        _hasValidImage = imagePath != null && File(imagePath).existsSync();
        _isLoading = false;
      });
      return;
    }

    // Otherwise, try to load from storage using ID
    if (widget.analysisId != null) {
      try {
        final history = _storageService.getScanHistory();
        final scan = history.where((s) => s.id == widget.analysisId).firstOrNull;
        
        if (scan != null) {
          setState(() {
            _analysisData = {
              'productName': scan.productName,
              'category': scan.category,
              'overallScore': scan.overallScore,
              'safety': scan.overallScore,
              'efficacy': ((scan.overallScore * 1.1).clamp(0, 100)).toInt(),
              'transparency': ((scan.overallScore * 1.3).clamp(0, 100)).toInt(),
              'summary': 'Analysis details for ${scan.productName}',
              'ingredients': [],
            };
            _isLoading = false;
          });
          return;
        }
      } catch (e, st) {
        debugPrint('Error loading scan history: $e\n$st');
        // Fall through to default data
      }
    }

    // Fallback to default sample data for demo purposes
    setState(() {
      _analysisData = {
        'productName': 'Unknown Product',
        'category': 'Product',
        'overallScore': 50,
        'safety': 50,
        'efficacy': 60,
        'transparency': 70,
        'summary': 'No analysis data available.',
        'ingredients': [],
      };
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) {
          // Redirect to history instead of going back to camera flow
          context.go('/history');
        }
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        scrolledUnderElevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Color(0xFF1A1A1A)),
            onPressed: () => context.go('/history'),
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
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: Color(0xFF22C55E)))
          : SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product Image
            Center(
              child: Container(
                margin: const EdgeInsets.all(16),
                height: 220,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: const Color(0xFFF9FAFB),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: _hasValidImage
                      ? Image.file(
                          File(_analysisData['imagePath'] as String),
                          fit: BoxFit.contain,
                        )
                      : const Center(
                          child: Icon(
                            Icons.inventory_2_outlined,
                            size: 80,
                            color: Color(0xFF9CA3AF),
                          ),
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
                    _analysisData['productName'] as String? ?? 'Unknown Product',
                    style: const TextStyle(
                      fontFamily: 'Outfit',
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1A1A1A),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _analysisData['category'] as String? ?? 'Product',
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
                  // Animated Overall Score Circle
                  AnimatedCircularScore(
                    score: (_analysisData['overallScore'] as num?)?.toInt() ?? 50,
                    size: 80,
                    strokeWidth: 6,
                  ),
                  const SizedBox(width: 24),
                  // Animated Score Breakdown Bars
                  Expanded(
                    child: Column(
                      children: [
                        AnimatedScoreBar(label: 'Safety', score: (_analysisData['safetyScore'] as num?)?.toInt() ?? (_analysisData['safety'] as num?)?.toInt() ?? 50),
                        const SizedBox(height: 8),
                        AnimatedScoreBar(label: 'Efficacy', score: (_analysisData['efficacyScore'] as num?)?.toInt() ?? (_analysisData['efficacy'] as num?)?.toInt() ?? 50),
                        const SizedBox(height: 8),
                        AnimatedScoreBar(label: 'Transparency', score: (_analysisData['transparencyScore'] as num?)?.toInt() ?? (_analysisData['transparency'] as num?)?.toInt() ?? 50),
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
                    _analysisData['summary'] as String? ?? 'No summary available.',
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
              ingredients: (_analysisData['ingredients'] as List?)
                  ?.whereType<Map<String, dynamic>>()
                  .toList() ?? [],
              totalIngredients: (_analysisData['totalIngredients'] as num?)?.toInt() ?? 0,
            ),
            const SizedBox(height: 16),

            // Expandable Sections
            _ExpandableSection(
              title: 'Health Impact',
              subtitle: _analysisData['healthImpact'] as String? ?? 'No health impact data available.',
              isExpanded: _expandedSections['healthImpact']!,
              onTap: () => setState(() {
                _expandedSections['healthImpact'] = !_expandedSections['healthImpact']!;
              }),
            ),
            _ExpandableSection(
              title: 'Possible Hidden Chemicals',
              subtitle: _analysisData['hiddenChemicals'] as String? ?? 'No hidden chemicals detected.',
              isExpanded: _expandedSections['possibleHiddenChemicals']!,
              onTap: () => setState(() {
                _expandedSections['possibleHiddenChemicals'] = !_expandedSections['possibleHiddenChemicals']!;
              }),
            ),
            _ExpandableSection(
              title: 'How to Use',
              subtitle: _analysisData['howToUse'] as String? ?? 'Follow product directions.',
              isExpanded: _expandedSections['howToUse']!,
              onTap: () => setState(() {
                _expandedSections['howToUse'] = !_expandedSections['howToUse']!;
              }),
            ),
            _ExpandableSection(
              title: 'The Good & Bad',
              subtitle: _analysisData['goodAndBad'] as String? ?? 'No pros and cons data available.',
              isExpanded: _expandedSections['goodAndBad']!,
              onTap: () => setState(() {
                _expandedSections['goodAndBad'] = !_expandedSections['goodAndBad']!;
              }),
            ),
            _ExpandableSection(
              title: 'What it does?',
              subtitle: _analysisData['whatItDoes'] as String? ?? 'No product purpose data available.',
              isExpanded: _expandedSections['whatItDoes']!,
              onTap: () => setState(() {
                _expandedSections['whatItDoes'] = !_expandedSections['whatItDoes']!;
              }),
            ),
            _ExpandableSection(
              title: 'What People Are Saying',
              subtitle: _analysisData['whatPeopleSay'] as String? ?? 'No reviews available.',
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
    ),  // Close PopScope
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

/// Ingredients Section Widget - Matches RevealIt design with green outline border
class _IngredientsSection extends StatelessWidget {
  final List<Map<String, dynamic>> ingredients;
  final int totalIngredients;

  const _IngredientsSection({
    required this.ingredients,
    required this.totalIngredients,
  });

  Color _getRiskColor(String riskLevel) {
    switch (riskLevel.toLowerCase()) {
      case 'high':
        return const Color(0xFFEF4444); // Red
      case 'moderate':
      case 'medium':
        return const Color(0xFFF59E0B); // Orange/Yellow
      case 'low':
      default:
        return const Color(0xFF22C55E); // Green
    }
  }

  String _formatRiskLevel(String riskLevel) {
    final risk = riskLevel.toLowerCase();
    switch (risk) {
      case 'high':
        return 'High Risk';
      case 'moderate':
      case 'medium':
        return 'Medium Risk';
      case 'low':
      default:
        return 'Low Risk';
    }
  }

  @override
  Widget build(BuildContext context) {
    final displayIngredients = ingredients;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFF22C55E), // Green outline
          width: 2,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
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
              ],
            ),
          ),
          
          // Ingredients list with dividers
          ...displayIngredients.asMap().entries.map((entry) {
            final index = entry.key;
            final ingredient = entry.value;
            final name = ingredient['name'] as String? ?? 'Unknown';
            final riskLevel = ingredient['riskLevel'] as String? ?? 'Low';
            final riskColor = _getRiskColor(riskLevel);
            final riskText = _formatRiskLevel(riskLevel);
            final isLast = index == displayIngredients.length - 1;
            
            return Column(
              children: [
                if (index == 0) 
                  const Divider(height: 1, thickness: 1, color: Color(0xFFE5E7EB)),
                _IngredientRow(
                  name: name,
                  risk: riskText,
                  riskColor: riskColor,
                ),
                if (!isLast)
                  const Divider(height: 1, thickness: 1, indent: 16, endIndent: 16, color: Color(0xFFE5E7EB)),
              ],
            );
          }),
          
          const SizedBox(height: 8),
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
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
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
                const SizedBox(height: 4),
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
                        fontWeight: FontWeight.w500,
                        color: riskColor,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: () {
              // TODO: Show ingredient details modal
            },
            child: Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: const Color(0xFF22C55E),
                  width: 1.5,
                ),
              ),
              child: const Center(
                child: Text(
                  'i',
                  style: TextStyle(
                    fontFamily: 'Outfit',
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    fontStyle: FontStyle.italic,
                    color: Color(0xFF22C55E),
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
