class ClinicModel {
  int? id;
  String? name;
  String? email;
  String? phone;
  String? address;
  String? logo;
  String? status;
  String? createdAt;
  String? updatedAt;

  ClinicModel({
    this.id,
    this.name,
    this.email,
    this.phone,
    this.address,
    this.logo,
    this.status,
    this.createdAt,
    this.updatedAt,
  });

  ClinicModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    email = json['email'];
    phone = json['phone'];
    address = json['address'];
    logo = json['logo'];
    status = json['status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['email'] = email;
    data['phone'] = phone;
    data['address'] = address;
    data['logo'] = logo;
    data['status'] = status;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}
