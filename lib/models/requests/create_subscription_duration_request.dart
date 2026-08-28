class CreateSubscriptionDurationRequest {
  final String name;
  final int duration;

  CreateSubscriptionDurationRequest({
    required this.name,
    required this.duration,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'duration': duration,
    };
  }
}
