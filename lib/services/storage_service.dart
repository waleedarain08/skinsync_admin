import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class StorageService {
  static FlutterSecureStorage? _storage;

  String? _cachedToken;
  static const String _authKey = 'access-token';

  Future<void> init() async {
    _storage = FlutterSecureStorage(
      aOptions: AndroidOptions(),
      iOptions: IOSOptions(
        accessibility: KeychainAccessibility.first_unlock_this_device,
      ),
    );
  }

  Future<void> saveAccessToken(String? accessToken) async {
    if (accessToken == null) {
      return;
    }
    await _storage?.write(key: _authKey, value: accessToken);
  }

  Future<String?> getAccessToken() async {
    if (_cachedToken != null) {
      return _cachedToken;
    }
    final token = await _storage?.read(key: _authKey);
    _cachedToken = token;
    return token;
  }
}
