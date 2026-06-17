import '../models/responses/base_response_model.dart';
import '../models/subscription_plan_model.dart';
import '../repositories/subscription_repository.dart';
import '../utils/enums.dart';
import '../utils/exception.dart';
import 'api_base_helper.dart';

class SubscriptionServices implements SubscriptionRepository {
  final ApiBaseHelper _api;

  SubscriptionServices({required ApiBaseHelper api}) : _api = api;

  @override
  Future<List<SubscriptionPlanModel>> getSubscriptionPlans() async {
    final jsonResponse = await _api.get(Endpoint.subscriptionPlans);
    final response = BaseApiResponseModel<List<SubscriptionPlanModel>>.fromJson(
      jsonResponse,
      (json) {
        return (json as List)
            .map((plan) => SubscriptionPlanModel.fromJson(plan))
            .toList();
      },
    );
    if (!response.status) {
      throw BadRequestException(response.message);
    }
    return response.data!;
  }

  @override
  Future<SubscriptionPlanModel> createSubscriptionPlan(SubscriptionPlanModel plan) async {
    final jsonResponse = await _api.post(
      Endpoint.subscriptionPlans,
      body: plan.toJson(),
    );
    final response = BaseApiResponseModel<SubscriptionPlanModel>.fromJson(
      jsonResponse,
      (json) => SubscriptionPlanModel.fromJson(json as Map<String, dynamic>),
    );

    if (!response.status) {
      throw BadRequestException(response.message);
    }
    return response.data!;
  }
}
