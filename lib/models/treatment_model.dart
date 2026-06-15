import 'common_models.dart';

class TreatmentModel {
  int? id;
  String? globalSku;
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
  Map<String, double>? unitPrices;
  bool? isArea;
  List<SideAreaModel>? sideAreas;
  String status; // draft | active | deactive

  // Logic Fields
  bool useInAiSimulator;
  bool enableByDefault;

  List<int>? combinableTreatmentIds;
  List<String>? protocolIds;
  List<TreatmentProtocolNote>? protocolNotes;
  List<TreatmentProtocolNoteItem>? standaloneNotes;
  int? baseDurationHours;
  int? baseDurationMinutes;
  String? preTreatmentInstructions;
  String? postTreatmentInstructions;

  // Scheduling Fields
  int prepTime;
  int cleanupTime;
  bool allowClinicOverride;
  bool allowProviderOverride;
  bool onlineBookable;
  bool manualApprovalRequired;
  int minimumBookingNotice;
  int maximumDaysInAdvance;

  // Notifications
  String preNotificationSource; // category | custom
  String postNotificationSource; // category | custom
  String? preTreatmentNotificationTitle;
  String? preTreatmentNotificationDescription;
  int? preTreatmentNotificationOffset; // in minutes
  String? postTreatmentNotificationTitle;
  String? postTreatmentNotificationDescription;
  int? postTreatmentNotificationOffset; // in minutes
  List<NotificationConfig> preNotifications;
  List<NotificationConfig> postNotifications;

  // Sessions
  String sessionSource; // category | custom
  int totalSessions;
  List<SessionConfig>? sessions;

  // Downtime
  String downtimeLevel; // None | Low | Moderate | High

  // Provider Roles
  String providerRolesSource; // category | custom
  List<String> allowedRoles;

  List<Attachment>? preTreatmentAttachments;
  List<Attachment>? postTreatmentAttachments;
  Attachment? preTreatmentConsentForm;

  List<ProductUsageModel>? productUsages;

  // Post Treatment Photos
  bool requirePostTreatmentPhotos;
  int requiredPostTreatmentPhotoCount;

  // Follow-Up Fields (Deprecated in favor of session-scoped follow-ups but kept for migration if needed)
  bool isFollowUpRequired;

  TreatmentModel({
    this.id,
    this.globalSku,
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
    this.unitPrices,
    this.isArea,
    this.sideAreas,
    this.status = 'active',
    this.useInAiSimulator = false,
    this.enableByDefault = false,
    this.combinableTreatmentIds,
    this.protocolIds,
    this.protocolNotes,
    this.standaloneNotes,
    this.baseDurationHours,
    this.baseDurationMinutes,
    this.preTreatmentInstructions,
    this.postTreatmentInstructions,
    this.prepTime = 0,
    this.cleanupTime = 0,
    this.allowClinicOverride = false,
    this.allowProviderOverride = false,
    this.onlineBookable = true,
    this.manualApprovalRequired = false,
    this.minimumBookingNotice = 24,
    this.maximumDaysInAdvance = 90,
    this.preNotificationSource = 'category',
    this.postNotificationSource = 'category',
    this.preTreatmentNotificationTitle,
    this.preTreatmentNotificationDescription,
    this.preTreatmentNotificationOffset,
    this.postTreatmentNotificationTitle,
    this.postTreatmentNotificationDescription,
    this.postTreatmentNotificationOffset,
    this.preNotifications = const [],
    this.postNotifications = const [],
    this.sessionSource = 'category',
    this.totalSessions = 1,
    this.sessions,
    this.downtimeLevel = 'None',
    this.providerRolesSource = 'category',
    this.allowedRoles = const [],
    this.preTreatmentAttachments,
    this.postTreatmentAttachments,
    this.preTreatmentConsentForm,
    this.productUsages,
    this.requirePostTreatmentPhotos = false,
    this.requiredPostTreatmentPhotoCount = 0,
    this.isFollowUpRequired = false,
  });

