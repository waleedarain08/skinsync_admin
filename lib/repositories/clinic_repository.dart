import 'package:skinsync_admin/models/clinic_model.dart';
import 'package:skinsync_admin/models/responses/base_response_model.dart';
import 'package:skinsync_admin/models/responses/clinic_detail_response.dart';
import 'package:skinsync_admin/models/responses/invite_clinic_detail_response.dart';

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
    String? status,
  });
  Future<BaseApiResponseModel> sendInvitation({required int inviteClinicId});
  Future<ClinicDetailResponse> getClinicDetail({required int clinicId});
  Future<InviteClinicDetailResponse> getInviteClinicDetail({required int inviteClinicId});
}
