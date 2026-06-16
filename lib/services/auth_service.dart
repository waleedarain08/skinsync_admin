import 'dart:async';

import '../models/requests/auth_req_models.dart';
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
    final response = LoginResponseModel.fromJson(
      jsonResponse,
    );

    if (!response.status) {
      throw BadRequestException(response.message);
    }
    if (response.data == null) {
      throw UnknownException(response.message);
    }

    await _secureStorage.saveToken(response.data!.accessToken!);
    await _secureStorage.saveRefreshToken(response.data!.refreshToken!);
    await _secureStorage.saveUser(response.data!.user);
    await _secureStorage.saveAccessTokenExpiry(
      DateTime.fromMillisecondsSinceEpoch(
        response.data!.accessExpiresAt! * 1000,
      ),
    );
    await _secureStorage.saveRefreshTokenExpiry(
      DateTime.fromMillisecondsSinceEpoch(
        response.data!.refreshExpiresAt! * 1000,
      ),
    );
    return response;
  }

  @override
  Future<BaseApiResponseModel> forgotPassword({required String email}) async {
    final jsonResponse = await _api.post(
      Endpoint.forgotPassword,
      body: {'email': email},
    );
    final response = BaseApiResponseModel<Null>.fromJson(
      jsonResponse,
          (_) => null,
    );
    if (!response.status) {
      throw BadRequestException(response.message);
    }
    return response;
  }

  @override
  Future<String> verifyOtp({required String email, required String otp}) async {
    final jsonResponse = await _api.post(
      Endpoint.verifyResetOtp,
      body: {'email': email, 'otp': otp},
    );
    final response = BaseApiResponseModel<String>.fromJson(
      jsonResponse,
          (json) => json as String,
    );
    if (!response.status) {
      throw BadRequestException(response.message);
    }
    return response.data!;
  }

  @override
  Future<BaseApiResponseModel> reSendOtp({required String email}) async {
    final jsonResponse = await _api.post(
      Endpoint.verifyResetOtp,
      body: {'email': email},
    );
    final response = BaseApiResponseModel<Null>.fromJson(
      jsonResponse,
          (_) => null,
    );
    if (!response.status) {
      throw BadRequestException(response.message);
    }
    return response;
  }

  @override
  Future<BaseApiResponseModel> resetPassword({
    required ResetPasswordReqModel req,
  }) async {
    final jsonResponse = await _api.post(
      Endpoint.resetPassword,
      body: req.toJson(),
    );
    final response = BaseApiResponseModel<Null>.fromJson(
      jsonResponse,
          (_) => null,
    );
    if (!response.status) {
      throw BadRequestException(response.message);
    }
    return response;
  }
}

