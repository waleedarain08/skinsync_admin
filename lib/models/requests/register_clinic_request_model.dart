class RegisterClinicReqModel {
  String? clinicName;
  String? clinicEmail;
  String? clinicPhone;
  String? cc;
  String? country;
  String? clinicAddress;
  String? clinicLogo;
  String? ownerName;
  String? ownerEmail;
  String? lat;
  String? long;
  String? website;
  String? description;
  List<AvailabilityModel>? availability;

  RegisterClinicReqModel({
    this.clinicName,
    this.clinicEmail,
    this.clinicPhone,
    this.cc,
    this.country,
    this.clinicAddress,
    this.clinicLogo = 'https://example.com/logo.png',
    this.ownerName,
    this.ownerEmail,
    this.lat,
    this.long,
    this.website,
    this.description,
    this.availability,
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
    data['lat'] = lat;
    data['long'] = long;
    data['website'] = website;
    data['description'] = description;
    if (availability != null) {
      data['availability'] = availability!.map((v) => v.toJson()).toList();
    }
    return data;
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
