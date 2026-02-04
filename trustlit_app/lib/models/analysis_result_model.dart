import 'ingredient_model.dart';

/// Analysis Result Model
/// Represents the full analysis result from the API
class AnalysisResultModel {
  final String productName;
  final String category;
  final int overallScore;
  final int safetyScore;
  final int efficacyScore;
  final int transparencyScore;
  final String summary;
  final List<IngredientModel> ingredients;
  final String? healthImpact;
  final String? shortTermEffects;
  final String? longTermEffects;
  final String? hiddenChemicals;
  final String? howToUse;
  final String? goodAndBad;
  final String? whatItDoes;
  final String? whatPeopleSay;
  final String? productImagePath;

  AnalysisResultModel({
    required this.productName,
    required this.category,
    required this.overallScore,
    required this.safetyScore,
    required this.efficacyScore,
    required this.transparencyScore,
    required this.summary,
    required this.ingredients,
    this.healthImpact,
    this.shortTermEffects,
    this.longTermEffects,
    this.hiddenChemicals,
    this.howToUse,
    this.goodAndBad,
    this.whatItDoes,
    this.whatPeopleSay,
    this.productImagePath,
  });

  /// Get rating label based on overall score
  String get ratingLabel {
    if (overallScore >= 76) return 'Excellent';
    if (overallScore >= 51) return 'Good';
    if (overallScore >= 26) return 'Average';
    return 'Bad';
  }

  factory AnalysisResultModel.fromJson(Map<String, dynamic> json) {
    return AnalysisResultModel(
      productName: json['productName'] as String? ?? 'Unknown Product',
      category: json['category'] as String? ?? 'General',
      overallScore: json['overallScore'] as int? ?? 0,
      safetyScore: json['safetyScore'] as int? ?? 0,
      efficacyScore: json['efficacyScore'] as int? ?? 0,
      transparencyScore: json['transparencyScore'] as int? ?? 0,
      summary: json['summary'] as String? ?? '',
      ingredients: (json['ingredients'] as List<dynamic>?)
              ?.map((e) => IngredientModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      healthImpact: json['healthImpact'] as String?,
      shortTermEffects: json['shortTermEffects'] as String?,
      longTermEffects: json['longTermEffects'] as String?,
      hiddenChemicals: json['hiddenChemicals'] as String?,
      howToUse: json['howToUse'] as String?,
      goodAndBad: json['goodAndBad'] as String?,
      whatItDoes: json['whatItDoes'] as String?,
      whatPeopleSay: json['whatPeopleSay'] as String?,
      productImagePath: json['productImagePath'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'productName': productName,
      'category': category,
      'overallScore': overallScore,
      'safetyScore': safetyScore,
      'efficacyScore': efficacyScore,
      'transparencyScore': transparencyScore,
      'summary': summary,
      'ingredients': ingredients.map((e) => e.toJson()).toList(),
      'healthImpact': healthImpact,
      'shortTermEffects': shortTermEffects,
      'longTermEffects': longTermEffects,
      'hiddenChemicals': hiddenChemicals,
      'howToUse': howToUse,
      'goodAndBad': goodAndBad,
      'whatItDoes': whatItDoes,
      'whatPeopleSay': whatPeopleSay,
      'productImagePath': productImagePath,
    };
  }
}
