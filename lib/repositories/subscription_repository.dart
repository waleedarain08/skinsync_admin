import '../models/clinic_subscription_plan_model.dart';
import '../models/patient_subscription_plan_model.dart';
import '../models/requests/create_benefit_request.dart';
import '../models/requests/create_clinic_subscription_plan_request.dart';
import '../models/requests/create_patient_subscription_plan_request.dart';
import '../models/requests/create_subscription_duration_request.dart';
import '../models/responses/base_response_model.dart';
import '../models/responses/clinic_subscription_plan_list_response.dart';
import '../models/responses/patient_subscription_benefit_list_response.dart';
import '../models/responses/patient_subscription_plan_list_response.dart';
import '../models/responses/subscription_duration_list_response.dart';

abstract class SubscriptionRepository {
  // Clinics
  Future<ClinicSubscriptionPlanListResponse> getSubscriptionPlans();
  Future<ClinicSubscriptionPlanModel> createClinicSubscriptionPlan(CreateClinicSubscriptionPlanRequest request);
  Future<ClinicSubscriptionPlanModel> updateSubscriptionPlan(int id, CreateClinicSubscriptionPlanRequest request);
  Future<BaseApiResponseModel<dynamic>> deleteSubscriptionPlan(int id);

  // Patients
  Future<PatientSubscriptionPlanListResponse> getPatientSubscriptionPlans();
  Future<PatientSubscriptionPlanModel> createPatientSubscriptionPlan(CreatePatientSubscriptionPlanRequest request);
  Future<BaseApiResponseModel<dynamic>> updatePatientSubscriptionPlan(int id, CreatePatientSubscriptionPlanRequest request);
  Future<BaseApiResponseModel<dynamic>> deletePatientSubscriptionPlan(int id);

  // Durations
  Future<SubscriptionDurationListResponse> getSubscriptionDurations();
  Future<BaseApiResponseModel<dynamic>> createSubscriptionDuration(CreateSubscriptionDurationRequest request);

  // Benefits
  Future<PatientSubscriptionBenefitListResponse> getBenefits();
  Future<BaseApiResponseModel<dynamic>> createBenefit(CreateBenefitRequest request);
}
