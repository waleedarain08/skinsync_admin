import '../requests/version_request.dart';
import 'base_response_model.dart';

class VersionResponse extends BaseApiResponseModel<VersionData> {
  final VersionData? data;

  const VersionResponse({
    required super.isSuccess,
    required super.message,
    this.data,
  });

  factory VersionResponse.fromJson(Map<String, dynamic> json) {
    return VersionResponse(
      isSuccess: json['is_success'],
      message: json['message'],
      data: json['data'] != null ? VersionData.fromJson(json['data']) : null,
    );
  }
}
