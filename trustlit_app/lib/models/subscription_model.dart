/// Subscription Model for managing in-app purchase state
class SubscriptionModel {
  final String? productId;
  final SubscriptionType type;
  final bool isActive;
  final DateTime? purchaseDate;
  final DateTime? expiryDate;

  SubscriptionModel({
    this.productId,
    this.type = SubscriptionType.free,
    this.isActive = false,
    this.purchaseDate,
    this.expiryDate,
  });

  bool get isLifetime => type == SubscriptionType.lifetime;
  bool get isYearly => type == SubscriptionType.yearly;

  factory SubscriptionModel.free() => SubscriptionModel(
        type: SubscriptionType.free,
        isActive: false,
      );

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
    );
  }

  Map<String, dynamic> toJson() => {
        'productId': productId,
        'type': type.name,
        'isActive': isActive,
        'purchaseDate': purchaseDate?.toIso8601String(),
        'expiryDate': expiryDate?.toIso8601String(),
      };
}

enum SubscriptionType {
  free,
  yearly,
  lifetime,
}
