import 'package:skinsync_admin/models/requests/create_treatment_requests/allowed_provider_role_request.dart';
import 'package:skinsync_admin/models/requests/create_treatment_requests/constent_form_selection_request.dart';
import 'package:skinsync_admin/models/requests/create_treatment_requests/treatment_area_request.dart';
import 'package:skinsync_admin/models/requests/create_treatment_requests/down_time_level_request.dart';
import 'package:skinsync_admin/models/requests/create_treatment_requests/follow_up_request.dart';
import 'package:skinsync_admin/models/requests/create_treatment_requests/phase_notifications_request.dart';
import 'package:skinsync_admin/models/requests/create_treatment_requests/post_photos_request.dart';
import 'package:skinsync_admin/models/requests/create_treatment_requests/post_treatment_instruction_request.dart';
import 'package:skinsync_admin/models/requests/create_treatment_requests/pre_treatment_instruction_request.dart';
import 'package:skinsync_admin/models/requests/create_treatment_requests/product_usage_request.dart';
import 'package:skinsync_admin/models/requests/create_treatment_requests/protocol_request.dart';
import 'package:skinsync_admin/models/requests/create_treatment_requests/step_pricing_request.dart';
import 'package:skinsync_admin/models/responses/base_response_model.dart';
import 'package:skinsync_admin/models/responses/treatment_detail_response.dart';
import 'package:skinsync_admin/models/requests/update_treatment_request.dart';

import '../models/requests/create_treatment_requests/basic_info_request.dart';
import '../models/requests/create_treatment_requests/business_logic_request.dart';
import '../models/requests/create_treatment_requests/sessions_setup_request.dart';
import '../models/requests/create_treatment_requests/treatment_schedule_request.dart';
import '../models/responses/basic_info_response.dart';
import '../models/responses/treatment_list_response.dart';
import '../models/responses/treatment_products_response.dart';
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
  }) async {
    final jsonResponse = await _api.get(
      Endpoint.adminTreatments,
      queryParams: {
        'page': page.toString(),
        'limit': limit.toString(),
        'search': search,
      },
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
  Future<BaseApiResponseModel> protocol({
    required ProtocolRequest request,
    required int draftTreatmentID,
  }) async {
    final jsonResponse = await _api.patch(
      Endpoint.updateTreatment,

      body: request,
      queryParams: {'treatment_id': draftTreatmentID.toString()},
    );
    final response = BaseApiResponseModel.fromJson(jsonResponse);

    if (!response.isSuccess) {
      throw BadRequestException(response.message);
    }

    return response;
  }

  @override
  Future<BaseApiResponseModel> productUsage({
    required ProductUsagesRequest request,
    required int draftTreatmentID,
  }) async {
    final jsonResponse = await _api.patch(
      Endpoint.updateTreatment,

      body: request,
      queryParams: {'treatment_id': draftTreatmentID.toString()},
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
    required int draftTreatmentID,
  }) async {
    final jsonResponse = await _api.patch(
      Endpoint.updateTreatment,

      body: request,
      queryParams: {'treatment_id': draftTreatmentID.toString()},
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
    required int draftTreatmentID,
  }) async {
    final jsonResponse = await _api.patch(
      Endpoint.updateTreatment,

      body: request,
      queryParams: {'treatment_id': draftTreatmentID.toString()},
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
    required int draftTreatmentID,
  }) async {
    final jsonResponse = await _api.patch(
      Endpoint.updateTreatment,

      body: request,
      queryParams: {'treatment_id': draftTreatmentID.toString()},
    );
    final response = BaseApiResponseModel.fromJson(jsonResponse);

    if (!response.isSuccess) {
      throw BadRequestException(response.message);
    }

    return response;
  }

  @override
  Future<BaseApiResponseModel> postTreatmentPhotos({
    required int draftTreatmentId,
    required bool requirePostPhotos,
    required int count,
  }) async {
    final jsonResponse = await _api.patch(
      Endpoint.updateTreatment,
      body: PostPhotosRequest(
        requirePostTreatmentPhotos: requirePostPhotos,
        requiredPostTreatmentPhotoCount: count,
      ),
      queryParams: {'treatment_id': draftTreatmentId.toString()},
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
    required int draftTreatmentID,
  }) async {
    final jsonResponse = await _api.patch(
      Endpoint.updateTreatment,

      body: request,
      queryParams: {'treatment_id': draftTreatmentID.toString()},
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
    required int draftTreatmentID,
  }) async {
    final jsonResponse = await _api.patch(
      Endpoint.updateTreatment,

      body: request,
      queryParams: {'treatment_id': draftTreatmentID.toString()},
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
    required int draftTreatmentID,
  }) async {
    final jsonResponse = await _api.patch(
      Endpoint.updateTreatment,

      body: request,
      queryParams: {'treatment_id': draftTreatmentID.toString()},
    );
    final response = BaseApiResponseModel.fromJson(jsonResponse);

    if (!response.isSuccess) {
      throw BadRequestException(response.message);
    }

    return response;
  }

  @override
  Future<TreatmentProductsResponse> getProductsByTreatment(
    List<int> categoryIds,
  ) async {
    final String idsParam = categoryIds.join(',');
    final jsonResponse = await _api.get(
      Endpoint.productsByTreatmentId,
      queryParams: {'category_ids': idsParam},
    );
    final response = TreatmentProductsResponse.fromJson(jsonResponse);
    if (!response.isSuccess) {
      throw BadRequestException(response.message);
    }
    return response;
  }

  @override
  Future<BaseApiResponseModel> phaseNotifications({
    required int draftTreatmentId,
    required PhaseNotificationsRequest request,
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
  Future<BaseApiResponseModel<dynamic>> followUpConfig({
    required int draftTreatmentId,
    required FollowUpRequest request,
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