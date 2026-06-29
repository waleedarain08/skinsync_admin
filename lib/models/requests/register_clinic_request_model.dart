class RegisterClinicReqModel {
  final String clinicName;
  final String clinicEmail;
  final String clinicPhone;
  final String cc;
  final String country;
  final String clinicAddress;
  final String clinicLogo;
  final String? ownerName;
  final String? ownerEmail;
  final double? lat;
  final double? long;
  final String website;
  final String description;
  final num? consultationFee;
  final num? initialDeposit;
  final List<AvailabilityModel> availability;
  final String? bannerImage;

  RegisterClinicReqModel({
    required this.clinicName,
    required this.clinicEmail,
    required this.clinicPhone,
    required this.cc,
    required this.country,
    required this.clinicAddress,
    required this.clinicLogo,
    this.ownerName,
    this.ownerEmail,
    this.lat,
    this.long,
    required this.website,
    required this.description,
    this.consultationFee,
    this.initialDeposit,
    this.availability = const [],
    this.bannerImage,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['clinic_name'] = clinicName;
    data['clinic_email'] = clinicEmail;
    data['cc'] = cc;
    data['country'] = country;
    data['clinic_phone'] = clinicPhone;
    data['clinic_address'] = clinicAddress;
    data['clinic_logo'] = clinicLogo;
    data['owner_name'] = ownerName;
    data['owner_email'] = ownerEmail;
    data['clinic_latitude'] = lat;
    data['clinic_longitude'] = long;
    data['website'] = website;
    data['description'] = description;
    data['consultation_fee'] = consultationFee;
    data['initial_deposit'] = initialDeposit;
    data['banner'] = bannerImage;
    data['availability'] = availability.map((v) => v.toJson()).toList();
    return data;
  }

  RegisterClinicReqModel copyWithLogo(String? clinicLogo, String? bannerImage) {
    return RegisterClinicReqModel(
      clinicName: clinicName,
      clinicEmail: clinicEmail,
      clinicPhone: clinicPhone,
      cc: cc,
      country: country,
      clinicAddress: clinicAddress,
      clinicLogo: clinicLogo ?? this.clinicLogo,
      ownerName: ownerName,
      ownerEmail: ownerEmail,
      lat: lat,
      long: long,
      website: website,
      description: description,
      consultationFee: consultationFee,
      initialDeposit: initialDeposit,
      availability: availability,
      bannerImage: bannerImage
    );
  }
}

class AvailabilityModel {
  String? openTime;
  String? closeTime;
  List<String>? days;

  AvailabilityModel({this.openTime, this.closeTime, this.days});

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['open_time'] = openTime;
    data['close_time'] = closeTime;
    data['days'] = days;
    return data;
  }
}
