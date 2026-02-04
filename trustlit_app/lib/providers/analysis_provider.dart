import 'package:flutter/foundation.dart';
import '../models/analysis_result_model.dart';
import '../models/ingredient_model.dart';
import '../models/scan_history_model.dart';
import '../services/api_service.dart';
import '../services/storage_service.dart';

/// Analysis Provider
/// Manages current analysis state, API calls, and loading status
class AnalysisProvider extends ChangeNotifier {
  final ApiService _apiService = ApiService();
  final StorageService _storageService = StorageService();

  AnalysisResultModel? _currentAnalysis;
  bool _isLoading = false;
  String? _error;
  String? _currentAnalysisId;

  AnalysisResultModel? get currentAnalysis => _currentAnalysis;
  bool get isLoading => _isLoading;
  String? get error => _error;
  String? get currentAnalysisId => _currentAnalysisId;

  /// Initialize API service
  void initialize() {
    _apiService.initialize();
  }

  void setLoading(bool loading) {
    _isLoading = loading;
    if (loading) _error = null;
    notifyListeners();
  }

  void setAnalysis(AnalysisResultModel analysis) {
    _currentAnalysis = analysis;
    _isLoading = false;
    _error = null;
    notifyListeners();
  }

  void setError(String error) {
    _error = error;
    _isLoading = false;
    notifyListeners();
  }

  void clear() {
    _currentAnalysis = null;
    _isLoading = false;
    _error = null;
    _currentAnalysisId = null;
    notifyListeners();
  }

  /// Analyze product images using the backend API
  Future<bool> analyzeProduct({
    required String frontImagePath,
    required String backImagePath,
    String productType = 'food',
  }) async {
    setLoading(true);

    try {
      final response = await _apiService.analyzeProduct(
        frontImagePath: frontImagePath,
        backImagePath: backImagePath,
        productType: productType,
      );

      if (response.success && response.data != null) {
        final data = response.data!;
        _currentAnalysisId = response.analysisId;

        // Parse ingredients
        final ingredients = <IngredientModel>[];
        if (data['ingredients'] != null) {
          for (final ing in data['ingredients'] as List) {
            ingredients.add(IngredientModel(
              name: ing['name'] ?? '',
              riskLevel: ing['riskLevel'] ?? 'Low',
              alsoKnownAs: ing['alsoKnownAs'],
              whyThisRisk: ing['whyThisRisk'],
              description: ing['description'],
            ));
          }
        }

        // Create analysis result
        final analysis = AnalysisResultModel(
          productName: data['productName'] ?? 'Unknown Product',
          category: data['category'] ?? productType,
          overallScore: data['overallScore'] ?? 50,
          safetyScore: data['safetyScore'] ?? 50,
          efficacyScore: data['efficacyScore'] ?? 50,
          transparencyScore: data['transparencyScore'] ?? 50,
          summary: data['summary'] ?? '',
          ingredients: ingredients,
          healthImpact: data['healthImpact'],
          shortTermEffects: data['shortTermEffects'],
          longTermEffects: data['longTermEffects'],
          hiddenChemicals: data['hiddenChemicals'],
          howToUse: data['howToUse'],
          goodAndBad: data['goodAndBad'],
          whatItDoes: data['whatItDoes'],
          whatPeopleSay: data['whatPeopleSay'],
          productImagePath: frontImagePath,
        );

        setAnalysis(analysis);

        // Save to history
        await _saveToHistory(
          analysis: analysis,
          frontImagePath: frontImagePath,
          backImagePath: backImagePath,
        );

        return true;
      } else {
        setError(response.error ?? 'Analysis failed');
        return false;
      }
    } catch (e) {
      setError('Error analyzing product: $e');
      return false;
    }
  }

  /// Save successful analysis to scan history
  Future<void> _saveToHistory({
    required AnalysisResultModel analysis,
    required String frontImagePath,
    required String backImagePath,
  }) async {
    final historyItem = ScanHistoryModel(
      id: _currentAnalysisId ?? DateTime.now().millisecondsSinceEpoch.toString(),
      productName: analysis.productName,
      category: analysis.category,
      overallScore: analysis.overallScore,
      ratingLabel: ScanHistoryModel.getRatingFromScore(analysis.overallScore),
      thumbnailPath: frontImagePath,
      scannedAt: DateTime.now(),
    );

    await _storageService.addScanHistory(historyItem);
  }

  /// Check if backend is reachable
  Future<bool> checkBackendHealth() async {
    final response = await _apiService.healthCheck();
    return response.success;
  }

  @override
  void dispose() {
    _apiService.dispose();
    super.dispose();
  }
}
