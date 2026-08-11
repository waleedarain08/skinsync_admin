import 'package:skinsync_admin/models/responses/app_version_response.dart';

import '../models/requests/app_version_request.dart';
import '../models/responses/base_response_model.dart';
import '../repositories/setting_repository.dart';
import '../utils/enums.dart';
import 'api_base_helper.dart';

class SettingService implements SettingRepository {
  final ApiBaseHelper _api;

  SettingService({required ApiBaseHelper api}) : _api = api;

  @override
  Future<BaseApiResponseModel> updateAppVersion({
    required AppVersionRequest req,
  }) async {
    final jsonResponse = await _api.patch(
      Endpoint.updateAppVersion,
      body: req.toJson(),
    );
    final response = BaseApiResponseModel<dynamic>.fromJson(jsonResponse);

    return response;
  }

  @override
  Future<AppVersionResponse> getAppVersion() async {
    final jsonResponse = await _api.get(Endpoint.updateAppVersion);
    return AppVersionResponse.fromJson(jsonResponse);
  }
}
