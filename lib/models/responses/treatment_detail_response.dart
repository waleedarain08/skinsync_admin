import '../treatment_model.dart';
import 'base_response_model.dart';

class TreatmentDetailResponse extends BaseApiResponseModel<TreatmentModel> {
  const TreatmentDetailResponse({
    required super.status,
    required super.message,
    super.data,
  });

  factory TreatmentDetailResponse.fromJson(Map<String, dynamic> json) =>
      TreatmentDetailResponse(
        status: json['status'] ?? false,
        message: json['message'] ?? '',
        data: json['data'] == null
            ? null
            : TreatmentModel.fromJson(json['data'] as Map<String, dynamic>),
      );

  Map<String, dynamic> toJson() => {
        'status': status,
        'message': message,
        'data': data?.toRequest(),
      };
}
