import 'dart:convert';
import 'package:skinsync_admin/models/clinic_model.dart';

class ClinicDetailResponse {
  ClinicModel get toClinicModel {
    return ClinicModel(
      id: id,
      name: name,
      email: email,
      phone: phone,
      address: address,
      logo: logo,
      status: status,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }

  final int? id;
  final String? name;
  final String? email;
  final String? phone;
  final String? address;
  final String? logo;
  final String? description;
  final String? workingHours;
  final String? status;
  final String? subscriptionPlan;
  final int? totalTreatments;
  final int? totalAppointments;
  final double? totalRevenue;
  final double? rating;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  // Additional fields for Prospect/Invite Clinics
  final String? notes;
  final String? lat;
  final String? long;
  final String? ownerName;
  final String? ownerEmail;
  final String? website;

  String get invitationStatus => status ?? 'onboarding_pending';
  int get interestedPatientsCount => 12;
  int get pendingAppointmentsCount => 5;
  String get invitedDate => createdAt != null ? createdAt!.toIso8601String().split('T')[0] : '';

  ClinicDetailResponse({
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
    this.notes,
    this.lat,
    this.long,
    this.ownerName,
    this.ownerEmail,
    this.website,
  });

  factory ClinicDetailResponse.fromRawJson(String str) =>
      ClinicDetailResponse.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ClinicDetailResponse.fromJson(Map<String, dynamic> json) => ClinicDetailResponse(
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
    totalRevenue: (json['total_revenue'] as num?)?.toDouble(),
    rating: (json['rating'] as num?)?.toDouble(),
    createdAt: json['created_at'] == null
        ? null
        : DateTime.parse(json['created_at']),
    updatedAt: json['updated_at'] == null
        ? null
        : DateTime.parse(json['updated_at']),
    notes: json['notes'],
    lat: json['lat'],
    long: json['long'],
    ownerName: json['owner_name'],
    ownerEmail: json['owner_email'],
    website: json['website'],
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'email': email,
    'phone': phone,
    'address': address,
    'logo': logo,
    'description': description,
    'working_hours': workingHours,
    'status': status,
    'subscription_plan': subscriptionPlan,
    'total_treatments': totalTreatments,
    'total_appointments': totalAppointments,
    'total_revenue': totalRevenue,
    'rating': rating,
    'created_at': createdAt?.toIso8601String(),
    'updated_at': updatedAt?.toIso8601String(),
    'notes': notes,
    'lat': lat,
    'long': long,
    'owner_name': ownerName,
    'owner_email': ownerEmail,
    'website': website,
  };
}
