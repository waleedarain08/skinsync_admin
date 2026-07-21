import 'package:skinsync_admin/models/requests/create_session_requests/allowed_provider_role_request.dart';
import 'package:skinsync_admin/models/requests/create_session_requests/constent_form_selection_request.dart';
import 'package:skinsync_admin/models/requests/create_session_requests/down_time_level_request.dart';
import 'package:skinsync_admin/models/requests/create_session_requests/final_finish_request.dart';
import 'package:skinsync_admin/models/requests/create_session_requests/follow_up_request.dart';
import 'package:skinsync_admin/models/requests/create_session_requests/phase_notifications_request.dart';
import 'package:skinsync_admin/models/requests/create_session_requests/post_photos_request.dart';
import 'package:skinsync_admin/models/requests/create_session_requests/post_treatment_instruction_request.dart';
import 'package:skinsync_admin/models/requests/create_session_requests/pre_treatment_instruction_request.dart';
import 'package:skinsync_admin/models/requests/create_session_requests/product_usage_request.dart';
import 'package:skinsync_admin/models/requests/create_session_requests/protocol_request.dart';
import 'package:skinsync_admin/models/requests/create_session_requests/step_pricing_request.dart';
import 'package:skinsync_admin/models/requests/create_session_requests/treatment_schedule_request.dart';
import 'package:skinsync_admin/models/responses/base_response_model.dart';
import 'package:skinsync_admin/models/responses/down_time_level_response.dart';
import 'package:skinsync_admin/models/responses/session_list_response.dart';
import 'package:skinsync_admin/models/responses/treatment_products_response.dart';
import 'package:skinsync_admin/models/responses/session_detail_response.dart';
import 'package:skinsync_admin/repositories/session_repository.dart';
import 'package:skinsync_admin/utils/enums.dart';
import 'package:skinsync_admin/utils/exception.dart';
import 'api_base_helper.dart';

class SessionServices implements SessionRepository {
  final ApiBaseHelper _api;

  SessionServices({required ApiBaseHelper api}) : _api = api;

  @override
  Future<BaseApiResponseModel> createSession({
    required int treatmentId,
    required int areaId,
    required String title,
    required int sessionNumber,
  }) async {
    final jsonResponse = await _api.post(
      Endpoint.createSession,
      body: {
        'treatment_id': treatmentId,
        'area_id': areaId,
        'title': title,
        'session_number': sessionNumber,
      },
    );
    final response = BaseApiResponseModel.fromJson(jsonResponse);
    if (!response.isSuccess) {
      throw BadRequestException(response.message);
    }
    return response;
  }

  @override
  Future<SessionListResponse> getSessions({
    required int treatmentId,
    required int areaId,
  }) async {
    final jsonResponse = await _api.get(
      Endpoint.sessionsList,
      queryParams: {
        'treatment_id': treatmentId.toString(),
        'area_id': areaId.toString(),
      },
    );
    final response = SessionListResponse.fromJson(jsonResponse);
    if (!response.isSuccess) {
      throw BadRequestException(response.message);
    }
    return response;
  }

   @override
  Future<TreatmentProductsResponse> getProductsByTreatment(
    int? unitTypeId,
  ) async {
   // final String idsParam = categoryIds.join(',');
    final jsonResponse = await _api.get(
      Endpoint.productsByTreatmentId,
     queryParams: {'unit_type_id': unitTypeId.toString()},
    );
    final response = TreatmentProductsResponse.fromJson(jsonResponse);
    if (!response.isSuccess) {
      throw BadRequestException(response.message);
    }
    return response;
  }


 @override
  Future<DownTimeLevelResponse> getDownTimeLevelByTreatment(
  {required int id,}
  ) async {
   // final String idsParam = categoryIds.join(',');
    final jsonResponse = await _api.get(
      Endpoint.downTimeLevel,
     pathParams: {'id': id.toString()},
    );
    final response = DownTimeLevelResponse.fromJson(jsonResponse);
    if (!response.isSuccess) {
      throw BadRequestException(response.message);
    }
    return response;
  }

  @override
  Future<BaseApiResponseModel> productUsage({
    required ProductUsagesRequest request,
    required int id,
  }) async {
    final jsonResponse = await _api.patch(
      Endpoint.sessionUpdate,

      body: request,
      queryParams: {'session_id': id.toString()},
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
      Endpoint.sessionUpdate,
      body: request.toJson(),
      queryParams: {'session_id': id.toString()},
    );

    final response = BaseApiResponseModel.fromJson(jsonResponse);

    if (!response.isSuccess) {
      throw BadRequestException(response.message);
    }
    return response;
  }
 @override
  Future<BaseApiResponseModel> stepPricing({
    required StepPricingRequest request,
    required int id,
  }) async {
    final jsonResponse = await _api.patch(
      Endpoint.sessionUpdate,

      body: request,
      queryParams: {'session_id': id.toString()},
    );
    final response = BaseApiResponseModel.fromJson(jsonResponse);

    if (!response.isSuccess) {
      throw BadRequestException(response.message);
    }

    return response;
  }

