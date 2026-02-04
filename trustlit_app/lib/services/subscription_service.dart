import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import '../models/subscription_model.dart';
import 'storage_service.dart';

/// Subscription Service for handling in-app purchases
class SubscriptionService {
  // Product IDs
  static const String yearlyProductId = 'com.trustlit.yearly';
  static const String lifetimeProductId = 'com.trustlit.lifetime';

  static final Set<String> _productIds = {yearlyProductId, lifetimeProductId};

  static final SubscriptionService _instance = SubscriptionService._internal();
  factory SubscriptionService() => _instance;
  SubscriptionService._internal();

  final InAppPurchase _inAppPurchase = InAppPurchase.instance;
  final StorageService _storageService = StorageService();

  StreamSubscription<List<PurchaseDetails>>? _subscription;
  List<ProductDetails> _products = [];
  bool _isAvailable = false;

  /// Product details getter
  List<ProductDetails> get products => _products;
  bool get isAvailable => _isAvailable;

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

  /// Purchase yearly subscription
  Future<bool> purchaseYearly() async {
    return _purchaseProduct(yearlyProductId);
  }

  /// Purchase lifetime access
  Future<bool> purchaseLifetime() async {
    return _purchaseProduct(lifetimeProductId);
  }

  /// Internal purchase method
  Future<bool> _purchaseProduct(String productId) async {
    final product = getProduct(productId);
    if (product == null) {
      debugPrint('Product not found: $productId');
      return false;
    }

    final purchaseParam = PurchaseParam(productDetails: product);

    try {
      // Use different purchase method based on product type
      if (productId == yearlyProductId) {
        return await _inAppPurchase.buyNonConsumable(
          purchaseParam: purchaseParam,
        );
      } else {
        return await _inAppPurchase.buyNonConsumable(
          purchaseParam: purchaseParam,
        );
      }
    } catch (e) {
      debugPrint('Purchase error: $e');
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
        break;

      case PurchaseStatus.error:
        debugPrint('Purchase error: ${purchaseDetails.error}');
        break;

      case PurchaseStatus.canceled:
        debugPrint('Purchase canceled');
        break;
    }

    // Complete the purchase
    if (purchaseDetails.pendingCompletePurchase) {
      await _inAppPurchase.completePurchase(purchaseDetails);
    }
  }

  /// Verify purchase (basic verification - implement server-side for production)
  Future<bool> _verifyPurchase(PurchaseDetails purchaseDetails) async {
    // TODO: Implement server-side receipt validation for production
    // For now, accept all purchases
    return true;
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
      );
    } else if (productId == yearlyProductId) {
      subscription = SubscriptionModel(
        productId: productId,
        type: SubscriptionType.yearly,
        isActive: true,
        purchaseDate: now,
        expiryDate: now.add(const Duration(days: 365)),
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

  /// Check if user has active subscription
  bool hasActiveSubscription() {
    final subscription = _storageService.getSubscription();

    if (!subscription.isActive) return false;

    // Lifetime never expires
    if (subscription.isLifetime) return true;

    // Check if yearly subscription has expired
    if (subscription.expiryDate != null) {
      return subscription.expiryDate!.isAfter(DateTime.now());
    }

    return false;
  }

  /// Get current subscription
  SubscriptionModel getCurrentSubscription() {
    return _storageService.getSubscription();
  }

  /// Dispose resources
  void dispose() {
    _subscription?.cancel();
  }
}
