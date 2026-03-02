class ClinicModel {
  int? id;
  String? name;
  String? email;
  String? phone;
  String? address;
  String? logo;
  String? status;

  ClinicModel({
    this.id,
    this.name,
    this.email,
    this.phone,
    this.address,
    this.logo,
    this.status,
  });

  ClinicModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    email = json['email'];
    phone = json['owner_email'];
    address = json['owner_password'];
    logo = json['logo'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['email'] = email;
    data['owner_email'] = phone;
    data['owner_password'] = address;
    data['logo'] = logo;
    data['status'] = status;
    return data;
  }
}
