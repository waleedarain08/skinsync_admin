import '../models/requests/create_subscription_plan_request.dart';
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
  Future<SubscriptionPlanModel> createClinicSubscriptionPlan(CreateSubscriptionPlanRequest request) async {
    final jsonResponse = await _api.post(
      Endpoint.subscriptionPlans,
      body: request.toJson(),
    );
    final response = SubscriptionPlanResponse.fromJson(
      jsonResponse,
    );

    if (!response.isSuccess) {
      throw BadRequestException(response.message);
    }
    return response.data!;
  }

  @override
  Future<SubscriptionPlanModel> updateSubscriptionPlan(int id, CreateSubscriptionPlanRequest request) async {
    final jsonResponse = await _api.put(
      Endpoint.updateSubscriptionPlan.withParams({'id': id.toString()}),
      body: request.toJson(),
    );
    final response = SubscriptionPlanResponse.fromJson(jsonResponse);

    if (!response.isSuccess) {
      throw BadRequestException(response.message);
    }
    return response.data!;
  }

  @override
  Future<bool> deleteSubscriptionPlan(int id) async {
    final jsonResponse = await _api.delete(
      Endpoint.deleteSubscriptionPlan.withParams({'id': id.toString()}),
    ) as Map<String, dynamic>;
    final isSuccess = (jsonResponse['is_success'] as bool?) ?? false;
    if (!isSuccess) {
      throw BadRequestException(
        jsonResponse['message']?.toString() ?? 'Failed to delete plan',
      );
    }
    return true;
  }
}
