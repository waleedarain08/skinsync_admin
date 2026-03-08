class AddProductReqModel {
  String? name;
  String? units;

  AddProductReqModel({this.name, this.units});

  // AddProductReqModel.fromJson(Map<String, dynamic> json) {
  //   name = json['clinic_name'];
  //   units = json['clinic_email'];
  //   clinicPhone = json['clinic_phone'];
  //   clinicAddress = json['clinic_address'];
  //   clinicLogo = json['clinic_logo'];
  //   ownerName = json['owner_name'];
  //   ownerEmail = json['owner_email'];
  // }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['units'] = units;
    return data;
  }
}
