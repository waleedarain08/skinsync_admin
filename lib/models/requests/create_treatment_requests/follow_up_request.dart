import 'package:skinsync_admin/utils/enums.dart';

class FollowUpRequest {
  final List<Session> sessions;

  FollowUpRequest({required this.sessions});

  Map<String, dynamic> toJson() => {
    'keys': [CreateTreatmentSteps.followUpSetup.name],
    'sessions': List<dynamic>.from(sessions.map((x) => x.toJson())),
  };
}

class Session {
  final int sessionNumber;
  final List<FollowUp> followUps;

  Session({required this.sessionNumber, required this.followUps});

  Map<String, dynamic> toJson() => {
    'session_number': sessionNumber,
    'follow_ups': List<dynamic>.from(followUps.map((x) => x.toJson())),
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
