import 'dart:convert';
import '../founder_clinic_model.dart';

class FounderClinicListResponse {
  final bool? isSuccess;
  final String? message;
  final List<FounderClinicModel>? data;
  final int? totalPages;
  final int? currentPage;

  FounderClinicListResponse({
    this.isSuccess,
    this.message,
    this.data,
    this.totalPages,
    this.currentPage,
  });

  factory FounderClinicListResponse.fromRawJson(String str) =>
      FounderClinicListResponse.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory FounderClinicListResponse.fromJson(Map<String, dynamic> json) => FounderClinicListResponse(
    isSuccess: json['is_success'],
    message: json['message'],
    data: json['data'] == null
        ? null
        : List<FounderClinicModel>.from((json['data'] as List).map((x) => FounderClinicModel.fromJson(x as Map<String, dynamic>))),
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
