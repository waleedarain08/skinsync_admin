import '../treatment_model.dart';
import 'base_response_model.dart';

class TreatmentCrudResponse extends BaseApiResponseModel<TreatmentModel> {
  const TreatmentCrudResponse({
    required super.isSuccess,
    required super.message,
    super.data,
  });

  factory TreatmentCrudResponse.fromJson(Map<String, dynamic> json) =>
      TreatmentCrudResponse(
        isSuccess: (json['is_success'] as bool?) ?? (json['status'] as bool?) ?? false,
        message: json['message'] ?? '',
        data: json['data'] == null
            ? null
            : TreatmentModel.fromJson(json['data'] as Map<String, dynamic>),
      );

  Map<String, dynamic> toJson() => {
        'status': isSuccess,
        'message': message,
        'data': data?.toRequest(),
      };
}
