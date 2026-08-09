import 'package:skinsync_admin/models/clinic_model.dart';
import 'package:skinsync_admin/models/responses/base_response_model.dart';
import 'package:skinsync_admin/models/responses/clinic_detail_response.dart';
import 'package:skinsync_admin/models/responses/clinic_list_response.dart';
import 'package:skinsync_admin/models/responses/invite_clinic_detail_response.dart';
import 'package:skinsync_admin/models/responses/clinic_web_request_detail_response.dart';
import 'package:skinsync_admin/models/responses/clinic_web_request_list_response.dart';
import 'package:skinsync_admin/models/responses/founder_clinic_detail_response.dart';
import 'package:skinsync_admin/models/responses/founder_clinic_list_response.dart';
import 'package:skinsync_admin/models/responses/clinic_list_response.dart';
import 'package:skinsync_admin/models/requests/send_notes_request.dart';

import '../models/requests/register_clinic_request_model.dart';

abstract class ClinicRepository {
  Future<BaseApiResponseModel> registerClinic({required RegisterClinicReqModel req});
  Future<ClinicModel> updateClinic({required int id, required RegisterClinicReqModel req});
  Future<ClinicListResponse> getClinics({
    required int page,
    required int limit,
    String? search,
    String? status,
  });
  Future<ClinicListResponse> getInviteClinics({
    required int page,
    required int limit,
    String? search,
    String? status,
  });
  Future<ClinicWebRequestListResponse> getWebRequests({
    required int page,
    required int limit,
    String? search,
    String? status,
  });
  Future<FounderClinicListResponse> getFounderClinics({
    required int page,
    required int limit,
    String? search,
    String? status,
  });
  Future<BaseApiResponseModel> sendInvitation({required int inviteClinicId});
  Future<ClinicDetailResponse> getClinicDetail({required int clinicId});
  Future<InviteClinicDetailResponse> getInviteClinicDetail({required int inviteClinicId});
  Future<ClinicWebRequestDetailResponse> getWebRequestDetail({required int id});
  Future<BaseApiResponseModel> sendWebRequestNotes({required int id, required SendNotesRequest req});
  Future<FounderClinicDetailResponse> getFounderClinicDetail({required int id});
}
