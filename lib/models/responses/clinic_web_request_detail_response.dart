import 'dart:convert';
import '../clinic_web_request_model.dart';

class ClinicWebRequestDetailResponse {
  final bool? isSuccess;
  final String? message;
  final ClinicWebRequestModel? data;

  ClinicWebRequestDetailResponse({
    this.isSuccess,
    this.message,
    this.data,
  });

  factory ClinicWebRequestDetailResponse.fromRawJson(String str) =>
      ClinicWebRequestDetailResponse.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ClinicWebRequestDetailResponse.fromJson(Map<String, dynamic> json) => ClinicWebRequestDetailResponse(
    isSuccess: json['is_success'],
    message: json['message'],
    data: json['data'] == null ? null : ClinicWebRequestModel.fromJson(json['data'] as Map<String, dynamic>),
  );

  Map<String, dynamic> toJson() => {
    'is_success': isSuccess,
    'message': message,
    'data': data?.toJson(),
  };
}
