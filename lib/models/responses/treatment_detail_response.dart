import 'dart:convert';
import 'package:skinsync_admin/models/responses/base_response_model.dart';

class TreatmentDetailResponse extends BaseApiResponseModel<TreatmentDetailDto> {
  const TreatmentDetailResponse({
    required super.isSuccess,
    required super.message,
    super.data,
  });

  factory TreatmentDetailResponse.fromJson(Map<String, dynamic> json) =>
      TreatmentDetailResponse(
        isSuccess: json['is_success'] ?? false,
        message: json['message'] ?? '',
        data: json['data'] == null
            ? null
            : TreatmentDetailDto.fromJson(json['data'] as Map<String, dynamic>),
      );

  Map<String, dynamic> toJson() => {
        'is_success': isSuccess,
        'message': message,
        'data': data?.toJson(),
      };
}

class TreatmentDetailDto {
  final int? id;
  final int? currentStep;
  final String? status;
  final List<int>? selectedCategoryIds;
  final List<TreatmentCategoryDetailDto>? selectedCategories;
  final String? globalSku;
  final String? patientDisplayName;
  final String? image;
  final String? icon;
  final String? shortDescription;
  final String? description;
  final List<int>? selectedAreaIds;
  final List<TreatmentAreaDetailDto>? selectedAreas;
  final bool? enableByDefault;
  final bool? useInAiSimulator;
  final List<TreatmentAreaDto>? areas;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  TreatmentDetailDto({
    this.id,
    this.currentStep,
    this.status,
    this.selectedCategoryIds,
    this.selectedCategories,
    this.globalSku,
    this.patientDisplayName,
    this.image,
    this.icon,
    this.shortDescription,
    this.description,
    this.selectedAreaIds,
    this.selectedAreas,
    this.enableByDefault,
    this.useInAiSimulator,
    this.areas,
    this.createdAt,
    this.updatedAt,
  });

  // Flattened sessions computed property for backward compatibility with older components
  List<TreatmentSessionDto> get sessions {
    if (areas == null) return [];
    final List<TreatmentSessionDto> allSessions = [];
    for (final area in areas!) {
      if (area.sessions != null) {
        allSessions.addAll(area.sessions!);
      }
    }
    return allSessions;
  }

  factory TreatmentDetailDto.fromRawJson(String str) =>
      TreatmentDetailDto.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory TreatmentDetailDto.fromJson(Map<String, dynamic> json) => TreatmentDetailDto(
        id: json['id'] as int?,
        currentStep: json['current_step'] as int?,
        status: json['status'] as String?,
        selectedCategoryIds: json['selected_category_ids'] != null
            ? List<int>.from(json['selected_category_ids'])
            : null,
        selectedCategories: json['selected_categories'] != null
            ? List<TreatmentCategoryDetailDto>.from(json['selected_categories']
                .map((x) => TreatmentCategoryDetailDto.fromJson(x)))
            : null,
        globalSku: json['global_sku'] as String?,
        patientDisplayName: json['patient_display_name'] as String?,
        image: json['image'] as String?,
        icon: json['icon'] as String?,
        shortDescription: json['short_description'] as String?,
        description: json['description'] as String?,
        selectedAreaIds: json['selected_area_ids'] != null
            ? List<int>.from(json['selected_area_ids'])
            : null,
        selectedAreas: json['selected_areas'] != null
            ? List<TreatmentAreaDetailDto>.from(json['selected_areas']
                .map((x) => TreatmentAreaDetailDto.fromJson(x)))
            : null,
        enableByDefault: json['enable_by_default'] as bool?,
        useInAiSimulator: json['use_in_ai_simulator'] as bool?,
        areas: json['areas'] != null
            ? List<TreatmentAreaDto>.from(json['areas']
                .map((x) => TreatmentAreaDto.fromJson(x as Map<String, dynamic>)))
            : null,
        createdAt: json['created_at'] == null
            ? null
            : DateTime.parse(json['created_at']),
        updatedAt: json['updated_at'] == null
            ? null
            : DateTime.parse(json['updated_at']),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'current_step': currentStep,
        'status': status,
        'selected_category_ids': selectedCategoryIds,
        'selected_categories': selectedCategories == null
            ? null
            : List<dynamic>.from(selectedCategories!.map((x) => x.toJson())),
        'global_sku': globalSku,
        'patient_display_name': patientDisplayName,
        'image': image,
        'icon': icon,
        'short_description': shortDescription,
        'description': description,
        'selected_area_ids': selectedAreaIds,
        'selected_areas': selectedAreas == null
            ? null
            : List<dynamic>.from(selectedAreas!.map((x) => x.toJson())),
        'enable_by_default': enableByDefault,
        'use_in_ai_simulator': useInAiSimulator,
        'areas': areas == null
            ? null
            : List<dynamic>.from(areas!.map((x) => x.toJson())),
        'created_at': createdAt?.toIso8601String(),
        'updated_at': updatedAt?.toIso8601String(),
      };
}

