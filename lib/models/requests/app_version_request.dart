class AppVersionRequest {
  final String applicationType;
  final String deviceType;
  final String version;
  final int build;

  const AppVersionRequest({
    required this.applicationType,
    required this.deviceType,
    required this.version,
    required this.build,
  });

  factory AppVersionRequest.fromJson(Map<String, dynamic> json) {
    return AppVersionRequest(
      applicationType: json['application_type'],
      deviceType: json['device_type'],
      version: json['version'],
      build: json['build'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'application_type': applicationType,
      'device_type': deviceType,
      'version': version,
      'build': build,
    };
  }
}
