import '../clinic_subscription_plan_model.dart';
import 'base_response_model.dart';

class ClinicSubscriptionPlanResponse
    extends BaseApiResponseModel<ClinicSubscriptionPlanModel> {
  const ClinicSubscriptionPlanResponse({
    required super.isSuccess,
    required super.message,
    super.data,
  });

  factory ClinicSubscriptionPlanResponse.fromJson(Map<String, dynamic> json) =>
      ClinicSubscriptionPlanResponse(
        isSuccess:
            (json['is_success'] as bool?) ?? (json['status'] as bool?) ?? false,
        message: json['message'] ?? '',
        data: json['data'] == null
            ? null
            : ClinicSubscriptionPlanModel.fromJson(
                json['data'] as Map<String, dynamic>,
              ),
      );
}
