import 'dart:convert';

import 'responses/invite_clinic_detail_response.dart';

class FounderClinicModel {
  final int? id;
  // Common / List fields
  final String? clinicName;
  final String? contactName;
  final String? email;
  final String? phone;
  final String? address;
  final String? status;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  // Detail specific fields
  final String? clinicLegalName;
  final String? publicFacingClinicName;
  final String? primaryLocation;
  final String? additionalLocations;
  final String? primaryServiceArea;
  final String? website;
  final String? primaryContactName;
  final String? emailAddress;
  final String? phoneNumber;
  final String? representativeName;
  final String? title;
  final String? electronicSignature;
  final String? signatureDate;
  final bool? authorizedToSubmit;

  // Old fields (retaining for compatibility if needed elsewhere)
  final String? city;
  final String? state;
  final String? zipCode;
  final String? currentEmr;
  final String? numberOfProviders;
  final String? specialty;
  final String? instagramHandle;
  final String? facebookPage;
  final String? founderReason;

  FounderClinicModel({
    this.id,
    this.clinicName,
    this.contactName,
    this.email,
    this.phone,
    this.address,
    this.status,
    this.createdAt,
    this.updatedAt,
    this.clinicLegalName,
    this.publicFacingClinicName,
    this.primaryLocation,
    this.additionalLocations,
    this.primaryServiceArea,
    this.website,
    this.primaryContactName,
    this.emailAddress,
    this.phoneNumber,
    this.representativeName,
    this.title,
    this.electronicSignature,
    this.signatureDate,
    this.authorizedToSubmit,
    this.city,
    this.state,
    this.zipCode,
    this.currentEmr,
    this.numberOfProviders,
    this.specialty,
    this.instagramHandle,
    this.facebookPage,
    this.founderReason,
  });

  factory FounderClinicModel.fromRawJson(String str) =>
      FounderClinicModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory FounderClinicModel.fromJson(Map<String, dynamic> json) =>
      FounderClinicModel(
        id: json['id'],
        // Mapping List keys
        clinicName: json['clinic_name'] ?? json['public_facing_clinic_name'],
        contactName: json['contact_name'] ?? json['primary_contact_name'],
        email: json['owner_email'] ?? json['email_address'] ?? json['email'],
        phone: json['contact_number'] ?? json['phone_number'] ?? json['phone'],
        address: json['clinic_location'] ?? json['primary_location'] ?? json['address'],
        status: json['status'],
        createdAt: json['created_at'] == null ? null : DateTime.parse(json['created_at']),
        updatedAt: json['updated_at'] == null ? null : DateTime.parse(json['updated_at']),

        // Mapping Detail keys
        clinicLegalName: json['clinic_legal_name'],
        publicFacingClinicName: json['public_facing_clinic_name'],
        primaryLocation: json['primary_location'],
        additionalLocations: json['additional_locations'],
        primaryServiceArea: json['primary_service_area'],
        website: json['website'],
        primaryContactName: json['primary_contact_name'],
        emailAddress: json['email_address'],
        phoneNumber: json['phone_number'],
        representativeName: json['representative_name'],
        title: json['title'],
        electronicSignature: json['electronic_signature'],
        signatureDate: json['date'],
        authorizedToSubmit: json['authorized_to_submit'],

        // Old fields
        city: json['city'],
        state: json['state'],
        zipCode: json['zip_code'],
        currentEmr: json['current_emr'],
        numberOfProviders: json['number_of_providers']?.toString(),
        specialty: json['specialty'],
        instagramHandle: json['instagram_handle'],
        facebookPage: json['facebook_page'],
        founderReason: json['founder_reason'],
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'clinic_name': clinicName,
        'contact_name': contactName,
        'owner_email': email,
        'contact_number': phone,
        'clinic_location': address,
        'status': status,
        'created_at': createdAt?.toIso8601String(),
        'updated_at': updatedAt?.toIso8601String(),
        'clinic_legal_name': clinicLegalName,
        'public_facing_clinic_name': publicFacingClinicName,
        'primary_location': primaryLocation,
        'additional_locations': additionalLocations,
        'primary_service_area': primaryServiceArea,
        'website': website,
        'primary_contact_name': primaryContactName,
        'email_address': emailAddress,
        'phone_number': phoneNumber,
        'representative_name': representativeName,
        'title': title,
        'electronic_signature': electronicSignature,
        'date': signatureDate,
        'authorized_to_submit': authorizedToSubmit,
        'city': city,
        'state': state,
        'zip_code': zipCode,
        'current_emr': currentEmr,
        'number_of_providers': numberOfProviders,
        'specialty': specialty,
        'instagram_handle': instagramHandle,
        'facebook_page': facebookPage,
        'founder_reason': founderReason,
      };

  InviteClinicDetailData toInviteClinicDetail() {
    return InviteClinicDetailData(
      clinicId: id,
      name: clinicName,
      email: email,
      phone: phone,
      address: address,
      ownerName: contactName,
      website: website,
      notes: founderReason,
      status: status,
    );
  }
}
