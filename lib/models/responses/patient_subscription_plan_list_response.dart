import '../patient_subscription_plan_model.dart';
import 'base_response_model.dart';

class PatientSubscriptionPlanListResponse
    extends BaseApiResponseModel<List<PatientSubscriptionPlanModel>> {
  const PatientSubscriptionPlanListResponse({
    required super.isSuccess,
    required super.message,
    super.data,
  });

  factory PatientSubscriptionPlanListResponse.fromJson(
    Map<String, dynamic> json,
  ) => PatientSubscriptionPlanListResponse(
    isSuccess:
        (json['is_success'] as bool?) ?? (json['status'] as bool?) ?? false,
    message: json['message'] ?? '',
    data: json['data'] == null
        ? []
        : List<PatientSubscriptionPlanModel>.from(
            (json['data'] as List).map(
              (e) => PatientSubscriptionPlanModel.fromJson(
                e as Map<String, dynamic>,
              ),
            ),
          ),
  );
}
