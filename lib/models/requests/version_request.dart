import '../../utils/enums.dart';

class VersionData {
  final ApplicationType applicationType;
  final String deviceType;
  final String version;
  final int build;

  VersionData({
    required this.applicationType,
    required this.deviceType,
    required this.version,
    required this.build,
  });

  factory VersionData.fromJson(Map<String, dynamic> json) {
    return VersionData(
      applicationType: ApplicationType.values.byName(json['application_type']),
      deviceType: json['device_type'],
      version: json['version'],
      build: json['build'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'application_type': applicationType.name,
      'device_type': deviceType,
      'version': version,
      'build': build,
    };
  }
}
