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
  double? basePrice;
  String? materialName;
  int maxMaterialQuantity;
  bool? isArea;
  List<SideAreaModel>? sideAreas;
  bool isActive;
  bool useInAiSimulator;
  int? baseDurationHours;
  int? baseDurationMinutes;

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
    this.basePrice,
    this.materialName,
    this.maxMaterialQuantity = 0,
    this.isArea,
    this.sideAreas,
    this.isActive = true,
    this.useInAiSimulator = false,
    this.baseDurationHours,
    this.baseDurationMinutes,
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
    basePrice = json['base_price']?.toDouble();
    materialName = json['material_name'];
    isArea = json['is_area'];
    sideAreas = json['side_areas'] != null
        ? (json['side_areas'] as List)
            .map((e) => SideAreaModel.fromJson(e))
            .toList()
        : null;
    baseDurationHours = json['base_duration_hours'];
    baseDurationMinutes = json['base_duration_minutes'];
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
    double? basePrice,
    String? materialName,
    int? maxMaterialQuantity,
    bool? isArea,
    List<SideAreaModel>? sideAreas,
    bool? isActive,
    bool? useInAiSimulator,
    int? baseDurationHours,
    int? baseDurationMinutes,
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
      basePrice: basePrice ?? this.basePrice,
      materialName: materialName ?? this.materialName,
      maxMaterialQuantity: maxMaterialQuantity ?? this.maxMaterialQuantity,
      isArea: isArea ?? this.isArea,
      sideAreas: sideAreas ?? this.sideAreas,
      isActive: isActive ?? this.isActive,
      useInAiSimulator: useInAiSimulator ?? this.useInAiSimulator,
      baseDurationHours: baseDurationHours ?? this.baseDurationHours,
      baseDurationMinutes: baseDurationMinutes ?? this.baseDurationMinutes,
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
      'base_price': basePrice,
      'material_name': materialName,
      'max_material_quantity': maxMaterialQuantity,
      'side_areas': sideAreas?.map((sideArea) => sideArea.toJson()).toList(),
      'is_active': isActive,
      'use_in_ai_simulator': useInAiSimulator,
      'base_duration_hours': baseDurationHours,
      'base_duration_minutes': baseDurationMinutes,
    };
  }
}

class SideAreaModel {
  int? id;
  String? name;
  List<SubAreaModel>? subAreas;

  SideAreaModel({this.id, this.name, this.subAreas});

  SideAreaModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    subAreas = json['sub_areas'] != null
        ? (json['sub_areas'] as List)
            .map((e) => SubAreaModel.fromJson(e))
            .toList()
        : null;
  }
  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "name": name,
      "sub_areas": subAreas?.map((e) => e.toJson()).toList(),
    };
  }
}

class SubAreaModel {
  int? id;
  String? name;
  int? maxMaterialQuantity;
  double? basePrice;

  SubAreaModel({this.id, this.name, this.maxMaterialQuantity, this.basePrice});

  SubAreaModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    maxMaterialQuantity = json['max_material_quantity'];
    basePrice = json['base_price']?.toDouble();
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "name": name,
      "max_material_quantity": maxMaterialQuantity,
      "base_price": basePrice,
    };
  }
}
