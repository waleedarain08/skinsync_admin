import '../models/clinic_subscription_plan_model.dart';
import '../models/patient_subscription_plan_model.dart';
import '../models/requests/create_clinic_subscription_plan_request.dart';
import '../models/requests/create_patient_subscription_plan_request.dart';
import '../models/requests/create_subscription_duration_request.dart';
import '../models/responses/base_response_model.dart';
import '../models/responses/clinic_subscription_plan_list_response.dart';
import '../models/responses/clinic_subscription_plan_response.dart';
import '../models/responses/patient_subscription_plan_list_response.dart';
import '../models/responses/patient_subscription_plan_response.dart';
import '../models/responses/subscription_duration_list_response.dart';
import '../models/responses/subscription_duration_response.dart';
import '../repositories/subscription_repository.dart';
import '../utils/enums.dart';
import '../utils/exception.dart';
import 'api_base_helper.dart';

class SubscriptionServices implements SubscriptionRepository {
  final ApiBaseHelper _api;

  SubscriptionServices({required ApiBaseHelper api}) : _api = api;

  // ---------------- CLINICS ----------------

  @override
  Future<ClinicSubscriptionPlanListResponse> getSubscriptionPlans() async {
    final jsonResponse =
        await _api.get(Endpoint.subscriptionPlans) as Map<String, dynamic>;
    final response = ClinicSubscriptionPlanListResponse.fromJson(jsonResponse);

    if (!response.isSuccess) {
      throw BadRequestException(response.message);
    }
    return response;
  }

  @override
  Future<ClinicSubscriptionPlanModel> createClinicSubscriptionPlan(
    CreateClinicSubscriptionPlanRequest request,
  ) async {
    final jsonResponse = await _api.post(
      Endpoint.subscriptionPlans,
      body: request.toJson(),
    );
    final response = ClinicSubscriptionPlanResponse.fromJson(jsonResponse);
    if (!response.isSuccess) throw BadRequestException(response.message);
    return response.data!;
  }

  @override
  Future<ClinicSubscriptionPlanModel> updateSubscriptionPlan(
    int id,
    CreateClinicSubscriptionPlanRequest request,
  ) async {
    final jsonResponse = await _api.put(
      Endpoint.updateSubscriptionPlan,
      pathParams: {'id': id.toString()},
      body: request.toJson(),
    );
    final response = ClinicSubscriptionPlanResponse.fromJson(jsonResponse);
    if (!response.isSuccess) throw BadRequestException(response.message);
    return response.data!;
  }

  @override
  Future<BaseApiResponseModel> deleteSubscriptionPlan(int id) async {
    final jsonResponse =
        await _api.delete(
              Endpoint.deleteSubscriptionPlan,
              pathParams: {'id': id.toString()},
            )
            as Map<String, dynamic>;
    final response = BaseApiResponseModel<Null>.fromJson(jsonResponse);

    if (!response.isSuccess) {
      throw BadRequestException(response.message);
    }
    return response;
  }

  // ---------------- PATIENTS ----------------

  @override
  Future<PatientSubscriptionPlanListResponse>
  getPatientSubscriptionPlans() async {
    final jsonResponse =
        await _api.get(Endpoint.patientSubscriptionPlans)
            as Map<String, dynamic>;
    final response = PatientSubscriptionPlanListResponse.fromJson(jsonResponse);

    if (!response.isSuccess) {
      throw BadRequestException(response.message);
    }

    return response;
  }

  @override
  Future<PatientSubscriptionPlanModel> createPatientSubscriptionPlan(
    CreatePatientSubscriptionPlanRequest request,
  ) async {
    final jsonResponse = await _api.post(
      Endpoint.patientSubscriptionPlans,
      body: request.toJson(),
    );
    final response = PatientSubscriptionPlanResponse.fromJson(jsonResponse);
    if (!response.isSuccess) throw BadRequestException(response.message);
    return response.data!;
  }

  @override
  Future<PatientSubscriptionPlanModel> updatePatientSubscriptionPlan(
    int id,
    CreatePatientSubscriptionPlanRequest request,
  ) async {
    final jsonResponse = await _api.patch(
      Endpoint.updatePatientSubscriptionPlan,
      pathParams: {'id': id.toString()},
      body: request.toJson(),
    );
    final response = PatientSubscriptionPlanResponse.fromJson(jsonResponse);
    if (!response.isSuccess) throw BadRequestException(response.message);
    return response.data!;
  }

  @override
  Future<BaseApiResponseModel> deletePatientSubscriptionPlan(int id) async {
    final jsonResponse =
        await _api.delete(
              Endpoint.deletePatientSubscriptionPlan,
              pathParams: {'id': id.toString()},
            )
            as Map<String, dynamic>;
    final response = BaseApiResponseModel<Null>.fromJson(jsonResponse);

    if (!response.isSuccess) {
      throw BadRequestException(response.message);
    }
    return response;
  }

  // ---------------- DURATIONS ----------------

  @override
  Future<SubscriptionDurationListResponse> getSubscriptionDurations() async {
    final jsonResponse =
        await _api.get(Endpoint.subscriptionDurations) as Map<String, dynamic>;
    final response = SubscriptionDurationListResponse.fromJson(jsonResponse);

    if (!response.isSuccess) {
      throw BadRequestException(response.message);
    }

    return response;
  }

  @override
  Future<BaseApiResponseModel> createSubscriptionDuration(
    CreateSubscriptionDurationRequest request,
  ) async {
    final jsonResponse = await _api.post(
      Endpoint.subscriptionDurations,
      body: request.toJson(),
    );
    final response = SubscriptionDurationResponse.fromJson(jsonResponse);

    if (!response.isSuccess) {
      throw BadRequestException(response.message);
    }
    return response;
  }
}
