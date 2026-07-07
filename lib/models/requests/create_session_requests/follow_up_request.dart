import 'package:skinsync_admin/utils/enums.dart';

class FollowUpRequest {
   final int stepNumber;
  final List<FollowUp> followUps;

  FollowUpRequest({ required this.stepNumber,required this.followUps});

  Map<String, dynamic> toJson() => {
        'step_number': stepNumber,
        'keys': [CreateTreatmentSteps.followUpSetup.name],
        'follow_ups': followUps.map((x) => x.toJson()).toList(),
      };
}

class FollowUp {
  final String type;
  final num durationValue;
  final String durationUnit;
  final num intervalValue;
  final String intervalUnit;
  final bool isImageRequired;
  final String notes;

  FollowUp({
    required this.type,
    required this.durationValue,
    required this.durationUnit,
    required this.intervalValue,
    required this.intervalUnit,
    required this.isImageRequired,
    required this.notes,
  });

  Map<String, dynamic> toJson() => {
        'type': type,
        'duration_value': durationValue,
        'duration_unit': durationUnit,
        'interval_value': intervalValue,
        'interval_unit': intervalUnit,
        'is_image_required': isImageRequired,
        'notes': notes,
      };
}