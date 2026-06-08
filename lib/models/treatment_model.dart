import 'common_models.dart';

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
  bool? isArea;
  List<SideAreaModel>? sideAreas;
  String status; // draft | active | deactive
  
  // Logic Fields
  bool useInAiSimulator;
  bool enableByDefault;

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
  
  List<ProductUsageModel>? productUsages;

  // Follow-Up Fields
  bool isFollowUpRequired;
  List<FollowUpConfig>? followUps;

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
    this.isArea,
    this.sideAreas,
    this.status = 'active',
    this.useInAiSimulator = false,
    this.enableByDefault = false,
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
    this.productUsages,
    this.isFollowUpRequired = false,
    this.followUps,
  });

  TreatmentModel.fromJson(Map<String, dynamic> json)
      : status = json['status'] ?? (json['is_active'] == false ? 'deactive' : 'active'),
        useInAiSimulator = json['use_in_ai_simulator'] ?? false,
        enableByDefault = json['enable_by_default'] ?? false,
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
    productUsages = json['product_usages'] != null
        ? (json['product_usages'] as List).map((e) => ProductUsageModel.fromJson(e)).toList()
        : null;
    followUps = json['follow_ups'] != null
        ? (json['follow_ups'] as List).map((e) => FollowUpConfig.fromJson(e)).toList()
        : null;
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
    bool? isArea,
    List<SideAreaModel>? sideAreas,
    String? status,
    bool? useInAiSimulator,
    bool? enableByDefault,
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
    List<ProductUsageModel>? productUsages,
    bool? isFollowUpRequired,
    List<FollowUpConfig>? followUps,
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
      isArea: isArea ?? this.isArea,
      sideAreas: sideAreas ?? this.sideAreas,
      status: status ?? this.status,
      useInAiSimulator: useInAiSimulator ?? this.useInAiSimulator,
      enableByDefault: enableByDefault ?? this.enableByDefault,
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
      productUsages: productUsages ?? this.productUsages,
      isFollowUpRequired: isFollowUpRequired ?? this.isFollowUpRequired,
      followUps: followUps ?? this.followUps,
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
      'side_areas': sideAreas?.map((sideArea) => sideArea.toJson()).toList(),
      'status': status,
      'is_active': status == 'active',
      'use_in_ai_simulator': useInAiSimulator,
      'enable_by_default': enableByDefault,
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
      'product_usages': productUsages?.map((e) => e.toJson()).toList(),
      'is_follow_up_required': isFollowUpRequired,
      'follow_ups': followUps?.map((e) => e.toJson()).toList(),
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
  double? basePrice;

  SubAreaModel({this.id, this.name, this.basePrice});

  SubAreaModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    basePrice = json['base_price']?.toDouble();
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "name": name,
      "base_price": basePrice,
    };
  }
}
