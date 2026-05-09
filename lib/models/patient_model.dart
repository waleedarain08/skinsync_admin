enum PatientSource { mobileApp, walkIn }

class PatientModel {
  int? id;
  String? name;
  String? email;
  String? phone;
  String? profileImage;
  String? status; // Active/Inactive
  PatientSource? source;
  String? clinicName;
  int? totalAppointments;
  int? treatmentsPurchased;
  String? lastAppointmentDate;
  List<String>? notes;
  List<String>? documents;
  String? registrationDate;

  PatientModel({
    this.id,
    this.name,
    this.email,
    this.phone,
    this.profileImage,
    this.status,
    this.source,
    this.clinicName,
    this.totalAppointments,
    this.treatmentsPurchased,
    this.lastAppointmentDate,
    this.notes,
    this.documents,
    this.registrationDate,
  });

  PatientModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    email = json['email'];
    phone = json['phone'];
    profileImage = json['profile_image'];
    status = json['status'];
    source = json['source'] == 'mobile_app' ? PatientSource.mobileApp : PatientSource.walkIn;
    clinicName = json['clinic_name'];
    totalAppointments = json['total_appointments'];
    treatmentsPurchased = json['treatments_purchased'];
    lastAppointmentDate = json['last_appointment_date'];
    notes = json['notes'] != null ? List<String>.from(json['notes']) : null;
    documents = json['documents'] != null ? List<String>.from(json['documents']) : null;
    registrationDate = json['registration_date'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['email'] = email;
    data['phone'] = phone;
    data['profile_image'] = profileImage;
    data['status'] = status;
    data['source'] = source == PatientSource.mobileApp ? 'mobile_app' : 'walk_in';
    data['clinic_name'] = clinicName;
    data['total_appointments'] = totalAppointments;
    data['treatments_purchased'] = treatmentsPurchased;
    data['last_appointment_date'] = lastAppointmentDate;
    data['notes'] = notes;
    data['documents'] = documents;
    data['registration_date'] = registrationDate;
    return data;
  }
}
