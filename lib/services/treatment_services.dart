
import 'package:skinsync_admin/models/requests/create_protocol_field_request.dart';
import 'package:skinsync_admin/models/requests/create_session_requests/treatment_schedule_request.dart';
import 'package:skinsync_admin/models/requests/create_treatment_requests/basic_info_request.dart';
import 'package:skinsync_admin/models/requests/create_treatment_requests/sessions_setup_request.dart';
import 'package:skinsync_admin/models/requests/create_treatment_requests/treatment_area_request.dart';
import 'package:skinsync_admin/models/requests/create_treatment_requests/update_basic_info_request.dart';
import 'package:skinsync_admin/models/requests/session_status_request.dart';
import 'package:skinsync_admin/models/requests/update_treatment_request.dart';
import 'package:skinsync_admin/models/responses/base_response_model.dart';
import 'package:skinsync_admin/models/responses/basic_info_response.dart';
import 'package:skinsync_admin/models/responses/protocol_fields_response.dart';
import 'package:skinsync_admin/models/responses/treatment_detail_response.dart';
import 'package:skinsync_admin/models/responses/treatment_list_response.dart';
import 'package:skinsync_admin/repositories/treatment_repository.dart';
import 'package:skinsync_admin/utils/enums.dart';
import 'package:skinsync_admin/utils/exception.dart';
import 'package:skinsync_admin/services/api_base_helper.dart';

class TreatmentServices implements TreatmentRepository {
  // ignore: unused_field
  final ApiBaseHelper _api;

  TreatmentServices({required ApiBaseHelper api}) : _api = api;

  @override
  Future<TreatmentListResponse> getTreatments({
    required int page,
    required int limit,
    String search = '',
    int? categoryId,
    TreatmentStatus? status,
  }) async {
    final Map<String, String> params = {
      'page': page.toString(),
      'limit': limit.toString(),
      'search': search,
      'status':  status == null || status == TreatmentStatus.all ? '' : status.name.toLowerCase()
    };
    if (categoryId != null) {
      params['category_id'] = categoryId.toString();
    }
    final jsonResponse = await _api.get(
      Endpoint.adminTreatments,
      queryParams: params,
    );
    final response = TreatmentListResponse.fromJson(jsonResponse);
    if (!response.isSuccess) {
      throw BadRequestException(response.message);
    }
    return response;
  }

  @override
  Future<BasicInfoResponse> createBasicInfo(BasicInfoRequest request) async {
    final jsonResponse = await _api.post(
      Endpoint.basicInfo,
      body: request.toJson(),
    );
    final response = BasicInfoResponse.fromJson(jsonResponse);

    if (!response.isSuccess) {
      throw BadRequestException(response.message);
    }
    return response;
  }
   @override
  Future<BasicInfoResponse> updateBasicInfo(UpdateBasicInfoRequest request, int id) async {
    final jsonResponse = await _api.patch(
      Endpoint.updateTreatment,
      body: request.toJson(),
      queryParams: {'treatment_id': id.toString()},
    );
    final response = BasicInfoResponse.fromJson(jsonResponse);

    if (!response.isSuccess) {
      throw BadRequestException(response.message);
    }
    return response;
  }


  @override
  Future<BaseApiResponseModel<dynamic>> createTreatmentArea(
    TreatmentAreaRequest request,
    int id,
  ) async {
    final jsonResponse = await _api.patch(
      Endpoint.updateTreatment,
      body: request.toJson(),
      queryParams: {'treatment_id': id.toString()},
    );

    final response = BaseApiResponseModel<dynamic>.fromJson(jsonResponse);

    if (!response.isSuccess) {
      throw BadRequestException(response.message);
    }
    return response;
  }

  @override
  Future<BaseApiResponseModel<dynamic>> createSchedule(
    TreatmentScheduleRequest request,
    int id,
  ) async {
    final jsonResponse = await _api.patch(
      Endpoint.updateTreatment,
      body: request.toJson(),
      queryParams: {'treatment_id': id.toString()},
    );

    final response = BaseApiResponseModel<dynamic>.fromJson(jsonResponse);

    if (!response.isSuccess) {
      throw BadRequestException(response.message);
    }
    return response;
  }

 
 
