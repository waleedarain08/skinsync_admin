import 'package:skinsync_admin/models/requests/constent_form_selection_request.dart';
import 'package:skinsync_admin/models/requests/phase_notifications_request.dart';
import 'package:skinsync_admin/models/requests/post_treatment_instruction_request.dart';
import 'package:skinsync_admin/models/requests/pre_treatment_instruction_request.dart';
import 'package:skinsync_admin/models/requests/product_usage_request.dart';
import 'package:skinsync_admin/models/requests/protocol_request.dart';
import 'package:skinsync_admin/models/requests/step_pricing_request.dart';
import 'package:skinsync_admin/models/requests/treatment_area_request.dart';
import 'package:skinsync_admin/models/responses/basic_info_response.dart';
import 'package:skinsync_admin/models/responses/treatment_list_response.dart';

import '../models/requests/allowed_provider_role_request.dart';
import '../models/requests/basic_info_request.dart';
import '../models/requests/down_time_level_request.dart';
import '../models/requests/sessions_setup_request.dart';
import '../models/requests/treatment_schedule_request.dart';
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

  Future<BaseApiResponseModel> consentFormSelection({
    required ConsentFormSelectionRequest request,
    required int draftTreatmentID,
  });
}
