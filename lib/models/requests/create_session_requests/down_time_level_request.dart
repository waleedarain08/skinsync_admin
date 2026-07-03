import 'package:skinsync_admin/utils/enums.dart';

class DownTimeLevelRequest {
  final String? downtimeLevel;
  final int? downtimeDays;

  DownTimeLevelRequest({this.downtimeLevel, this.downtimeDays});

  Map<String, dynamic> toJson() => {
    'keys': [CreateTreatmentSteps.downtimeLevel.name],
    'downtime_level': downtimeLevel,
    'downtime_days': downtimeDays,
  };
}
