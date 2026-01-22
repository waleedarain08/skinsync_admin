import 'dart:async';
import 'dart:convert';

import '../models/requests/sign_in_request.dart';
import '../models/responses/auth_response.dart';
import '../repositories/auth_repository.dart';
import '../utils/enums.dart';
import 'api_base_helper.dart';
import 'locator.dart';
import 'storage_service.dart';

class AuthService implements AuthRepository {
  final ApiBaseHelper _apiClient;
  final StorageService _secureStorage = locator<StorageService>();

  AuthService({required ApiBaseHelper apiClient}) : _apiClient = apiClient;

  @override
  Future<AuthResponse> signInApi({required SignInRequest signInRequest}) async {
    try {
      final response = await _apiClient.httpRequest(
        endPoint: Endpoint.signIn,
        requestType: 'POST',
        requestBody: signInRequest,
        params: '',
      );

      // Check HTTP status code
      if (response.statusCode >= 200 && response.statusCode < 300) {
        final parsed = json.decode(response.body);
        AuthResponse authResponse = AuthResponse.fromJson(parsed);
        if (authResponse.isSuccess == true) {
          _secureStorage.saveAccessToken(authResponse.data?.clientToken);
        }
        return authResponse;
      } else {
        // Handle HTTP error status codes
        final parsed = json.decode(response.body);
        return AuthResponse.fromJson(parsed);
      }
    } catch (e) {
      // Return error response on exception
      return AuthResponse(
        isSuccess: false,
        message: 'An error occurred. Please try again.',
      );
    }
  }
}
