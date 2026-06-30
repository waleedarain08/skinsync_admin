import 'package:skinsync_admin/utils/enums.dart';

class SessionsSetupRequest {
  final int totalSessions;

  const SessionsSetupRequest({required this.totalSessions});

  Map<String, dynamic> toJson() {
    return {
      'keys': [CreateTreatmentSteps.sessionsSetup.name],
      'total_sessions': totalSessions,
    };
  }
}
