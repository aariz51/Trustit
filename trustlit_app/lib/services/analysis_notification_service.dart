import 'dart:async';
import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../services/storage_service.dart';
import '../models/scan_history_model.dart';
import '../models/analysis_result_model.dart';
import '../models/ingredient_model.dart';

/// Service to manage background analysis with notification bar
class AnalysisNotificationService extends ChangeNotifier {
  static final AnalysisNotificationService _instance = AnalysisNotificationService._internal();
  factory AnalysisNotificationService() => _instance;
  AnalysisNotificationService._internal();

  final StorageService _storageService = StorageService();

  bool _isAnalyzing = false;
  double _progress = 0.0;
  int _elapsedSeconds = 0;
  String _statusText = 'Analyzing your image for ingredients...';
  Map<String, dynamic>? _analysisResult;
  Timer? _timer;
  bool _isComplete = false;
  bool _isDismissed = false;
  String? _frontImagePath;

  // Getters
  bool get isAnalyzing => _isAnalyzing;
  double get progress => _progress;
  int get elapsedSeconds => _elapsedSeconds;
  String get statusText => _statusText;
  Map<String, dynamic>? get analysisResult => _analysisResult;
  bool get isComplete => _isComplete;
  bool get isDismissed => _isDismissed;
  bool get shouldShowNotification => (_isAnalyzing || _isComplete) && !_isDismissed;

  /// Start background analysis
  Future<void> startAnalysis({
    required String? frontImagePath,
    required String? backImagePath,
  }) async {
    _frontImagePath = frontImagePath;
    _isAnalyzing = true;
    _isComplete = false;
    _isDismissed = false;
    _progress = 0.0;
    _elapsedSeconds = 0;
    _statusText = 'Analyzing your image for ingredients...';
    _analysisResult = null;
    notifyListeners();

    // Validate images
    if (frontImagePath == null || backImagePath == null) {
      _isAnalyzing = false;
      _statusText = 'Missing image files.';
      notifyListeners();
      Future.delayed(const Duration(seconds: 3), () {
        dismiss();
      });
      return;
    }

    // Start timer for elapsed seconds
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _elapsedSeconds++;
      // Simulate progress (max 90% until actual result)
      if (_progress < 0.9 && !_isComplete) {
        _progress += 0.03;
        if (_progress > 0.9) _progress = 0.9;
      }
      notifyListeners();
    });

    // Call API
    try {
      final response = await ApiService().analyzeProduct(
        frontImagePath: frontImagePath,
        backImagePath: backImagePath,
      );
      
      if (response.success && response.data != null) {
        // Add image path to the result data
        final resultData = Map<String, dynamic>.from(response.data!);
        resultData['imagePath'] = frontImagePath;
        
        _analysisResult = resultData;
        _isComplete = true;
        _isAnalyzing = false;
        _progress = 1.0;
        _statusText = 'Analysis complete! Tap to view results.';
        _timer?.cancel();
        
        // Save to history
        await _saveToHistory(resultData);
        
        notifyListeners();

        // Auto-dismiss after 10 seconds if not tapped
        Future.delayed(const Duration(seconds: 10), () {
          if (!_isDismissed && _isComplete) {
            dismiss();
          }
        });
      } else {
        _isAnalyzing = false;
        _isComplete = false;
        _statusText = response.error ?? 'Analysis failed. Please try again.';
        _timer?.cancel();
        notifyListeners();
        
        // Auto-dismiss on error after 5 seconds
        Future.delayed(const Duration(seconds: 5), () {
          dismiss();
        });
      }
    } catch (e) {
      _isAnalyzing = false;
      _isComplete = false;
      _statusText = 'Analysis failed. Please try again.';
      _timer?.cancel();
      notifyListeners();
      
      // Auto-dismiss on error after 5 seconds
      Future.delayed(const Duration(seconds: 5), () {
        dismiss();
      });
    }
  }

  /// Save analysis result to history
  Future<void> _saveToHistory(Map<String, dynamic> resultData) async {
    try {
      final productName = resultData['productName'] as String? ?? 'Unknown Product';
      final category = resultData['category'] as String? ?? 'Product';
      final overallScore = (resultData['overallScore'] as num?)?.toInt() ?? 50;
      final ratingLabel = ScanHistoryModel.getRatingFromScore(overallScore);
      
      // Create ingredients list from result data
      final ingredientsList = (resultData['ingredients'] as List<dynamic>?)
          ?.map((e) => IngredientModel.fromJson(e as Map<String, dynamic>))
          .toList() ?? [];
      
      // Create full analysis model
      final fullAnalysis = AnalysisResultModel(
        productName: productName,
        category: category,
        overallScore: overallScore,
        safetyScore: (resultData['safetyScore'] as num?)?.toInt() ?? overallScore,
        efficacyScore: (resultData['efficacyScore'] as num?)?.toInt() ?? overallScore,
        transparencyScore: (resultData['transparencyScore'] as num?)?.toInt() ?? overallScore,
        summary: resultData['summary'] as String? ?? '',
        ingredients: ingredientsList,
        healthImpact: resultData['healthImpact'] as String?,
        hiddenChemicals: resultData['hiddenChemicals'] as String?,
        howToUse: resultData['howToUse'] as String?,
        goodAndBad: resultData['goodAndBad'] as String?,
        whatItDoes: resultData['whatItDoes'] as String?,
        whatPeopleSay: resultData['whatPeopleSay'] as String?,
        productImagePath: _frontImagePath,
      );
      
      final scanHistory = ScanHistoryModel(
        id: 'scan_${DateTime.now().millisecondsSinceEpoch}',
        productName: productName,
        category: category,
        overallScore: overallScore,
        ratingLabel: ratingLabel,
        thumbnailPath: _frontImagePath,
        fullAnalysis: fullAnalysis,
        scannedAt: DateTime.now(),
      );
      
      await _storageService.addScanHistory(scanHistory);
    } catch (e) {
      debugPrint('Error saving to history: $e');
    }
  }

  /// Dismiss the notification
  void dismiss() {
    _isDismissed = true;
    _isAnalyzing = false;
    _timer?.cancel();
    notifyListeners();
  }

  /// Reset state
  void reset() {
    _isAnalyzing = false;
    _isComplete = false;
    _isDismissed = false;
    _progress = 0.0;
    _elapsedSeconds = 0;
    _analysisResult = null;
    _frontImagePath = null;
    _timer?.cancel();
    notifyListeners();
  }
}
