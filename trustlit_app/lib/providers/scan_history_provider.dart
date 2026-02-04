import 'package:flutter/foundation.dart';
import '../models/scan_history_model.dart';
import '../services/storage_service.dart';

/// Scan History Provider
/// Manages the list of scanned products with Hive persistence
class ScanHistoryProvider extends ChangeNotifier {
  final StorageService _storageService = StorageService();
  List<ScanHistoryModel> _history = [];
  bool _isLoaded = false;

  List<ScanHistoryModel> get history => _history;

  bool get isEmpty => _history.isEmpty;

  int get count => _history.length;

  bool get isLoaded => _isLoaded;

  /// Load history from local storage
  Future<void> loadHistory() async {
    if (_isLoaded) return;
    
    try {
      _history = _storageService.getScanHistory();
      _isLoaded = true;
      notifyListeners();
    } catch (e) {
      debugPrint('Error loading scan history: $e');
    }
  }

  /// Add a new scan to history
  Future<void> addScan(ScanHistoryModel scan) async {
    try {
      await _storageService.addScanHistory(scan);
      _history.insert(0, scan);
      notifyListeners();
    } catch (e) {
      debugPrint('Error adding scan: $e');
    }
  }

  /// Remove a scan from history
  Future<void> removeScan(String id) async {
    try {
      await _storageService.deleteScanHistory(id);
      _history.removeWhere((scan) => scan.id == id);
      notifyListeners();
    } catch (e) {
      debugPrint('Error removing scan: $e');
    }
  }

  /// Clear all history
  Future<void> clearHistory() async {
    try {
      await _storageService.clearScanHistory();
      _history.clear();
      notifyListeners();
    } catch (e) {
      debugPrint('Error clearing history: $e');
    }
  }

  /// Refresh history from storage
  Future<void> refreshHistory() async {
    try {
      _history = _storageService.getScanHistory();
      notifyListeners();
    } catch (e) {
      debugPrint('Error refreshing history: $e');
    }
  }

  /// Get scan by ID
  ScanHistoryModel? getScanById(String id) {
    try {
      return _history.firstWhere((scan) => scan.id == id);
    } catch (_) {
      return null;
    }
  }

  /// Get recent scans (last N items)
  List<ScanHistoryModel> getRecentScans(int count) {
    return _history.take(count).toList();
  }
}
