import 'base_response_model.dart';

class AppVersionResponse extends BaseApiResponseModel<List<VersionData>> {
  const AppVersionResponse({
    required super.isSuccess,
    required super.message,
    super.data,
  });

  factory AppVersionResponse.fromJson(Map<String, dynamic> json) =>
      AppVersionResponse(
        isSuccess: json['is_success'],
        message: json['message'],
        data: json['data'] == null
            ? []
            : List<VersionData>.from(
                json['data']!.map((x) => VersionData.fromJson(x)),
              ),
      );
}

class VersionData {
  final int? id;
  final String? app;
  final String? type;
  final String? version;
  final int? buildNumber;
  final DateTime? updatedAt;

  VersionData({
    this.id,
    this.app,
    this.type,
    this.version,
    this.buildNumber,
    this.updatedAt,
  });

  factory VersionData.fromJson(Map<String, dynamic> json) => VersionData(
    id: json['id'],
    app: json['app'],
    type: json['type'],
    version: json['version'],
    buildNumber: json['build_number'],
    updatedAt: json['updated_at'] == null
        ? null
        : DateTime.parse(json['updated_at']),
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'app': app,
    'type': type,
    'version': version,
    'build_number': buildNumber,
    'updated_at': updatedAt?.toIso8601String(),
  };
}
