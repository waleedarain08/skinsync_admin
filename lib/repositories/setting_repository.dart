import '../models/requests/app_version_request_model.dart';
import '../models/responses/base_response_model.dart';

abstract class SettingRepository {
  Future<BaseApiResponseModel> updateCustomerAppVersion({required AppVersionRequestModel req});
  Future<BaseApiResponseModel> updateClinicAppVersion({required AppVersionRequestModel req});
}
