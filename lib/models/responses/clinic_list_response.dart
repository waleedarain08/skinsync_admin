import 'package:skinsync_admin/models/clinic_model.dart';
import 'package:skinsync_admin/models/responses/base_response_model.dart';

class ClinicListResponse extends BaseApiResponseModel<List<ClinicModel>> {
  final int totalPages;
  const ClinicListResponse({
    required super.isSuccess,
    required super.message,
    super.data,
    required this.totalPages,
  });

  factory ClinicListResponse.fromJson(Map<String, dynamic> json) {
    final rawData = json['data'];
    List<ClinicModel>? listData;
    if (rawData is List) {
      listData = rawData
          .map((e) => ClinicModel.fromJson(e as Map<String, dynamic>))
          .toList();
    } else if (rawData is Map<String, dynamic>) {
      listData = [ClinicModel.fromJson(rawData)];
    }

    return ClinicListResponse(
      isSuccess: (json['is_success'] as bool?) ?? false,
      message: json['message'] ?? '',
      data: listData,
      totalPages: json['total_pages'] ?? 1,
    );
  }

  Map<String, dynamic> toJson() => {
    'is_success': isSuccess,
    'message': message,
    'data': data?.map((e) => e.toJson()).toList(),
    'total_pages': totalPages,
  };
}
