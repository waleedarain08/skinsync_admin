import 'package:skinsync_admin/models/requests/create_session_requests/allowed_provider_role_request.dart';
import 'package:skinsync_admin/models/requests/create_session_requests/constent_form_selection_request.dart';
import 'package:skinsync_admin/models/requests/create_session_requests/down_time_level_request.dart';
import 'package:skinsync_admin/models/requests/create_session_requests/follow_up_request.dart';
import 'package:skinsync_admin/models/requests/create_session_requests/phase_notifications_request.dart';
import 'package:skinsync_admin/models/requests/create_session_requests/post_treatment_instruction_request.dart';
import 'package:skinsync_admin/models/requests/create_session_requests/pre_treatment_instruction_request.dart';
import 'package:skinsync_admin/models/requests/create_session_requests/product_usage_request.dart';
import 'package:skinsync_admin/models/requests/create_session_requests/protocol_request.dart';
import 'package:skinsync_admin/models/requests/create_session_requests/step_pricing_request.dart';
import 'package:skinsync_admin/models/requests/create_session_requests/treatment_schedule_request.dart';
import 'package:skinsync_admin/models/responses/base_response_model.dart';
import 'package:skinsync_admin/models/responses/session_list_response.dart';
import 'package:skinsync_admin/models/responses/treatment_products_response.dart';

abstract class SessionRepository {
  Future<BaseApiResponseModel> createSession({
    required int treatmentId,
    required int areaId,
    required String title,
    required int sessionNumber,
  });

  Future<SessionListResponse> getSessions({
    required int treatmentId,
    required int areaId,
  });

  Future<TreatmentProductsResponse> getProductsByTreatment(
    // List<int> categoryIds,
  );

  Future<BaseApiResponseModel> productUsage({
    required ProductUsagesRequest request,
    required int id,
  });

  Future<BaseApiResponseModel> createSchedule(
    TreatmentScheduleRequest request,
    int id,
  );
  Future<BaseApiResponseModel> stepPricing({
    required StepPricingRequest request,
    required int id,
  });
  Future<BaseApiResponseModel> protocol({
    required ProtocolRequest request,
    required int id,
  });

  Future<BaseApiResponseModel> preTreatmentInstructions({
    required PreTreatmentInstructionsRequest request,
    required int id,
  });
  Future<BaseApiResponseModel> postTreatmentInstructions({
    required PostTreatmentInstructionsRequest request,
    required int id,
  });

  Future<BaseApiResponseModel> postTreatmentPhotos({
    required int id,
    required bool requirePostPhotos,
    required int count,
  });

  Future<BaseApiResponseModel> phaseNotifications({
    required int id,
    required PhaseNotificationsRequest request,
  });

  Future<BaseApiResponseModel> downTimeLevels({
    required DownTimeLevelRequest request,
    required int id,
  });
  Future<BaseApiResponseModel> allowedProviderRoles({
    required AllowedProviderRolesRequest request,
    required int id,
  });

  Future<BaseApiResponseModel> followUpConfig({
    required int id,
    required FollowUpRequest request,
  });

  Future<BaseApiResponseModel> consentFormSelection({
    required ConsentFormSelectionRequest request,
    required int id,
  });
}
