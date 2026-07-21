class CreateBookingMethodRequest {
  final String title;
  final String key;
  final String description;
  final String? icon;

  const CreateBookingMethodRequest({
    required this.title,
    required this.key,
    required this.description,
    this.icon,
  });

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'key': key,
      'description': description,
      if (icon != null) 'icon': icon,
    };
  }
}
