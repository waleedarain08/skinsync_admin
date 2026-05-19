import '../models/subscription_plan_model.dart';

abstract class SubscriptionRepository {
  Future<List<SubscriptionPlanModel>> getSubscriptionPlans();
  Future<SubscriptionPlanModel> createSubscriptionPlan(SubscriptionPlanModel plan);
}
