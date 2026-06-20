import 'dart:convert';
import 'package:skinsync_admin/models/responses/base_response_model.dart';

class ClinicResponse extends BaseApiResponseModel<ClinicModel> {
  const ClinicResponse({
    required super.isSuccess,
    required super.message,
    super.data,
  });

  factory ClinicResponse.fromJson(Map<String, dynamic> json) =>
      ClinicResponse(
        isSuccess: (json['is_success'] as bool?) ?? (json['is_success'] as bool?) ?? false,
        message: json['message'] ?? '',
        data: json['data'] == null
            ? null
            : ClinicModel.fromJson(json['data'] as Map<String, dynamic>),
      );

  Map<String, dynamic> toJson() => {
        'is_success': isSuccess,
        'message': message,
        'data': data?.toJson(),
      };
}

class ClinicModel {
  final int? id;
  final String? name;
  final String? email;
  final String? phone;
  final String? address;
  final String? logo;
  final String? description;
  final String? workingHours;
  final String? status; // Active/Inactive
  final String? subscriptionPlan;
  final int? totalTreatments;
  final int? totalAppointments;
  final double? totalRevenue;
  final double? rating;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  ClinicModel({
    this.id,
    this.name,
    this.email,
    this.phone,
    this.address,
    this.logo,
    this.description,
    this.workingHours,
    this.status,
    this.subscriptionPlan,
    this.totalTreatments,
    this.totalAppointments,
    this.totalRevenue,
    this.rating,
    this.createdAt,
    this.updatedAt,
  });

  factory ClinicModel.fromRawJson(String str) =>
      ClinicModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ClinicModel.fromJson(Map<String, dynamic> json) => ClinicModel(
    id: json["id"],
    name: json["name"],
    email: json["email"],
    phone: json["phone"],
    address: json["address"],
    logo: json["logo"],
    description: json["description"],
    workingHours: json["working_hours"],
    status: json["status"],
    subscriptionPlan: json["subscription_plan"],
    totalTreatments: json["total_treatments"],
    totalAppointments: json["total_appointments"],
    totalRevenue: (json["total_revenue"] as num?)?.toDouble(),
    rating: (json["rating"] as num?)?.toDouble(),
    createdAt: json["created_at"] == null
        ? null
        : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null
        ? null
        : DateTime.parse(json["updated_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "email": email,
    "phone": phone,
    "address": address,
    "logo": logo,
    "description": description,
    "working_hours": workingHours,
    "status": status,
    "subscription_plan": subscriptionPlan,
    "total_treatments": totalTreatments,
    "total_appointments": totalAppointments,
    "total_revenue": totalRevenue,
    "rating": rating,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
  };
}