  @override
  Future<BaseApiResponseModel<dynamic>> sessionsSetup({
    required int draftTreatmentId,
    required SessionsSetupRequest request,
  }) async {
    final jsonResponse = await _api.patch(
      Endpoint.updateTreatment,
      body: request,
      queryParams: {'treatment_id': draftTreatmentId.toString()},
    );
    final response = BaseApiResponseModel<dynamic>.fromJson(jsonResponse);

    if (!response.isSuccess) {
      throw BadRequestException(response.message);
    }
    return response;
  }

  
  // @override
  // Future<BaseApiResponseModel<dynamic>> businessLogic({
  //   required int draftTreatmentId,
  //   required BusinessLogicRequest request,
  // }) async {
  //   final jsonResponse = await _api.patch(
  //     Endpoint.updateTreatment,
  //     body: request,
  //     queryParams: {'treatment_id': draftTreatmentId.toString()},
  //   );
  //   final response = BaseApiResponseModel.fromJson(jsonResponse);
  //
  //   if (!response.isSuccess) {
  //     throw BadRequestException(response.message);
  //   }
  //   return response;
  // }

  @override
  Future<BaseApiResponseModel<dynamic>> updateTreatmentStatus({
    required int treatmentId,
    required String status,
  }) async {
    final jsonResponse = await _api.patch(
      Endpoint.treatmentsStatus,
      body: {'status': status},
      queryParams: {'treatment_id': treatmentId.toString()},
    );
    final response = BaseApiResponseModel<dynamic>.fromJson(jsonResponse);
    if (!response.isSuccess) {
      throw BadRequestException(response.message);
    }
    return response;
  }

  @override
  Future<TreatmentDetailResponse> getTreatmentDetail({
    required int id,
  }) async {
    final jsonResponse = await _api.get(
      Endpoint.treatmentDetail,
      pathParams: {'id': id.toString()},
    );
    final response = TreatmentDetailResponse.fromJson(jsonResponse);
    if (!response.isSuccess) {
      throw BadRequestException(response.message);
    }
    return response;
  }

  @override
  Future<BaseApiResponseModel<dynamic>> changeSessionStatus({
    required SessionStatusRequest request,
  }) async {
    final jsonResponse = await _api.patch(
      Endpoint.sessionStatus,
      body: request
    );
    final response = BaseApiResponseModel<dynamic>.fromJson(jsonResponse);

    if (!response.isSuccess) {
      throw BadRequestException(response.message);
    }
    return response;
  }

  @override
  Future<BaseApiResponseModel<dynamic>> updateTreatment({
    required int treatmentId,
    required UpdateTreatmentRequest request,
  }) async {
    final jsonResponse = await _api.patch(
      Endpoint.updateTreatment,
      body: request.toJson(),
      queryParams: {'treatment_id': treatmentId.toString()},
    );
    final response = BaseApiResponseModel<dynamic>.fromJson(jsonResponse);
    if (!response.isSuccess) {
      throw BadRequestException(response.message);
    }
    return response;
  }

  @override
  Future<ProtocolFieldsResponse> getProtocolFields() async {
    final jsonResponse = await _api.get(Endpoint.protocolFields);
    final response = ProtocolFieldsResponse.fromJson(jsonResponse);
    if (!response.isSuccess) {
      throw BadRequestException(response.message);
    }
    return response;
  }

  @override
  Future<BaseApiResponseModel<dynamic>> createProtocolField(
    CreateProtocolFieldRequest request,
  ) async {
    final jsonResponse = await _api.post(
      Endpoint.protocolFields,
      body: request.toJson(),
    );
    final response = BaseApiResponseModel<dynamic>.fromJson(jsonResponse);
    if (!response.isSuccess) {
      throw BadRequestException(response.message);
    }
    return response;
  }
}