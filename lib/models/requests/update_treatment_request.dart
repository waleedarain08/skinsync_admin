class UpdateTreatmentRequest {
  final List<int>? selectedCategoryIds;
  final String? globalSku;
  final String? patientDisplayName;
  final String? image;
  final String? icon;
  final String? shortDescription;
  final String? description;
  final List<int>? selectedAreaIds;
  final List<UpdateProductUsage>? productUsages;
  final int? baseDuration;
  final int? prepTime;
  final int? cleanupTime;
  final List<UpdateProductDuration>? productDurations;
  final bool? allowClinicOverride;
  final bool? allowProviderOverride;
  final bool? onlineBookable;
  final bool? manualApprovalRequired;
  final int? minimumBookingNotice;
  final int? maximumDaysInAdvance;
  final double? basePrice;
  final List<UpdateUnitPriceOverride>? unitPriceOverrides;
  final UpdateClinicalProtocolPdf? clinicalProtocolPdf;
  final String? preTreatmentInstructions;
  final List<UpdateAttachment>? preTreatmentAttachments;
  final String? postTreatmentInstructions;
  final List<UpdateAttachment>? postTreatmentAttachments;
  final bool? requirePostTreatmentPhotos;
  final int? requiredPostTreatmentPhotoCount;
  final List<UpdateNotification>? preNotifications;
  final List<UpdateNotification>? postNotifications;
  final String? downtimeLevel;
  final int? downtimeDays;
  final List<String>? allowedRoles;
  final int? totalSessions;
  final List<UpdateSession>? sessions;
  final UpdateConsentForm? preTreatmentConsentForm;
  final bool? enableByDefault;
  final bool? useInAiSimulator;

  UpdateTreatmentRequest({
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
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (selectedCategoryIds != null) data['selected_category_ids'] = selectedCategoryIds;
    if (globalSku != null) data['global_sku'] = globalSku;
    if (patientDisplayName != null) data['patient_display_name'] = patientDisplayName;
    if (image != null) data['image'] = image;
    if (icon != null) data['icon'] = icon;
    if (shortDescription != null) data['short_description'] = shortDescription;
    if (description != null) data['description'] = description;
    if (selectedAreaIds != null) data['selected_area_ids'] = selectedAreaIds;
    if (productUsages != null) data['product_usages'] = productUsages!.map((v) => v.toJson()).toList();
    if (baseDuration != null) data['base_duration'] = baseDuration;
    if (prepTime != null) data['prep_time'] = prepTime;
    if (cleanupTime != null) data['cleanup_time'] = cleanupTime;
    if (productDurations != null) data['product_durations'] = productDurations!.map((v) => v.toJson()).toList();
    if (allowClinicOverride != null) data['allow_clinic_override'] = allowClinicOverride;
    if (allowProviderOverride != null) data['allow_provider_override'] = allowProviderOverride;
    if (onlineBookable != null) data['online_bookable'] = onlineBookable;
    if (manualApprovalRequired != null) data['manual_approval_required'] = manualApprovalRequired;
    if (minimumBookingNotice != null) data['minimum_booking_notice'] = minimumBookingNotice;
    if (maximumDaysInAdvance != null) data['maximum_days_in_advance'] = maximumDaysInAdvance;
    if (basePrice != null) data['base_price'] = basePrice;
    if (unitPriceOverrides != null) data['unit_price_overrides'] = unitPriceOverrides!.map((v) => v.toJson()).toList();
    if (clinicalProtocolPdf != null) data['clinical_protocol_pdf'] = clinicalProtocolPdf!.toJson();
    if (preTreatmentInstructions != null) data['pre_treatment_instructions'] = preTreatmentInstructions;
    if (preTreatmentAttachments != null) data['pre_treatment_attachments'] = preTreatmentAttachments!.map((v) => v.toJson()).toList();
    if (postTreatmentInstructions != null) data['post_treatment_instructions'] = postTreatmentInstructions;
    if (postTreatmentAttachments != null) data['post_treatment_attachments'] = postTreatmentAttachments!.map((v) => v.toJson()).toList();
    if (requirePostTreatmentPhotos != null) data['require_post_treatment_photos'] = requirePostTreatmentPhotos;
    if (requiredPostTreatmentPhotoCount != null) data['required_post_treatment_photo_count'] = requiredPostTreatmentPhotoCount;
    if (preNotifications != null) data['pre_notifications'] = preNotifications!.map((v) => v.toJson()).toList();
    if (postNotifications != null) data['post_notifications'] = postNotifications!.map((v) => v.toJson()).toList();
    if (downtimeLevel != null) data['downtime_level'] = downtimeLevel;
    if (downtimeDays != null) data['downtime_days'] = downtimeDays;
    if (allowedRoles != null) data['allowed_roles'] = allowedRoles;
    if (totalSessions != null) data['total_sessions'] = totalSessions;
    if (sessions != null) data['sessions'] = sessions!.map((v) => v.toJson()).toList();
    if (preTreatmentConsentForm != null) data['pre_treatment_consent_form'] = preTreatmentConsentForm!.toJson();
    if (enableByDefault != null) data['enable_by_default'] = enableByDefault;
    if (useInAiSimulator != null) data['use_in_ai_simulator'] = useInAiSimulator;
    return data;
  }
}

class UpdateProductUsage {
  final int? productId;
  final String? productName;
  final String? usageType;
  final double? minQuantity;
  final double? maxQuantity;
  final String? deductionTiming;
  final bool? allowSubstitution;
  final String? notes;
  final String? unit;
  final double? perUnitDuration;

  UpdateProductUsage({
    this.productId,
    this.productName,
    this.usageType,
    this.minQuantity,
    this.maxQuantity,
    this.deductionTiming,
    this.allowSubstitution,
    this.notes,
    this.unit,
    this.perUnitDuration,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (productId != null) data['product_id'] = productId;
    if (productName != null) data['product_name'] = productName;
    if (usageType != null) data['usage_type'] = usageType;
    if (minQuantity != null) data['min_quantity'] = minQuantity;
    if (maxQuantity != null) data['max_quantity'] = maxQuantity;
    if (deductionTiming != null) data['deduction_timing'] = deductionTiming;
    if (allowSubstitution != null) data['allow_substitution'] = allowSubstitution;
    if (notes != null) data['notes'] = notes;
    if (unit != null) data['unit'] = unit;
    if (perUnitDuration != null) data['per_unit_duration'] = perUnitDuration;
    return data;
  }
}

class UpdateProductDuration {
  final int? productId;
  final String? productName;
  final int? duration;

  UpdateProductDuration({this.productId, this.productName, this.duration});

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (productId != null) data['product_id'] = productId;
    if (productName != null) data['product_name'] = productName;
    if (duration != null) data['duration'] = duration;
    return data;
  }
}

class UpdateUnitPriceOverride {
  final String? role;
  final double? price;

  UpdateUnitPriceOverride({this.role, this.price});

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (role != null) data['role'] = role;
    if (price != null) data['price'] = price;
    return data;
  }
}

