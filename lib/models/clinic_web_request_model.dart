import 'dart:convert';

class ClinicWebRequestModel {
  final int? id;
  final String? clinicName;
  final String? ownerName;
  final String? email;
  final String? phone;
  final String? address;
  final String? website;
  final String? specialty;
  final String? yearsInBusiness;
  final String? instagramHandle;
  final String? facebookPage;
  final String? message;
  final String? status; // Pending, Approved, Rejected
  final DateTime? createdAt;

  ClinicWebRequestModel({
    this.id,
    this.clinicName,
    this.ownerName,
    this.email,
    this.phone,
    this.address,
    this.website,
    this.specialty,
    this.yearsInBusiness,
    this.instagramHandle,
    this.facebookPage,
    this.message,
    this.status,
    this.createdAt,
  });

  factory ClinicWebRequestModel.fromRawJson(String str) =>
      ClinicWebRequestModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ClinicWebRequestModel.fromJson(Map<String, dynamic> json) => ClinicWebRequestModel(
    id: json['id'],
    clinicName: json['clinic_name'],
    ownerName: json['owner_name'],
    email: json['email'],
    phone: json['phone'],
    address: json['address'],
    website: json['website'],
    specialty: json['specialty'],
    yearsInBusiness: json['years_in_business']?.toString(),
    instagramHandle: json['instagram_handle'],
    facebookPage: json['facebook_page'],
    message: json['message'],
    status: json['status'],
    createdAt: json['created_at'] == null
        ? null
        : DateTime.parse(json['created_at']),
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'clinic_name': clinicName,
    'owner_name': ownerName,
    'email': email,
    'phone': phone,
    'address': address,
    'website': website,
    'specialty': specialty,
    'years_in_business': yearsInBusiness,
    'instagram_handle': instagramHandle,
    'facebook_page': facebookPage,
    'message': message,
    'status': status,
    'created_at': createdAt?.toIso8601String(),
  };
}
