import 'package:skinsync_admin/utils/enums.dart';

class TreatmentAreaRequest {
  final List<int> selectedAreaIds;

  TreatmentAreaRequest({required this.selectedAreaIds});

  Map<String, dynamic> toJson() => {
    'keys': [CreateTreatmentSteps.treatmentAreas.name],
    'step_number': 2,
    'selected_area_ids': List<dynamic>.from(selectedAreaIds.map((x) => x)),
  };
}
