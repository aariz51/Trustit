import 'package:hive_flutter/hive_flutter.dart';
import '../models/subscription_model.dart';
import '../models/scan_history_model.dart';

/// Storage Service for local data persistence using Hive
class StorageService {
  static const String _subscriptionBox = 'subscription';
  static const String _scanHistoryBox = 'scanHistory';
  static const String _settingsBox = 'settings';

  static final StorageService _instance = StorageService._internal();
  factory StorageService() => _instance;
  StorageService._internal();

  // ============ SUBSCRIPTION METHODS ============

  /// Get current subscription status
  SubscriptionModel getSubscription() {
    final box = Hive.box(_subscriptionBox);
    final data = box.get('current');
    if (data != null) {
      return SubscriptionModel.fromJson(Map<String, dynamic>.from(data));
    }
    return SubscriptionModel.free();
  }

  /// Save subscription status
  Future<void> saveSubscription(SubscriptionModel subscription) async {
    final box = Hive.box(_subscriptionBox);
    await box.put('current', subscription.toJson());
  }

  /// Clear subscription (for logout/restore)
  Future<void> clearSubscription() async {
    final box = Hive.box(_subscriptionBox);
    await box.delete('current');
  }

  // ============ SCAN HISTORY METHODS ============

  /// Get all scan history items
  List<ScanHistoryModel> getScanHistory() {
    final box = Hive.box(_scanHistoryBox);
    final items = <ScanHistoryModel>[];
    
    for (var i = 0; i < box.length; i++) {
      final data = box.getAt(i);
      if (data != null) {
        items.add(ScanHistoryModel.fromJson(Map<String, dynamic>.from(data)));
      }
    }
    
    // Sort by date, newest first
    items.sort((a, b) => b.scannedAt.compareTo(a.scannedAt));
    return items;
  }

  /// Add a new scan to history
  Future<void> addScanHistory(ScanHistoryModel scan) async {
    final box = Hive.box(_scanHistoryBox);
    await box.add(scan.toJson());
  }

  /// Delete a scan from history by ID
  Future<void> deleteScanHistory(String id) async {
    final box = Hive.box(_scanHistoryBox);
    
    for (var i = 0; i < box.length; i++) {
      final data = box.getAt(i);
      if (data != null && data['id'] == id) {
        await box.deleteAt(i);
        break;
      }
    }
  }

  /// Clear all scan history
  Future<void> clearScanHistory() async {
    final box = Hive.box(_scanHistoryBox);
    await box.clear();
  }

  /// Get scan count
  int getScanCount() {
    final box = Hive.box(_scanHistoryBox);
    return box.length;
  }

  // ============ SETTINGS METHODS ============

  /// Get a setting value
  T? getSetting<T>(String key, {T? defaultValue}) {
    final box = Hive.box(_settingsBox);
    return box.get(key, defaultValue: defaultValue) as T?;
  }

  /// Set a setting value
  Future<void> setSetting<T>(String key, T value) async {
    final box = Hive.box(_settingsBox);
    await box.put(key, value);
  }

  /// Check if this is the first app launch
  bool isFirstLaunch() {
    return getSetting<bool>('hasLaunched', defaultValue: false) != true;
  }

  /// Mark app as launched
  Future<void> markLaunched() async {
    await setSetting('hasLaunched', true);
  }

  /// Get notification preferences
  bool getNotificationsEnabled() {
    return getSetting<bool>('notificationsEnabled', defaultValue: true) ?? true;
  }

  /// Set notification preferences
  Future<void> setNotificationsEnabled(bool enabled) async {
    await setSetting('notificationsEnabled', enabled);
  }

  // ============ UTILITY METHODS ============

  /// Clear all local data
  Future<void> clearAllData() async {
    await clearSubscription();
    await clearScanHistory();
    final settingsBox = Hive.box(_settingsBox);
    await settingsBox.clear();
  }

  /// Get total storage size (approximate)
  int getStorageSize() {
    int size = 0;
    size += Hive.box(_subscriptionBox).length;
    size += Hive.box(_scanHistoryBox).length;
    size += Hive.box(_settingsBox).length;
    return size;
  }
}
