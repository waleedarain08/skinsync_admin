import 'subscription_duration_model.dart';

class SubscriptionDurationOption {
  final SubscriptionDuration? duration;
  final double? basePrice;

  SubscriptionDurationOption({
    this.duration,
    this.basePrice,
  });

  factory SubscriptionDurationOption.fromJson(Map<String, dynamic> json) {
    SubscriptionDuration? duration;
    if (json['duration'] != null) {
      duration = SubscriptionDuration.fromJson(
          json['duration'] as Map<String, dynamic>);
    } else if (json['duration_id'] != null) {
      duration = SubscriptionDuration(
        id: (json['duration_id'] as num?)?.toInt(),
        name: json['name'] as String?,
      );
    } else if (json['id'] != null || json['name'] != null) {
      duration = SubscriptionDuration(
        id: (json['id'] as num?)?.toInt(),
        name: json['name'] as String?,
        duration: (json['duration_days'] as num?)?.toInt() ?? (json['duration'] as num?)?.toInt(),
      );
    }

    return SubscriptionDurationOption(
      duration: duration,
      basePrice: (json['base_price'] as num?)?.toDouble() ??
          (json['price'] as num?)?.toDouble() ??
          0.0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'duration_id': duration?.id,
      'base_price': basePrice,
    };
  }
}
