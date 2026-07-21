// import 'package:skinsync_admin/models/requests/create_treatment_requests/business_logic_request.dart';
import 'package:skinsync_admin/models/requests/create_treatment_requests/treatment_area_request.dart';
import 'package:skinsync_admin/models/requests/session_status_request.dart';
import 'package:skinsync_admin/models/requests/update_treatment_request.dart';
import 'package:skinsync_admin/models/responses/basic_info_response.dart';
import 'package:skinsync_admin/models/responses/treatment_list_response.dart';
import 'package:skinsync_admin/models/responses/treatment_detail_response.dart';
import 'package:skinsync_admin/utils/enums.dart';

import '../models/requests/create_treatment_requests/basic_info_request.dart';
import '../models/requests/create_treatment_requests/sessions_setup_request.dart';
import '../models/requests/create_treatment_requests/update_basic_info_request.dart';
import '../models/responses/base_response_model.dart';

abstract class TreatmentRepository {
  Future<TreatmentListResponse> getTreatments({
    required int page,
    required int limit,
    String search = '',
    int? categoryId,
    TreatmentStatus? status,
  });

  Future<BasicInfoResponse> createBasicInfo(BasicInfoRequest request);
  Future<BasicInfoResponse> updateBasicInfo(UpdateBasicInfoRequest request, int id);

  Future<BaseApiResponseModel> createTreatmentArea(
    TreatmentAreaRequest request,
    int id,
  );

  Future<BaseApiResponseModel> sessionsSetup({
    required int draftTreatmentId,
    required SessionsSetupRequest request,
  });

  // Future<BaseApiResponseModel> businessLogic({
  //   required int draftTreatmentId,
  //   required BusinessLogicRequest request,
  // });

  Future<BaseApiResponseModel> updateTreatmentStatus({
    required int treatmentId,
    required String status,
  });

  Future<TreatmentDetailResponse> getTreatmentDetail({required int id});

  Future<BaseApiResponseModel> updateTreatment({
    required int treatmentId,
    required UpdateTreatmentRequest request,
  });
  Future<BaseApiResponseModel> changeSessionStatus({
    required SessionStatusRequest request,
  });
}