class UpdateClinicalProtocolPdf {
  final int? id;
  final String? name;
  final String? url;

  UpdateClinicalProtocolPdf({this.id, this.name, this.url});

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (id != null) data['id'] = id;
    if (name != null) data['name'] = name;
    if (url != null) data['url'] = url;
    return data;
  }
}

class UpdateAttachment {
  final String? url;
  final String? type;
  final String? name;

  UpdateAttachment({this.url, this.type, this.name});

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (url != null) data['url'] = url;
    if (type != null) data['type'] = type;
    if (name != null) data['name'] = name;
    return data;
  }
}

class UpdateNotification {
  final String? title;
  final String? message;
  final int? timing;
  final String? timingUnit;
  final String? type;

  UpdateNotification({
    this.title,
    this.message,
    this.timing,
    this.timingUnit,
    this.type,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (title != null) data['title'] = title;
    if (message != null) data['message'] = message;
    if (timing != null) data['timing'] = timing;
    if (timingUnit != null) data['timing_unit'] = timingUnit;
    if (type != null) data['type'] = type;
    return data;
  }
}

class UpdateSession {
  final int? sessionNumber;
  final List<UpdateFollowUp>? followUps;

  UpdateSession({this.sessionNumber, this.followUps});

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (sessionNumber != null) data['session_number'] = sessionNumber;
    if (followUps != null) data['follow_ups'] = followUps!.map((v) => v.toJson()).toList();
    return data;
  }
}

class UpdateFollowUp {
  final String? type;
  final int? durationValue;
  final String? durationUnit;
  final String? notes;
  final int? intervalValue;
  final String? intervalUnit;
  final bool? isImageRequired;

  UpdateFollowUp({
    this.type,
    this.durationValue,
    this.durationUnit,
    this.notes,
    this.intervalValue,
    this.intervalUnit,
    this.isImageRequired,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (type != null) data['type'] = type;
    if (durationValue != null) data['duration_value'] = durationValue;
    if (durationUnit != null) data['duration_unit'] = durationUnit;
    if (notes != null) data['notes'] = notes;
    if (intervalValue != null) data['interval_value'] = intervalValue;
    if (intervalUnit != null) data['interval_unit'] = intervalUnit;
    if (isImageRequired != null) data['is_image_required'] = isImageRequired;
    return data;
  }
}

class UpdateConsentForm {
  final int? id;
  final String? name;
  final String? url;

  UpdateConsentForm({this.id, this.name, this.url});

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (id != null) data['id'] = id;
    if (name != null) data['name'] = name;
    if (url != null) data['url'] = url;
    return data;
  }
}