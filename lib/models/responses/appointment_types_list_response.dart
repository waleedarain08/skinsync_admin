import 'base_response_model.dart';

class AppointmentTypesListResponse extends BaseApiResponseModel<List<AppointmentTypeModel>> {
  const AppointmentTypesListResponse({
    required super.isSuccess,
    required super.message,
    super.data,
  });

  factory AppointmentTypesListResponse.fromJson(Map<String, dynamic> json) {
    return AppointmentTypesListResponse(
      isSuccess: json['is_success'] as bool? ?? false,
      message: json['message'] ?? '',
      data: (json['data'] as List?)
          ?.map((e) => AppointmentTypeModel.fromJson(e))
          .toList(),
    );
  }
}

class AppointmentTypeModel {
  final int id;
  final String key;
  final String title;
  final String description;
  final String timing;
  final int maxDuration;
  final List<String> appointmentModes;
  final String? icon;
  final String? image;

  const AppointmentTypeModel({
    required this.id,
    required this.key,
    required this.title,
    required this.description,
    required this.timing,
    required this.maxDuration,
    required this.appointmentModes,
    this.icon,
    this.image,
  });

  factory AppointmentTypeModel.fromJson(Map<String, dynamic> json) {
    return AppointmentTypeModel(
      id: json['id'] ?? 0,
      key: json['key'] ?? '',
      title: json['title'] ?? json['internal_title'] ?? '',
      description: json['description'] ?? '',
      timing: json['timing'] ?? '',
      maxDuration: json['max_duration'] ?? 0,
      appointmentModes: (json['appointment_modes'] as List?)?.map((e) => e.toString()).toList() ?? [],
      icon: json['icon'],
      image: json['image'],
    );
  }
}
