class TreatmentAreaRequest {
  final int stepNumber;
  final List<int> selectedAreaIds;

  TreatmentAreaRequest({
    required this.stepNumber,
   required this.selectedAreaIds,
  });



  Map<String, dynamic> toJson() => {
    'step_number': stepNumber,
    'selected_area_ids': List<dynamic>.from(selectedAreaIds.map((x) => x)),
  };
}