class TreatmentCategoryDetailDto {
  final int? id;
  final String? name;
  final String? icon;
  final String? image;
  final String? shortDescription;
  final String? status;

  TreatmentCategoryDetailDto({
    this.id,
    this.name,
    this.icon,
    this.image,
    this.shortDescription,
    this.status,
  });

  factory TreatmentCategoryDetailDto.fromJson(Map<String, dynamic> json) =>
      TreatmentCategoryDetailDto(
        id: json['id'] as int?,
        name: json['name'] as String?,
        icon: json['icon'] as String?,
        image: json['image'] as String?,
        shortDescription: json['short_description'] as String?,
        status: json['status'] as String?,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'icon': icon,
        'image': image,
        'short_description': shortDescription,
        'status': status,
      };
}

class TreatmentAreaDetailDto {
  final int? id;
  final String? name;
  final String? globalSku;
  final String? icon;
  final String? image;
  final String? status;

  TreatmentAreaDetailDto({
    this.id,
    this.name,
    this.globalSku,
    this.icon,
    this.image,
    this.status,
  });

  factory TreatmentAreaDetailDto.fromJson(Map<String, dynamic> json) =>
      TreatmentAreaDetailDto(
        id: json['id'] as int?,
        name: json['name'] as String?,
        globalSku: json['global_sku'] as String?,
        icon: json['icon'] as String?,
        image: json['image'] as String?,
        status: json['status'] as String?,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'global_sku': globalSku,
        'icon': icon,
        'image': image,
        'status': status,
      };
}

class TreatmentAreaDto {
  final int? areaId;
  final String? areaName;
  final List<TreatmentSessionDto>? sessions;

  TreatmentAreaDto({
    this.areaId,
    this.areaName,
    this.sessions,
  });

  factory TreatmentAreaDto.fromJson(Map<String, dynamic> json) => TreatmentAreaDto(
        areaId: json['area_id'] as int?,
        areaName: json['area_name'] as String?,
        sessions: json['sessions'] != null
            ? List<TreatmentSessionDto>.from(json['sessions']
                .map((x) => TreatmentSessionDto.fromJson(x as Map<String, dynamic>)))
            : null,
      );

  Map<String, dynamic> toJson() => {
        'area_id': areaId,
        'area_name': areaName,
        'sessions': sessions == null
            ? null
            : List<dynamic>.from(sessions!.map((x) => x.toJson())),
      };
}

