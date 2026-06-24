
class BasicInfoRequest {
  final int stepNumber;
  final List<int> selectedCategoryIds;
  final String globalSku;
  final String patientDisplayName;
  final String image;
  final String icon;
  final String shortDescription;
  final String description;

  BasicInfoRequest({
    required this.stepNumber,
    required this.selectedCategoryIds,
    required this.globalSku,
    required this.patientDisplayName,
    required this.image,
    required this.icon,
    required this.shortDescription,
    required this.description,
  });


  Map<String, dynamic> toJson() => {
    'step_number': stepNumber,
    'selected_category_ids': List<dynamic>.from(selectedCategoryIds.map((x) => x)),
    'global_sku': globalSku,
    'patient_display_name': patientDisplayName,
    'image': image,
    'icon': icon,
    'short_description': shortDescription,
    'description': description,
  };
}
