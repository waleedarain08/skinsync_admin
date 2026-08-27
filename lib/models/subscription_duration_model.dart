class SubscriptionDuration {
  final int? id;
  final String? name;
  final int? duration;

  SubscriptionDuration({
    this.id,
    this.name,
    this.duration,
  });

  factory SubscriptionDuration.fromJson(Map<String, dynamic> json) {
    return SubscriptionDuration(
      id: json['id'] as int?,
      name: json['name'] as String?,
      duration: json['duration'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'duration': duration,
    };
  }
}
