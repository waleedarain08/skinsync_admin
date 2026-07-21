class CreateAppointmentTypeRequest {
  final String title;
  final String key;
  final String description;
  final String timing;
  final int maxDuration;
  final List<String> appointmentModes;
  final String? icon;
  final String? image;

  const CreateAppointmentTypeRequest({
    required this.title,
    required this.key,
    required this.description,
    required this.timing,
    required this.maxDuration,
    required this.appointmentModes,
    this.icon,
    this.image,
  });

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'key': key,
      'description': description,
      'timing': timing,
      'max_duration': maxDuration,
      'appointment_modes': appointmentModes,
      if (icon != null) 'icon': icon,
      if (image != null) 'image': image,
    };
  }
}
