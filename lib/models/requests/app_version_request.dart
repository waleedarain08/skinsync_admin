class AppVersionRequest {
  final String type;
  final String version;
  final String buildNumber;

  AppVersionRequest({
    required this.type,
    required this.version,
    required this.buildNumber,
  });

  factory AppVersionRequest.fromJson(Map<String, dynamic> json) {
    return AppVersionRequest(
      type: json['type'],
      version: json['version'],
      buildNumber: json['build_number'],
    );
  }

  Map<String, dynamic> toJson() {
    return {'type': type, 'version': version, 'build_number': buildNumber};
  }
}
