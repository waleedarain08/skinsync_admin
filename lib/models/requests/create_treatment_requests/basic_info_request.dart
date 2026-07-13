class BasicInfoRequest {
  final List<int> selectedCategoryIds;
  final String globalSku;
  final String patientDisplayName;
  final String image;
  final String icon;
  final String shortDescription;
  final String description;
  final bool enableByDefault;
  final bool useInAiSimulator;

  BasicInfoRequest({
    required this.selectedCategoryIds,
    required this.globalSku,
    required this.patientDisplayName,
    required this.image,
    required this.icon,
    required this.shortDescription,
    required this.description,
    required this.enableByDefault,
    required this.useInAiSimulator,
  });

  Map<String, dynamic> toJson() => {
    'step_number': 2,
    'selected_category_ids': List<dynamic>.from(selectedCategoryIds.map((x) => x)),
    'global_sku': globalSku,
    'patient_display_name': patientDisplayName,
    'image': image,
    'icon': icon,
    'short_description': shortDescription,
    'description': description,
    'enable_by_default': enableByDefault,
    'use_in_ai_simulator': useInAiSimulator,
  };
}
