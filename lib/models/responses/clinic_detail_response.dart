import 'dart:convert';

class ClinicDetailResponse {
  final bool? isSuccess;
  final String? message;
  final List<ClinicDetailData>? data;

  ClinicDetailResponse({
    this.isSuccess,
    this.message,
    this.data,
  });

  factory ClinicDetailResponse.fromRawJson(String str) =>
      ClinicDetailResponse.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ClinicDetailResponse.fromJson(Map<String, dynamic> json) => ClinicDetailResponse(
    isSuccess: json['is_success'],
    message: json['message'],
    data: json['data'] == null
        ? null
        : List<ClinicDetailData>.from(json['data'].map((x) => ClinicDetailData.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    'is_success': isSuccess,
    'message': message,
    'data': data == null ? null : List<dynamic>.from(data!.map((x) => x.toJson())),
  };
}

class ClinicDetailData {
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
  final List<ClinicAvailability>? availability;
  final List<dynamic>? treatments;
  final String? cc;
  final String? country;

  ClinicDetailData({
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
    this.cc,
    this.country
  });

  factory ClinicDetailData.fromJson(Map<String, dynamic> json) => ClinicDetailData(
    clinicId: json['clinic_id'],
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
        : List<ClinicAvailability>.from(json['availability'].map((x) => ClinicAvailability.fromJson(x))),
    treatments: json['treatments'] == null
        ? null
        : List<dynamic>.from(json['treatments']),
        country: json['country'],
        cc:json['cc'],
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
  };
}

class ClinicAvailability {
  final String? openTime;
  final String? closeTime;
  final List<String>? days;

  ClinicAvailability({
    this.openTime,
    this.closeTime,
    this.days,
  });

  factory ClinicAvailability.fromJson(Map<String, dynamic> json) => ClinicAvailability(
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
