import '../patient_subscription_plan_model.dart';
import 'base_response_model.dart';

class PatientSubscriptionPlanResponse
    extends BaseApiResponseModel<PatientSubscriptionPlanModel> {
  const PatientSubscriptionPlanResponse({
    required super.isSuccess,
    required super.message,
    super.data,
  });

  factory PatientSubscriptionPlanResponse.fromJson(Map<String, dynamic> json) =>
      PatientSubscriptionPlanResponse(
        isSuccess:
            (json['is_success'] as bool?) ?? (json['status'] as bool?) ?? false,
        message: json['message'] ?? '',
        data: json['data'] == null
            ? null
            : PatientSubscriptionPlanModel.fromJson(
                json['data'] as Map<String, dynamic>,
              ),
      );
}
