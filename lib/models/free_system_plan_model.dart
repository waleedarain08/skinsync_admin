import 'subscription_plan_model.dart';

class FreeSystemPlanModel {
  int? id;
  String name;
  int durationMonths;
  int doctorSeats;
  bool unlimitedDoctors;
  int staffSeats;
  bool unlimitedStaff;
  double standardBookingCommissionPercent;
  double dynamicBookingCommissionPercent;
  double technologyFeePerTreatment;
  List<PlanBenefit>? benefits;

  FreeSystemPlanModel({
    this.id,
    this.name = 'Free System Plan',
    this.durationMonths = 2,
    this.doctorSeats = 0,
    this.unlimitedDoctors = false,
    this.staffSeats = 0,
    this.unlimitedStaff = false,
    this.standardBookingCommissionPercent = 0.0,
    this.dynamicBookingCommissionPercent = 0.0,
    this.technologyFeePerTreatment = 0.0,
    this.benefits,
  });

  factory FreeSystemPlanModel.fromJson(Map<String, dynamic> json) {
    return FreeSystemPlanModel(
      id: json['id'],
      name: json['name'] ?? 'Free System Plan',
      durationMonths: json['duration_months'] ?? 2,
      doctorSeats: json['doctor_seats'] ?? 0,
      unlimitedDoctors: json['unlimited_doctors'] ?? false,
      staffSeats: json['staff_seats'] ?? 0,
      unlimitedStaff: json['unlimited_staff'] ?? false,
      standardBookingCommissionPercent: json['standard_booking_commission_percent']?.toDouble() ?? 0.0,
      dynamicBookingCommissionPercent: json['dynamic_booking_commission_percent']?.toDouble() ?? 0.0,
      technologyFeePerTreatment: json['technology_fee_per_treatment']?.toDouble() ?? 0.0,
      benefits: json['benefits'] != null
          ? (json['benefits'] as List).map((e) => PlanBenefit.fromJson(e)).toList()
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'duration_months': durationMonths,
      'doctor_seats': doctorSeats,
      'unlimited_doctors': unlimitedDoctors,
      'staff_seats': staffSeats,
      'unlimited_staff': unlimitedStaff,
      'standard_booking_commission_percent': standardBookingCommissionPercent,
      'dynamic_booking_commission_percent': dynamicBookingCommissionPercent,
      'technology_fee_per_treatment': technologyFeePerTreatment,
      'benefits': benefits?.map((e) => e.toJson()).toList(),
      'is_system_plan': true, // Still useful for backend identification
    };
  }
}
