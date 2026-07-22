import 'base_response_model.dart';

class AppointmentTimingListResponse extends BaseApiResponseModel<List<String>> {
  const AppointmentTimingListResponse({
    required super.isSuccess,
    required super.message,
    super.data,
  });

  factory AppointmentTimingListResponse.fromJson(Map<String, dynamic> json) {
    return AppointmentTimingListResponse(
      isSuccess: json['is_success'] as bool? ?? false,
      message: json['message'] ?? '',
      data: (json['data'] as List?)?.map((e) => e.toString()).toList(),
    );
  }
}
