import 'package:skinsync_admin/utils/enums.dart';

class DownTimeLevelRequest {
   final int stepNumber;
  final String? downtimeLevel;
  final int? downtimeDays;

  DownTimeLevelRequest({ required this.stepNumber,this.downtimeLevel, this.downtimeDays});

  Map<String, dynamic> toJson() => {
    'step_number': stepNumber,
    'keys': [CreateTreatmentSteps.downtimeLevel.name],
    'downtime_level': downtimeLevel,
    'downtime_days': downtimeDays,
  };
}
