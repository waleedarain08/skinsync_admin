import 'package:skinsync_admin/models/responses/base_response_model.dart';
import 'package:skinsync_admin/models/subscription_plan_benefit_model.dart';

class PatientSubscriptionBenefitListResponse
    extends BaseApiResponseModel<List<PlanBenefit>> {
  const PatientSubscriptionBenefitListResponse({
    required super.isSuccess,
    required super.message,
    super.data,
  });

  factory PatientSubscriptionBenefitListResponse.fromJson(
    Map<String, dynamic> json,
  ) =>
      PatientSubscriptionBenefitListResponse(
        isSuccess:
            (json['is_success'] as bool?) ?? (json['status'] as bool?) ?? false,
        message: json['message'] ?? '',
        data: json['data'] == null
            ? []
            : List<PlanBenefit>.from(
                (json['data'] as List).map(
                  (e) => PlanBenefit.fromJson(
                    e as Map<String, dynamic>,
                  ),
                ),
              ),
      );
}
