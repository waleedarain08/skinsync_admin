class RegisterClinicReqModel {
  String? clinicName;
  String? clinicEmail;
  String? clinicPhone;
  String? clinicAddress;
  String? clinicLogo;
  String? ownerName;
  String? ownerEmail;

  RegisterClinicReqModel({
    this.clinicName,
    this.clinicEmail,
    this.clinicPhone,
    this.clinicAddress,
    this.clinicLogo = "https://example.com/logo.png",
    this.ownerName,
    this.ownerEmail,
  });

  // RegisterClinicReqModel.fromJson(Map<String, dynamic> json) {
  //   clinicName = json['clinic_name'];
  //   clinicEmail = json['clinic_email'];
  //   clinicPhone = json['clinic_phone'];
  //   clinicAddress = json['clinic_address'];
  //   clinicLogo = json['clinic_logo'];
  //   ownerName = json['owner_name'];
  //   ownerEmail = json['owner_email'];
  // }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['clinic_name'] = clinicName;
    data['clinic_email'] = clinicEmail;
    data['clinic_phone'] = clinicPhone;
    data['clinic_address'] = clinicAddress;
    data['clinic_logo'] = clinicLogo;
    data['owner_name'] = ownerName;
    data['owner_email'] = ownerEmail;
    return data;
  }
}
