class PatientModel {
  final int? id;
  final String name;
  final String email;
  final String phone;
  final String? gender;
  final String? lastVisit;

  PatientModel({
    this.id,
    required this.name,
    required this.email,
    required this.phone,
    this.gender,
    this.lastVisit,
  });

  factory PatientModel.fromJson(Map<String, dynamic> json) {
    return PatientModel(
      id: json['id'],
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
      gender: json['gender'],
      lastVisit: json['lastVisit'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'gender': gender,
      'lastVisit': lastVisit,
    };
  }

  PatientModel copyWith({
    int? id,
    String? name,
    String? email,
    String? phone,
    String? gender,
    String? lastVisit,
  }) {
    return PatientModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      gender: gender ?? this.gender,
      lastVisit: lastVisit ?? this.lastVisit,
    );
  }
}
