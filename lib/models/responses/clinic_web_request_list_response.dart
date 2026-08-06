import 'dart:convert';
import '../clinic_web_request_model.dart';

class ClinicWebRequestListResponse {
  final bool? isSuccess;
  final String? message;
  final List<ClinicWebRequestModel>? data;
  final int? totalPages;
  final int? currentPage;
  final int? limit;
  final int? total;

  ClinicWebRequestListResponse({
    this.isSuccess,
    this.message,
    this.data,
    this.totalPages,
    this.currentPage,
    this.limit,
    this.total,
  });

  factory ClinicWebRequestListResponse.fromRawJson(String str) =>
      ClinicWebRequestListResponse.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ClinicWebRequestListResponse.fromJson(Map<String, dynamic> json) {
    final dataObj = json['data'];
    if (dataObj is Map<String, dynamic>) {
      return ClinicWebRequestListResponse(
        isSuccess: json['is_success'],
        message: json['message'],
        data: dataObj['items'] == null
            ? null
            : List<ClinicWebRequestModel>.from((dataObj['items'] as List).map((x) => ClinicWebRequestModel.fromJson(x as Map<String, dynamic>))),
        totalPages: dataObj['total_pages'],
        currentPage: dataObj['page'],
        limit: dataObj['limit'],
        total: dataObj['total'],
      );
    }
    return ClinicWebRequestListResponse(
      isSuccess: json['is_success'],
      message: json['message'],
      data: [],
    );
  }

  Map<String, dynamic> toJson() => {
    'is_success': isSuccess,
    'message': message,
    'data': {
      'items': data == null ? null : List<dynamic>.from(data!.map((x) => x.toJson())),
      'total_pages': totalPages,
      'page': currentPage,
      'limit': limit,
      'total': total,
    },
  };
}
