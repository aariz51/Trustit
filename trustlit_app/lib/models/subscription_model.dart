/// Subscription Model for managing in-app purchase state
class SubscriptionModel {
  final String? productId;
  final SubscriptionType type;
  final bool isActive;
  final DateTime? purchaseDate;
  final DateTime? expiryDate;
  
  // Trial tracking
  final bool isTrialActive;
  final DateTime? trialStartDate;
  final DateTime? trialEndDate;

  SubscriptionModel({
    this.productId,
    this.type = SubscriptionType.free,
    this.isActive = false,
    this.purchaseDate,
    this.expiryDate,
    this.isTrialActive = false,
    this.trialStartDate,
    this.trialEndDate,
  });

  bool get isLifetime => type == SubscriptionType.lifetime;
  bool get isYearly => type == SubscriptionType.yearly;
  bool get isFree => type == SubscriptionType.free;
  
  /// Check if trial has expired
  bool get isTrialExpired {
    if (!isTrialActive || trialEndDate == null) return false;
    return DateTime.now().isAfter(trialEndDate!);
  }
  
  /// Check if user has valid access (premium or active trial)
  bool get hasValidAccess {
    // Lifetime never expires
    if (isLifetime && isActive) return true;
    
    // Active trial
    if (isTrialActive && !isTrialExpired) return true;
    
    // Active yearly subscription
    if (isYearly && isActive) {
      // If expiryDate is null but subscription is active, treat as valid
      // (expiry date may not be set immediately after purchase)
      if (expiryDate == null) return true;
      if (DateTime.now().isBefore(expiryDate!)) return true;
    }
    
    return false;
  }
  
  /// Days remaining in trial
  int get trialDaysRemaining {
    if (!isTrialActive || trialEndDate == null) return 0;
    final diff = trialEndDate!.difference(DateTime.now()).inDays;
    return diff > 0 ? diff : 0;
  }

  factory SubscriptionModel.free() => SubscriptionModel(
        type: SubscriptionType.free,
        isActive: false,
      );
      
  /// Create a trial subscription
  factory SubscriptionModel.trial() {
    final now = DateTime.now();
    return SubscriptionModel(
      type: SubscriptionType.yearly,
      isActive: false, // Not yet paid
      isTrialActive: true,
      trialStartDate: now,
      trialEndDate: now.add(const Duration(days: 3)),
    );
  }

  factory SubscriptionModel.fromJson(Map<String, dynamic> json) {
    return SubscriptionModel(
      productId: json['productId'] as String?,
      type: SubscriptionType.values.firstWhere(
        (e) => e.name == json['type'],
        orElse: () => SubscriptionType.free,
      ),
      isActive: json['isActive'] as bool? ?? false,
      purchaseDate: json['purchaseDate'] != null
          ? DateTime.tryParse(json['purchaseDate'] as String)
          : null,
      expiryDate: json['expiryDate'] != null
          ? DateTime.tryParse(json['expiryDate'] as String)
          : null,
      isTrialActive: json['isTrialActive'] as bool? ?? false,
      trialStartDate: json['trialStartDate'] != null
          ? DateTime.tryParse(json['trialStartDate'] as String)
          : null,
      trialEndDate: json['trialEndDate'] != null
          ? DateTime.tryParse(json['trialEndDate'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
        'productId': productId,
        'type': type.name,
        'isActive': isActive,
        'purchaseDate': purchaseDate?.toIso8601String(),
        'expiryDate': expiryDate?.toIso8601String(),
        'isTrialActive': isTrialActive,
        'trialStartDate': trialStartDate?.toIso8601String(),
        'trialEndDate': trialEndDate?.toIso8601String(),
      };
      
  /// Copy with new values
  SubscriptionModel copyWith({
    String? productId,
    SubscriptionType? type,
    bool? isActive,
    DateTime? purchaseDate,
    DateTime? expiryDate,
    bool? isTrialActive,
    DateTime? trialStartDate,
    DateTime? trialEndDate,
  }) {
    return SubscriptionModel(
      productId: productId ?? this.productId,
      type: type ?? this.type,
      isActive: isActive ?? this.isActive,
      purchaseDate: purchaseDate ?? this.purchaseDate,
      expiryDate: expiryDate ?? this.expiryDate,
      isTrialActive: isTrialActive ?? this.isTrialActive,
      trialStartDate: trialStartDate ?? this.trialStartDate,
      trialEndDate: trialEndDate ?? this.trialEndDate,
    );
  }
}

enum SubscriptionType {
  free,
  yearly,
  lifetime,
}
