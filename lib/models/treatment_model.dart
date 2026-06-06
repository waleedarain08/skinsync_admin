class TreatmentModel {
  int? id;
  String? name;
  String? patientDisplayName;
  String? description;
  String? shortDescription;
  String? categoryId;
  String? categoryName;
  String? categoryPath; // e.g. "Injectables > Botox > Forehead"
  String? icon;
  String? image;
  double? basePrice;
  String? materialName;
  int maxMaterialQuantity;
  bool? isArea;
  List<SideAreaModel>? sideAreas;
  bool isActive;
  bool useInAiSimulator;
  List<int>? combinableTreatmentIds;
  List<String>? protocolIds;
  int? baseDurationHours;
  int? baseDurationMinutes;
  String? preTreatmentInstructions;
  String? postTreatmentInstructions;
  String? preTreatmentNotificationTitle;
  String? preTreatmentNotificationDescription;
  int? preTreatmentNotificationOffset; // in minutes
  String? postTreatmentNotificationTitle;
  String? postTreatmentNotificationDescription;
  int? postTreatmentNotificationOffset; // in minutes
  List<Attachment>? preTreatmentAttachments;
  List<Attachment>? postTreatmentAttachments;
  Attachment? preTreatmentConsentForm;
  
  // Follow-Up Fields
  bool isFollowUpRequired;
  int? totalFollowUps;
  String? followUpType; // virtual | in_person
  int? followUpDurationValue;
  String? followUpDurationUnit; // minutes | hours
  String? followUpNotes;

  TreatmentModel({
    this.id,
    this.name,
    this.patientDisplayName,
    this.description,
    this.shortDescription,
    this.categoryId,
    this.categoryName,
    this.categoryPath,
    this.icon,
    this.image,
    this.basePrice,
    this.materialName,
    this.maxMaterialQuantity = 0,
    this.isArea,
    this.sideAreas,
    this.isActive = true,
    this.useInAiSimulator = false,
    this.combinableTreatmentIds,
    this.protocolIds,
    this.baseDurationHours,
    this.baseDurationMinutes,
    this.preTreatmentInstructions,
    this.postTreatmentInstructions,
    this.preTreatmentNotificationTitle,
    this.preTreatmentNotificationDescription,
    this.preTreatmentNotificationOffset,
    this.postTreatmentNotificationTitle,
    this.postTreatmentNotificationDescription,
    this.postTreatmentNotificationOffset,
    this.preTreatmentAttachments,
    this.postTreatmentAttachments,
    this.preTreatmentConsentForm,
    this.isFollowUpRequired = false,
    this.totalFollowUps,
    this.followUpType,
    this.followUpDurationValue,
    this.followUpDurationUnit,
    this.followUpNotes,
  });

  TreatmentModel.fromJson(Map<String, dynamic> json)
      : isActive = json['is_active'] ?? true,
        useInAiSimulator = json['use_in_ai_simulator'] ?? false,
        maxMaterialQuantity = json['max_material_quantity'] ?? 0,
        isFollowUpRequired = json['is_follow_up_required'] ?? false {
    id = json['id'];
    name = json['name'];
    patientDisplayName = json['patient_display_name'];
    description = json['description'];
    shortDescription = json['short_description'];
    categoryId = json['category_id'];
    categoryName = json['category_name'];
    categoryPath = json['category_path'];
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
    combinableTreatmentIds = json['combinable_treatment_ids'] != null
        ? List<int>.from(json['combinable_treatment_ids'])
        : null;
    protocolIds = json['protocol_ids'] != null
        ? List<String>.from(json['protocol_ids'])
        : null;
    baseDurationHours = json['base_duration_hours'];
    baseDurationMinutes = json['base_duration_minutes'];
    preTreatmentInstructions = json['pre_treatment_instructions'];
    postTreatmentInstructions = json['post_treatment_instructions'];
    preTreatmentNotificationTitle = json['pre_treatment_notification_title'];
    preTreatmentNotificationDescription = json['pre_treatment_notification_description'];
    preTreatmentNotificationOffset = json['pre_treatment_notification_offset'];
    postTreatmentNotificationTitle = json['post_treatment_notification_title'];
    postTreatmentNotificationDescription = json['post_treatment_notification_description'];
    postTreatmentNotificationOffset = json['post_treatment_notification_offset'];
    preTreatmentAttachments = json['pre_treatment_attachments'] != null
        ? (json['pre_treatment_attachments'] as List)
            .map((e) => Attachment.fromJson(e))
            .toList()
        : null;
    postTreatmentAttachments = json['post_treatment_attachments'] != null
        ? (json['post_treatment_attachments'] as List)
            .map((e) => Attachment.fromJson(e))
            .toList()
        : null;
    preTreatmentConsentForm = json['pre_treatment_consent_form'] != null 
        ? Attachment.fromJson(json['pre_treatment_consent_form']) 
        : null;
    totalFollowUps = json['total_follow_ups'];
    followUpType = json['follow_up_type'];
    followUpDurationValue = json['follow_up_duration_value'];
    followUpDurationUnit = json['follow_up_duration_unit'];
    followUpNotes = json['follow_up_notes'];
  }

  TreatmentModel copyWith({
    int? id,
    String? name,
    String? patientDisplayName,
    String? description,
    String? shortDescription,
    String? categoryId,
    String? categoryName,
    String? categoryPath,
    String? icon,
    String? image,
    double? basePrice,
    String? materialName,
    int? maxMaterialQuantity,
    bool? isArea,
    List<SideAreaModel>? sideAreas,
    bool? isActive,
    bool? useInAiSimulator,
    List<int>? combinableTreatmentIds,
    List<String>? protocolIds,
    int? baseDurationHours,
    int? baseDurationMinutes,
    String? preTreatmentInstructions,
    String? postTreatmentInstructions,
    String? preTreatmentNotificationTitle,
    String? preTreatmentNotificationDescription,
    int? preTreatmentNotificationOffset,
    String? postTreatmentNotificationTitle,
    String? postTreatmentNotificationDescription,
    int? postTreatmentNotificationOffset,
    List<Attachment>? preTreatmentAttachments,
    List<Attachment>? postTreatmentAttachments,
    Attachment? preTreatmentConsentForm,
    bool? isFollowUpRequired,
    int? totalFollowUps,
    String? followUpType,
    int? followUpDurationValue,
    String? followUpDurationUnit,
    String? followUpNotes,
  }) {
    return TreatmentModel(
      id: id ?? this.id,
      name: name ?? this.name,
      patientDisplayName: patientDisplayName ?? this.patientDisplayName,
      description: description ?? this.description,
      shortDescription: shortDescription ?? this.shortDescription,
      categoryId: categoryId ?? this.categoryId,
      categoryName: categoryName ?? this.categoryName,
      categoryPath: categoryPath ?? this.categoryPath,
      icon: icon ?? this.icon,
      image: image ?? this.image,
      basePrice: basePrice ?? this.basePrice,
      materialName: materialName ?? this.materialName,
      maxMaterialQuantity: maxMaterialQuantity ?? this.maxMaterialQuantity,
      isArea: isArea ?? this.isArea,
      sideAreas: sideAreas ?? this.sideAreas,
      isActive: isActive ?? this.isActive,
      useInAiSimulator: useInAiSimulator ?? this.useInAiSimulator,
      combinableTreatmentIds: combinableTreatmentIds ?? this.combinableTreatmentIds,
      protocolIds: protocolIds ?? this.protocolIds,
      baseDurationHours: baseDurationHours ?? this.baseDurationHours,
      baseDurationMinutes: baseDurationMinutes ?? this.baseDurationMinutes,
      preTreatmentInstructions: preTreatmentInstructions ?? this.preTreatmentInstructions,
      postTreatmentInstructions: postTreatmentInstructions ?? this.postTreatmentInstructions,
      preTreatmentNotificationTitle: preTreatmentNotificationTitle ?? this.preTreatmentNotificationTitle,
      preTreatmentNotificationDescription: preTreatmentNotificationDescription ?? this.preTreatmentNotificationDescription,
      preTreatmentNotificationOffset: preTreatmentNotificationOffset ?? this.preTreatmentNotificationOffset,
      postTreatmentNotificationTitle: postTreatmentNotificationTitle ?? this.postTreatmentNotificationTitle,
      postTreatmentNotificationDescription: postTreatmentNotificationDescription ?? this.postTreatmentNotificationDescription,
      postTreatmentNotificationOffset: postTreatmentNotificationOffset ?? this.postTreatmentNotificationOffset,
      preTreatmentAttachments: preTreatmentAttachments ?? this.preTreatmentAttachments,
      postTreatmentAttachments: postTreatmentAttachments ?? this.postTreatmentAttachments,
      preTreatmentConsentForm: preTreatmentConsentForm ?? this.preTreatmentConsentForm,
      isFollowUpRequired: isFollowUpRequired ?? this.isFollowUpRequired,
      totalFollowUps: totalFollowUps ?? this.totalFollowUps,
      followUpType: followUpType ?? this.followUpType,
      followUpDurationValue: followUpDurationValue ?? this.followUpDurationValue,
      followUpDurationUnit: followUpDurationUnit ?? this.followUpDurationUnit,
      followUpNotes: followUpNotes ?? this.followUpNotes,
    );
  }

  Map<String, dynamic> toRequest() {
    return {
      'treatment_id': id,
      'name': name,
      'patient_display_name': patientDisplayName,
      'description': description,
      'short_description': shortDescription,
      'category_id': categoryId,
      'category_name': categoryName,
      'category_path': categoryPath,
      'icon': icon,
      'image': image,
      'base_price': basePrice,
      'material_name': materialName,
      'max_material_quantity': maxMaterialQuantity,
      'side_areas': sideAreas?.map((sideArea) => sideArea.toJson()).toList(),
      'is_active': isActive,
      'use_in_ai_simulator': useInAiSimulator,
      'combinable_treatment_ids': combinableTreatmentIds,
      'protocol_ids': protocolIds,
      'base_duration_hours': baseDurationHours,
      'base_duration_minutes': baseDurationMinutes,
      'pre_treatment_instructions': preTreatmentInstructions,
      'post_treatment_instructions': postTreatmentInstructions,
      'pre_treatment_notification_title': preTreatmentNotificationTitle,
      'pre_treatment_notification_description': preTreatmentNotificationDescription,
      'pre_treatment_notification_offset': preTreatmentNotificationOffset,
      'post_treatment_notification_title': postTreatmentNotificationTitle,
      'post_treatment_notification_description': postTreatmentNotificationDescription,
      'post_treatment_notification_offset': postTreatmentNotificationOffset,
      'pre_treatment_attachments': preTreatmentAttachments?.map((e) => e.toJson()).toList(),
      'post_treatment_attachments': postTreatmentAttachments?.map((e) => e.toJson()).toList(),
      'pre_treatment_consent_form': preTreatmentConsentForm?.toJson(),
      'is_follow_up_required': isFollowUpRequired,
      'total_follow_ups': totalFollowUps,
      'follow_up_type': followUpType,
      'follow_up_duration_value': followUpDurationValue,
      'follow_up_duration_unit': followUpDurationUnit,
      'follow_up_notes': followUpNotes,
    };
  }
}


class Attachment {
  String url;
  String type; // image | video | pdf
  String name;

  Attachment({required this.url, required this.type, required this.name});

  factory Attachment.fromJson(Map<String, dynamic> json) => Attachment(
    url: json['url'],
    type: json['type'],
    name: json['name'],
  );

  Map<String, dynamic> toJson() => {
    'url': url,
    'type': type,
    'name': name,
  };
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
