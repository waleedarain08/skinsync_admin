import 'package:skinsync_admin/models/clinic_model.dart';
import 'package:skinsync_admin/models/responses/base_response_model.dart';

class ClinicListResponse extends BaseApiResponseModel<List<ClinicModel>> {
  const ClinicListResponse({
    required super.isSuccess,
    required super.message,
    super.data,
  });

  factory ClinicListResponse.fromJson(Map<String, dynamic> json) =>
      ClinicListResponse(
        isSuccess: (json['is_success'] as bool?)  ?? false,
        message: json['message'] ?? '',
        data: json['data'] == null
            ? null
            : (json['data'] as List)
                .map((e) => ClinicModel.fromJson(e as Map<String, dynamic>))
                .toList(),
      );

  Map<String, dynamic> toJson() => {
        'is_success': isSuccess,
        'message': message,
        'data': data?.map((e) => e.toJson()).toList(),
      };
}