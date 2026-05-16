class InviteClinicModel {
  final int id;
  final String name;
  final String? logo;
  final String address;
  final String email;
  final String phone;
  final String invitationStatus; // Not Invited, Invitation Sent, Awaiting Response, Interested, Pending Onboarding, Expired
  final int interestedPatientsCount;
  final int pendingAppointmentsCount;
  final String invitedDate;
  final String? notes;

  InviteClinicModel({
    required this.id,
    required this.name,
    this.logo,
    required this.address,
    required this.email,
    required this.phone,
    required this.invitationStatus,
    required this.interestedPatientsCount,
    required this.pendingAppointmentsCount,
    required this.invitedDate,
    this.notes,
  });

  factory InviteClinicModel.fromJson(Map<String, dynamic> json) {
    return InviteClinicModel(
      id: json['id'],
      name: json['name'],
      logo: json['logo'],
      address: json['address'],
      email: json['email'],
      phone: json['phone'],
      invitationStatus: json['invitation_status'],
      interestedPatientsCount: json['interested_patients_count'],
      pendingAppointmentsCount: json['pending_appointments_count'],
      invitedDate: json['invited_date'],
      notes: json['notes'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'logo': logo,
      'address': address,
      'email': email,
      'phone': phone,
      'invitation_status': invitationStatus,
      'interested_patients_count': interestedPatientsCount,
      'pending_appointments_count': pendingAppointmentsCount,
      'invited_date': invitedDate,
      'notes': notes,
    };
  }
}
