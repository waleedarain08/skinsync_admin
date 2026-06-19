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
    final response = SubscriptionPlanListResponse.fromJson(
      jsonResponse,
      
    );
    if (!response.isSuccess) {
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
    final response =SubscriptionPlanResponse.fromJson(
      jsonResponse,
    );

    if (!response.isSuccess) {
      throw BadRequestException(response.message);
    }
    return response.data!;
  }
}
