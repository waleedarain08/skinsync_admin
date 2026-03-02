class Clinic {
  int? id;
  String? name;
  String? email;
  String? phone;
  String? address;
  String? logo;
  String? status;

  Clinic({
    this.id,
    this.name,
    this.email,
    this.phone,
    this.address,
    this.logo,
    this.status,
  });

  Clinic.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    email = json['email'];
    phone = json['phone'];
    address = json['address'];
    logo = json['logo'];
    status = json['status'];
  }
}