  factory TreatmentModel.fromJson(Map<String, dynamic> json) {
    Map<String, double>? unitPrices;
    if (json['unit_prices'] != null) {
      unitPrices = {};
      (json['unit_prices'] as Map).forEach((key, value) {
        unitPrices?[key.toString()] = (value as num).toDouble();
      });
    }

    return TreatmentModel(
      id: json['id'],
      globalSku: json['global_sku'],
      name: json['name'],
      patientDisplayName: json['patient_display_name'],
      description: json['description'],
      shortDescription: json['short_description'],
      categoryId: json['category_id'],
      categoryName: json['category_name'],
      categoryPath: json['category_path'],
      icon: json['icon'],
      image: json['image'],
      basePrice: json['base_price']?.toDouble(),
      unitPrices: unitPrices,
      isArea: json['is_area'],
      sideAreas: (json['side_areas'] as List?)
          ?.map((e) => SideAreaModel.fromJson(e))
          .toList(),
      status:
          json['status'] ??
          (json['is_active'] == false ? 'deactive' : 'active'),
      useInAiSimulator: json['use_in_ai_simulator'] ?? false,
      enableByDefault: json['enable_by_default'] ?? false,
      combinableTreatmentIds: json['combinable_treatment_ids'] != null
          ? List<int>.from(json['combinable_treatment_ids'])
          : null,
      protocolIds: json['protocol_ids'] != null
          ? List<String>.from(json['protocol_ids'])
          : null,
      protocolNotes: (json['protocol_notes'] as List?)
          ?.map((e) => TreatmentProtocolNote.fromJson(e))
          .toList(),
      standaloneNotes: (json['notes'] as List?)
          ?.map((e) => TreatmentProtocolNoteItem.fromJson(e))
          .toList(),
      baseDurationHours: json['base_duration_hours'],
      baseDurationMinutes: json['base_duration_minutes'],
      preTreatmentInstructions: json['pre_treatment_instructions'],
      postTreatmentInstructions: json['post_treatment_instructions'],
      prepTime: json['prep_time'] ?? 0,
      cleanupTime: json['cleanup_time'] ?? 0,
      allowClinicOverride: json['allow_clinic_override'] ?? false,
      allowProviderOverride: json['allow_provider_override'] ?? false,
      onlineBookable: json['online_bookable'] ?? true,
      manualApprovalRequired: json['manual_approval_required'] ?? false,
      minimumBookingNotice: json['minimum_booking_notice'] ?? 24,
      maximumDaysInAdvance: json['maximum_days_in_advance'] ?? 90,
      preNotificationSource: json['pre_notification_source'] ?? 'category',
      postNotificationSource: json['post_notification_source'] ?? 'category',
      preTreatmentNotificationTitle: json['pre_treatment_notification_title'],
      preTreatmentNotificationDescription:
          json['pre_treatment_notification_description'],
      preTreatmentNotificationOffset: json['pre_treatment_notification_offset'],
      postTreatmentNotificationTitle: json['post_treatment_notification_title'],
      postTreatmentNotificationDescription:
          json['post_treatment_notification_description'],
      postTreatmentNotificationOffset:
          json['post_treatment_notification_offset'],
      preNotifications:
          (json['pre_notifications'] as List?)
              ?.map((e) => NotificationConfig.fromJson(e))
              .toList() ??
          [],
      postNotifications:
          (json['post_notifications'] as List?)
              ?.map((e) => NotificationConfig.fromJson(e))
              .toList() ??
          [],
      sessionSource: json['session_source'] ?? 'category',
      totalSessions: json['total_sessions'] ?? 1,
      sessions: (json['sessions'] as List?)
          ?.map((e) => SessionConfig.fromJson(e))
          .toList(),
      downtimeLevel: json['downtime_level'] ?? 'None',
      providerRolesSource: json['provider_roles_source'] ?? 'category',
      allowedRoles: json['allowed_roles'] != null
          ? List<String>.from(json['allowed_roles'])
          : [],
      preTreatmentAttachments: (json['pre_treatment_attachments'] as List?)
          ?.map((e) => Attachment.fromJson(e))
          .toList(),
      postTreatmentAttachments: (json['post_treatment_attachments'] as List?)
          ?.map((e) => Attachment.fromJson(e))
          .toList(),
      preTreatmentConsentForm: json['pre_treatment_consent_form'] != null
          ? Attachment.fromJson(json['pre_treatment_consent_form'])
          : null,
      productUsages: (json['product_usages'] as List?)
          ?.map((e) => ProductUsageModel.fromJson(e))
          .toList(),
      requirePostTreatmentPhotos: json['require_post_treatment_photos'] ?? false,
      requiredPostTreatmentPhotoCount:
          json['required_post_treatment_photo_count'] ?? 0,
      isFollowUpRequired: json['is_follow_up_required'] ?? false,
    );
  }

