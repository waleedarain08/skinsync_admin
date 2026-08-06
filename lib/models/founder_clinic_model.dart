import 'dart:convert';

class FounderClinicModel {
  final int? id;
  final String? clinicName;
  final String? contactName;
  final String? email;
  final String? phone;
  final String? address;
  final String? city;
  final String? state;
  final String? zipCode;
  final String? website;
  final String? currentEmr;
  final String? numberOfProviders;
  final String? specialty;
  final String? instagramHandle;
  final String? facebookPage;
  final String? founderReason;
  final String? status; // Pending, Approved, Rejected
  final DateTime? createdAt;

  FounderClinicModel({
    this.id,
    this.clinicName,
    this.contactName,
    this.email,
    this.phone,
    this.address,
    this.city,
    this.state,
    this.zipCode,
    this.website,
    this.currentEmr,
    this.numberOfProviders,
    this.specialty,
    this.instagramHandle,
    this.facebookPage,
    this.founderReason,
    this.status,
    this.createdAt,
  });

  factory FounderClinicModel.fromRawJson(String str) =>
      FounderClinicModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory FounderClinicModel.fromJson(Map<String, dynamic> json) => FounderClinicModel(
    id: json['id'],
    clinicName: json['clinic_name'],
    contactName: json['contact_name'],
    email: json['email'],
    phone: json['phone'],
    address: json['address'],
    city: json['city'],
    state: json['state'],
    zipCode: json['zip_code'],
    website: json['website'],
    currentEmr: json['current_emr'],
    numberOfProviders: json['number_of_providers']?.toString(),
    specialty: json['specialty'],
    instagramHandle: json['instagram_handle'],
    facebookPage: json['facebook_page'],
    founderReason: json['founder_reason'],
    status: json['status'],
    createdAt: json['created_at'] == null
        ? null
        : DateTime.parse(json['created_at']),
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'clinic_name': clinicName,
    'contact_name': contactName,
    'email': email,
    'phone': phone,
    'address': address,
    'city': city,
    'state': state,
    'zip_code': zipCode,
    'website': website,
    'current_emr': currentEmr,
    'number_of_providers': numberOfProviders,
    'specialty': specialty,
    'instagram_handle': instagramHandle,
    'facebook_page': facebookPage,
    'founder_reason': founderReason,
    'status': status,
    'created_at': createdAt?.toIso8601String(),
  };
}
