import '../models/requests/create_subscription_plan_request.dart';
import '../models/subscription_plan_model.dart';

abstract class SubscriptionRepository {
  Future<List<SubscriptionPlanModel>> getSubscriptionPlans();
  Future<SubscriptionPlanModel> createClinicSubscriptionPlan(CreateSubscriptionPlanRequest request);
  Future<SubscriptionPlanModel> updateSubscriptionPlan(int id, CreateSubscriptionPlanRequest request);
  Future<bool> deleteSubscriptionPlan(int id);
}
