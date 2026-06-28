import 'package:skinsync_admin/models/requests/create_treatment_requests/business_logic_request.dart';
import 'package:skinsync_admin/models/requests/create_treatment_requests/constent_form_selection_request.dart';
import 'package:skinsync_admin/models/requests/create_treatment_requests/treatment_area_request.dart';
import 'package:skinsync_admin/models/requests/create_treatment_requests/follow_up_request.dart';
import 'package:skinsync_admin/models/requests/create_treatment_requests/phase_notifications_request.dart';
import 'package:skinsync_admin/models/requests/create_treatment_requests/post_treatment_instruction_request.dart';
import 'package:skinsync_admin/models/requests/create_treatment_requests/pre_treatment_instruction_request.dart';
import 'package:skinsync_admin/models/requests/create_treatment_requests/product_usage_request.dart';
import 'package:skinsync_admin/models/requests/create_treatment_requests/protocol_request.dart';
import 'package:skinsync_admin/models/requests/create_treatment_requests/step_pricing_request.dart';
import 'package:skinsync_admin/models/responses/basic_info_response.dart';
import 'package:skinsync_admin/models/responses/treatment_list_response.dart';
import 'package:skinsync_admin/models/responses/treatment_detail_response.dart';
import 'package:skinsync_admin/models/requests/update_treatment_request.dart';

import '../models/requests/create_treatment_requests/allowed_provider_role_request.dart';
import '../models/requests/create_treatment_requests/basic_info_request.dart';
import '../models/requests/create_treatment_requests/down_time_level_request.dart';
import '../models/requests/create_treatment_requests/sessions_setup_request.dart';
import '../models/requests/create_treatment_requests/treatment_schedule_request.dart';
import '../models/responses/base_response_model.dart';
import '../models/responses/treatment_products_response.dart';

abstract class TreatmentRepository {
  Future<TreatmentProductsResponse> getProductsByTreatment(
    List<int> categoryIds,
  );
  Future<TreatmentListResponse> getTreatments({
    int page = 1,
    int limit = 10,
    String search = '',
  });

  Future<BasicInfoResponse> createBasicInfo(BasicInfoRequest request);
  Future<BaseApiResponseModel> protocol({
    required ProtocolRequest request,
    required int draftTreatmentID,
  });

  // ignore: strict_raw_type
  Future<BaseApiResponseModel> createTreatmentArea(
    TreatmentAreaRequest request,
    int id,
  );
  Future<BaseApiResponseModel> createSchedule(
    TreatmentScheduleRequest request,
    int id,
  );

  Future<BaseApiResponseModel> productUsage({
    required ProductUsagesRequest request,
    required int draftTreatmentID,
  });
  Future<BaseApiResponseModel> stepPricing({
    required StepPricingRequest request,
    required int draftTreatmentID,
  });
  Future<BaseApiResponseModel> preTreatmentInstructions({
    required PreTreatmentInstructionsRequest request,
    required int draftTreatmentID,
  });
  Future<BaseApiResponseModel> postTreatmentInstructions({
    required PostTreatmentInstructionsRequest request,
    required int draftTreatmentID,
  });

  Future<BaseApiResponseModel> postTreatmentPhotos({
    required int draftTreatmentId,
    required bool requirePostPhotos,
    required int count,
  });

  Future<BaseApiResponseModel> phaseNotifications({
    required int draftTreatmentId,
    required PhaseNotificationsRequest request,
  });

  Future<BaseApiResponseModel> downTimeLevels({
    required DownTimeLevelRequest request,
    required int draftTreatmentID,
  });
  Future<BaseApiResponseModel> allowedProviderRoles({
    required AllowedProviderRolesRequest request,
    required int draftTreatmentID,
  });

  Future<BaseApiResponseModel> sessionsSetup({
    required int draftTreatmentId,
    required SessionsSetupRequest request,
  });

  Future<BaseApiResponseModel> followUpConfig({
    required int draftTreatmentId,
    required FollowUpRequest request,
  });

  Future<BaseApiResponseModel> businessLogic({
    required int draftTreatmentId,
    required BusinessLogicRequest request,
  });

  Future<BaseApiResponseModel> consentFormSelection({
    required ConsentFormSelectionRequest request,
    required int draftTreatmentID,
  });

  Future<BaseApiResponseModel> updateTreatmentStatus({
    required int treatmentId,
    required String status,
  });

  Future<TreatmentDetailResponse> getTreatmentDetail({
    required int id,
  });

  Future<BaseApiResponseModel> updateTreatment({
    required int treatmentId,
    required UpdateTreatmentRequest request,
  });
}