   @override
  Future<BaseApiResponseModel> protocol({
    required ProtocolRequest request,
    required int id,
  }) async {
    final jsonResponse = await _api.patch(
      Endpoint.sessionUpdate,

      body: request,
      queryParams: {'session_id': id.toString()},
    );
    final response = BaseApiResponseModel.fromJson(jsonResponse);

    if (!response.isSuccess) {
      throw BadRequestException(response.message);
    }

    return response;
  }

  
  @override
  Future<BaseApiResponseModel> preTreatmentInstructions({
    required PreTreatmentInstructionsRequest request,
    required int id,
  }) async {
    final jsonResponse = await _api.patch(
      Endpoint.sessionUpdate,

      body: request,
      queryParams: {'session_id': id.toString()},
    );
    final response = BaseApiResponseModel.fromJson(jsonResponse);

    if (!response.isSuccess) {
      throw BadRequestException(response.message);
    }

    return response;
  }

  @override
  Future<BaseApiResponseModel> postTreatmentInstructions({
    required PostTreatmentInstructionsRequest request,
    required int id,
  }) async {
    final jsonResponse = await _api.patch(
      Endpoint.sessionUpdate,

      body: request,
      queryParams: {'session_id': id.toString()},
    );
    final response = BaseApiResponseModel.fromJson(jsonResponse);

    if (!response.isSuccess) {
      throw BadRequestException(response.message);
    }

    return response;
  }

  @override
  Future<BaseApiResponseModel> postTreatmentPhotos({
    required int id,
    required bool requirePostPhotos,
    required int count,
    required List<PhotoMilestone> configs,
    required int stepNumber,
  }) async {
    final jsonResponse = await _api.patch(
      Endpoint.sessionUpdate,
      body: PostPhotosRequest(
        stepNumber: stepNumber,
        requirePostTreatmentPhotos: requirePostPhotos,
        photoMilestone: configs,
      ),
      queryParams: {'session_id': id.toString()},
    );
    final response = BaseApiResponseModel.fromJson(jsonResponse);

    if (!response.isSuccess) {
      throw BadRequestException(response.message);
    }
    return response;
  }

  @override
  Future<BaseApiResponseModel> downTimeLevels({
    required DownTimeLevelRequest request,
    required int id,
  }) async {
    final jsonResponse = await _api.patch(
      Endpoint.sessionUpdate,

      body: request,
      queryParams: {'session_id': id.toString()},
    );
    final response = BaseApiResponseModel.fromJson(jsonResponse);

    if (!response.isSuccess) {
      throw BadRequestException(response.message);
    }

    return response;
  }

  @override
  Future<BaseApiResponseModel> allowedProviderRoles({
    required AllowedProviderRolesRequest request,
    required int id,
  }) async {
    final jsonResponse = await _api.patch(
      Endpoint.sessionUpdate,

      body: request,
      queryParams: {'session_id': id.toString()},
    );
    final response = BaseApiResponseModel.fromJson(jsonResponse);

    if (!response.isSuccess) {
      throw BadRequestException(response.message);
    }

    return response;
  }

  @override
  Future<BaseApiResponseModel> consentFormSelection({
    required ConsentFormSelectionRequest request,
    required int id,
  }) async {
    final jsonResponse = await _api.patch(
      Endpoint.sessionUpdate,

      body: request,
      queryParams: {'session_id': id.toString()},
    );
    final response = BaseApiResponseModel.fromJson(jsonResponse);

    if (!response.isSuccess) {
      throw BadRequestException(response.message);
    }

    return response;
  }

 
  @override
  Future<BaseApiResponseModel> phaseNotifications({
    required int id,
    required PhaseNotificationsRequest request,
  }) async {
    final jsonResponse = await _api.patch(
      Endpoint.sessionUpdate,
      body: request,
      queryParams: {'session_id': id.toString()},
    );
    final response = BaseApiResponseModel.fromJson(jsonResponse);

    if (!response.isSuccess) {
      throw BadRequestException(response.message);
    }
    return response;
  }

@override
  Future<BaseApiResponseModel<dynamic>> followUpConfig({
    required int id,
    required FollowUpRequest request,
  }) async {
    final jsonResponse = await _api.patch(
      Endpoint.sessionUpdate,
      body: request,
      queryParams: {'session_id': id.toString()},
    );
    final response = BaseApiResponseModel.fromJson(jsonResponse);

    if (!response.isSuccess) {
      throw BadRequestException(response.message);
    }
    return response;
  }

@override
  Future<BaseApiResponseModel<dynamic>> finalFinish({
    required int id,
    required FinalFinishRequest request,
  }) async {
    final jsonResponse = await _api.patch(
      Endpoint.sessionUpdate,
      body: request,
      queryParams: {'session_id': id.toString()},
    );
    final response = BaseApiResponseModel.fromJson(jsonResponse);

    if (!response.isSuccess) {
      throw BadRequestException(response.message);
    }
    return response;
  }

  @override
  Future<SessionDetailResponse> getSessionDetail({
    required int id,
  }) async {
    final jsonResponse = await _api.get(
      Endpoint.sessionDetail,
      pathParams: {'id': id.toString()},
    );
    final response = SessionDetailResponse.fromJson(jsonResponse);

    if (!response.isSuccess) {
      throw BadRequestException(response.message);
    }
    return response;
  }

  @override
  Future<BaseApiResponseModel> deleteSession({
    required int id,
  }) async {
    final jsonResponse = await _api.delete(
      Endpoint.deleteSession,
      pathParams: {'id':id.toString()},
    );
    final response = BaseApiResponseModel.fromJson(jsonResponse);

    if (!response.isSuccess) {
      throw BadRequestException(response.message);
    }
    return response;
  }



}