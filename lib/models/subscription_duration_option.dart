class SubscriptionDurationOption {
  final String name;
  final int duration; // Stored as days
  final double price;

  SubscriptionDurationOption({
    required this.name,
    required this.duration,
    required this.price,
  });

  factory SubscriptionDurationOption.fromJson(Map<String, dynamic> json) {
    return SubscriptionDurationOption(
      name: json['name'] as String? ?? '',
      duration: json['duration'] as int? ?? 0,
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'duration': duration,
      'price': price,
    };
  }
}
