import 'analysis_result_model.dart';

/// Scan History Model
/// Represents a scanned product in history
class ScanHistoryModel {
  final String id;
  final String productName;
  final String category;
  final int overallScore;
  final String ratingLabel;
  final String? thumbnailPath;
  final AnalysisResultModel? fullAnalysis;
  final DateTime scannedAt;

  ScanHistoryModel({
    required this.id,
    required this.productName,
    required this.category,
    required this.overallScore,
    required this.ratingLabel,
    this.thumbnailPath,
    this.fullAnalysis,
    required this.scannedAt,
  });

  /// Get rating label based on score
  static String getRatingFromScore(int score) {
    if (score >= 76) return 'Excellent';
    if (score >= 51) return 'Good';
    if (score >= 26) return 'Average';
    return 'Bad';
  }

  factory ScanHistoryModel.fromJson(Map<String, dynamic> json) {
    return ScanHistoryModel(
      id: json['id'] as String,
      productName: json['productName'] as String,
      category: json['category'] as String,
      overallScore: json['overallScore'] as int,
      ratingLabel: json['ratingLabel'] as String,
      thumbnailPath: json['thumbnailPath'] as String?,
      fullAnalysis: json['fullAnalysis'] != null
          ? AnalysisResultModel.fromJson(json['fullAnalysis'])
          : null,
      scannedAt: DateTime.parse(json['scannedAt'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'productName': productName,
      'category': category,
      'overallScore': overallScore,
      'ratingLabel': ratingLabel,
      'thumbnailPath': thumbnailPath,
      'fullAnalysis': fullAnalysis?.toJson(),
      'scannedAt': scannedAt.toIso8601String(),
    };
  }
}
