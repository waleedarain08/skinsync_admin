import 'base_response_model.dart';

class PatientListResponse extends BaseApiResponseModel<List<PatientData>> {
  final int page;
  final int limit;
  final int totalPages;
  final int totalRequest;
  final int totalPatients;
  final int totalResults;

  PatientListResponse({
    required super.isSuccess,
    required super.message,
    super.data,
    required this.page,
    required this.limit,
    required this.totalPages,
    required this.totalResults,
    required this.totalRequest,
    required this.totalPatients,
  });

  factory PatientListResponse.fromJson(Map<String, dynamic> json) {
    return PatientListResponse(
      isSuccess: json['is_success'] ?? false,
      message: json['message'] ?? '',
      data:
          (json['data'] as List<dynamic>?)
              ?.map((e) => PatientData.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      page: json['page'] ?? 1,
      limit: json['limit'] ?? 10,
      totalPages: json['total_pages'] ?? 0,
      totalResults: json['total_results'] ?? 0,
      totalRequest: json['total_request'] ?? 0,
      totalPatients: json['total_patients'] ?? 0,
    );
  }
}

class PatientData {
  final int? id;
  final String? patientName;
  final String? email;
  final String? image;
  final String? phoneNumber;
  final int? requestCount;
  final String? status;

  PatientData({
    this.id,
    this.patientName,
    this.email,
    this.image,
    this.phoneNumber,
    this.requestCount,
    this.status,
  });

  factory PatientData.fromJson(Map<String, dynamic> json) {
    return PatientData(
      id: json['id'],
      patientName: json['patient_name'],
      email: json['email'],
      image: json['image'],
      phoneNumber: json['phone_number'],
      status: json['status'],
      requestCount: json['request_counts'] ?? 0,
    );
  }
}
