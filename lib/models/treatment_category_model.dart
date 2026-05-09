class TreatmentCategoryModel {
  final int id;
  final String name;
  final String? description;
  final List<TreatmentCategoryModel> subCategories;
  final List<int> treatmentIds;

  TreatmentCategoryModel({
    required this.id,
    required this.name,
    this.description,
    this.subCategories = const [],
    this.treatmentIds = const [],
  });

  factory TreatmentCategoryModel.fromJson(Map<String, dynamic> json) {
    return TreatmentCategoryModel(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      subCategories: json['sub_categories'] != null
          ? (json['sub_categories'] as List)
              .map((e) => TreatmentCategoryModel.fromJson(e))
              .toList()
          : [],
      treatmentIds: json['treatment_ids'] != null
          ? List<int>.from(json['treatment_ids'])
          : [],
    );
  }
}
