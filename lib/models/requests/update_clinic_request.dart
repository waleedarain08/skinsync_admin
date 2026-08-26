
class UpdateClinicRequest {
  final int? clinicId;
  final String? clinicName;
  final String? clinicEmail;
  final String? clinicPhone;
  final String? cc;
  final String? country;
  final String? clinicAddress;
  final String? clinicLogo;
  final double? clinicLatitude;
  final double? clinicLongitude;
  final String? website;
  final String? description;
  final String? banner;

  UpdateClinicRequest({
    this.clinicId,
    this.clinicName,
    this.clinicEmail,
    this.clinicPhone,
    this.cc,
    this.country,
    this.clinicAddress,
    this.clinicLogo,
    this.clinicLatitude,
    this.clinicLongitude,
    this.website,
    this.description,
    this.banner,
  });

  factory UpdateClinicRequest.fromJson(Map<String, dynamic> json) {
    return UpdateClinicRequest(
      clinicId: json['clinic_id'],
      clinicName: json['clinic_name'],
      clinicEmail: json['clinic_email'],
      clinicPhone: json['clinic_phone'],
      cc: json['cc'],
      country: json['country'],
      clinicAddress: json['clinic_address'],
      clinicLogo: json['clinic_logo'],
      clinicLatitude: (json['clinic_latitude'] as num?)?.toDouble(),
      clinicLongitude: (json['clinic_longitude'] as num?)?.toDouble(),
      website: json['website'],
      description: json['description'],
      banner: json['banner'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'clinic_id': clinicId,
      'clinic_name': clinicName,
      'clinic_email': clinicEmail,
      'clinic_phone': clinicPhone,
      'cc': cc,
      'country': country,
      'clinic_address': clinicAddress,
      'clinic_logo': clinicLogo,
      'clinic_latitude': clinicLatitude,
      'clinic_longitude': clinicLongitude,
      'website': website,
      'description': description,
      'banner': banner,
    };
  }
}

