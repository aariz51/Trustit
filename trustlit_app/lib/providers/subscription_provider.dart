import 'package:flutter/foundation.dart';
import '../models/subscription_model.dart';
import '../services/subscription_service.dart';
import '../services/storage_service.dart';

/// Subscription Provider
/// Manages subscription state for in-app purchases with service integration
class SubscriptionProvider extends ChangeNotifier {
  final SubscriptionService _subscriptionService = SubscriptionService();
  final StorageService _storageService = StorageService();

  SubscriptionModel _subscription = SubscriptionModel.free();
  bool _isLoading = false;
  String? _error;
  bool _isInitialized = false;

  SubscriptionModel get subscription => _subscription;
  bool get isActive => _subscription.isActive;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get isLifetime => _subscription.isLifetime;
  bool get isYearly => _subscription.isYearly;
  bool get isInitialized => _isInitialized;

  String? get productId => _subscription.productId;
  DateTime? get purchaseDate => _subscription.purchaseDate;
  DateTime? get expiryDate => _subscription.expiryDate;

  /// Initialize subscription service and load stored subscription
  Future<void> initialize() async {
    if (_isInitialized) return;

    try {
      // Load stored subscription first
      _subscription = _storageService.getSubscription();

      // Check if expired
      if (_subscription.isActive && _subscription.expiryDate != null) {
        if (_subscription.expiryDate!.isBefore(DateTime.now())) {
          // Subscription expired
          _subscription = SubscriptionModel.free();
          await _storageService.saveSubscription(_subscription);
        }
      }

      // Initialize in-app purchase service
      await _subscriptionService.initialize();
      _isInitialized = true;
      notifyListeners();
    } catch (e) {
      debugPrint('Subscription initialization error: $e');
      _error = 'Failed to initialize subscriptions';
      _isInitialized = true; // Mark as initialized to prevent retries
      notifyListeners();
    }
  }

  /// Purchase yearly subscription
  Future<bool> purchaseYearly() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final success = await _subscriptionService.purchaseYearly();
      _isLoading = false;

      if (success) {
        // Reload subscription from storage (updated by service)
        await Future.delayed(const Duration(seconds: 2));
        _subscription = _storageService.getSubscription();
      }

      notifyListeners();
      return success;
    } catch (e) {
      _error = 'Purchase failed: $e';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  /// Purchase lifetime access
  Future<bool> purchaseLifetime() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final success = await _subscriptionService.purchaseLifetime();
      _isLoading = false;

      if (success) {
        // Reload subscription from storage (updated by service)
        await Future.delayed(const Duration(seconds: 2));
        _subscription = _storageService.getSubscription();
      }

      notifyListeners();
      return success;
    } catch (e) {
      _error = 'Purchase failed: $e';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  /// Restore previous purchases
  Future<void> restorePurchases() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      await _subscriptionService.restorePurchases();

      // Wait for restoration to complete and reload
      await Future.delayed(const Duration(seconds: 2));
      _subscription = _storageService.getSubscription();

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = 'Restore failed: $e';
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Manually set subscription (for testing/bypass)
  Future<void> setSubscription({
    required bool isActive,
    required String productId,
    required DateTime purchaseDate,
    DateTime? expiryDate,
  }) async {
    final subscriptionType = productId.contains('lifetime')
        ? SubscriptionType.lifetime
        : SubscriptionType.yearly;

    _subscription = SubscriptionModel(
      productId: productId,
      type: subscriptionType,
      isActive: isActive,
      purchaseDate: purchaseDate,
      expiryDate: expiryDate,
    );

    await _storageService.saveSubscription(_subscription);
    notifyListeners();
  }

  /// Clear subscription (logout)
  Future<void> clearSubscription() async {
    _subscription = SubscriptionModel.free();
    await _storageService.clearSubscription();
    notifyListeners();
  }

  /// Check if user has access (active subscription)
  bool hasAccess() {
    return _subscriptionService.hasActiveSubscription();
  }

  /// Get days remaining for yearly subscription
  int? getDaysRemaining() {
    if (!isActive || isLifetime || expiryDate == null) return null;
    return expiryDate!.difference(DateTime.now()).inDays;
  }

  @override
  void dispose() {
    _subscriptionService.dispose();
    super.dispose();
  }
}
