import 'package:skinsync_admin/utils/enums.dart';

class FinalFinishRequest {
  final String? status;
  final bool? isCompleted;

  FinalFinishRequest({this.status, this.isCompleted});

  Map<String, dynamic> toJson() => {
    'keys': [CreateTreatmentSteps.status.name],
    'status': status,
    'is_completed': isCompleted,
  };
}
