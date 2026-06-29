import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;

import '../app_init.dart';
import '../models/responses/refresh_token_response.dart';
import '../screens/sign_in_screen.dart';
import '../utils/enums.dart';
import '../utils/exception.dart';
import 'locator.dart';
import 'storage_service.dart';

class ApiBaseHelper {
  static BaseUrls baseUrl = BaseUrls.apiQa;

  final http.Client _client = http.Client();
  final Connectivity _connectivity = Connectivity();
  final SecureStorageService _storage = SecureStorageService();

  // ---------------- SAFE REQUEST WRAPPER ----------------

  Future<T> _safeRequest<T>(Future<T> Function() request) async {
    try {
      await _checkInternet();
      await _refreshToken();
      return await request();
    } on SocketException {
      throw const NoInternetException();
    } on AppException catch (e, s) {
      log(e.toString(), stackTrace: s);
      if (e is UnauthorizedException) {
        await _storage.clearToken();
        GoRouter.of(navigatorKey.currentContext!).go(SignInScreen.routeName);
      }
      rethrow;
    } catch (e) {
      throw UnknownException(e.toString());
    }
  }

  // ---------------- HTTP METHODS ----------------

  Future<dynamic> get(
    Endpoint endpoint, {
    Map<String, String>? pathParams,
    Map<String, String>? queryParams,
  }) {
    return _safeRequest(() async {
      final urlPath = pathParams != null
          ? endpoint.withParams(pathParams)
          : endpoint.path;

      final uri = Uri.parse(
        '${baseUrl.url}$urlPath',
      ).replace(queryParameters: queryParams);
      // log('URL: $uri');
      final headers = await _headers();
      // log('HEADERS: $headers');
      final response = await _client.get(uri, headers: headers);
      // log('RESPONSE: ${response.body}');

      return _processResponse(response);
    });
  }

  Future<dynamic> post(
    Endpoint endpoint, {
    Object? body,
    Map<String, String>? pathParams,
    Map<String, String>? queryParams,
  }) {
    return _safeRequest(() async {
      final urlPath = pathParams != null
          ? endpoint.withParams(pathParams)
          : endpoint.path;

      final uri = Uri.parse(
        '${baseUrl.url}$urlPath',
      ).replace(queryParameters: queryParams);
      log('URL: ${baseUrl.url}${endpoint.path}');
      final encodedBody = jsonEncode(body);
      log('REQUEST: $encodedBody');
      final response = await _client.post(
        uri,
        headers: await _headers(),
        body: encodedBody,
      );
      return _processResponse(response);
    });
  }

  Future<dynamic> put(
    Endpoint endpoint, {
    Object? body,
    Map<String, String>? pathParams,
    Map<String, String>? queryParams,
  }) {
    final urlPath = pathParams != null
        ? endpoint.withParams(pathParams)
        : endpoint.path;

    final uri = Uri.parse(
      '${baseUrl.url}$urlPath',
    ).replace(queryParameters: queryParams);
    return _safeRequest(() async {
      final response = await _client.put(
        uri,
        headers: await _headers(),
        body: jsonEncode(body),
      );
      return _processResponse(response);
    });
  }

  Future<dynamic> patch(
    Endpoint endpoint, {
    Object? body,
    Map<String, String>? pathParams,
    Map<String, String>? queryParams,
  }) {
    final urlPath = pathParams != null
        ? endpoint.withParams(pathParams)
        : endpoint.path;

    final uri = Uri.parse(
      '${baseUrl.url}$urlPath',
    ).replace(queryParameters: queryParams);
    return _safeRequest(() async {
      log('PATCH URL: $uri');
      log('PATCH BODY: ${jsonEncode(body)}');
      final response = await _client.patch(
        uri,
        headers: await _headers(),
        body: jsonEncode(body),
      );
      return _processResponse(response);
    });
  }

  Future<dynamic> delete(
    Endpoint endpoint, {
    Map<String, String>? pathParams,
    Map<String, String>? queryParams,
  }) {
    return _safeRequest(() async {
      final urlPath = pathParams != null
          ? endpoint.withParams(pathParams)
          : endpoint.path;

      final uri = Uri.parse(
        '${baseUrl.url}$urlPath',
      ).replace(queryParameters: queryParams);
      // log('URL: $uri');
      final response = await _client.delete(uri, headers: await _headers());
      return _processResponse(response);
    });
  }

  // ---------------- HELPERS ----------------

  Future<Map<String, String>> _headers() async {
    final token = await _storage.getToken();
    return {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      // if (_storage.token != null)
      'Authorization': 'Bearer $token',
    };
  }

  Future<void> _checkInternet() async {
    final result = await _connectivity.checkConnectivity();
    if (result.any((result) => result == ConnectivityResult.none)) {
      throw const NoInternetException();
    }
  }

  Future<void> _refreshToken() async {
    if (_storage.token == null) {
      return;
    }
    final expiry = await _storage.getAccessTokenExpiry();
    final now = DateTime.now();
    if (expiry?.isAfter(now) ?? false) {
      return;
    }
    final refreshExpiry = await _storage.getRefreshTokenExpiry();
    if (refreshExpiry?.isBefore(now) ?? true) {
      throw const UnauthorizedException('Unauthorized');
    }
    final refreshToken = await _storage.getRefreshToken();
    if (refreshToken == null) {
      throw const UnauthorizedException('Unauthorized');
    }
    log('EXPIRY: $expiry');
    log('REFRESH EXPIRY: $refreshExpiry');
    final uri = Uri.parse('${baseUrl.url}${Endpoint.refreshToken.path}');
    log('URL: $uri');
    final request = {'refresh_token': refreshToken};
    log('REQUEST: $request');
    final json = await http.post(uri, body: jsonEncode(request));
    log('RESPONSE: ${json.body}');
    final response = RefreshTokenResponse.fromJson(_processResponse(json));
    if (!response.isSuccess) {
      throw const UnauthorizedException('Unauthorized');
    }
    final secureStorage = locator<SecureStorageService>();
    await secureStorage.saveToken(response.data!.accessToken);
    await secureStorage.saveRefreshToken(response.data!.refreshToken);
    await secureStorage.saveAccessTokenExpiry(
      DateTime.fromMillisecondsSinceEpoch(
        response.data!.accessExpiresAt * 1000,
      ),
    );
    await secureStorage.saveRefreshTokenExpiry(
      DateTime.fromMillisecondsSinceEpoch(
        response.data!.refreshExpiresAt * 1000,
      ),
    );
    log('TOKEN REFRESHED');
  }

  dynamic _processResponse(http.Response response) {
    log('RESPONSE: ${response.body}');
    switch (response.statusCode) {
      case 200:
      case 201:
        return _decode(response.body);

      case 400:
        throw BadRequestException(_message(response));

      case 401:
      case 403:
        // _storage.clearToken();
        throw UnauthorizedException(_message(response));

      case 404:
        throw const NotFoundException('Endpoint not found');

      default:
        throw ServerException(_message(response));
    }
  }

  dynamic _decode(String body) {
    try {
      return jsonDecode(body);
    } catch (_) {
      return body;
    }
  }

  String _message(http.Response response) {
    try {
      final body = jsonDecode(response.body);
      return (body['message'] as String?) ?? 'Something went wrong';
    } catch (_) {
      return 'Something went wrong';
    }
  }
}
