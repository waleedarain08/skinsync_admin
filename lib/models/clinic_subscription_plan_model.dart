import 'subscription_duration_option.dart';
import 'subscription_plan_benefit_model.dart';

class ClinicSubscriptionPlanModel {
  int? id;
  String? name;
  double? basePrice;
  int doctorSeats;
  bool unlimitedDoctors;
  int staffSeats;
  bool unlimitedStaff;
  double standardBookingCommissionPercent;
  double dynamicBookingCommissionPercent;
  double technologyFeePerTreatment;
  List<PlanBenefit>? benefits;
  List<int>? assignedClinics;
  bool isActive;
  bool isDefault;
  bool isLifetime;
  List<SubscriptionDurationOption>? durationOptions;

  ClinicSubscriptionPlanModel({
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
    this.isLifetime = false,
    this.durationOptions,
  });

  factory ClinicSubscriptionPlanModel.fromJson(Map<String, dynamic> json) {
    return ClinicSubscriptionPlanModel(
      id: json['id'],
      name: json['name'],
      basePrice: (json['base_price'] as num?)?.toDouble(),
      doctorSeats: json['doctor_seats'] ?? 0,
      unlimitedDoctors: json['unlimited_doctors'] ?? false,
      staffSeats: json['staff_seats'] ?? 0,
      unlimitedStaff: json['unlimited_staff'] ?? false,
      standardBookingCommissionPercent:
          (json['standard_booking_commission_percent'] as num?)?.toDouble() ??
              0.0,
      dynamicBookingCommissionPercent:
          (json['dynamic_booking_commission_percent'] as num?)?.toDouble() ??
              0.0,
      technologyFeePerTreatment:
          (json['technology_fee_per_treatment'] as num?)?.toDouble() ?? 0.0,
      isActive: (json['is_active'] as bool?) ?? true,
      isDefault: (json['is_default'] as bool?) ?? false,
      isLifetime: (json['is_lifetime'] as bool?) ?? false,
      durationOptions: json['duration_options'] != null
          ? (json['duration_options'] as List)
              .where((e) => e != null)
              .map((e) =>
                  SubscriptionDurationOption.fromJson(e as Map<String, dynamic>))
              .toList()
          : null,
      benefits: json['benefits'] != null
          ? (json['benefits'] as List)
              .where((e) => e != null)
              .map((e) => PlanBenefit.fromJson(e as Map<String, dynamic>))
              .toList()
          : null,
      assignedClinics: json['assigned_clinics'] != null
          ? List<int>.from(
              (json['assigned_clinics'] as Iterable).where((e) => e != null))
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
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
      'is_lifetime': isLifetime,
      'duration_options': durationOptions?.map((e) => e.toJson()).toList(),
      'benefits': benefits?.map((e) => e.toJson()).toList(),
      'assigned_clinics': assignedClinics,
    };
  }
}