class TreatmentSessionDto {
  final int? id;
  final int? treatmentId;
  final int? areaId;
  final String? areaName;
  final String? title;
  final int? sessionNumber;
  final String? status;
  final int? currentStep;
  final bool? isCompleted;
  final List<ProductUsageDto>? productUsages;
  final int? baseDuration;
  final int? prepTime;
  final int? cleanupTime;
  final List<ProductDurationDto>? productDurations;
  final bool? allowClinicOverride;
  final bool? allowProviderOverride;
  final bool? onlineBookable;
  final bool? manualApprovalRequired;
  final int? minimumBookingNotice;
  final int? maximumDaysInAdvance;
  final int? calculatedTotalDuration;
  final bool? isFixedDuration;
  final int? fixedDuration;
  final double? basePrice;
  final bool? isFixedPrice;
  final double? fixedPrice;
  final List<UnitPriceOverrideDto>? unitPriceOverrides;
  final ClinicalAttachmentDto? clinicalProtocolPdf;
  final String? preTreatmentInstructions;
  final List<ClinicalAttachmentDto>? preTreatmentAttachments;
  final String? postTreatmentInstructions;
  final List<ClinicalAttachmentDto>? postTreatmentAttachments;
  final bool? requirePostTreatmentPhotos;
  final List<PhotoMilestoneDto>? photoMilestones;
  final List<NotificationDto>? preNotifications;
  final List<NotificationDto>? postNotifications;
  final String? downtimeLevel;
  final int? downtimeDays;
  final List<String>? allowedRoles;
  final List<FollowUpDto>? followUps;
  final ClinicalAttachmentDto? preTreatmentConsentForm;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  TreatmentSessionDto({
    this.id,
    this.treatmentId,
    this.areaId,
    this.areaName,
    this.title,
    this.sessionNumber,
    this.status,
    this.currentStep,
    this.isCompleted,
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
    this.calculatedTotalDuration,
    this.isFixedDuration,
    this.fixedDuration,
    this.basePrice,
    this.isFixedPrice,
    this.fixedPrice,
    this.unitPriceOverrides,
    this.clinicalProtocolPdf,
    this.preTreatmentInstructions,
    this.preTreatmentAttachments,
    this.postTreatmentInstructions,
    this.postTreatmentAttachments,
    this.requirePostTreatmentPhotos,
    this.photoMilestones,
    this.preNotifications,
    this.postNotifications,
    this.downtimeLevel,
    this.downtimeDays,
    this.allowedRoles,
    this.followUps,
    this.preTreatmentConsentForm,
    this.createdAt,
    this.updatedAt,
  });

