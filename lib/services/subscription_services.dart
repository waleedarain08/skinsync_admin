import '../models/clinic_subscription_plan_model.dart';
import '../models/requests/create_clinic_subscription_plan_request.dart';
import '../models/responses/clinic_subscription_plan_response.dart';
import '../repositories/subscription_repository.dart';
import '../utils/dummy_data.dart';
import '../utils/enums.dart';
import '../utils/exception.dart';
import 'api_base_helper.dart';

class SubscriptionServices implements SubscriptionRepository {
  final ApiBaseHelper _api;

  SubscriptionServices({required ApiBaseHelper api}) : _api = api;

  @override
  Future<List<ClinicSubscriptionPlanModel>> getSubscriptionPlans() async {
    // TODO: Uncomment when backend is ready
    /*
    final jsonResponse = await _api.get(Endpoint.subscriptionPlans);
    final response = ClinicSubscriptionPlanListResponse.fromJson(jsonResponse);
    if (!response.isSuccess) {
      throw BadRequestException(response.message);
    }
    return response.data!;
    */

    // Returning dummy data for now as requested
    await Future<void>.delayed(const Duration(milliseconds: 500)); // Simulate network lag
    return TreatmentData.dummySubscriptionPlans;
  }

  @override
  Future<ClinicSubscriptionPlanModel> createClinicSubscriptionPlan(CreateClinicSubscriptionPlanRequest request) async {
    final jsonResponse = await _api.post(
      Endpoint.subscriptionPlans,
      body: request.toJson(),
    );
    final response = ClinicSubscriptionPlanResponse.fromJson(
      jsonResponse,
    );

    if (!response.isSuccess) {
      throw BadRequestException(response.message);
    }
    return response.data!;
  }

  @override
  Future<ClinicSubscriptionPlanModel> updateSubscriptionPlan(int id, CreateClinicSubscriptionPlanRequest request) async {
    final jsonResponse = await _api.put(
      Endpoint.updateSubscriptionPlan,
      pathParams: {'id': id.toString()},
      body: request.toJson(),
    );
    final response = ClinicSubscriptionPlanResponse.fromJson(jsonResponse);

    if (!response.isSuccess) {
      throw BadRequestException(response.message);
    }
    return response.data!;
  }

  @override
  Future<bool> deleteSubscriptionPlan(int id) async {
    final jsonResponse = await _api.delete(
      Endpoint.deleteSubscriptionPlan,
      pathParams: {'id': id.toString()},
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
