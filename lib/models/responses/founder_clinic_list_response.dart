import 'dart:convert';
import 'package:skinsync_admin/models/responses/base_response_model.dart';

import '../founder_clinic_model.dart';

class FounderClinicListResponse
    extends BaseApiResponseModel<List<FounderClinicModel>> {
  final int? totalPages;
  final int? currentPage;
  final int? totalItems;

  FounderClinicListResponse({
    required super.isSuccess,
    required super.message,
    super.data,
    this.totalPages,
    this.currentPage,
    this.totalItems,
  });

  factory FounderClinicListResponse.fromRawJson(String str) =>
      FounderClinicListResponse.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory FounderClinicListResponse.fromJson(Map<String, dynamic> json) =>
      FounderClinicListResponse(
        isSuccess: json['is_success'],
        message: json['message'],
        data:
            json['data'] == null || json['data']['items'] == null
                ? null
                : List<FounderClinicModel>.from(
                  (json['data']['items'] as List).map(
                    (x) =>
                        FounderClinicModel.fromJson(x as Map<String, dynamic>),
                  ),
                ),
        totalPages: json['data']?['total_pages'],
        currentPage: json['data']?['page'],
        totalItems: json['data']?['total'],
      );

  Map<String, dynamic> toJson() => {
    'is_success': isSuccess,
    'message': message,
    'data': {
      'items':
          data == null
              ? null
              : List<dynamic>.from(data!.map((x) => x.toJson())),
      'total_pages': totalPages,
      'page': currentPage,
      'total': totalItems,
    },
  };
}
