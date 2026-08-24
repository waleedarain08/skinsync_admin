import 'base_response_model.dart';

class PatientDetailResponse extends BaseApiResponseModel<PatientDetailData> {
  PatientDetailResponse({
    required super.isSuccess,
    required super.message,
    super.data,
  });

  factory PatientDetailResponse.fromJson(Map<String, dynamic> json) {
    return PatientDetailResponse(
      isSuccess: json['is_success'] ?? false,
      message: json['message'] ?? '',
      data: json['data'] != null
          ? PatientDetailData.fromJson(json['data'] as Map<String, dynamic>)
          : null,
    );
  }
}

class PatientDetailData {
  final int id;
  final String patientName;
  final String email;
  final String? image;
  final String phoneNumber;

  PatientDetailData({
    required this.id,
    required this.patientName,
    required this.email,
    this.image,
    required this.phoneNumber,
  });

  factory PatientDetailData.fromJson(Map<String, dynamic> json) {
    return PatientDetailData(
      id: json['id'] ?? 0,
      patientName: json['name'] ?? '',
      email: json['email'] ?? '',
      image: json['image'],
      phoneNumber: json['phone_number'] ?? '',
    );
  }
}