  factory TreatmentSessionDto.fromJson(Map<String, dynamic> json) =>
      TreatmentSessionDto(
        id: json['id'] as int?,
        treatmentId: json['treatment_id'] as int?,
        areaId: json['area_id'] as int?,
        areaName: json['area_name'] as String?,
        title: json['title'] as String?,
        sessionNumber: json['session_number'] as int?,
        status: json['status'] as String?,
        currentStep: json['current_step'] as int?,
        isCompleted: json['is_completed'] as bool?,
        productUsages: json['product_usages'] != null
            ? List<ProductUsageDto>.from(json['product_usages']
                .map((x) => ProductUsageDto.fromJson(x as Map<String, dynamic>)))
            : null,
        baseDuration: json['base_duration'] as int?,
        prepTime: json['prep_time'] as int?,
        cleanupTime: json['cleanup_time'] as int?,
        productDurations: json['product_durations'] != null
            ? List<ProductDurationDto>.from(json['product_durations']
                .map((x) => ProductDurationDto.fromJson(x as Map<String, dynamic>)))
            : null,
        allowClinicOverride: json['allow_clinic_override'] as bool?,
        allowProviderOverride: json['allow_provider_override'] as bool?,
        onlineBookable: json['online_bookable'] as bool?,
        manualApprovalRequired: json['manual_approval_required'] as bool?,
        minimumBookingNotice: json['minimum_booking_notice'] as int?,
        maximumDaysInAdvance: json['maximum_days_in_advance'] as int?,
        calculatedTotalDuration: json['calculated_total_duration'] as int?,
        isFixedDuration: json['is_fixed_duration'] as bool?,
        fixedDuration: json['fixed_duration'] as int?,
        basePrice: json['base_price'] == null ? null : (json['base_price'] as num).toDouble(),
        isFixedPrice: json['is_fixed_price'] as bool?,
        fixedPrice: json['fixed_price'] == null ? null : (json['fixed_price'] as num).toDouble(),
        unitPriceOverrides: json['unit_price_overrides'] != null
            ? List<UnitPriceOverrideDto>.from(json['unit_price_overrides']
                .map((x) => UnitPriceOverrideDto.fromJson(x as Map<String, dynamic>)))
            : null,
        clinicalProtocolPdf: json['clinical_protocol_pdf'] != null
            ? ClinicalAttachmentDto.fromJson(json['clinical_protocol_pdf'] as Map<String, dynamic>)
            : null,
        preTreatmentInstructions: json['pre_treatment_instructions'] as String?,
        preTreatmentAttachments: json['pre_treatment_attachments'] != null
            ? List<ClinicalAttachmentDto>.from(json['pre_treatment_attachments']
                .map((x) => ClinicalAttachmentDto.fromJson(x as Map<String, dynamic>)))
            : null,
        postTreatmentInstructions: json['post_treatment_instructions'] as String?,
        postTreatmentAttachments: json['post_treatment_attachments'] != null
            ? List<ClinicalAttachmentDto>.from(json['post_treatment_attachments']
                .map((x) => ClinicalAttachmentDto.fromJson(x as Map<String, dynamic>)))
            : null,
        requirePostTreatmentPhotos: json['require_post_treatment_photos'] as bool?,
        photoMilestones: json['photo_milestone'] != null
            ? List<PhotoMilestoneDto>.from(json['photo_milestone']
                .map((x) => PhotoMilestoneDto.fromJson(x as Map<String, dynamic>)))
            : null,
        preNotifications: json['pre_notifications'] != null
            ? List<NotificationDto>.from(json['pre_notifications']
                .map((x) => NotificationDto.fromJson(x as Map<String, dynamic>)))
            : null,
        postNotifications: json['post_notifications'] != null
            ? List<NotificationDto>.from(json['post_notifications']
                .map((x) => NotificationDto.fromJson(x as Map<String, dynamic>)))
            : null,
        downtimeLevel: json['downtime_level'] as String?,
        downtimeDays: json['downtime_days'] as int?,
        allowedRoles: json['allowed_roles'] != null
            ? List<String>.from(json['allowed_roles'])
            : null,
        followUps: json['follow_ups'] != null
            ? List<FollowUpDto>.from(json['follow_ups']
                .map((x) => FollowUpDto.fromJson(x as Map<String, dynamic>)))
            : null,
        preTreatmentConsentForm: json['pre_treatment_consent_form'] != null
            ? ClinicalAttachmentDto.fromJson(json['pre_treatment_consent_form'] as Map<String, dynamic>)
            : null,
        createdAt: json['created_at'] == null
            ? null
            : DateTime.parse(json['created_at']),
        updatedAt: json['updated_at'] == null
            ? null
            : DateTime.parse(json['updated_at']),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'treatment_id': treatmentId,
        'area_id': areaId,
        'area_name': areaName,
        'title': title,
        'session_number': sessionNumber,
        'status': status,
        'current_step': currentStep,
        'is_completed': isCompleted,
        'product_usages': productUsages == null
            ? null
            : List<dynamic>.from(productUsages!.map((x) => x.toJson())),
        'base_duration': baseDuration,
        'prep_time': prepTime,
        'cleanup_time': cleanupTime,
        'product_durations': productDurations == null
            ? null
            : List<dynamic>.from(productDurations!.map((x) => x.toJson())),
        'allow_clinic_override': allowClinicOverride,
        'allow_provider_override': allowProviderOverride,
        'online_bookable': onlineBookable,
        'manual_approval_required': manualApprovalRequired,
        'minimum_booking_notice': minimumBookingNotice,
        'maximum_days_in_advance': maximumDaysInAdvance,
        'calculated_total_duration': calculatedTotalDuration,
        'is_fixed_duration': isFixedDuration,
        'fixed_duration': fixedDuration,
        'base_price': basePrice,
        'is_fixed_price': isFixedPrice,
        'fixed_price': fixedPrice,
        'unit_price_overrides': unitPriceOverrides == null
            ? null
            : List<dynamic>.from(unitPriceOverrides!.map((x) => x.toJson())),
        'clinical_protocol_pdf': clinicalProtocolPdf?.toJson(),
        'pre_treatment_instructions': preTreatmentInstructions,
        'pre_treatment_attachments': preTreatmentAttachments == null
            ? null
            : List<dynamic>.from(preTreatmentAttachments!.map((x) => x.toJson())),
        'post_treatment_instructions': postTreatmentInstructions,
        'post_treatment_attachments': postTreatmentAttachments == null
            ? null
            : List<dynamic>.from(postTreatmentAttachments!.map((x) => x.toJson())),
        'require_post_treatment_photos': requirePostTreatmentPhotos,
        'photo_milestone': photoMilestones == null
            ? null
            : List<dynamic>.from(photoMilestones!.map((x) => x.toJson())),
        'pre_notifications': preNotifications == null
            ? null
            : List<dynamic>.from(preNotifications!.map((x) => x.toJson())),
        'post_notifications': postNotifications == null
            ? null
            : List<dynamic>.from(postNotifications!.map((x) => x.toJson())),
        'downtime_level': downtimeLevel,
        'downtime_days': downtimeDays,
        'allowed_roles': allowedRoles,
        'follow_ups': followUps == null
            ? null
            : List<dynamic>.from(followUps!.map((x) => x.toJson())),
        'pre_treatment_consent_form': preTreatmentConsentForm?.toJson(),
        'created_at': createdAt?.toIso8601String(),
        'updated_at': updatedAt?.toIso8601String(),
      };
}

