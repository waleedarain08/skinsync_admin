class TreatmentModel {
  int? id;
  String? name;
  String? patientDisplayName;
  String? description;
  String? shortDescription;
  String? category;
  String? subcategory;
  String? icon;
  String? image;
  String? materialName;
  int maxMaterialQuantity;
  bool? isArea;
  List<SideAreaModel>? sideAreas;
  bool isActive;
  bool useInAiSimulator;
  List<int>? combinableTreatmentIds;

  TreatmentModel({
    this.id,
    this.name,
    this.patientDisplayName,
    this.description,
    this.shortDescription,
    this.category,
    this.subcategory,
    this.icon,
    this.image,
    this.materialName,
    this.maxMaterialQuantity = 0,
    this.isArea,
    this.sideAreas,
    this.isActive = true,
    this.useInAiSimulator = false,
    this.combinableTreatmentIds,
  });

  TreatmentModel.fromJson(Map<String, dynamic> json)
      : isActive = json['is_active'] ?? true,
        useInAiSimulator = json['use_in_ai_simulator'] ?? false,
        maxMaterialQuantity = json['max_material_quantity'] ?? 0 {
    id = json['id'];
    name = json['name'];
    patientDisplayName = json['patient_display_name'];
    description = json['description'];
    shortDescription = json['short_description'];
    category = json['category'];
    subcategory = json['subcategory'];
    icon = json['icon'];
    image = json['image'];
    materialName = json['material_name'];
    isArea = json['is_area'];
    sideAreas = json['side_areas'] != null
        ? (json['side_areas'] as List)
            .map((e) => SideAreaModel.fromJson(e))
            .toList()
        : null;
    combinableTreatmentIds = json['combinable_treatment_ids'] != null
        ? List<int>.from(json['combinable_treatment_ids'])
        : null;
  }

  TreatmentModel copyWith({
    int? id,
    String? name,
    String? patientDisplayName,
    String? description,
    String? shortDescription,
    String? category,
    String? subcategory,
    String? icon,
    String? image,
    String? materialName,
    int? maxMaterialQuantity,
    bool? isArea,
    List<SideAreaModel>? sideAreas,
    bool? isActive,
    bool? useInAiSimulator,
    List<int>? combinableTreatmentIds,
  }) {
    return TreatmentModel(
      id: id ?? this.id,
      name: name ?? this.name,
      patientDisplayName: patientDisplayName ?? this.patientDisplayName,
      description: description ?? this.description,
      shortDescription: shortDescription ?? this.shortDescription,
      category: category ?? this.category,
      subcategory: subcategory ?? this.subcategory,
      icon: icon ?? this.icon,
      image: image ?? this.image,
      materialName: materialName ?? this.materialName,
      maxMaterialQuantity: maxMaterialQuantity ?? this.maxMaterialQuantity,
      isArea: isArea ?? this.isArea,
      sideAreas: sideAreas ?? this.sideAreas,
      isActive: isActive ?? this.isActive,
      useInAiSimulator: useInAiSimulator ?? this.useInAiSimulator,
      combinableTreatmentIds: combinableTreatmentIds ?? this.combinableTreatmentIds,
    );
  }

  Map<String, dynamic> toRequest() {
    return {
      'treatment_id': id,
      'name': name,
      'patient_display_name': patientDisplayName,
      'description': description,
      'short_description': shortDescription,
      'category': category,
      'subcategory': subcategory,
      'icon': icon,
      'image': image,
      'material_name': materialName,
      'max_material_quantity': maxMaterialQuantity,
      'treatments_sub_sec_id': sideAreas?.map((sideArea) => sideArea.id).toList(),
      'is_active': isActive,
      'use_in_ai_simulator': useInAiSimulator,
      'combinable_treatment_ids': combinableTreatmentIds,
    };
  }
}

class SideAreaModel {
  int? id;
  String? name;
  int? maxUnits;

  SideAreaModel({this.id, this.name, this.maxUnits});

  SideAreaModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    maxUnits = json['max_units'];
  }
  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "name": name,
      "max_units": maxUnits,
    };
  }
}
