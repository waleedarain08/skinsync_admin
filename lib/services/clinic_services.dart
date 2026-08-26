import 'dart:async';

import 'package:skinsync_admin/models/requests/register_clinic_request_model.dart';
import 'package:skinsync_admin/models/requests/send_notes_request.dart';
import 'package:skinsync_admin/models/requests/update_clinic_request.dart';
import 'package:skinsync_admin/models/responses/base_response_model.dart';
import 'package:skinsync_admin/models/responses/clinic_detail_response.dart';
import 'package:skinsync_admin/models/responses/clinic_list_response.dart';
import 'package:skinsync_admin/models/responses/clinic_web_request_detail_response.dart';
import 'package:skinsync_admin/models/responses/clinic_web_request_list_response.dart';
import 'package:skinsync_admin/models/responses/founder_clinic_detail_response.dart';
import 'package:skinsync_admin/models/responses/founder_clinic_list_response.dart';
import 'package:skinsync_admin/models/responses/invite_clinic_detail_response.dart';
import 'package:skinsync_admin/repositories/clinic_repository.dart';

import '../utils/enums.dart';
import '../utils/exception.dart';
import 'api_base_helper.dart';

class ClinicService implements ClinicRepository {
  final ApiBaseHelper _api;

  ClinicService({required ApiBaseHelper api}) : _api = api;

  @override
  Future<BaseApiResponseModel> registerClinic({
    required RegisterClinicReqModel req,
  }) async {
    final jsonResponse = await _api.post(
      Endpoint.registerClinic,
      body: req.toJson(),
    );
    final response = BaseApiResponseModel.fromJson(jsonResponse);

    if (!response.isSuccess) {
      throw BadRequestException(response.message);
    }
    return response;
  }

  @override
  Future<BaseApiResponseModel> updateClinicStatus({
    required int clinicId,
    required Status status,
  }) async {
    final jsonResponse = await _api.patch(
      Endpoint.updateClinicStatus,
      pathParams: {'id' : clinicId.toString()},
      body: {
        'status': status.name,
      },
    );
    final response = BaseApiResponseModel.fromJson(jsonResponse);

    if (!response.isSuccess) {
      throw BadRequestException(response.message);
    }
    return response;
  }

  @override
  Future<BaseApiResponseModel> updateClinic({
   
    required UpdateClinicRequest req,
  }) async {
    final jsonResponse = await _api.patch(
      Endpoint.updateClinic,
     
      body: req.toJson(),
    );
    final response = BaseApiResponseModel.fromJson(jsonResponse);

    if (!response.isSuccess) {
      throw BadRequestException(response.message);
    }
    return response;
  }

  @override
  Future<ClinicListResponse> getClinics({
    required int page,
    required int limit,
    String? search,
    String? status,
  }) async {
    final Map<String, String> queryParams = {
      'page': page.toString(),
      'limit': limit.toString(),
      'search': search ?? 'null',
    };
    if (status != null) {
      queryParams['status'] = status;
    }
    final jsonResponse = await _api.get(
      Endpoint.getClinics,
      queryParams: queryParams,
    );
    final response = ClinicListResponse.fromJson(jsonResponse);

    if (!response.isSuccess) {
      throw BadRequestException(response.message);
    }
    return response;
  }

  @override
  Future<ClinicListResponse> getInviteClinics({
    required int page,
    required int limit,
    String? search,
    String? status,
  }) async {
    final Map<String, String> queryParams = {
      'page': page.toString(),
      'limit': limit.toString(),
      'search': search ?? 'null',
    };
    if (status != null && status.isNotEmpty) {
      queryParams['status'] = status;
    }
    final jsonResponse = await _api.get(
      Endpoint.inviteClinics,
      queryParams: queryParams,
    );
    final response = ClinicListResponse.fromJson(jsonResponse);

    if (!response.isSuccess) {
      throw BadRequestException(response.message);
    }
    return response;
  }

