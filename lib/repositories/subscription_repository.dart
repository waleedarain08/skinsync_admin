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
  Future<BaseApiResponseModel<dynamic>> createClinicSubscriptionPlan(
    CreateClinicSubscriptionPlanRequest request,
  );
  Future<BaseApiResponseModel<dynamic>> updateSubscriptionPlan(
    String id,
    CreateClinicSubscriptionPlanRequest request,
  );
  Future<BaseApiResponseModel<dynamic>> deleteSubscriptionPlan(String id);

  // Patients
  Future<PatientSubscriptionPlanListResponse> getPatientPlans();
  Future<BaseApiResponseModel<dynamic>> createPatientSubscriptionPlan(
    CreatePatientSubscriptionPlanRequest request,
  );
  Future<BaseApiResponseModel<dynamic>> updatePatientSubscriptionPlan(
    String id,
    CreatePatientSubscriptionPlanRequest request,
  );
  Future<BaseApiResponseModel<dynamic>> deletePatientSubscriptionPlan(
    String id,
  );

  // Durations
  Future<SubscriptionDurationListResponse> getSubscriptionDurations();
  Future<BaseApiResponseModel<dynamic>> createSubscriptionDuration(
    CreateSubscriptionDurationRequest request,
  );

  // Benefits
  Future<PatientSubscriptionBenefitListResponse> getBenefits();
  Future<BaseApiResponseModel<dynamic>> createBenefit(
    CreateBenefitRequest request,
  );
}
