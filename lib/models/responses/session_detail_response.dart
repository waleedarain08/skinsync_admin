import 'package:skinsync_admin/models/responses/base_response_model.dart';

class SessionDetailResponse extends BaseApiResponseModel<SessionDetailDto> {
  SessionDetailResponse({
    super.data,
    required super.isSuccess,
    required super.message,
  });

  factory SessionDetailResponse.fromJson(Map<String, dynamic> json) {
    return SessionDetailResponse(
      data: json['data'] != null ? SessionDetailDto.fromJson(json['data']) : null,
      isSuccess: json['is_success'] as bool? ?? false,
      message: json['message'] as String? ?? '',
    );
  }
}

class SessionDetailDto {
  final int id;
  final int treatmentId;
  final int areaId;
  final String areaName;
  final String title;
  final int sessionNumber;
  final String status;
  final int currentStep;
  final bool isCompleted;
  final List<SessionProductUsageDto> productUsages;
  final int baseDuration;
  final int prepTime;
  final int cleanupTime;
  final List<SessionProductDurationDto> productDurations;
  final bool allowClinicOverride;
  final bool allowProviderOverride;
  final bool onlineBookable;
  final bool manualApprovalRequired;
  final int minimumBookingNotice;
  final int maximumDaysInAdvance;
  final int calculatedTotalDuration;
  final bool isFixedDuration;
  final int fixedDuration;
  final double basePrice;
  final bool isFixedPrice;
  final double fixedPrice;
  final List<SessionUnitPriceOverrideDto> unitPriceOverrides;
  final SessionAttachmentDto? clinicalProtocolPdf;
  final String preTreatmentInstructions;
  final List<SessionAttachmentDto> preTreatmentAttachments;
  final String postTreatmentInstructions;
  final List<SessionAttachmentDto> postTreatmentAttachments;
  final bool requirePostTreatmentPhotos;
  final List<PhotoMilestoneDto> photoMilestone;
  final List<SessionNotificationDto> preNotifications;
  final List<SessionNotificationDto> postNotifications;
  final String downtimeLevel;
  final int downtimeDays;
  final List<String> allowedRoles;
  final List<SessionFollowUpDto> followUps;
  final SessionAttachmentDto? preTreatmentConsentForm;

  // New MaterialsStep Redesign properties
  final int? selectedUnitTypeId;
  final double? minimumUnits;
  final double? maximumUnits;
  final List<int> otherMaterials;

  SessionDetailDto({
    required this.id,
    required this.treatmentId,
    required this.areaId,
    required this.areaName,
    required this.title,
    required this.sessionNumber,
    required this.status,
    required this.currentStep,
    required this.isCompleted,
    required this.productUsages,
    required this.baseDuration,
    required this.prepTime,
    required this.cleanupTime,
    required this.productDurations,
    required this.allowClinicOverride,
    required this.allowProviderOverride,
    required this.onlineBookable,
    required this.manualApprovalRequired,
    required this.minimumBookingNotice,
    required this.maximumDaysInAdvance,
    required this.calculatedTotalDuration,
    required this.isFixedDuration,
    required this.fixedDuration,
    required this.basePrice,
    required this.isFixedPrice,
    required this.fixedPrice,
    required this.unitPriceOverrides,
    this.clinicalProtocolPdf,
    required this.preTreatmentInstructions,
    required this.preTreatmentAttachments,
    required this.postTreatmentInstructions,
    required this.postTreatmentAttachments,
    required this.requirePostTreatmentPhotos,
    required this.photoMilestone,
    required this.preNotifications,
    required this.postNotifications,
    required this.downtimeLevel,
    required this.downtimeDays,
    required this.allowedRoles,
    required this.followUps,
    this.preTreatmentConsentForm,
    this.selectedUnitTypeId,
    this.minimumUnits,
    this.maximumUnits,
    required this.otherMaterials,
  });

