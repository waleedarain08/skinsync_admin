import 'package:skinsync_admin/utils/enums.dart';

class TreatmentScheduleRequest {
  final int? baseDuration;
  final int? prepTime;
  final int? cleanupTime;
  final List<ProductDuration>? productDurations;
  final bool? allowClinicOverride;
  final bool? allowProviderOverride;
  final bool? onlineBookable;
  final bool? manualApprovalRequired;
  final int? minimumBookingNotice;
  final int? maximumDaysInAdvance;

  TreatmentScheduleRequest({
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
  });

  Map<String, dynamic> toJson() => {
    'keys': [CreateTreatmentSteps.scheduling.name],
    'base_duration': baseDuration,
    'prep_time': prepTime,
    'cleanup_time': cleanupTime,
    'product_durations': productDurations == null
        ? []
        : List<dynamic>.from(productDurations!.map((x) => x.toJson())),
    'allow_clinic_override': allowClinicOverride,
    'allow_provider_override': allowProviderOverride,
    'online_bookable': onlineBookable,
    'manual_approval_required': manualApprovalRequired,
    'minimum_booking_notice': minimumBookingNotice,
    'maximum_days_in_advance': maximumDaysInAdvance,
  };
}

class ProductDuration {
  final int? productId;
  final double? perUnitDuration;

  ProductDuration({this.productId, this.perUnitDuration});

  Map<String, dynamic> toJson() => {
    'product_id': productId,
    'per_unit_duration': perUnitDuration,
  };
}
