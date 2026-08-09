import 'dart:convert';
import 'package:skinsync_admin/models/responses/base_response_model.dart';

import '../founder_clinic_model.dart';

class FounderClinicListResponse
    extends BaseApiResponseModel<List<FounderClinicModel>> {
  final int? totalPages;
  final int? currentPage;

  FounderClinicListResponse({
    required super.isSuccess,
    required super.message,
    super.data,
    this.totalPages,
    this.currentPage,
  });

  factory FounderClinicListResponse.fromRawJson(String str) =>
      FounderClinicListResponse.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory FounderClinicListResponse.fromJson(Map<String, dynamic> json) =>
      FounderClinicListResponse(
        isSuccess: json['is_success'],
        message: json['message'],
        data: json['data'] == null
            ? null
            : List<FounderClinicModel>.from(
                (json['data'] as List).map(
                  (x) => FounderClinicModel.fromJson(x as Map<String, dynamic>),
                ),
              ),
        totalPages: json['total_pages'],
        currentPage: json['current_page'],
      );

  Map<String, dynamic> toJson() => {
    'is_success': isSuccess,
    'message': message,
    'data': data == null
        ? null
        : List<dynamic>.from(data!.map((x) => x.toJson())),
    'total_pages': totalPages,
    'current_page': currentPage,
  };
}
