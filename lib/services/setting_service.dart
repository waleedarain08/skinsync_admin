import '../models/requests/app_version_request_model.dart';
import '../models/responses/base_response_model.dart';
import '../repositories/setting_repository.dart';
import '../utils/enums.dart';
import 'api_base_helper.dart';

class SettingService implements SettingRepository {
  final ApiBaseHelper _api;

  SettingService({required ApiBaseHelper api}) : _api = api;

  @override
  Future<BaseApiResponseModel> updateCustomerAppVersion({
    required AppVersionRequestModel req,
  }) async {
    final jsonResponse = await _api.patch(
      Endpoint.updateCustomerAppVersion,
      body: req.toJson(),
    );
    final response = BaseApiResponseModel<dynamic>.fromJson(
      jsonResponse,
    
    );

    return response;
  }

  @override
  Future<BaseApiResponseModel> updateClinicAppVersion({
    required AppVersionRequestModel req,
  }) async {
    final jsonResponse = await _api.patch(
      Endpoint.updateClinicAppVersion,
      body: req.toJson(),
    );
    final response = BaseApiResponseModel<dynamic>.fromJson(
      jsonResponse,
     
    );

    return response;
  }
}
