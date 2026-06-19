import 'base_response_model.dart';

class RefreshTokenResponse extends BaseApiResponseModel<RefreshTokenData> {
  RefreshTokenResponse({
    required super.isSuccess,
    required super.message,
    super.data,
  });

  factory RefreshTokenResponse.fromJson(Map<String, dynamic> json) =>
      RefreshTokenResponse(
        isSuccess: (json['is_success'] as bool?) ?? false,
        message: json['message'] ?? '',
        data: json['data'] == null
            ? null
            : RefreshTokenData.fromJson(json['data']),
      );
}

class RefreshTokenData {
  final String accessToken;
  final String refreshToken;
  final int accessExpiresAt;
  final int refreshExpiresAt;

  const RefreshTokenData({
    required this.accessToken,
    required this.refreshToken,
    required this.accessExpiresAt,
    required this.refreshExpiresAt,
  });

  factory RefreshTokenData.fromJson(Map<String, dynamic> json) =>
      RefreshTokenData(
        accessToken: json['access_token'],
        refreshToken: json['refresh_token'],
        accessExpiresAt: json['access_expires_at'],
        refreshExpiresAt: json['refresh_expires_at'],
      );
}
