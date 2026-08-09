import '../models/requests/app_version_request.dart';
import '../models/responses/base_response_model.dart';

abstract class SettingRepository {
  Future<BaseApiResponseModel> updateAppVersion({
    required AppVersionRequest req,
  });

  Future<BaseApiResponseModel<AppVersionRequest>> getAppVersion();
}
