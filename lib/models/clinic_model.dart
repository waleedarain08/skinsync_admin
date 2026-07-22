import 'dart:convert';

class ClinicModel {
  final int? id;
  final String? name;
  final String? email;
  final String? phone;
  final String? address;
  final String? logo;
  final String? status; // Active/Inactive/onboarding_pending
  final DateTime? createdAt;
  final DateTime? updatedAt;

  String get invitationStatus => status ?? 'onboarding_pending';
  int get interestedPatientsCount => 0;
  int get pendingAppointmentsCount => 0;
  String get invitedDate => createdAt != null ? createdAt!.toIso8601String() : '';
  String get subscriptionPlan => 'Premium';
  int get totalAppointments => 6;
  int get totalTreatments => 2;
  double get rating => 4.8;

  ClinicModel({
    this.id,
    this.name,
    this.email,
    this.phone,
    this.address,
    this.logo,
    this.status,
    this.createdAt,
    this.updatedAt,
  });

  factory ClinicModel.fromRawJson(String str) =>
      ClinicModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ClinicModel.fromJson(Map<String, dynamic> json) => ClinicModel(
    id: json['id'],
    name: json['name'],
    email: json['email'],
    phone: json['phone'],
    address: json['address'],
    logo: json['logo'],
    status: json['status'],
    createdAt: json['created_at'] == null
        ? null
        : DateTime.parse(json['created_at']),
    updatedAt: json['updated_at'] == null
        ? null
        : DateTime.parse(json['updated_at']),
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'email': email,
    'phone': phone,
    'address': address,
    'logo': logo,
    'status': status,
    'created_at': createdAt?.toIso8601String(),
    'updated_at': updatedAt?.toIso8601String(),
  };
}
