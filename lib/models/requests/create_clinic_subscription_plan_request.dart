import '../clinic_subscription_plan_model.dart';
import '../duration_option_model.dart';
import '../subscription_plan_benefit_model.dart';

class CreateClinicSubscriptionPlanRequest {
  final String? name;
  final double? basePrice;
  final int doctorSeats;
  final bool unlimitedDoctors;
  final int staffSeats;
  final bool unlimitedStaff;
  final double standardBookingCommissionPercent;
  final double dynamicBookingCommissionPercent;
  final double technologyFeePerTreatment;
  final List<PlanBenefit>? benefits;
  final List<int>? assignedClinics;
  final bool isActive;
  final bool isDefault;
  final bool isLifetime;
  final List<DurationOption>? durationOptions;

  CreateClinicSubscriptionPlanRequest({
    this.name,
    this.basePrice,
    this.doctorSeats = 0,
    this.unlimitedDoctors = false,
    this.staffSeats = 0,
    this.unlimitedStaff = false,
    this.standardBookingCommissionPercent = 0.0,
    this.dynamicBookingCommissionPercent = 0.0,
    this.technologyFeePerTreatment = 0.0,
    this.benefits,
    this.assignedClinics,
    this.isActive = true,
    this.isDefault = false,
    this.isLifetime = false,
    this.durationOptions,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'doctor_seats': doctorSeats,
      'unlimited_doctor': unlimitedDoctors,
      'staff_seats': staffSeats,
      'unlimited_staff': unlimitedStaff,
      'standard_booking_commission_percent': standardBookingCommissionPercent,
      'dynamic_booking_commission_percent': dynamicBookingCommissionPercent,
      'technology_fee_per_treatment': technologyFeePerTreatment,
      'is_active': isActive,
      'is_default': isDefault,
      'is_lifetime': isLifetime,
      'base_price': basePrice ?? 0,
      if (assignedClinics != null) 'assigned_clinics': assignedClinics,
      if (benefits != null)
        'benefit_ids': benefits!.map((e) => e.id).whereType<int>().toList(),
      if (durationOptions != null)
        'duration_options': durationOptions!
            .map(
              (e) => {
                'interval': e.interval?.name,
                'amount': e.amount,
              },
            )
            .toList(),
    };
  }

  factory CreateClinicSubscriptionPlanRequest.fromModel(
    ClinicSubscriptionPlanModel model,
  ) {
    return CreateClinicSubscriptionPlanRequest(
      name: model.name,
      basePrice: model.basePrice,
      doctorSeats: model.doctorSeats,
      unlimitedDoctors: model.unlimitedDoctors,
      staffSeats: model.staffSeats,
      unlimitedStaff: model.unlimitedStaff,
      standardBookingCommissionPercent: model.standardBookingCommissionPercent,
      dynamicBookingCommissionPercent: model.dynamicBookingCommissionPercent,
      technologyFeePerTreatment: model.technologyFeePerTreatment,
      benefits: model.benefits,
      assignedClinics: model.assignedClinics,
      isActive: model.isActive,
      isDefault: model.isDefault,
      isLifetime: model.isLifetime,
      durationOptions: model.durationOptions,
    );
  }
}
