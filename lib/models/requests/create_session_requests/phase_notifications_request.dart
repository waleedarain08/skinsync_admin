import 'package:skinsync_admin/utils/enums.dart';

class PhaseNotificationsRequest {
  final List<NotificationRequest> preNotifications;
  final List<NotificationRequest> postNotifications;

  PhaseNotificationsRequest({
    this.preNotifications = const [],
    this.postNotifications = const [],
  });

  Map<String, dynamic> toJson() => {
    'keys': [CreateTreatmentSteps.phaseNotifications.name],
    'pre_notifications': List<dynamic>.from(
      preNotifications.map((x) => x.toJson()),
    ),
    'post_notifications': List<dynamic>.from(
      postNotifications.map((x) => x.toJson()),
    ),
  };
}

class NotificationRequest {
  final String? title;
  final String? message;
  final int? timing;
  final String? timingUnit;
  final String? type;

  NotificationRequest({
    this.title,
    this.message,
    this.timing,
    this.timingUnit,
    this.type,
  });

  Map<String, dynamic> toJson() => {
    'title': title,
    'message': message,
    'timing': timing,
    'timing_unit': timingUnit,
    'type': type,
  };
}
