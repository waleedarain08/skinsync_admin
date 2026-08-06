import 'dart:convert';
import '../founder_clinic_model.dart';

class FounderClinicDetailResponse {
  final bool? isSuccess;
  final String? message;
  final FounderClinicModel? data;

  FounderClinicDetailResponse({
    this.isSuccess,
    this.message,
    this.data,
  });

  factory FounderClinicDetailResponse.fromRawJson(String str) =>
      FounderClinicDetailResponse.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory FounderClinicDetailResponse.fromJson(Map<String, dynamic> json) => FounderClinicDetailResponse(
    isSuccess: json['is_success'],
    message: json['message'],
    data: json['data'] == null ? null : FounderClinicModel.fromJson(json['data'] as Map<String, dynamic>),
  );

  Map<String, dynamic> toJson() => {
    'is_success': isSuccess,
    'message': message,
    'data': data?.toJson(),
  };
}
