/// Ingredient Model
/// Represents a single ingredient in the analysis
class IngredientModel {
  final String name;
  final String riskLevel; // "Low", "Medium", "High"
  final String? alsoKnownAs;
  final String? whyThisRisk;
  final String? description;

  IngredientModel({
    required this.name,
    required this.riskLevel,
    this.alsoKnownAs,
    this.whyThisRisk,
    this.description,
  });

  /// Check if this is a low risk ingredient
  bool get isLowRisk => riskLevel.toLowerCase() == 'low';

  /// Check if this is a medium risk ingredient
  bool get isMediumRisk => riskLevel.toLowerCase() == 'medium';

  /// Check if this is a high risk ingredient
  bool get isHighRisk => riskLevel.toLowerCase() == 'high';

  factory IngredientModel.fromJson(Map<String, dynamic> json) {
    return IngredientModel(
      name: json['name'] as String? ?? 'Unknown',
      riskLevel: json['riskLevel'] as String? ?? 'Low',
      alsoKnownAs: json['alsoKnownAs'] as String?,
      whyThisRisk: json['whyThisRisk'] as String?,
      description: json['description'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'riskLevel': riskLevel,
      'alsoKnownAs': alsoKnownAs,
      'whyThisRisk': whyThisRisk,
      'description': description,
    };
  }
}
