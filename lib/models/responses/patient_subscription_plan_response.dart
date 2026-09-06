import '../patient_plan_model.dart';
import 'base_response_model.dart';

class PatientPlanResponse extends BaseApiResponseModel<PatientPlan> {
  const PatientPlanResponse({
    required super.isSuccess,
    required super.message,
    super.data,
  });

  factory PatientPlanResponse.fromJson(Map<String, dynamic> json) =>
      PatientPlanResponse(
        isSuccess:
            (json['is_success'] as bool?) ?? (json['status'] as bool?) ?? false,
        message: json['message'] ?? '',
        data: json['data'] == null
            ? null
            : PatientPlan.fromJson(json['data'] as Map<String, dynamic>),
      );
}
