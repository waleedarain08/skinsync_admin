class Clinic {
  Clinic({
    this.id,
    this.name,
    this.email,
    this.phone,
    this.address,
    this.logo,
    this.status,
  });

  factory Clinic.fromJson(Map<String, dynamic> json) {
    return Clinic(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      phone: json['phone'],
      address: json['address'],
      logo: json['logo'],
      status: json['status'],
    );
  }
  int? id;
  String? name;
  String? email;
  String? phone;
  String? address;
  String? logo;
  String? status;
}
