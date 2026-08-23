import '../models/clinic_subscription_plan_model.dart';
import '../models/requests/create_clinic_subscription_plan_request.dart';

abstract class SubscriptionRepository {
  Future<List<ClinicSubscriptionPlanModel>> getSubscriptionPlans();
  Future<ClinicSubscriptionPlanModel> createClinicSubscriptionPlan(CreateClinicSubscriptionPlanRequest request);
  Future<ClinicSubscriptionPlanModel> updateSubscriptionPlan(int id, CreateClinicSubscriptionPlanRequest request);
  Future<bool> deleteSubscriptionPlan(int id);
}
