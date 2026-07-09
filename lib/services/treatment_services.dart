
import 'package:skinsync_admin/models/requests/create_treatment_requests/treatment_area_request.dart';
import 'package:skinsync_admin/models/requests/update_treatment_request.dart';
import 'package:skinsync_admin/models/responses/base_response_model.dart';

import '../models/requests/create_treatment_requests/basic_info_request.dart';
import '../models/requests/create_treatment_requests/business_logic_request.dart';
import '../models/requests/create_treatment_requests/sessions_setup_request.dart';
import '../models/requests/create_session_requests/treatment_schedule_request.dart';
import '../models/responses/basic_info_response.dart';
import '../models/responses/treatment_list_response.dart';
import '../models/responses/treatment_detail_response.dart';
import '../repositories/treatment_repository.dart';
import '../utils/enums.dart';
import '../utils/exception.dart';
import 'api_base_helper.dart';

class TreatmentServices implements TreatmentRepository {
  // ignore: unused_field
  final ApiBaseHelper _api;

  TreatmentServices({required ApiBaseHelper api}) : _api = api;

  @override
  Future<TreatmentListResponse> getTreatments({
    int page = 1,
    int limit = 10,
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
  Future<BasicInfoResponse> updateBasicInfo(BasicInfoRequest request, int id) async {
    final jsonResponse = await _api.patch(
      Endpoint.basicInfo,
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
  Future<BaseApiResponseModel> createTreatmentArea(
    TreatmentAreaRequest request,
    int id,
  ) async {
    final jsonResponse = await _api.patch(
      Endpoint.updateTreatment,
      body: request.toJson(),
      queryParams: {'treatment_id': id.toString()},
    );

    final response = BaseApiResponseModel.fromJson(jsonResponse);

    if (!response.isSuccess) {
      throw BadRequestException(response.message);
    }
    return response;
  }

  @override
  Future<BaseApiResponseModel> createSchedule(
    TreatmentScheduleRequest request,
    int id,
  ) async {
    final jsonResponse = await _api.patch(
      Endpoint.updateTreatment,
      body: request.toJson(),
      queryParams: {'treatment_id': id.toString()},
    );

    final response = BaseApiResponseModel.fromJson(jsonResponse);

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
    final response = BaseApiResponseModel.fromJson(jsonResponse);

    if (!response.isSuccess) {
      throw BadRequestException(response.message);
    }
    return response;
  }

  
  @override
  Future<BaseApiResponseModel<dynamic>> businessLogic({
    required int draftTreatmentId,
    required BusinessLogicRequest request,
  }) async {
    final jsonResponse = await _api.patch(
      Endpoint.updateTreatment,
      body: request,
      queryParams: {'treatment_id': draftTreatmentId.toString()},
    );
    final response = BaseApiResponseModel.fromJson(jsonResponse);

    if (!response.isSuccess) {
      throw BadRequestException(response.message);
    }
    return response;
  }

  @override
  Future<BaseApiResponseModel> updateTreatmentStatus({
    required int treatmentId,
    required String status,
  }) async {
    final jsonResponse = await _api.patch(
      Endpoint.treatmentsStatus,
      body: {'status': status},
      queryParams: {'treatment_id': treatmentId.toString()},
    );
    final response = BaseApiResponseModel.fromJson(jsonResponse);
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
  Future<BaseApiResponseModel> updateTreatment({
    required int treatmentId,
    required UpdateTreatmentRequest request,
  }) async {
    final jsonResponse = await _api.patch(
      Endpoint.updateTreatment,
      body: request.toJson(),
      queryParams: {'treatment_id': treatmentId.toString()},
    );
    final response = BaseApiResponseModel.fromJson(jsonResponse);
    if (!response.isSuccess) {
      throw BadRequestException(response.message);
    }
    return response;
  }
}