  TreatmentModel copyWith({
    int? id,
    String? globalSku,
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
    Map<String, double>? unitPrices,
    bool? isArea,
    List<SideAreaModel>? sideAreas,
    String? status,
    bool? useInAiSimulator,
    bool? enableByDefault,
    int? prepTime,
    int? cleanupTime,
    bool? allowClinicOverride,
    bool? allowProviderOverride,
    bool? onlineBookable,
    bool? manualApprovalRequired,
    int? minimumBookingNotice,
    int? maximumDaysInAdvance,
    List<int>? combinableTreatmentIds,
    List<String>? protocolIds,
    List<TreatmentProtocolNote>? protocolNotes,
    List<TreatmentProtocolNoteItem>? standaloneNotes,
    int? baseDurationHours,
    int? baseDurationMinutes,
    String? preTreatmentInstructions,
    String? postTreatmentInstructions,
    String? preNotificationSource,
    String? postNotificationSource,
    String? preTreatmentNotificationTitle,
    String? preTreatmentNotificationDescription,
    int? preTreatmentNotificationOffset,
    String? postTreatmentNotificationTitle,
    String? postTreatmentNotificationDescription,
    int? postTreatmentNotificationOffset,
    List<NotificationConfig>? preNotifications,
    List<NotificationConfig>? postNotifications,
    String? sessionSource,
    int? totalSessions,
    List<SessionConfig>? sessions,
    String? downtimeLevel,
    String? providerRolesSource,
    List<String>? allowedRoles,
    List<Attachment>? preTreatmentAttachments,
    List<Attachment>? postTreatmentAttachments,
    Attachment? preTreatmentConsentForm,
    List<ProductUsageModel>? productUsages,
    bool? requirePostTreatmentPhotos,
    int? requiredPostTreatmentPhotoCount,
    bool? isFollowUpRequired,
  }) {
    return TreatmentModel(
      id: id ?? this.id,
      globalSku: globalSku ?? this.globalSku,
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
      unitPrices: unitPrices ?? this.unitPrices,
      isArea: isArea ?? this.isArea,
      sideAreas: sideAreas ?? this.sideAreas,
      status: status ?? this.status,
      useInAiSimulator: useInAiSimulator ?? this.useInAiSimulator,
      enableByDefault: enableByDefault ?? this.enableByDefault,
      prepTime: prepTime ?? this.prepTime,
      cleanupTime: cleanupTime ?? this.cleanupTime,
      allowClinicOverride: allowClinicOverride ?? this.allowClinicOverride,
      allowProviderOverride:
          allowProviderOverride ?? this.allowProviderOverride,
      onlineBookable: onlineBookable ?? this.onlineBookable,
      manualApprovalRequired:
          manualApprovalRequired ?? this.manualApprovalRequired,
      minimumBookingNotice: minimumBookingNotice ?? this.minimumBookingNotice,
      maximumDaysInAdvance: maximumDaysInAdvance ?? this.maximumDaysInAdvance,
      combinableTreatmentIds:
          combinableTreatmentIds ?? this.combinableTreatmentIds,
      protocolIds: protocolIds ?? this.protocolIds,
      protocolNotes: protocolNotes ?? this.protocolNotes,
      standaloneNotes: standaloneNotes ?? this.standaloneNotes,
      baseDurationHours: baseDurationHours ?? this.baseDurationHours,
      baseDurationMinutes: baseDurationMinutes ?? this.baseDurationMinutes,
      preTreatmentInstructions:
          preTreatmentInstructions ?? this.preTreatmentInstructions,
      postTreatmentInstructions:
          postTreatmentInstructions ?? this.postTreatmentInstructions,
      preNotificationSource:
          preNotificationSource ?? this.preNotificationSource,
      postNotificationSource:
          postNotificationSource ?? this.postNotificationSource,
      preTreatmentNotificationTitle:
          preTreatmentNotificationTitle ?? this.preTreatmentNotificationTitle,
      preTreatmentNotificationDescription:
          preTreatmentNotificationDescription ??
          this.preTreatmentNotificationDescription,
      preTreatmentNotificationOffset:
          preTreatmentNotificationOffset ?? this.preTreatmentNotificationOffset,
      postTreatmentNotificationTitle:
          postTreatmentNotificationTitle ?? this.postTreatmentNotificationTitle,
      postTreatmentNotificationDescription:
          postTreatmentNotificationDescription ??
          this.postTreatmentNotificationDescription,
      postTreatmentNotificationOffset:
          postTreatmentNotificationOffset ??
          this.postTreatmentNotificationOffset,
      preNotifications: preNotifications ?? this.preNotifications,
      postNotifications: postNotifications ?? this.postNotifications,
      sessionSource: sessionSource ?? this.sessionSource,
      totalSessions: totalSessions ?? this.totalSessions,
      sessions: sessions ?? this.sessions,
      downtimeLevel: downtimeLevel ?? this.downtimeLevel,
      providerRolesSource: providerRolesSource ?? this.providerRolesSource,
      allowedRoles: allowedRoles ?? this.allowedRoles,
      preTreatmentAttachments:
          preTreatmentAttachments ?? this.preTreatmentAttachments,
      postTreatmentAttachments:
          postTreatmentAttachments ?? this.postTreatmentAttachments,
      preTreatmentConsentForm:
          preTreatmentConsentForm ?? this.preTreatmentConsentForm,
      productUsages: productUsages ?? this.productUsages,
      requirePostTreatmentPhotos:
          requirePostTreatmentPhotos ?? this.requirePostTreatmentPhotos,
      requiredPostTreatmentPhotoCount:
          requiredPostTreatmentPhotoCount ?? this.requiredPostTreatmentPhotoCount,
      isFollowUpRequired: isFollowUpRequired ?? this.isFollowUpRequired,
    );
  }

