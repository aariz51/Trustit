import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:dio/dio.dart';
import '../models/subscription_model.dart';
import 'storage_service.dart';

/// Subscription Service for handling Apple App Store in-app purchases
/// Supports:
/// - 3-day free trial that converts to yearly subscription
/// - Yearly subscription ($29.99/year)
/// - Lifetime purchase ($59.99 one-time)
class SubscriptionService {
  // Product IDs - Must match App Store Connect
  static const String yearlyProductId = 'com.trustlt.yearly';
  static const String lifetimeProductId = 'com.trustlt.lifetime';

  static final Set<String> _productIds = {yearlyProductId, lifetimeProductId};

  static final SubscriptionService _instance = SubscriptionService._internal();
  factory SubscriptionService() => _instance;
  SubscriptionService._internal();

  final InAppPurchase _inAppPurchase = InAppPurchase.instance;
  final StorageService _storageService = StorageService();
  final Dio _dio = Dio();

  StreamSubscription<List<PurchaseDetails>>? _subscription;
  List<ProductDetails> _products = [];
  bool _isAvailable = false;
  bool _isPurchasing = false;

  /// Product details getter
  List<ProductDetails> get products => _products;
  bool get isAvailable => _isAvailable;
  bool get isPurchasing => _isPurchasing;

  /// Initialize the subscription service
  Future<void> initialize() async {
    _isAvailable = await _inAppPurchase.isAvailable();

    if (!_isAvailable) {
      debugPrint('In-app purchases not available');
      return;
    }

    // Start listening to purchase updates
    final purchaseUpdated = _inAppPurchase.purchaseStream;
    _subscription = purchaseUpdated.listen(
      _onPurchaseUpdate,
      onDone: () => _subscription?.cancel(),
      onError: (error) => debugPrint('Purchase stream error: $error'),
    );

    // Load products
    await loadProducts();
    
    // Check trial status on startup
    await checkTrialStatus();
  }

  /// Load available products from store
  Future<void> loadProducts() async {
    if (!_isAvailable) return;

    final response = await _inAppPurchase.queryProductDetails(_productIds);

    if (response.notFoundIDs.isNotEmpty) {
      debugPrint('Products not found: ${response.notFoundIDs}');
    }

    if (response.productDetails.isNotEmpty) {
      _products = response.productDetails;
      debugPrint('Loaded ${_products.length} products');
      for (final product in _products) {
        debugPrint('Product: ${product.id} - ${product.price}');
      }
    }
  }

  /// Get product by ID
  ProductDetails? getProduct(String productId) {
    try {
      return _products.firstWhere((p) => p.id == productId);
    } catch (_) {
      return null;
    }
  }

  /// Get yearly product price string
  String getYearlyPrice() {
    final product = getProduct(yearlyProductId);
    return product?.price ?? '\$29.99/year';
  }

  /// Get lifetime product price string
  String getLifetimePrice() {
    final product = getProduct(lifetimeProductId);
    return product?.price ?? '\$59.99';
  }

  // ==========================================
  // TRIAL MANAGEMENT
  // ==========================================

  /// Start 3-day free trial
  Future<bool> startFreeTrial() async {
    final currentSub = _storageService.getSubscription();
    
    // Check if user already had a trial
    if (currentSub.trialStartDate != null) {
      debugPrint('User already used trial');
      return false;
    }
    
    // Create trial subscription
    final trialSub = SubscriptionModel.trial();
    await _storageService.saveSubscription(trialSub);
    
    debugPrint('Free trial started - expires: ${trialSub.trialEndDate}');
    return true;
  }

  /// Check and update trial status
  Future<void> checkTrialStatus() async {
    final subscription = _storageService.getSubscription();
    
    if (subscription.isTrialActive && subscription.isTrialExpired) {
      // Trial expired - prompt for purchase
      debugPrint('Trial expired');
      
      // Update subscription to mark trial as no longer active
      final updated = subscription.copyWith(isTrialActive: false);
      await _storageService.saveSubscription(updated);
    }
  }

  /// Check if user is eligible for free trial
  bool isEligibleForTrial() {
    final subscription = _storageService.getSubscription();
    // Eligible if never had a trial before
    return subscription.trialStartDate == null;
  }

  // ==========================================
  // PURCHASE METHODS
  // ==========================================

  /// Purchase yearly subscription (with introductory offer/trial if eligible)
  Future<bool> purchaseYearly() async {
    return _purchaseProduct(yearlyProductId);
  }

  /// Purchase lifetime access
  Future<bool> purchaseLifetime() async {
    return _purchaseProduct(lifetimeProductId);
  }

  /// Internal purchase method
  Future<bool> _purchaseProduct(String productId) async {
    if (_isPurchasing) {
      debugPrint('Purchase already in progress');
      return false;
    }

    final product = getProduct(productId);
    if (product == null) {
      debugPrint('Product not found: $productId');
      return false;
    }

    _isPurchasing = true;

    try {
      final purchaseParam = PurchaseParam(productDetails: product);
      
      // For subscriptions, use buyNonConsumable (Apple handles subscription logic)
      final started = await _inAppPurchase.buyNonConsumable(
        purchaseParam: purchaseParam,
      );
      
      if (!started) {
        _isPurchasing = false;
      }
      
      return started;
    } catch (e) {
      debugPrint('Purchase error: $e');
      _isPurchasing = false;
      return false;
    }
  }

