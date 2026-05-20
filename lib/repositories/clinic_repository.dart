import 'package:skinsync_admin/models/clinic_model.dart';

import '../models/requests/register_clinic_request_model.dart';

abstract class ClinicRepository {
  Future<ClinicModel> registerClinic({required RegisterClinicReqModel req});
  Future<ClinicModel> updateClinic({required int id, required RegisterClinicReqModel req});
  Future<List<ClinicModel>> getClinics();
}