  Map<String, dynamic> toRequest() {
    return {
      'treatment_id': id,
      'global_sku': globalSku,
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
      'unit_prices': unitPrices,
      'side_areas': sideAreas?.map((sideArea) => sideArea.toJson()).toList(),
      'status': status,
      'is_active': status == 'active',
      'use_in_ai_simulator': useInAiSimulator,
      'enable_by_default': enableByDefault,
      'prep_time': prepTime,
      'cleanup_time': cleanupTime,
      'allow_clinic_override': allowClinicOverride,
      'allow_provider_override': allowProviderOverride,
      'online_bookable': onlineBookable,
      'manual_approval_required': manualApprovalRequired,
      'minimum_booking_notice': minimumBookingNotice,
      'maximum_days_in_advance': maximumDaysInAdvance,
      'combinable_treatment_ids': combinableTreatmentIds,
      'protocol_ids': protocolIds,
      'protocol_notes': protocolNotes?.map((e) => e.toJson()).toList(),
      'notes': standaloneNotes?.map((e) => e.toJson()).toList(),
      'base_duration_hours': baseDurationHours,
      'base_duration_minutes': baseDurationMinutes,
      'pre_treatment_instructions': preTreatmentInstructions,
      'post_treatment_instructions': postTreatmentInstructions,
      'pre_notification_source': preNotificationSource,
      'post_notification_source': postNotificationSource,
      'pre_treatment_notification_title': preTreatmentNotificationTitle,
      'pre_treatment_notification_description':
          preTreatmentNotificationDescription,
      'pre_treatment_notification_offset': preTreatmentNotificationOffset,
      'post_treatment_notification_title': postTreatmentNotificationTitle,
      'post_treatment_notification_description':
          postTreatmentNotificationDescription,
      'post_treatment_notification_offset': postTreatmentNotificationOffset,
      'pre_notifications': preNotifications.map((e) => e.toJson()).toList(),
      'post_notifications': postNotifications.map((e) => e.toJson()).toList(),
      'session_source': sessionSource,
      'total_sessions': totalSessions,
      'sessions': sessions?.map((e) => e.toJson()).toList(),
      'downtime_level': downtimeLevel,
      'provider_roles_source': providerRolesSource,
      'allowed_roles': allowedRoles,
      'pre_treatment_attachments': preTreatmentAttachments
          ?.map((e) => e.toJson())
          .toList(),
      'post_treatment_attachments': postTreatmentAttachments
          ?.map((e) => e.toJson())
          .toList(),
      'pre_treatment_consent_form': preTreatmentConsentForm?.toJson(),
      'product_usages': productUsages?.map((e) => e.toJson()).toList(),
      'require_post_treatment_photos': requirePostTreatmentPhotos,
      'required_post_treatment_photo_count': requiredPostTreatmentPhotoCount,
      'is_follow_up_required': isFollowUpRequired,
    };
  }
}

