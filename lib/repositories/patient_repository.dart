import '../models/responses/patient_detail_response.dart';
import '../models/responses/patient_list_response.dart';
import '../models/responses/patient_treatment_request_response.dart';
import '../utils/enums.dart';

abstract class PatientRepository {
  Future<PatientListResponse> getPatients({
    required int page,
    required int limit,
    String? search,
    PatientStatus? status,
  });

  Future<PatientDetailResponse> getPatientDetail({required int patientId});

  Future<PatientTreatmentRequestResponse> getPatientTreatmentRequests({
    required int page,
    required int limit,
    int? patientId,
  });

  Future<void> updatePatientStatus({
    required int patientId,
    required String status,
  });
}
