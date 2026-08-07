import '../requests/app_version_request.dart';
import 'base_response_model.dart';

class VersionResponse extends BaseApiResponseModel<AppVersionRequest> {
  final AppVersionRequest? data;

  const VersionResponse({
    required super.isSuccess,
    required super.message,
    this.data,
  });

  factory VersionResponse.fromJson(Map<String, dynamic> json) {
    return VersionResponse(
      isSuccess: json['is_success'],
      message: json['message'],
      data: json['data'] != null
          ? AppVersionRequest.fromJson(json['data'])
          : null,
    );
  }
}