class SideAreaModel {
  int? id;
  String? name;
  String? globalSku;
  String? icon;
  List<SubAreaModel>? subAreas;

  SideAreaModel({this.id, this.name, this.globalSku, this.icon, this.subAreas});

  factory SideAreaModel.fromJson(Map<String, dynamic> json) {
    return SideAreaModel(
      id: json['id'],
      name: json['name'],
      globalSku: json['global_sku'],
      icon: json['icon'],
      subAreas: (json['sub_areas'] as List?)
          ?.map((e) => SubAreaModel.fromJson(e))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'global_sku': globalSku,
      'icon': icon,
      'sub_areas': subAreas?.map((e) => e.toJson()).toList(),
    };
  }
}

class SubAreaModel {
  int? id;
  String? name;
  String? globalSku;
  String? icon;
  double? basePrice;
  Map<String, double>? unitPrices;
  List<SubAreaModel>? children;

  SubAreaModel({
    this.id,
    this.name,
    this.globalSku,
    this.icon,
    this.basePrice,
    this.unitPrices,
    this.children,
  });

  factory SubAreaModel.fromJson(Map<String, dynamic> json) {
    Map<String, double>? unitPrices;
    if (json['unit_prices'] != null) {
      unitPrices = {};
      (json['unit_prices'] as Map).forEach((key, value) {
        unitPrices?[key.toString()] = (value as num).toDouble();
      });
    }

    return SubAreaModel(
      id: json['id'],
      name: json['name'],
      globalSku: json['global_sku'],
      icon: json['icon'],
      basePrice: json['base_price']?.toDouble(),
      unitPrices: unitPrices,
      children: (json['children'] as List?)
          ?.map((e) => SubAreaModel.fromJson(e))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'global_sku': globalSku,
      'icon': icon,
      'base_price': basePrice,
      if (unitPrices != null) 'unit_prices': unitPrices,
      'children': children?.map((e) => e.toJson()).toList(),
    };
  }
}

class TreatmentProtocolNoteItem {
  final String? title;
  final String description;
  final int order;

  TreatmentProtocolNoteItem({
    this.title,
    required this.description,
    required this.order,
  });

  factory TreatmentProtocolNoteItem.fromJson(Map<String, dynamic> json) =>
      TreatmentProtocolNoteItem(
        title: json['title'],
        description: json['description'] ?? '',
        order: json['order'] ?? 0,
      );

  Map<String, dynamic> toJson() => {
    'title': title,
    'description': description,
    'order': order,
  };
}

class TreatmentProtocolNote {
  final String protocolName;
  final List<TreatmentProtocolNoteItem> notes;

  TreatmentProtocolNote({required this.protocolName, required this.notes});

  factory TreatmentProtocolNote.fromJson(Map<String, dynamic> json) =>
      TreatmentProtocolNote(
        protocolName: json['protocolName'] ?? '',
        notes: json['notes'] != null
            ? (json['notes'] as List)
                  .map((e) => TreatmentProtocolNoteItem.fromJson(e))
                  .toList()
            : [],
      );

  Map<String, dynamic> toJson() => {
    'protocolName': protocolName,
    'notes': notes.map((e) => e.toJson()).toList(),
  };
}
