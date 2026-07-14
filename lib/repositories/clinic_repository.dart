import 'package:skinsync_admin/models/clinic_model.dart';
import 'package:skinsync_admin/models/responses/base_response_model.dart';

import '../models/requests/register_clinic_request_model.dart';

abstract class ClinicRepository {
  Future<BaseApiResponseModel> registerClinic({required RegisterClinicReqModel req});
  Future<ClinicModel> updateClinic({required int id, required RegisterClinicReqModel req});
  Future<List<ClinicModel>> getClinics({
    required int page,
    required int limit,
    String? search,
    String? status,
  });
  Future<List<ClinicModel>> getInviteClinics({
    required int page,
    required int limit,
    String? search,
    required String status,
  });
}
