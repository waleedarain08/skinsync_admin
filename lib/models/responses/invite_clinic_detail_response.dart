import 'dart:convert';

class InviteClinicDetailResponse {
  final bool? isSuccess;
  final String? message;
  final List<InviteClinicDetailData>? data;

  InviteClinicDetailResponse({
    this.isSuccess,
    this.message,
    this.data,
  });

  factory InviteClinicDetailResponse.fromRawJson(String str) =>
      InviteClinicDetailResponse.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory InviteClinicDetailResponse.fromJson(Map<String, dynamic> json) => InviteClinicDetailResponse(
    isSuccess: json['is_success'],
    message: json['message'],
    data: json['data'] == null
        ? null
        : List<InviteClinicDetailData>.from(json['data'].map((x) => InviteClinicDetailData.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    'is_success': isSuccess,
    'message': message,
    'data': data == null ? null : List<dynamic>.from(data!.map((x) => x.toJson())),
  };
}

class InviteClinicDetailData {
  final int? clinicId;
  final String? name;
  final String? email;
  final String? phone;
  final String? address;
  final double? latitude;
  final double? longitude;
  final String? logo;
  final String? description;
  final String? website;
  final String? banner;
  final String? status;
  final List<InviteClinicAvailability>? availability;
  final List<dynamic>? treatments;
  final String? ownerName;
  final String? ownerEmail;
  final String? notes;
  final DateTime? createdAt;

  String get lat => latitude != null ? latitude.toString() : '';
  String get long => longitude != null ? longitude.toString() : '';

  InviteClinicDetailData({
    this.clinicId,
    this.name,
    this.email,
    this.phone,
    this.address,
    this.latitude,
    this.longitude,
    this.logo,
    this.description,
    this.website,
    this.banner,
    this.status,
    this.availability,
    this.treatments,
    this.ownerName,
    this.ownerEmail,
    this.notes, this.createdAt,
  });

  factory InviteClinicDetailData.fromJson(Map<String, dynamic> json) => InviteClinicDetailData(
    clinicId: json['clinic_id'] ?? json['id'],
    name: json['name'],
    email: json['email'],
    phone: json['phone']?.toString(),
    address: json['address'],
    latitude: (json['latitude'] as num?)?.toDouble(),
    longitude: (json['longitude'] as num?)?.toDouble(),
    logo: json['logo'],
    description: json['description'],
    website: json['website'],
    banner: json['banner'],
    status: json['status'],
    availability: json['availability'] == null
        ? null
        : List<InviteClinicAvailability>.from(json['availability'].map((x) => InviteClinicAvailability.fromJson(x))),
    treatments: json['treatments'] == null
        ? null
        : List<dynamic>.from(json['treatments']),
    ownerName: json['owner_name'],
    ownerEmail: json['owner_email'],
    notes: json['notes'],
    createdAt: json['created_at'] == null ? null : DateTime.parse(json['created_at']),
  );

  Map<String, dynamic> toJson() => {
    'clinic_id': clinicId,
    'name': name,
    'email': email,
    'phone': phone,
    'address': address,
    'latitude': latitude,
    'longitude': longitude,
    'logo': logo,
    'description': description,
    'website': website,
    'banner': banner,
    'status': status,
    'availability': availability == null ? null : List<dynamic>.from(availability!.map((x) => x.toJson())),
    'treatments': treatments == null ? null : List<dynamic>.from(treatments!),
    'owner_name': ownerName,
    'owner_email': ownerEmail,
    'notes': notes,
  };
}

class InviteClinicAvailability {
  final String? openTime;
  final String? closeTime;
  final List<String>? days;

  InviteClinicAvailability({
    this.openTime,
    this.closeTime,
    this.days,
  });

  factory InviteClinicAvailability.fromJson(Map<String, dynamic> json) => InviteClinicAvailability(
    openTime: json['open_time'],
    closeTime: json['close_time'],
    days: json['days'] == null ? null : List<String>.from(json['days'].map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    'open_time': openTime,
    'close_time': closeTime,
    'days': days == null ? null : List<dynamic>.from(days!.map((x) => x)),
  };
}
