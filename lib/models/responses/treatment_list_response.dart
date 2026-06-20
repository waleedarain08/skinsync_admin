import '../treatment_model.dart';
import 'base_response_model.dart';

class TreatmentListResponse extends BaseApiResponseModel<List<TreatmentModel>> {
  const TreatmentListResponse({
    required super.isSuccess,
    required super.message,
    super.data,
  });

  factory TreatmentListResponse.fromJson(Map<String, dynamic> json) =>
      TreatmentListResponse(
        isSuccess: (json['is_success'] as bool?)  ?? false,
        message: json['message'] ?? '',
        data: json['data'] == null
            ? null
            : (json['data'] as List)
                .map((e) => TreatmentModel.fromJson(e as Map<String, dynamic>))
                .toList(),
      );


}
