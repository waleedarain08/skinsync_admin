import 'base_response_model.dart';

class BookingConfigurationResponse extends BaseApiResponseModel<BookingConfigurationData> {
  const BookingConfigurationResponse({
    required super.isSuccess,
    required super.message,
    super.data,
  });

  factory BookingConfigurationResponse.fromJson(Map<String, dynamic> json) {
    return BookingConfigurationResponse(
      isSuccess: json['is_success'] as bool? ?? false,
      message: json['message'] ?? '',
      data: json['data'] != null ? BookingConfigurationData.fromJson(json['data']) : null,
    );
  }
}

class BookingConfigurationData {
  final List<BookingMethodModel> bookingMethods;
  final List<AppointmentTypeModel> appointmentTypes;

  const BookingConfigurationData({
    required this.bookingMethods,
    required this.appointmentTypes,
  });

  factory BookingConfigurationData.fromJson(Map<String, dynamic> json) {
    return BookingConfigurationData(
      bookingMethods: (json['booking_methods'] as List?)
              ?.map((e) => BookingMethodModel.fromJson(e))
              .toList() ??
          [],
      appointmentTypes: (json['appointment_types'] as List?)
              ?.map((e) => AppointmentTypeModel.fromJson(e))
              .toList() ??
          [],
    );
  }
}

class BookingMethodModel {
  final int id;
  final String key;
  final String title;
  final String description;
  final String? icon;

  const BookingMethodModel({
    required this.id,
    required this.key,
    required this.title,
    required this.description,
    this.icon,
  });

  factory BookingMethodModel.fromJson(Map<String, dynamic> json) {
    return BookingMethodModel(
      id: json['id'] ?? 0,
      key: json['key'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      icon: json['icon'],
    );
  }
}

class AppointmentTypeModel {
  final int id;
  final String key;
  final String internalTitle;
  final String patientDisplayName;
  final String description;
  final String timing;
  final int maxDuration;
  final List<String> appointmentModes;
  final String? icon;
  final String? image;

  const AppointmentTypeModel({
    required this.id,
    required this.key,
    required this.internalTitle,
    required this.patientDisplayName,
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
      internalTitle: json['internal_title'] ?? '',
      patientDisplayName: json['patient_display_name'] ?? '',
      description: json['description'] ?? '',
      timing: json['timing'] ?? '',
      maxDuration: json['max_duration'] ?? 0,
      appointmentModes: (json['appointment_modes'] as List?)?.map((e) => e.toString()).toList() ?? [],
      icon: json['icon'],
      image: json['image'],
    );
  }
}
