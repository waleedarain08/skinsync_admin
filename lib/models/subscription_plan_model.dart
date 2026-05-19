class SubscriptionPlanModel {
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
  bool isActive;

  SubscriptionPlanModel({
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
    this.isActive = true,
  });

  factory SubscriptionPlanModel.fromJson(Map<String, dynamic> json) {
    return SubscriptionPlanModel(
      id: json['id'],
      name: json['name'],
      basePrice: json['base_price']?.toDouble(),
      doctorSeats: json['doctor_seats'] ?? 0,
      unlimitedDoctors: json['unlimited_doctors'] ?? false,
      staffSeats: json['staff_seats'] ?? 0,
      unlimitedStaff: json['unlimited_staff'] ?? false,
      standardBookingCommissionPercent: json['standard_booking_commission_percent']?.toDouble() ?? 0.0,
      dynamicBookingCommissionPercent: json['dynamic_booking_commission_percent']?.toDouble() ?? 0.0,
      technologyFeePerTreatment: json['technology_fee_per_treatment']?.toDouble() ?? 0.0,
      isActive: json['is_active'] ?? true,
      benefits: json['benefits'] != null
          ? (json['benefits'] as List).map((e) => PlanBenefit.fromJson(e)).toList()
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
      'benefits': benefits?.map((e) => e.toJson()).toList(),
    };
  }
}

class PlanBenefit {
  String? title;
  String? description;
  int? freeMonths; 
  bool enabled;

  PlanBenefit({this.title, this.description, this.freeMonths, this.enabled = true});

  factory PlanBenefit.fromJson(Map<String, dynamic> json) {
    return PlanBenefit(
      title: json['title'],
      description: json['description'],
      freeMonths: json['free_months'],
      enabled: json['enabled'] ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'free_months': freeMonths,
      'enabled': enabled,
    };
  }
}
