import 'dart:async';
import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../models/user_model.dart';
import '../utils/colored_print.dart';
import '../utils/enums.dart';

class SecureStorageService {
  static final SecureStorageService _instance =
      SecureStorageService._internal();
  factory SecureStorageService() => _instance;

  SecureStorageService._internal();

  static const _tokenKey = SharedPreferencesKeys.accessTokenKey;
  static const _userKey = SharedPreferencesKeys.userKey;
  static const _refreshTokenKey = SharedPreferencesKeys.refreshTokenKey;
  static const _accessTokenExpiryKey =
      SharedPreferencesKeys.accessTokenExpiryKey;
  static const _refreshTokenExpiryKey =
      SharedPreferencesKeys.refreshTokenExpiryKey;

  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  final _authStateController = StreamController<bool>.broadcast();

  String? _token;

  /// Call once at app start
  Future<void> init() async {
    _token = await _storage.read(key: _tokenKey.name);
    ColoredPrint.green('Auth Token: $_token');
    _authStateController.add(isLoggedIn);
  }

  String? get token => _token;
  bool get isLoggedIn => _token != null;

  Stream<bool> get authStateChanges => _authStateController.stream;

  Future<void> saveToken(String token) async {
    _token = token;
    await _storage.write(key: _tokenKey.name, value: token);
    ColoredPrint.green('Token Saved');
    ColoredPrint.green(token);
    _authStateController.add(true);
  }

  Future<String?> getToken() async {
    return await _storage.read(key: _tokenKey.name);
  }

  Future<void> clearToken() async {
    _token = null;
    await _storage.delete(key: _tokenKey.name);
    ColoredPrint.red('Token Cleared');
    _authStateController.add(false);
  }

  Future<void> saveUser(UserModel? user) async {
    if (user == null) {
      return;
    }
    await _storage.write(key: _userKey.name, value: jsonEncode(user.toJson()));
  }

  Future<UserModel?> getUser() async {
    final userJson = await _storage.read(key: _userKey.name);
    if (userJson == null) {
      return null;
    }
    return UserModel.fromJson(jsonDecode(userJson));
  }

  Future<void> saveRefreshToken(String refreshToken) async {
    await _storage.write(key: _refreshTokenKey.name, value: refreshToken);
  }

  Future<String?> getRefreshToken() async {
    return await _storage.read(key: _refreshTokenKey.name);
  }

  Future<void> saveAccessTokenExpiry(DateTime expiryDate) async {
    await _storage.write(
      key: _accessTokenExpiryKey.name,
      value: expiryDate.toIso8601String(),
    );
  }

  Future<DateTime?> getAccessTokenExpiry() async {
    final expiryDate = await _storage.read(key: _accessTokenExpiryKey.name);
    if (expiryDate == null) {
      return null;
    }
    return DateTime.tryParse(expiryDate);
  }

  Future<void> saveRefreshTokenExpiry(DateTime date) async {
    await _storage.write(
      key: _refreshTokenExpiryKey.name,
      value: date.toIso8601String(),
    );
  }

  Future<DateTime?> getRefreshTokenExpiry() async {
    final expiryDate = await _storage.read(key: _refreshTokenExpiryKey.name);
    if (expiryDate == null) {
      return null;
    }
    return DateTime.tryParse(expiryDate);
  }

  Future<void> clearAll() async {
    await _storage.deleteAll();
  }

  void dispose() {
    ColoredPrint.red('Dispose: SecureStorageService');
    _authStateController.close();
  }
}