  factory SessionDetailDto.fromJson(Map<String, dynamic> json) {
    return SessionDetailDto(
      id: json['id'] as int? ?? 0,
      treatmentId: json['treatment_id'] as int? ?? 0,
      areaId: json['area_id'] as int? ?? 0,
      areaName: json['area_name'] as String? ?? '',
      title: json['title'] as String? ?? '',
      sessionNumber: json['session_number'] as int? ?? 1,
      status: json['status'] as String? ?? 'Active',
      currentStep: json['current_step'] as int? ?? 1,
      isCompleted: json['is_completed'] as bool? ?? false,
      productUsages: (json['billable_materials'] as List? ?? json['product_usages'] as List?)
              ?.map((e) => SessionProductUsageDto.fromJson(e))
              .toList() ??
          [],
      baseDuration: json['base_duration'] as int? ?? 0,
      prepTime: json['prep_time'] as int? ?? 0,
      cleanupTime: json['cleanup_time'] as int? ?? 0,
      productDurations: (json['product_durations'] as List?)
              ?.map((e) => SessionProductDurationDto.fromJson(e))
              .toList() ??
          [],
      allowClinicOverride: json['allow_clinic_override'] as bool? ?? false,
      allowProviderOverride: json['allow_provider_override'] as bool? ?? false,
      onlineBookable: json['online_bookable'] as bool? ?? false,
      manualApprovalRequired: json['manual_approval_required'] as bool? ?? false,
      minimumBookingNotice: json['minimum_booking_notice'] as int? ?? 0,
      maximumDaysInAdvance: json['maximum_days_in_advance'] as int? ?? 0,
      calculatedTotalDuration: json['calculated_total_duration'] as int? ?? 0,
      isFixedDuration: json['is_fixed_duration'] as bool? ?? false,
      fixedDuration: json['fixed_duration'] as int? ?? 0,
      basePrice: (json['base_price'] as num?)?.toDouble() ?? 0.0,
      isFixedPrice: json['is_fixed_price'] as bool? ?? false,
      fixedPrice: (json['fixed_price'] as num?)?.toDouble() ?? 0.0,
      unitPriceOverrides: (json['unit_price_overrides'] as List?)
              ?.map((e) => SessionUnitPriceOverrideDto.fromJson(e))
              .toList() ??
          [],
      clinicalProtocolPdf: json['clinical_protocol_pdf'] != null
          ? SessionAttachmentDto.fromJson(json['clinical_protocol_pdf'])
          : null,
      preTreatmentInstructions: json['pre_treatment_instructions'] as String? ?? '',
      preTreatmentAttachments: (json['pre_treatment_attachments'] as List?)
              ?.map((e) => SessionAttachmentDto.fromJson(e))
              .toList() ??
          [],
      postTreatmentInstructions: json['post_treatment_instructions'] ?? '',
      postTreatmentAttachments: (json['post_treatment_attachments'] as List?)
              ?.map((e) => SessionAttachmentDto.fromJson(e))
              .toList() ??
          [],
      requirePostTreatmentPhotos: json['require_post_treatment_photos'] as bool? ?? false,
      photoMilestone: (json['photo_milestone'] as List?)
              ?.map((e) => PhotoMilestoneDto.fromJson(e))
              .toList() ??
          [],
      preNotifications: (json['pre_notifications'] as List?)
              ?.map((e) => SessionNotificationDto.fromJson(e))
              .toList() ??
          [],
      postNotifications: (json['post_notifications'] as List?)
              ?.map((e) => SessionNotificationDto.fromJson(e))
              .toList() ??
          [],
      downtimeLevel: json['downtime_level'] as String? ?? 'none',
      downtimeDays: json['downtime_days'] as int? ?? 0,
      allowedRoles: (json['allowed_roles'] as List?)?.map((e) => e as String).toList() ?? [],
      followUps: (json['follow_ups'] as List?)
              ?.map((e) => SessionFollowUpDto.fromJson(e))
              .toList() ??
          [],
      preTreatmentConsentForm: json['pre_treatment_consent_form'] != null
          ? SessionAttachmentDto.fromJson(json['pre_treatment_consent_form'])
          : null,
      selectedUnitTypeId: json['selected_unit_type_id'] is int 
          ? json['selected_unit_type_id'] as int?
          : (json['selected_unit_type_id'] as Map<String, dynamic>?)?['id'] as int?,
      minimumUnits: (json['minimum_units'] as num?)?.toDouble() ?? 0.0,
      maximumUnits: (json['maximum_units'] as num?)?.toDouble() ?? 0.0,
      otherMaterials: (json['other_materials'] as List?)
              ?.map((e) => e is int ? e : ((e as Map<String, dynamic>)['product_id'] ?? (e)['id']) as int)
              .toList() ??
          [],
    );
  }
}

class SessionProductUsageDto {
  final int productId;
  final String productName;
  final String productImage;
  final String productSku;
  final String deductionTiming;
  final bool allowSubstitution;
  final String notes;
  final double minQuantity;
  final double maxQuantity;

  SessionProductUsageDto({
    required this.productId,
    required this.productName,
    required this.productImage,
    required this.productSku,
    required this.deductionTiming,
    required this.allowSubstitution,
    required this.notes,
    required this.minQuantity,
    required this.maxQuantity,
  });

