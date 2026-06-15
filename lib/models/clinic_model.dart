class ClinicModel {

  ClinicModel({
    this.id,
    this.name,
    this.email,
    this.phone,
    this.address,
    this.logo,
    this.description,
    this.workingHours,
    this.status,
    this.subscriptionPlan,
    this.totalTreatments,
    this.totalAppointments,
    this.totalRevenue,
    this.rating,
    this.createdAt,
    this.updatedAt,
  });
  factory ClinicModel.fromJson(Map<String, dynamic> json) {
    return ClinicModel(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      phone: json['phone'],
      address: json['address'],
      logo: json['logo'],
      description: json['description'],
      workingHours: json['working_hours'],
      status: json['status'],
      subscriptionPlan: json['subscription_plan'],
      totalTreatments: json['total_treatments'],
      totalAppointments: json['total_appointments'],
      totalRevenue: json['total_revenue']?.toDouble(),
      rating: json['rating']?.toDouble(),
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }
  int? id;
  String? name;
  String? email;
  String? phone;
  String? address;
  String? logo;
  String? description;
  String? workingHours;
  String? status; // Active/Inactive
  String? subscriptionPlan;
  int? totalTreatments;
  int? totalAppointments;
  double? totalRevenue;
  double? rating;
  String? createdAt;
  String? updatedAt;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['email'] = email;
    data['phone'] = phone;
    data['address'] = address;
    data['logo'] = logo;
    data['description'] = description;
    data['working_hours'] = workingHours;
    data['status'] = status;
    data['subscription_plan'] = subscriptionPlan;
    data['total_treatments'] = totalTreatments;
    data['total_appointments'] = totalAppointments;
    data['total_revenue'] = totalRevenue;
    data['rating'] = rating;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}
