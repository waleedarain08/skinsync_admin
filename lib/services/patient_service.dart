import '../models/responses/patient_detail_response.dart';
import '../models/responses/patient_list_response.dart';
import '../models/responses/patient_treatment_request_response.dart';
import '../repositories/patient_repository.dart';
import '../utils/enums.dart';
import '../utils/exception.dart';
import 'api_base_helper.dart';

class PatientService implements PatientRepository {
  final ApiBaseHelper _api;

  PatientService({required ApiBaseHelper api}) : _api = api;

  @override
  Future<PatientListResponse> getPatients({
    required int page,
    required int limit,
    String? search,
    PatientStatus? status,
  }) async {
    final jsonResponse = await _api.get(
      Endpoint.patients,
      queryParams: {
        'page': page.toString(),
        'limit': limit.toString(),
        'status': status == null || status == PatientStatus.all
            ? ''
            : status.name,
        if (search != null && search.isNotEmpty) 'search': search,
      },
    );

    final response = PatientListResponse.fromJson(jsonResponse);

    if (!response.isSuccess) {
      throw BadRequestException(response.message);
    }

    return response;
  }

  @override
  Future<PatientDetailResponse> getPatientDetail({
    required int patientId,
  }) async {
    final jsonResponse = await _api.get(
      Endpoint.patientDetail,
      pathParams: {'id': patientId.toString()},
    );

    final response = PatientDetailResponse.fromJson(jsonResponse);

    if (!response.isSuccess) {
      throw BadRequestException(response.message);
    }

    return response;
  }

  @override
  Future<PatientTreatmentRequestResponse> getPatientTreatmentRequests({
    required int page,
    required int limit,
    int? patientId,
  }) async {
    final jsonResponse = await _api.get(
      Endpoint.patientTreatmentRequest,
      queryParams: {
        'page': page.toString(),
        'limit': limit.toString(),
        if (patientId != null) 'patient_id': patientId.toString(),
      },
    );

    final response = PatientTreatmentRequestResponse.fromJson(jsonResponse);

    if (!response.isSuccess) {
      throw BadRequestException(response.message);
    }

    return response;
  }

  @override
  Future<void> updatePatientStatus({
    required int patientId,
    required String status,
  }) async {
    final response = await _api.patch(
      Endpoint.updatePatientStatus,
      body: {'status': status},
      pathParams: {'id': patientId.toString()},
    );

    if (response is Map && response['success'] == false) {
      throw BadRequestException(
        response['message'] ?? 'Failed to update status',
      );
    }
  }
}
