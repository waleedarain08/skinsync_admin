import '../models/clinic_subscription_plan_model.dart';
import '../models/patient_subscription_plan_model.dart';
import '../models/requests/create_clinic_subscription_plan_request.dart';
import '../models/requests/create_patient_subscription_plan_request.dart';

abstract class SubscriptionRepository {
  // Clinics
  Future<List<ClinicSubscriptionPlanModel>> getSubscriptionPlans();
  Future<ClinicSubscriptionPlanModel> createClinicSubscriptionPlan(CreateClinicSubscriptionPlanRequest request);
  Future<ClinicSubscriptionPlanModel> updateSubscriptionPlan(int id, CreateClinicSubscriptionPlanRequest request);
  Future<bool> deleteSubscriptionPlan(int id);

  // Patients
  Future<List<PatientSubscriptionPlanModel>> getPatientSubscriptionPlans();
  Future<PatientSubscriptionPlanModel> createPatientSubscriptionPlan(CreatePatientSubscriptionPlanRequest request);
  Future<PatientSubscriptionPlanModel> updatePatientSubscriptionPlan(int id, CreatePatientSubscriptionPlanRequest request);
  Future<bool> deletePatientSubscriptionPlan(int id);
}
