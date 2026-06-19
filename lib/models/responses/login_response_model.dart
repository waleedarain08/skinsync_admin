import '../user_model.dart';
import 'base_response_model.dart';

class LoginResponseModel extends BaseApiResponseModel<AuthData> {
  const LoginResponseModel({
    required super.isSuccess,
    required super.message,
    super.data,
  });

  factory LoginResponseModel.fromJson(Map<String, dynamic> json) =>
      LoginResponseModel(
        isSuccess: (json['is_success'] as bool?) ?? false,
        message: json['message'] ?? '',
        data: json['data'] == null ? null : AuthData.fromJson(json['data']),
      );

  Map<String, dynamic> toJson() => {
    'status': isSuccess,
    'message': message,
    'data': data?.toJson(),
  };
}

class AuthData {
  final String? accessToken;
  final String? refreshToken;
  final int? accessExpiresAt;
  final int? refreshExpiresAt;
  final UserModel? user;

  AuthData({
    this.accessToken,
    this.refreshToken,
    this.accessExpiresAt,
    this.refreshExpiresAt,
    this.user,
  });

  factory AuthData.fromJson(Map<String, dynamic> json) => AuthData(
    accessToken: json['access_token'],
    refreshToken: json['refresh_token'],
    accessExpiresAt: json['access_expires_at'],
    refreshExpiresAt: json['refresh_expires_at'],
    user: json['admin_user'] == null
        ? null
        : UserModel.fromJson(json['admin_user']),
  );

  Map<String, dynamic> toJson() => {
    'access_token': accessToken,
    'refresh_token': refreshToken,
    'access_expires_at': accessExpiresAt,
    'refresh_expires_at': refreshExpiresAt,
    'admin_user': user?.toJson(),
  };
}