class ProductUsageDto {
  final int? productId;
  final String? productName;
  final String? productImage;
  final String? productSku;
  final String? deductionTiming;
  final bool? allowSubstitution;
  final String? notes;
  final double? minQuantity;
  final double? maxQuantity;

  ProductUsageDto({
    this.productId,
    this.productName,
    this.productImage,
    this.productSku,
    this.deductionTiming,
    this.allowSubstitution,
    this.notes,
    this.minQuantity,
    this.maxQuantity,
  });

  factory ProductUsageDto.fromJson(Map<String, dynamic> json) => ProductUsageDto(
        productId: json['product_id'] as int?,
        productName: json['product_name'] as String?,
        productImage: json['product_image'] as String?,
        productSku: json['product_sku'] as String?,
        deductionTiming: json['deduction_timing'] as String?,
        allowSubstitution: json['allow_substitution'] as bool?,
        notes: json['notes'] as String?,
        minQuantity: json['min_quantity'] == null ? null : (json['min_quantity'] as num).toDouble(),
        maxQuantity: json['max_quantity'] == null ? null : (json['max_quantity'] as num).toDouble(),
      );

  Map<String, dynamic> toJson() => {
        'product_id': productId,
        'product_name': productName,
        'product_image': productImage,
        'product_sku': productSku,
        'deduction_timing': deductionTiming,
        'allow_substitution': allowSubstitution,
        'notes': notes,
        'min_quantity': minQuantity,
        'max_quantity': maxQuantity,
      };
}

class ProductDurationDto {
  final int? productId;
  final String? productName;
  final double? perUnitDuration;

  ProductDurationDto({
    this.productId,
    this.productName,
    this.perUnitDuration,
  });

