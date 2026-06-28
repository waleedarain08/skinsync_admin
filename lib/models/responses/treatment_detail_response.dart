import 'package:skinsync_admin/models/common_models.dart';
import 'package:skinsync_admin/models/treatment_model.dart';
import 'base_response_model.dart';

class TreatmentDetailResponse extends BaseApiResponseModel<TreatmentDetailData> {
  const TreatmentDetailResponse({
    required super.isSuccess,
    required super.message,
    super.data,
  });

  factory TreatmentDetailResponse.fromJson(Map<String, dynamic> json) {
    final bool success = (json['is_success'] as bool?) ?? false;
    return TreatmentDetailResponse(
      isSuccess: success,
      message: json['message'] ?? '',
      data: json['data'] == null
          ? null
          : TreatmentDetailData.fromJson(json['data'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toJson() => {
        'is_success': isSuccess,
        'message': message,
        'data': data?.toJson(),
      };
}

class TreatmentDetailData {
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
  final List<int>? selectedAreaIds;
  final List<TreatmentProductUsage>? productUsages;
  final int? baseDuration;
  final int? prepTime;
  final int? cleanupTime;
  final List<TreatmentProductDuration>? productDurations;
  final bool? allowClinicOverride;
  final bool? allowProviderOverride;
  final bool? onlineBookable;
  final bool? manualApprovalRequired;
  final int? minimumBookingNotice;
  final int? maximumDaysInAdvance;
  final double? basePrice;
  final List<TreatmentUnitPriceOverride>? unitPriceOverrides;
  final TreatmentClinicalProtocolPdf? clinicalProtocolPdf;
  final String? preTreatmentInstructions;
  final List<Attachment>? preTreatmentAttachments;
  final String? postTreatmentInstructions;
  final List<Attachment>? postTreatmentAttachments;
  final bool? requirePostTreatmentPhotos;
  final int? requiredPostTreatmentPhotoCount;
  final List<TreatmentNotification>? preNotifications;
  final List<TreatmentNotification>? postNotifications;
  final String? downtimeLevel;
  final int? downtimeDays;
  final List<String>? allowedRoles;
  final int? totalSessions;
  final List<TreatmentSession>? sessions;
  final TreatmentConsentForm? preTreatmentConsentForm;
  final bool? enableByDefault;
  final bool? useInAiSimulator;
  final String? createdAt;
  final String? updatedAt;

  TreatmentDetailData({
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

  factory TreatmentDetailData.fromJson(Map<String, dynamic> json) {
    return TreatmentDetailData(
      id: json['id'] as int?,
      currentStep: json['current_step'] as int?,
      status: json['status'] as String?,
      selectedCategoryIds: json['selected_category_ids'] != null
          ? List<int>.from(json['selected_category_ids'])
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
      productUsages: json['product_usages'] != null
          ? (json['product_usages'] as List)
              .map((e) => TreatmentProductUsage.fromJson(e as Map<String, dynamic>))
              .toList()
          : null,
      baseDuration: json['base_duration'] as int?,
      prepTime: json['prep_time'] as int?,
      cleanupTime: json['cleanup_time'] as int?,
      productDurations: json['product_durations'] != null
          ? (json['product_durations'] as List)
              .map((e) => TreatmentProductDuration.fromJson(e as Map<String, dynamic>))
              .toList()
          : null,
      allowClinicOverride: json['allow_clinic_override'] as bool?,
      allowProviderOverride: json['allow_provider_override'] as bool?,
      onlineBookable: json['online_bookable'] as bool?,
      manualApprovalRequired: json['manual_approval_required'] as bool?,
      minimumBookingNotice: json['minimum_booking_notice'] as int?,
      maximumDaysInAdvance: json['maximum_days_in_advance'] as int?,
      basePrice: (json['base_price'] as num?)?.toDouble(),
      unitPriceOverrides: json['unit_price_overrides'] != null
          ? (json['unit_price_overrides'] as List)
              .map((e) => TreatmentUnitPriceOverride.fromJson(e as Map<String, dynamic>))
              .toList()
          : null,
      clinicalProtocolPdf: json['clinical_protocol_pdf'] != null
          ? TreatmentClinicalProtocolPdf.fromJson(json['clinical_protocol_pdf'] as Map<String, dynamic>)
          : null,
      preTreatmentInstructions: json['pre_treatment_instructions'] as String?,
      preTreatmentAttachments: json['pre_treatment_attachments'] != null
          ? (json['pre_treatment_attachments'] as List)
              .map((e) => Attachment.fromJson(e as Map<String, dynamic>))
              .toList()
          : null,
      postTreatmentInstructions: json['post_treatment_instructions'] as String?,
      postTreatmentAttachments: json['post_treatment_attachments'] != null
          ? (json['post_treatment_attachments'] as List)
              .map((e) => Attachment.fromJson(e as Map<String, dynamic>))
              .toList()
          : null,
      requirePostTreatmentPhotos: json['require_post_treatment_photos'] as bool?,
      requiredPostTreatmentPhotoCount: json['required_post_treatment_photo_count'] as int?,
      preNotifications: json['pre_notifications'] != null
          ? (json['pre_notifications'] as List)
              .map((e) => TreatmentNotification.fromJson(e as Map<String, dynamic>))
              .toList()
          : null,
      postNotifications: json['post_notifications'] != null
          ? (json['post_notifications'] as List)
              .map((e) => TreatmentNotification.fromJson(e as Map<String, dynamic>))
              .toList()
          : null,
      downtimeLevel: json['downtime_level'] as String?,
      downtimeDays: json['downtime_days'] as int?,
      allowedRoles: json['allowed_roles'] != null
          ? List<String>.from(json['allowed_roles'])
          : null,
      totalSessions: json['total_sessions'] as int?,
      sessions: json['sessions'] != null
          ? (json['sessions'] as List)
              .map((e) => TreatmentSession.fromJson(e as Map<String, dynamic>))
              .toList()
          : null,
      preTreatmentConsentForm: json['pre_treatment_consent_form'] != null
          ? TreatmentConsentForm.fromJson(json['pre_treatment_consent_form'] as Map<String, dynamic>)
          : null,
      enableByDefault: json['enable_by_default'] as bool?,
      useInAiSimulator: json['use_in_ai_simulator'] as bool?,
      createdAt: json['created_at'] as String?,
      updatedAt: json['updated_at'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'current_step': currentStep,
        'status': status,
        'selected_category_ids': selectedCategoryIds,
        'global_sku': globalSku,
        'patient_display_name': patientDisplayName,
        'image': image,
        'icon': icon,
        'short_description': shortDescription,
        'description': description,
        'selected_area_ids': selectedAreaIds,
        'product_usages': productUsages?.map((e) => e.toJson()).toList(),
        'base_duration': baseDuration,
        'prep_time': prepTime,
        'cleanup_time': cleanupTime,
        'product_durations': productDurations?.map((e) => e.toJson()).toList(),
        'allow_clinic_override': allowClinicOverride,
        'allow_provider_override': allowProviderOverride,
        'online_bookable': onlineBookable,
        'manual_approval_required': manualApprovalRequired,
        'minimum_booking_notice': minimumBookingNotice,
        'maximum_days_in_advance': maximumDaysInAdvance,
        'base_price': basePrice,
        'unit_price_overrides': unitPriceOverrides?.map((e) => e.toJson()).toList(),
        'clinical_protocol_pdf': clinicalProtocolPdf?.toJson(),
        'pre_treatment_instructions': preTreatmentInstructions,
        'pre_treatment_attachments': preTreatmentAttachments?.map((e) => e.toJson()).toList(),
        'post_treatment_instructions': postTreatmentInstructions,
        'post_treatment_attachments': postTreatmentAttachments?.map((e) => e.toJson()).toList(),
        'require_post_treatment_photos': requirePostTreatmentPhotos,
        'required_post_treatment_photo_count': requiredPostTreatmentPhotoCount,
        'pre_notifications': preNotifications?.map((e) => e.toJson()).toList(),
        'post_notifications': postNotifications?.map((e) => e.toJson()).toList(),
        'downtime_level': downtimeLevel,
        'downtime_days': downtimeDays,
        'allowed_roles': allowedRoles,
        'total_sessions': totalSessions,
        'sessions': sessions?.map((e) => e.toJson()).toList(),
        'pre_treatment_consent_form': preTreatmentConsentForm?.toJson(),
        'enable_by_default': enableByDefault,
        'use_in_ai_simulator': useInAiSimulator,
        'created_at': createdAt,
        'updated_at': updatedAt,
      };

  TreatmentModel toTreatmentModel() {
    final Map<String, double> mappedUnitPrices = {};
    if (unitPriceOverrides != null) {
      for (final override in unitPriceOverrides!) {
        if (override.role != null && override.price != null) {
          mappedUnitPrices[override.role!] = override.price!;
        }
      }
    }

    return TreatmentModel(
      id: id,
      globalSku: globalSku,
      name: patientDisplayName, // UI maps this to display name or name
      patientDisplayName: patientDisplayName,
      description: description,
      shortDescription: shortDescription,
      categoryId: selectedCategoryIds?.isNotEmpty == true ? selectedCategoryIds!.first.toString() : null,
      icon: icon,
      image: image,
      basePrice: basePrice,
      unitPrices: mappedUnitPrices,
      status: (status ?? 'active').toLowerCase(),
      useInAiSimulator: useInAiSimulator ?? false,
      enableByDefault: enableByDefault ?? false,
      baseDurationHours: baseDuration != null ? baseDuration! ~/ 60 : 0,
      baseDurationMinutes: baseDuration != null ? baseDuration! % 60 : 0,
      preTreatmentInstructions: preTreatmentInstructions,
      postTreatmentInstructions: postTreatmentInstructions,
      prepTime: prepTime ?? 0,
      cleanupTime: cleanupTime ?? 0,
      allowClinicOverride: allowClinicOverride ?? false,
      allowProviderOverride: allowProviderOverride ?? false,
      onlineBookable: onlineBookable ?? true,
      manualApprovalRequired: manualApprovalRequired ?? false,
      minimumBookingNotice: minimumBookingNotice ?? 24,
      maximumDaysInAdvance: maximumDaysInAdvance ?? 90,
      preNotifications: preNotifications?.map((n) => NotificationConfig(
            title: n.title,
            message: n.message,
            timing: n.timing,
            timingUnit: n.timingUnit,
            type: n.type,
          )).toList() ?? const [],
      postNotifications: postNotifications?.map((n) => NotificationConfig(
            title: n.title,
            message: n.message,
            timing: n.timing,
            timingUnit: n.timingUnit,
            type: n.type,
          )).toList() ?? const [],
      totalSessions: totalSessions ?? 1,
      sessions: sessions?.map((s) => SessionConfig(
            sessionNumber: s.sessionNumber ?? 1,
            followUps: s.followUps?.map((fu) => FollowUpConfig(
                  type: fu.type ?? 'virtual',
                  durationValue: fu.durationValue,
                  durationUnit: fu.durationUnit ?? 'minutes',
                  notes: fu.notes,
                  intervalValue: fu.intervalValue,
                  intervalUnit: fu.intervalUnit ?? 'days',
                  isImageRequired: fu.isImageRequired ?? false,
                )).toList() ?? const [],
          )).toList(),
      downtimeLevel: (() {
        if (downtimeLevel == null) return 'None';
        final l = downtimeLevel!.toLowerCase();
        if (l == 'none') return 'None';
        if (l == 'low') return 'Low';
        if (l == 'moderate') return 'Moderate';
        if (l == 'high') return 'High';
        return 'None';
      })(),
      allowedRoles: allowedRoles ?? const [],
      preTreatmentAttachments: preTreatmentAttachments,
      postTreatmentAttachments: postTreatmentAttachments,
      preTreatmentConsentForm: preTreatmentConsentForm != null 
          ? Attachment(url: preTreatmentConsentForm!.url ?? '', type: 'pdf', name: preTreatmentConsentForm!.name ?? '') 
          : null,
      productUsages: productUsages?.map((u) => ProductUsageModel(
            productId: u.productId ?? 0,
            productName: u.productName ?? '',
            usageType: u.usageType ?? 'Required',
            minQuantity: u.minQuantity,
            maxQuantity: u.maxQuantity,
            deductionTiming: u.deductionTiming ?? 'On_Completion',
            allowSubstitution: u.allowSubstitution ?? false,
            notes: u.notes,
            unit: u.unit ?? 'Units',
            perUnitDuration: u.perUnitDuration,
          )).toList(),
      requirePostTreatmentPhotos: requirePostTreatmentPhotos ?? false,
      requiredPostTreatmentPhotoCount: requiredPostTreatmentPhotoCount ?? 0,
    );
  }
}

class TreatmentClinicalProtocolPdf {
  final int? id;
  final String? name;
  final String? url;

  TreatmentClinicalProtocolPdf({this.id, this.name, this.url});

  factory TreatmentClinicalProtocolPdf.fromJson(Map<String, dynamic> json) => TreatmentClinicalProtocolPdf(
        id: json['id'] as int?,
        name: json['name'] as String?,
        url: json['url'] as String?,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'url': url,
      };
}

class TreatmentNotification {
  final String? title;
  final String? message;
  final int? timing;
  final String? timingUnit;
  final String? type;

  TreatmentNotification({
    this.title,
    this.message,
    this.timing,
    this.timingUnit,
    this.type,
  });

  factory TreatmentNotification.fromJson(Map<String, dynamic> json) => TreatmentNotification(
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

class TreatmentSession {
  final int? sessionNumber;
  final List<TreatmentFollowUp>? followUps;

  TreatmentSession({this.sessionNumber, this.followUps});

  factory TreatmentSession.fromJson(Map<String, dynamic> json) => TreatmentSession(
        sessionNumber: json['session_number'] as int?,
        followUps: json['follow_ups'] != null
            ? (json['follow_ups'] as List)
                .map((e) => TreatmentFollowUp.fromJson(e as Map<String, dynamic>))
                .toList()
            : null,
      );

  Map<String, dynamic> toJson() => {
        'session_number': sessionNumber,
        'follow_ups': followUps?.map((e) => e.toJson()).toList(),
      };
}

class TreatmentFollowUp {
  final String? type;
  final int? durationValue;
  final String? durationUnit;
  final String? notes;
  final int? intervalValue;
  final String? intervalUnit;
  final bool? isImageRequired;

  TreatmentFollowUp({
    this.type,
    this.durationValue,
    this.durationUnit,
    this.notes,
    this.intervalValue,
    this.intervalUnit,
    this.isImageRequired,
  });

  factory TreatmentFollowUp.fromJson(Map<String, dynamic> json) => TreatmentFollowUp(
        type: json['type'] as String?,
        durationValue: json['duration_value'] as int?,
        durationUnit: json['duration_unit'] as String?,
        notes: json['notes'] as String?,
        intervalValue: json['interval_value'] as int?,
        intervalUnit: json['interval_unit'] as String?,
        isImageRequired: json['is_image_required'] as bool?,
      );

  Map<String, dynamic> toJson() => {
        'type': type,
        'duration_value': durationValue,
        'duration_unit': durationUnit,
        'notes': notes,
        'interval_value': intervalValue,
        'interval_unit': intervalUnit,
        'is_image_required': isImageRequired,
      };
}

class TreatmentProductUsage {
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

  TreatmentProductUsage({
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

  factory TreatmentProductUsage.fromJson(Map<String, dynamic> json) => TreatmentProductUsage(
        productId: json['product_id'] as int?,
        productName: json['product_name'] as String?,
        usageType: json['usage_type'] as String?,
        minQuantity: (json['min_quantity'] as num?)?.toDouble(),
        maxQuantity: (json['max_quantity'] as num?)?.toDouble(),
        deductionTiming: json['deduction_timing'] as String?,
        allowSubstitution: json['allow_substitution'] as bool?,
        notes: json['notes'] as String?,
        unit: json['unit'] as String?,
        perUnitDuration: (json['per_unit_duration'] as num?)?.toDouble(),
      );

  Map<String, dynamic> toJson() => {
        'product_id': productId,
        'product_name': productName,
        'usage_type': usageType,
        'min_quantity': minQuantity,
        'max_quantity': maxQuantity,
        'deduction_timing': deductionTiming,
        'allow_substitution': allowSubstitution,
        'notes': notes,
        'unit': unit,
        'per_unit_duration': perUnitDuration,
      };
}

class TreatmentProductDuration {
  final int? productId;
  final String? productName;
  final int? duration;

  TreatmentProductDuration({this.productId, this.productName, this.duration});

  factory TreatmentProductDuration.fromJson(Map<String, dynamic> json) => TreatmentProductDuration(
        productId: json['product_id'] as int?,
        productName: json['product_name'] as String?,
        duration: json['duration'] as int?,
      );

  Map<String, dynamic> toJson() => {
        'product_id': productId,
        'product_name': productName,
        'duration': duration,
      };
}

class TreatmentUnitPriceOverride {
  final String? role;
  final double? price;

  TreatmentUnitPriceOverride({this.role, this.price});

  factory TreatmentUnitPriceOverride.fromJson(Map<String, dynamic> json) => TreatmentUnitPriceOverride(
        role: json['role'] as String?,
        price: (json['price'] as num?)?.toDouble(),
      );

  Map<String, dynamic> toJson() => {
        'role': role,
        'price': price,
      };
}

class TreatmentConsentForm {
  final int? id;
  final String? name;
  final String? url;

  TreatmentConsentForm({this.id, this.name, this.url});

  factory TreatmentConsentForm.fromJson(Map<String, dynamic> json) => TreatmentConsentForm(
        id: json['id'] as int?,
        name: json['name'] as String?,
        url: json['url'] as String?,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'url': url,
      };
}
