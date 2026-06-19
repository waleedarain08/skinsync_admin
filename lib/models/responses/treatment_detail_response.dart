import '../treatment_model.dart';
import 'base_response_model.dart';

class TreatmentDetailResponse extends BaseApiResponseModel<TreatmentModel> {
  const TreatmentDetailResponse({
    required super.isSuccess,
    required super.message,
    super.data,
  });

  factory TreatmentDetailResponse.fromJson(Map<String, dynamic> json) =>
      TreatmentDetailResponse(
        isSuccess: (json['is_success'] as bool?)  ?? false,
        message: json['message'] ?? '',
        data: json['data'] == null
            ? null
            : TreatmentModel.fromJson(json['data'] as Map<String, dynamic>),
      );

 
}
