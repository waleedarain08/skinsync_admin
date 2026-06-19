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
        isSuccess: json['status'] ?? false,
        message: json['message'] ?? '',
        data: json['data'] == null
            ? null
            : (json['data'] as List)
                .map((e) => TreatmentModel.fromJson(e as Map<String, dynamic>))
                .toList(),
      );

  Map<String, dynamic> toJson() => {
        'status': isSuccess,
        'message': message,
        'data': data?.map((e) => e.toRequest()).toList(),
      };
}
