import 'dart:async';

import '../models/requests/login_request_model.dart';
import '../models/responses/base_response_model.dart';
import '../models/responses/login_response_model.dart';
import '../repositories/auth_repository.dart';
import '../utils/enums.dart';
import '../utils/exception.dart';
import 'api_base_helper.dart';
import 'locator.dart';
import 'storage_service.dart';

class AuthService implements AuthRepository {
  final ApiBaseHelper _api;
  final SecureStorageService _secureStorage = locator<SecureStorageService>();

  AuthService({required ApiBaseHelper api}) : _api = api;

  @override
  Future<LoginResponseModel> login({required LoginRequestModel req}) async {
    final jsonResponse = await _api.post(Endpoint.login, body: req.toJson());
    final response = BaseApiResponseModel<LoginResponseModel>.fromJson(
      jsonResponse,
      (json) => LoginResponseModel.fromJson(json as Map<String, dynamic>),
    );

    if (!response.isSuccess) {
      throw BadRequestException(response.message);
    }
    if (response.data?.accessToken == null) {
      throw UnknownException(response.message);
    }

    await _secureStorage.saveToken(response.data!.accessToken!);
    await _secureStorage.saveUser(response.data!.user);
    return response.data!;
  }
}
