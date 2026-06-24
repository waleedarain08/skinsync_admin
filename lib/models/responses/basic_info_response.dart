
import 'dart:convert';

import 'package:skinsync_admin/models/responses/base_response_model.dart';

class BasicInfoResponse  extends BaseApiResponseModel<BasicInfo>{


  BasicInfoResponse({
    super.data,
    required super.isSuccess,
    required super.message,
  });


  factory BasicInfoResponse.fromJson(Map<String, dynamic> json) => BasicInfoResponse(
    data: json["data"] == null ? null : BasicInfo.fromJson(json["data"]),
    isSuccess: json["is_success"],
    message: json["message"],
  );


}

class BasicInfo {
  final int? id;
  final int? currentStep;
  final String? status;
  final List<int>? selectedCategoryIds;
  final String? globalSku;
  final String? patientDisplayName;
  final String? image;
  final String? icon;
  final String? shortDescription;
  final String? description;
  final List<dynamic>? selectedAreaIds;
  final List<dynamic>? productUsages;
  final int? baseDuration;
  final int? prepTime;
  final int? cleanupTime;
  final List<dynamic>? productDurations;
  final bool? allowClinicOverride;
  final bool? allowProviderOverride;
  final bool? onlineBookable;
  final bool? manualApprovalRequired;
  final int? minimumBookingNotice;
  final int? maximumDaysInAdvance;
  final int? basePrice;
  final List<dynamic>? unitPriceOverrides;
  final dynamic clinicalProtocolPdf;
  final String? preTreatmentInstructions;
  final List<dynamic>? preTreatmentAttachments;
  final String? postTreatmentInstructions;
  final List<dynamic>? postTreatmentAttachments;
  final bool? requirePostTreatmentPhotos;
  final int? requiredPostTreatmentPhotoCount;
  final List<dynamic>? preNotifications;
  final List<dynamic>? postNotifications;
  final String? downtimeLevel;
  final int? downtimeDays;
  final List<dynamic>? allowedRoles;
  final int? totalSessions;
  final List<dynamic>? sessions;
  final dynamic preTreatmentConsentForm;
  final bool? enableByDefault;
  final bool? useInAiSimulator;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  BasicInfo({
    this.id,
    this.currentStep,
    this.status,
    this.selectedCategoryIds,
    this.globalSku,
    this.patientDisplayName,
    this.image,
    this.icon,
    this.shortDescription,
    this.description,
    this.selectedAreaIds,
    this.productUsages,
    this.baseDuration,
    this.prepTime,
    this.cleanupTime,
    this.productDurations,
    this.allowClinicOverride,
    this.allowProviderOverride,
    this.onlineBookable,
    this.manualApprovalRequired,
    this.minimumBookingNotice,
    this.maximumDaysInAdvance,
    this.basePrice,
    this.unitPriceOverrides,
    this.clinicalProtocolPdf,
    this.preTreatmentInstructions,
    this.preTreatmentAttachments,
    this.postTreatmentInstructions,
    this.postTreatmentAttachments,
    this.requirePostTreatmentPhotos,
    this.requiredPostTreatmentPhotoCount,
    this.preNotifications,
    this.postNotifications,
    this.downtimeLevel,
    this.downtimeDays,
    this.allowedRoles,
    this.totalSessions,
    this.sessions,
    this.preTreatmentConsentForm,
    this.enableByDefault,
    this.useInAiSimulator,
    this.createdAt,
    this.updatedAt,
  });