  factory SessionProductUsageDto.fromJson(Map<String, dynamic> json) {
    return SessionProductUsageDto(
      productId: json['product_id'] is int 
          ? json['product_id'] as int 
          : (json['product_id'] as Map<String, dynamic>?)?['id'] as int? ?? (json['id'] as int? ?? 0),
      productName: json['product_name'] as String? ?? '',
      productImage: json['product_image'] as String? ?? '',
      productSku: json['product_sku'] as String? ?? '',
      deductionTiming: json['deduction_timing']?.toString() ?? '',
      allowSubstitution: json['allow_substitution'] as bool? ?? false,
      notes: json['notes'] as String? ?? '',
      minQuantity: (json['min_quantity'] as num?)?.toDouble() ?? 0.0,
      maxQuantity: (json['max_quantity'] as num?)?.toDouble() ?? 0.0,
    );
  }
}

class SessionProductDurationDto {
  final int productId;
  final String productName;
  final double perUnitDuration;

  SessionProductDurationDto({
    required this.productId,
    required this.productName,
    required this.perUnitDuration,
  });

  factory SessionProductDurationDto.fromJson(Map<String, dynamic> json) {
    return SessionProductDurationDto(
      productId: json['product_id'] as int? ?? 0,
      productName: json['product_name'] as String? ?? '',
      perUnitDuration: (json['per_unit_duration'] as num?)?.toDouble() ?? 0.0,
    );
  }
}

class SessionUnitPriceOverrideDto {
  final int productId;
  final String productName;
  final double pricePerUnit;

  SessionUnitPriceOverrideDto({
    required this.productId,
    required this.productName,
    required this.pricePerUnit,
  });

  factory SessionUnitPriceOverrideDto.fromJson(Map<String, dynamic> json) {
    return SessionUnitPriceOverrideDto(
      productId: json['product_id'] as int? ?? 0,
      productName: json['product_name'] as String? ?? '',
      pricePerUnit: (json['price_per_unit'] as num?)?.toDouble() ?? 0.0,
    );
  }
}

class SessionAttachmentDto {
  final String name;
  final String url;
  final String? type;

  SessionAttachmentDto({
    required this.name,
    required this.url,
    this.type,
  });

  factory SessionAttachmentDto.fromJson(Map<String, dynamic> json) {
    return SessionAttachmentDto(
      name: json['name'] as String? ?? '',
      url: json['url'] as String? ?? '',
      type: json['type'] as String?,
    );
  }
}

class SessionNotificationDto {
  final String title;
  final String message;
  final int timing;
  final String timingUnit;
  final String type;

  SessionNotificationDto({
    required this.title,
    required this.message,
    required this.timing,
    required this.timingUnit,
    required this.type,
  });

  factory SessionNotificationDto.fromJson(Map<String, dynamic> json) {
    return SessionNotificationDto(
      title: json['title'] as String? ?? '',
      message: json['message'] as String? ?? '',
      timing: json['timing'] as int? ?? 0,
      timingUnit: json['timing_unit'] as String? ?? 'days',
      type: json['type'] as String? ?? 'sms',
    );
  }
}

class PhotoMilestoneDto {
  final int numberOfDays;
  final int requiredPhotos;

  PhotoMilestoneDto({
    required this.numberOfDays,
    required this.requiredPhotos,
  });

  factory PhotoMilestoneDto.fromJson(Map<String, dynamic> json) {
    return PhotoMilestoneDto(
      numberOfDays: json['number_of_days'] as int? ?? 0,
      requiredPhotos: json['required_photos'] as int? ?? 0,
    );
  }
}

class SessionFollowUpDto {
  final String type;
  final String durationUnit;
  final int durationValue;
  final String notes;
  final int intervalValue;
  final String intervalUnit;
  final bool isImageRequired;

  SessionFollowUpDto({
    required this.type,
    required this.durationUnit,
    required this.durationValue,
    required this.notes,
    required this.intervalValue,
    required this.intervalUnit,
    required this.isImageRequired,
  });

  factory SessionFollowUpDto.fromJson(Map<String, dynamic> json) {
    return SessionFollowUpDto(
      type: json['type'] as String? ?? '',
      durationUnit: json['duration_unit'] as String? ?? '',
      durationValue: json['duration_value'] as int? ?? 0,
      notes: json['notes'] as String? ?? '',
      intervalValue: json['interval_value'] as int? ?? 0,
      intervalUnit: json['interval_unit'] as String? ?? '',
      isImageRequired: json['is_image_required'] as bool? ?? false,
    );
  }
}
