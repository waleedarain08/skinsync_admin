import 'dart:convert';
import '../clinic_web_request_model.dart';

class ClinicWebRequestListResponse {
  final bool? isSuccess;
  final String? message;
  final List<ClinicWebRequestModel>? data;
  final int? totalPages;
  final int? currentPage;

  ClinicWebRequestListResponse({
    this.isSuccess,
    this.message,
    this.data,
    this.totalPages,
    this.currentPage,
  });

  factory ClinicWebRequestListResponse.fromRawJson(String str) =>
      ClinicWebRequestListResponse.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ClinicWebRequestListResponse.fromJson(Map<String, dynamic> json) => ClinicWebRequestListResponse(
    isSuccess: json['is_success'],
    message: json['message'],
    data: json['data'] == null
        ? null
        : List<ClinicWebRequestModel>.from((json['data'] as List).map((x) => ClinicWebRequestModel.fromJson(x))),
    totalPages: json['total_pages'],
    currentPage: json['current_page'],
  );

  Map<String, dynamic> toJson() => {
    'is_success': isSuccess,
    'message': message,
    'data': data == null ? null : List<dynamic>.from(data!.map((x) => x.toJson())),
    'total_pages': totalPages,
    'current_page': currentPage,
  };
}