  @override
  Future<ClinicWebRequestListResponse> getWebRequests({
    required int page,
    required int limit,
    String? search,
    String? status,
  }) async {
    final Map<String, String> queryParams = {
      'page': page.toString(),
      'limit': limit.toString(),
      'search': search ?? '',
    };
    if (status != null && status.isNotEmpty) {
      queryParams['status'] = status;
    }
    final jsonResponse = await _api.get(
      Endpoint.webRequests,
      queryParams: queryParams,
    );
    final response = ClinicWebRequestListResponse.fromJson(jsonResponse);

    if (!(response.isSuccess ?? false)) {
      throw BadRequestException(
        response.message ?? 'Failed to get web requests',
      );
    }
    return response;
  }

  @override
  Future<FounderClinicListResponse> getFounderClinics({
    required int page,
    required int limit,
    String? search,
    String? status,
  }) async {
    final Map<String, String> queryParams = {
      'page': page.toString(),
      'limit': limit.toString(),
      'search': search ?? '',
    };
    if (status != null && status.isNotEmpty) {
      queryParams['status'] = status;
    }
    final jsonResponse = await _api.get(
      Endpoint.founderClinics,
      queryParams: queryParams,
    );
    final response = FounderClinicListResponse.fromJson(jsonResponse);

    if (!(response.isSuccess)) {
      throw BadRequestException(response.message);
    }
    return response;
  }

  @override
  Future<BaseApiResponseModel> sendInvitation({
    required int inviteClinicId,
  }) async {
    final jsonResponse = await _api.post(
      Endpoint.sendInvitation,
      body: {'invite_clinic_id': inviteClinicId},
    );
    final response = BaseApiResponseModel.fromJson(jsonResponse);

    if (!response.isSuccess) {
      throw BadRequestException(response.message);
    }
    return response;
  }

  @override
  Future<ClinicDetailResponse> getClinicDetail({required int clinicId}) async {
    final jsonResponse = await _api.get(
      Endpoint.clinicDetail,
      queryParams: {'id': clinicId.toString()},
    );
    final response = ClinicDetailResponse.fromJson(jsonResponse);
    final isSuccess = jsonResponse['is_success'] as bool? ?? false;
    if (!isSuccess) {
      throw BadRequestException(
        jsonResponse['message'] ?? 'Failed to get clinic detail',
      );
    }
    return response;
  }

  @override
  Future<InviteClinicDetailResponse> getInviteClinicDetail({
    required int inviteClinicId,
  }) async {
    final jsonResponse = await _api.get(
      Endpoint.inviteClinicDetail,
      queryParams: {'id': inviteClinicId.toString()},
    );
    final response = InviteClinicDetailResponse.fromJson(jsonResponse);
    final isSuccess = jsonResponse['is_success'] as bool? ?? false;
    if (!isSuccess) {
      throw BadRequestException(
        jsonResponse['message'] ?? 'Failed to get invite clinic detail',
      );
    }
    return response;
  }

  @override
  Future<ClinicWebRequestDetailResponse> getWebRequestDetail({
    required int id,
  }) async {
    final jsonResponse = await _api.get(
      Endpoint.webRequestDetail,
      pathParams: {'id': id.toString()},
    );
    final response = ClinicWebRequestDetailResponse.fromJson(jsonResponse);
    if (!(response.isSuccess ?? false)) {
      throw BadRequestException(
        response.message ?? 'Failed to get web request detail',
      );
    }
    return response;
  }

  @override
  Future<BaseApiResponseModel> sendWebRequestNotes({
    required int id,
    required SendNotesRequest req,
  }) async {
    final jsonResponse = await _api.post(
      Endpoint.sendWebRequestNotes,
      pathParams: {'id': id.toString()},
      body: req.toJson(),
    );
    return BaseApiResponseModel.fromJson(jsonResponse);
  }

  @override
  Future<FounderClinicDetailResponse> getFounderClinicDetail({
    required int id,
  }) async {
    final jsonResponse = await _api.get(
      Endpoint.founderClinicDetail,
      pathParams: {'id': id.toString()},
    );
    final response = FounderClinicDetailResponse.fromJson(jsonResponse);
    if (!(response.isSuccess ?? false)) {
      throw BadRequestException(
        response.message ?? 'Failed to get founder clinic detail',
      );
    }
    return response;
  }
}
