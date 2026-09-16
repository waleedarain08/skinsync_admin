import 'duration_option_model.dart';
import 'subscription_plan_benefit_model.dart';

class ClinicSubscriptionPlanModel {
  String? id;
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
  List<DurationOption>? durationOptions;

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
      id: json['id']?.toString(),
      name: json['name'] as String?,
      basePrice: (json['base_price'] as num?)?.toDouble(),
      doctorSeats: (json['doctor_seats'] ?? 0) as int,
      unlimitedDoctors: (json['unlimited_doctor'] ??
          false) as bool,
      staffSeats: (json['staff_seats']?? 0) as int,
      unlimitedStaff: (json['unlimited_staff'] ?? false) as bool,
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
              .map((e) => DurationOption.fromJson(e as Map<String, dynamic>))
              .toList()
          : null,
      benefits: json['benefits'] != null
          ? (json['benefits'] as List)
              .where((e) => e != null)
              .map((e) => PlanBenefit.fromJson(e as Map<String, dynamic>))
              .toList()
          : null,
      assignedClinics: json['assigned_clinics'] != null
          ? (json['assigned_clinics'] as List)
              .map((e) => (e as num).toInt())
              .toList()
          : json['assigned_patients'] != null
              ? (json['assigned_patients'] as List)
                  .map((e) => (e['clinic_id'] as num).toInt())
                  .toList()
              : null,
    );
  }

  // Map<String, dynamic> toJson() {
  //   return {
  //     'id': id,
  //     'name': name,
  //     'base_price': basePrice,
  //     'doctor_seats': doctorSeats,
  //     'unlimited_doctors': unlimitedDoctors,
  //     'staff_seats': staffSeats,
  //     'unlimited_staff': unlimitedStaff,
  //     'standard_booking_commission_percent': standardBookingCommissionPercent,
  //     'dynamic_booking_commission_percent': dynamicBookingCommissionPercent,
  //     'technology_fee_per_treatment': technologyFeePerTreatment,
  //     'is_active': isActive,
  //     'is_default': isDefault,
  //     'is_lifetime': isLifetime,
  //     'duration_options': durationOptions?.map((e) => e.toJson()).toList(),
  //     'benefits': benefits?.map((e) => e.toJson()).toList(),
  //     'assigned_clinics': assignedClinics,
  //   };
  // }
}
