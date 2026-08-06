import 'dart:convert';
import 'responses/invite_clinic_detail_response.dart';

class ClinicWebRequestModel {
  final int? id;
  // List fields
  final String? clinicName; // clinic_name in list
  final String? ownerEmail; // owner_email in list
  final String? contactName; // contact_name in list
  final String? contactNumber; // contact_number in list
  final String? clinicLocation; // clinic_location in list
  final String? status;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  // Detail specific fields
  final String? clinicOrPracticeName;
  final String? clinicType;
  final String? clinicWebsite;
  final String? primaryClinicAddress;
  final String? numberOfLocations;
  final String? firstAndLastName;
  final String? professionalTitle;
  final String? businessEmailAddress;
  final String? phoneNumber;
  final String? approximateNumberOfProviders;
  final String? approximateMonthlyPatientVolume;
  final String? currentSchedulingEhrCrmOrPracticeManagementSoftware;
  final List<String>? skinsyncAiCapabilities;
  final String? howDidYouHearAboutSkinsyncAi;
  final bool? authorizedToCreateAccount;
  final bool? agreeToTermsOfServiceAndPrivacyPolicy;

  ClinicWebRequestModel({
    this.id,
    this.clinicName,
    this.ownerEmail,
    this.contactName,
    this.contactNumber,
    this.clinicLocation,
    this.status,
    this.createdAt,
    this.updatedAt,
    this.clinicOrPracticeName,
    this.clinicType,
    this.clinicWebsite,
    this.primaryClinicAddress,
    this.numberOfLocations,
    this.firstAndLastName,
    this.professionalTitle,
    this.businessEmailAddress,
    this.phoneNumber,
    this.approximateNumberOfProviders,
    this.approximateMonthlyPatientVolume,
    this.currentSchedulingEhrCrmOrPracticeManagementSoftware,
    this.skinsyncAiCapabilities,
    this.howDidYouHearAboutSkinsyncAi,
    this.authorizedToCreateAccount,
    this.agreeToTermsOfServiceAndPrivacyPolicy,
  });

  factory ClinicWebRequestModel.fromRawJson(String str) =>
      ClinicWebRequestModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ClinicWebRequestModel.fromJson(Map<String, dynamic> json) => ClinicWebRequestModel(
    id: json['id'],
    // List mappings
    clinicName: json['clinic_name'],
    ownerEmail: json['owner_email'],
    contactName: json['contact_name'],
    contactNumber: json['contact_number'],
    clinicLocation: json['clinic_location'],
    status: json['status'],
    createdAt: json['created_at'] == null ? null : DateTime.parse(json['created_at']),
    updatedAt: json['updated_at'] == null ? null : DateTime.parse(json['updated_at']),

    // Detail mappings
    clinicOrPracticeName: json['clinic_or_practice_name'],
    clinicType: json['clinic_type'],
    clinicWebsite: json['clinic_website'],
    primaryClinicAddress: json['primary_clinic_address'],
    numberOfLocations: json['number_of_locations']?.toString(),
    firstAndLastName: json['first_and_last_name'],
    professionalTitle: json['professional_title'],
    businessEmailAddress: json['business_email_address'],
    phoneNumber: json['phone_number'],
    approximateNumberOfProviders: json['approximate_number_of_providers']?.toString(),
    approximateMonthlyPatientVolume: json['approximate_monthly_patient_volume']?.toString(),
    currentSchedulingEhrCrmOrPracticeManagementSoftware: json['current_scheduling_ehr_crm_or_practice_management_software'],
    skinsyncAiCapabilities: json['skinsync_ai_capabilities'] != null 
        ? List<String>.from(json['skinsync_ai_capabilities']) 
        : null,
    howDidYouHearAboutSkinsyncAi: json['how_did_you_hear_about_skinsync_ai'],
    authorizedToCreateAccount: json['authorized_to_create_account'],
    agreeToTermsOfServiceAndPrivacyPolicy: json['agree_to_terms_of_service_and_privacy_policy'],
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'clinic_name': clinicName,
    'owner_email': ownerEmail,
    'contact_name': contactName,
    'contact_number': contactNumber,
    'clinic_location': clinicLocation,
    'status': status,
    'created_at': createdAt?.toIso8601String(),
    'updated_at': updatedAt?.toIso8601String(),
    'clinic_or_practice_name': clinicOrPracticeName,
    'clinic_type': clinicType,
    'clinic_website': clinicWebsite,
    'primary_clinic_address': primaryClinicAddress,
    'number_of_locations': numberOfLocations,
    'first_and_last_name': firstAndLastName,
    'professional_title': professionalTitle,
    'business_email_address': businessEmailAddress,
    'phone_number': phoneNumber,
    'approximate_number_of_providers': approximateNumberOfProviders,
    'approximate_monthly_patient_volume': approximateMonthlyPatientVolume,
    'current_scheduling_ehr_crm_or_practice_management_software': currentSchedulingEhrCrmOrPracticeManagementSoftware,
    'skinsync_ai_capabilities': skinsyncAiCapabilities,
    'how_did_you_hear_about_skinsync_ai': howDidYouHearAboutSkinsyncAi,
    'authorized_to_create_account': authorizedToCreateAccount,
    'agree_to_terms_of_service_and_privacy_policy': agreeToTermsOfServiceAndPrivacyPolicy,
  };

  InviteClinicDetailData toInviteClinicDetail() {
    return InviteClinicDetailData(
      clinicId: id,
      name: clinicOrPracticeName ?? clinicName,
      email: businessEmailAddress ?? ownerEmail,
      phone: phoneNumber ?? contactNumber,
      address: primaryClinicAddress ?? clinicLocation,
      ownerName: firstAndLastName ?? contactName,
      website: clinicWebsite,
      status: status,
    );
  }
}