  factory BasicInfo.fromRawJson(String str) => BasicInfo.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory BasicInfo.fromJson(Map<String, dynamic> json) => BasicInfo(
    id: json["id"],
    currentStep: json["current_step"],
    status: json["status"],
    selectedCategoryIds: json["selected_category_ids"] == null ? [] : List<int>.from(json["selected_category_ids"]!.map((x) => x)),
    globalSku: json["global_sku"],
    patientDisplayName: json["patient_display_name"],
    image: json["image"],
    icon: json["icon"],
    shortDescription: json["short_description"],
    description: json["description"],
    selectedAreaIds: json["selected_area_ids"] == null ? [] : List<dynamic>.from(json["selected_area_ids"]!.map((x) => x)),
    productUsages: json["product_usages"] == null ? [] : List<dynamic>.from(json["product_usages"]!.map((x) => x)),
    baseDuration: json["base_duration"],
    prepTime: json["prep_time"],
    cleanupTime: json["cleanup_time"],
    productDurations: json["product_durations"] == null ? [] : List<dynamic>.from(json["product_durations"]!.map((x) => x)),
    allowClinicOverride: json["allow_clinic_override"],
    allowProviderOverride: json["allow_provider_override"],
    onlineBookable: json["online_bookable"],
    manualApprovalRequired: json["manual_approval_required"],
    minimumBookingNotice: json["minimum_booking_notice"],
    maximumDaysInAdvance: json["maximum_days_in_advance"],
    basePrice: json["base_price"],
    unitPriceOverrides: json["unit_price_overrides"] == null ? [] : List<dynamic>.from(json["unit_price_overrides"]!.map((x) => x)),
    clinicalProtocolPdf: json["clinical_protocol_pdf"],
    preTreatmentInstructions: json["pre_treatment_instructions"],
    preTreatmentAttachments: json["pre_treatment_attachments"] == null ? [] : List<dynamic>.from(json["pre_treatment_attachments"]!.map((x) => x)),
    postTreatmentInstructions: json["post_treatment_instructions"],
    postTreatmentAttachments: json["post_treatment_attachments"] == null ? [] : List<dynamic>.from(json["post_treatment_attachments"]!.map((x) => x)),
    requirePostTreatmentPhotos: json["require_post_treatment_photos"],
    requiredPostTreatmentPhotoCount: json["required_post_treatment_photo_count"],
    preNotifications: json["pre_notifications"] == null ? [] : List<dynamic>.from(json["pre_notifications"]!.map((x) => x)),
    postNotifications: json["post_notifications"] == null ? [] : List<dynamic>.from(json["post_notifications"]!.map((x) => x)),
    downtimeLevel: json["downtime_level"],
    downtimeDays: json["downtime_days"],
    allowedRoles: json["allowed_roles"] == null ? [] : List<dynamic>.from(json["allowed_roles"]!.map((x) => x)),
    totalSessions: json["total_sessions"],
    sessions: json["sessions"] == null ? [] : List<dynamic>.from(json["sessions"]!.map((x) => x)),
    preTreatmentConsentForm: json["pre_treatment_consent_form"],
    enableByDefault: json["enable_by_default"],
    useInAiSimulator: json["use_in_ai_simulator"],
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "current_step": currentStep,
    "status": status,
    "selected_category_ids": selectedCategoryIds == null ? [] : List<dynamic>.from(selectedCategoryIds!.map((x) => x)),
    "global_sku": globalSku,
    "patient_display_name": patientDisplayName,
    "image": image,
    "icon": icon,
    "short_description": shortDescription,
    "description": description,
    "selected_area_ids": selectedAreaIds == null ? [] : List<dynamic>.from(selectedAreaIds!.map((x) => x)),
    "product_usages": productUsages == null ? [] : List<dynamic>.from(productUsages!.map((x) => x)),
    "base_duration": baseDuration,
    "prep_time": prepTime,
    "cleanup_time": cleanupTime,
    "product_durations": productDurations == null ? [] : List<dynamic>.from(productDurations!.map((x) => x)),
    "allow_clinic_override": allowClinicOverride,
    "allow_provider_override": allowProviderOverride,
    "online_bookable": onlineBookable,
    "manual_approval_required": manualApprovalRequired,
    "minimum_booking_notice": minimumBookingNotice,
    "maximum_days_in_advance": maximumDaysInAdvance,
    "base_price": basePrice,
    "unit_price_overrides": unitPriceOverrides == null ? [] : List<dynamic>.from(unitPriceOverrides!.map((x) => x)),
    "clinical_protocol_pdf": clinicalProtocolPdf,
    "pre_treatment_instructions": preTreatmentInstructions,
    "pre_treatment_attachments": preTreatmentAttachments == null ? [] : List<dynamic>.from(preTreatmentAttachments!.map((x) => x)),
    "post_treatment_instructions": postTreatmentInstructions,
    "post_treatment_attachments": postTreatmentAttachments == null ? [] : List<dynamic>.from(postTreatmentAttachments!.map((x) => x)),
    "require_post_treatment_photos": requirePostTreatmentPhotos,
    "required_post_treatment_photo_count": requiredPostTreatmentPhotoCount,
    "pre_notifications": preNotifications == null ? [] : List<dynamic>.from(preNotifications!.map((x) => x)),
    "post_notifications": postNotifications == null ? [] : List<dynamic>.from(postNotifications!.map((x) => x)),
    "downtime_level": downtimeLevel,
    "downtime_days": downtimeDays,
    "allowed_roles": allowedRoles == null ? [] : List<dynamic>.from(allowedRoles!.map((x) => x)),
    "total_sessions": totalSessions,
    "sessions": sessions == null ? [] : List<dynamic>.from(sessions!.map((x) => x)),
    "pre_treatment_consent_form": preTreatmentConsentForm,
    "enable_by_default": enableByDefault,
    "use_in_ai_simulator": useInAiSimulator,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
  };
}
