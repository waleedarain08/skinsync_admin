import 'package:skinsync_admin/models/responses/base_response_model.dart';
import 'package:skinsync_admin/models/responses/session_list_response.dart';

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
}