  /// Handle purchase updates
  void _onPurchaseUpdate(List<PurchaseDetails> purchaseDetailsList) {
    for (final purchaseDetails in purchaseDetailsList) {
      _handlePurchase(purchaseDetails);
    }
  }

  /// Process individual purchase
  Future<void> _handlePurchase(PurchaseDetails purchaseDetails) async {
    switch (purchaseDetails.status) {
      case PurchaseStatus.pending:
        debugPrint('Purchase pending: ${purchaseDetails.productID}');
        break;

      case PurchaseStatus.purchased:
      case PurchaseStatus.restored:
        // Verify and deliver the purchase
        final valid = await _verifyPurchase(purchaseDetails);
        if (valid) {
          await _deliverPurchase(purchaseDetails);
        }
        _isPurchasing = false;
        break;

      case PurchaseStatus.error:
        debugPrint('Purchase error: ${purchaseDetails.error}');
        _isPurchasing = false;
        break;

      case PurchaseStatus.canceled:
        debugPrint('Purchase canceled');
        _isPurchasing = false;
        break;
    }

    // Complete the purchase
    if (purchaseDetails.pendingCompletePurchase) {
      await _inAppPurchase.completePurchase(purchaseDetails);
    }
  }

  /// Verify purchase with server-side validation
  Future<bool> _verifyPurchase(PurchaseDetails purchaseDetails) async {
    // For development/testing, accept all purchases
    if (kDebugMode) {
      debugPrint('DEBUG MODE: Skipping receipt validation');
      return true;
    }

    // Server-side receipt validation for production
    try {
      final receiptData = purchaseDetails.verificationData.serverVerificationData;
      
      // Call backend to verify receipt
      // Note: Update this URL to your production backend
      final response = await _dio.post(
        'https://trustlt.onrender.com/api/verify-receipt',
        data: {
          'receiptData': receiptData,
          'productId': purchaseDetails.productID,
          'platform': Platform.isIOS ? 'ios' : 'android',
        },
      );

      if (response.statusCode == 200 && response.data['valid'] == true) {
        return true;
      }
      
      debugPrint('Receipt validation failed: ${response.data}');
      return false;
    } catch (e) {
      debugPrint('Receipt validation error: $e');
      // In case of network error, accept purchase (user-friendly)
      // Backend will re-validate on next app launch
      return true;
    }
  }

  /// Deliver the purchase to the user
  Future<void> _deliverPurchase(PurchaseDetails purchaseDetails) async {
    final productId = purchaseDetails.productID;
    final now = DateTime.now();

    SubscriptionModel subscription;

    if (productId == lifetimeProductId) {
      subscription = SubscriptionModel(
        productId: productId,
        type: SubscriptionType.lifetime,
        isActive: true,
        purchaseDate: now,
        expiryDate: null, // Lifetime never expires
        isTrialActive: false,
      );
    } else if (productId == yearlyProductId) {
      subscription = SubscriptionModel(
        productId: productId,
        type: SubscriptionType.yearly,
        isActive: true,
        purchaseDate: now,
        expiryDate: now.add(const Duration(days: 365)),
        isTrialActive: false, // Paid subscription replaces trial
      );
    } else {
      return;
    }

    await _storageService.saveSubscription(subscription);
    debugPrint('Subscription activated: $productId');
  }

  /// Restore previous purchases
  Future<void> restorePurchases() async {
    if (!_isAvailable) {
      debugPrint('In-app purchases not available');
      return;
    }

    await _inAppPurchase.restorePurchases();
  }

  // ==========================================
  // SUBSCRIPTION STATUS
  // ==========================================

  /// Check if user has active subscription or trial
  bool hasActiveSubscription() {
    final subscription = _storageService.getSubscription();
    return subscription.hasValidAccess;
  }

  /// Check if user is in active trial
  bool isInTrial() {
    final subscription = _storageService.getSubscription();
    return subscription.isTrialActive && !subscription.isTrialExpired;
  }

  /// Get current subscription
  SubscriptionModel getCurrentSubscription() {
    return _storageService.getSubscription();
  }

  /// Get subscription status string for UI
  String getStatusString() {
    final sub = getCurrentSubscription();
    
    if (sub.isLifetime && sub.isActive) {
      return 'Lifetime Access';
    }
    
    if (sub.isTrialActive && !sub.isTrialExpired) {
      final days = sub.trialDaysRemaining;
      return 'Trial: $days day${days != 1 ? 's' : ''} remaining';
    }
    
    if (sub.isYearly && sub.isActive) {
      return 'Yearly Subscription';
    }
    
    return 'Free';
  }

  /// Dispose resources
  void dispose() {
    _subscription?.cancel();
  }
}
