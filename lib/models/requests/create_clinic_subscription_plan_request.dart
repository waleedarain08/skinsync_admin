import '../clinic_subscription_plan_model.dart';

class CreateClinicSubscriptionPlanRequest {
  final int? id;
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
  final List<String>? assignedClinics;
  final bool isActive;
  final bool isDefault;

  CreateClinicSubscriptionPlanRequest({
    this.id,
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
  });

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'name': name,
      'base_price': basePrice,
      'doctor_seats': doctorSeats,
      'unlimited_doctors': unlimitedDoctors,
      'staff_seats': staffSeats,
      'unlimited_staff': unlimitedStaff,
      'standard_booking_commission_percent': standardBookingCommissionPercent,
      'dynamic_booking_commission_percent': dynamicBookingCommissionPercent,
      'technology_fee_per_treatment': technologyFeePerTreatment,
      'is_active': isActive,
      'is_default': isDefault,
      'benefits': benefits?.map((e) => e.toJson()).toList(),
      'assigned_clinics': assignedClinics,
    };
  }

  factory CreateClinicSubscriptionPlanRequest.fromModel(ClinicSubscriptionPlanModel model) {
    return CreateClinicSubscriptionPlanRequest(
      id: model.id,
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
    );
  }
}
