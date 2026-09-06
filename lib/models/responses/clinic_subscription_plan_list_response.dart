import '../clinic_subscription_plan_model.dart';
import 'base_response_model.dart';

class ClinicSubscriptionPlanListResponse
    extends BaseApiResponseModel<List<ClinicSubscriptionPlanModel>> {
  const ClinicSubscriptionPlanListResponse({
    required super.isSuccess,
    required super.message,
    super.data,
  });

  factory ClinicSubscriptionPlanListResponse.fromJson(
    Map<String, dynamic> json,
  ) => ClinicSubscriptionPlanListResponse(
    isSuccess:
        (json['is_success'] as bool?) ?? (json['status'] as bool?) ?? false,
    message: json['message'] ?? '',
    data: json['data'] == null
        ? []
        : List<ClinicSubscriptionPlanModel>.from(
            (json['data'] as List).map(
              (e) => ClinicSubscriptionPlanModel.fromJson(
                e as Map<String, dynamic>,
              ),
            ),
          ),
  );
}