  factory ProductDurationDto.fromJson(Map<String, dynamic> json) => ProductDurationDto(
        productId: json['product_id'] as int?,
        productName: json['product_name'] as String?,
        perUnitDuration: json['per_unit_duration'] == null ? null : (json['per_unit_duration'] as num).toDouble(),
      );

  Map<String, dynamic> toJson() => {
        'product_id': productId,
        'product_name': productName,
        'per_unit_duration': perUnitDuration,
      };
}

class UnitPriceOverrideDto {
  final int? productId;
  final String? productName;
  final double? pricePerUnit;

  UnitPriceOverrideDto({
    this.productId,
    this.productName,
    this.pricePerUnit,
  });

  factory UnitPriceOverrideDto.fromJson(Map<String, dynamic> json) => UnitPriceOverrideDto(
        productId: json['product_id'] as int?,
        productName: json['product_name'] as String?,
        pricePerUnit: json['price_per_unit'] == null ? null : (json['price_per_unit'] as num).toDouble(),
      );

  Map<String, dynamic> toJson() => {
        'product_id': productId,
        'product_name': productName,
        'price_per_unit': pricePerUnit,
      };
}

class ClinicalAttachmentDto {
  final String? name;
  final String? url;
  final String? type;

  ClinicalAttachmentDto({
    this.name,
    this.url,
    this.type,
  });

  factory ClinicalAttachmentDto.fromJson(Map<String, dynamic> json) => ClinicalAttachmentDto(
        name: json['name'] as String?,
        url: json['url'] as String?,
        type: json['type'] as String?,
      );

  Map<String, dynamic> toJson() => {
        'name': name,
        'url': url,
        'type': type,
      };
}

class PhotoMilestoneDto {
  final int? timingValue;
  final String? timingUnit;

  PhotoMilestoneDto({
    this.timingValue,
    this.timingUnit,
  });

  factory PhotoMilestoneDto.fromJson(Map<String, dynamic> json) => PhotoMilestoneDto(
        timingValue: json['timing_value'] as int?,
        timingUnit: json['timing_unit'] as String?,
      );

  Map<String, dynamic> toJson() => {
        'timing_value': timingValue,
        'timing_unit': timingUnit,
      };
}

class NotificationDto {
  final String? title;
  final String? message;
  final int? timing;
  final String? timingUnit;
  final String? type;

  NotificationDto({
    this.title,
    this.message,
    this.timing,
    this.timingUnit,
    this.type,
  });

  factory NotificationDto.fromJson(Map<String, dynamic> json) => NotificationDto(
        title: json['title'] as String?,
        message: json['message'] as String?,
        timing: json['timing'] as int?,
        timingUnit: json['timing_unit'] as String?,
        type: json['type'] as String?,
      );

  Map<String, dynamic> toJson() => {
        'title': title,
        'message': message,
        'timing': timing,
        'timing_unit': timingUnit,
        'type': type,
      };
}

class FollowUpDto {
  final String? type;
  final int? durationValue;
  final String? durationUnit;
  final int? intervalValue;
  final String? intervalUnit;
  final bool? isImageRequired;
  final String? notes;

  FollowUpDto({
    this.type,
    this.durationValue,
    this.durationUnit,
    this.intervalValue,
    this.intervalUnit,
    this.isImageRequired,
    this.notes,
  });

  factory FollowUpDto.fromJson(Map<String, dynamic> json) => FollowUpDto(
        type: json['type'] as String?,
        durationValue: json['duration_value'] as int?,
        durationUnit: json['duration_unit'] as String?,
        intervalValue: json['interval_value'] as int?,
        intervalUnit: json['interval_unit'] as String?,
        isImageRequired: json['is_image_required'] as bool?,
        notes: json['notes'] as String?,
      );

  Map<String, dynamic> toJson() => {
        'type': type,
        'duration_value': durationValue,
        'duration_unit': durationUnit,
        'interval_value': intervalValue,
        'interval_unit': intervalUnit,
        'is_image_required': isImageRequired,
        'notes': notes,
      };
}
