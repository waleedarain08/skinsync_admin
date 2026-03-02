import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:http/http.dart' as http;

import '../utils/enums.dart';
import '../utils/exception.dart';
import 'storage_service.dart';

class ApiBaseHelper {
  static BaseUrls baseUrl = BaseUrls.api;

  final http.Client _client = http.Client();
  final Connectivity _connectivity = Connectivity();
  final SecureStorageService _storage = SecureStorageService();

  // ---------------- SAFE REQUEST WRAPPER ----------------

  Future<T> _safeRequest<T>(Future<T> Function() request) async {
    await _checkInternet();
    try {
      return await request();
    } on SocketException {
      throw const NoInternetException();
    } on AppException {
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
      log('URL: $uri');
      final response = await _client.get(uri, headers: _headers());
      log('RESPONSE: ${response.body}');

      return _processResponse(response);
    });
  }

  Future<dynamic> post(Endpoint endpoint, {Object? body}) {
    return _safeRequest(() async {
      log('URL: ${baseUrl.url}${endpoint.path}');
      log('REQUEST: $body');
      final response = await _client.post(
        Uri.parse('${baseUrl.url}${endpoint.path}'),
        headers: _headers(),
        body: jsonEncode(body),
      );
      return _processResponse(response);
    });
  }

  Future<dynamic> put(Endpoint endpoint, {Object? body}) {
    return _safeRequest(() async {
      final response = await _client.put(
        Uri.parse('${baseUrl.url}${endpoint.path}'),
        headers: _headers(),
        body: jsonEncode(body),
      );
      return _processResponse(response);
    });
  }

  Future<dynamic> patch(Endpoint endpoint, {Object? body}) {
    return _safeRequest(() async {
      final response = await _client.patch(
        Uri.parse('${baseUrl.url}${endpoint.path}'),
        headers: _headers(),
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
      log('URL: $uri');
      final response = await _client.delete(uri, headers: _headers());
      return _processResponse(response);
    });
  }

  // ---------------- HELPERS ----------------

  Map<String, String> _headers() {
    return {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      // if (_storage.token != null)
      'Authorization': 'Bearer ${_storage.token}',
    };
  }

  Future<void> _checkInternet() async {
    final result = await _connectivity.checkConnectivity();
    if (result.any((result) => result == ConnectivityResult.none)) {
      throw const NoInternetException();
    }
  }

  dynamic _processResponse(http.Response response) {
    switch (response.statusCode) {
      case 200:
      case 201:
        return _decode(response.body);

      case 400:
        throw BadRequestException(_message(response));

      case 401:
      case 403:
        _storage.clearToken();
        throw UnauthorizedException(_message(response));

      case 404:
        throw NotFoundException('Endpoint not found');

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
      return body['message'] ?? 'Something went wrong';
    } catch (_) {
      return 'Something went wrong';
    }
  }
}
