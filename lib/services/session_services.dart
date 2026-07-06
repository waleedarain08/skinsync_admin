import 'package:skinsync_admin/models/responses/base_response_model.dart';
import 'package:skinsync_admin/models/responses/session_list_response.dart';
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
}