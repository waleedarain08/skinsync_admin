import 'package:skinsync_admin/models/treatment_model.dart';

import 'base_response_model.dart';

class TreatmentListResponse extends BaseApiResponseModel<List<TreatmentListData>> {
  final int? page;
  final int? limit;
  final int? totalPages;

  const TreatmentListResponse({
    required super.isSuccess,
    required super.message,
    super.data,
    this.page,
    this.limit,
    this.totalPages,
  });

  factory TreatmentListResponse.fromJson(Map<String, dynamic> json) {
    final bool success = (json['is_success'] as bool?) ?? (json['status'] as bool?) ?? false;
    return TreatmentListResponse(
      isSuccess: success,
      message: json['message'] ?? '',
      page: json['page'] as int?,
      limit: json['limit'] as int?,
      totalPages: json['total_pages'] as int? ?? json['totalPages'] as int?,
      data: json['data'] == null
          ? null
          : (json['data'] as List)
              .map((e) => TreatmentListData.fromJson(e as Map<String, dynamic>))
              .toList(),
    );
  }

 
}

// class TreatmentListData {
//   final int? id;
//   final String? name;
//   final String? shortDescription;
//   final String? globalSku;
//   final String? icon;
//   final String? image;
//   final String? status;

//   TreatmentListData({
//     this.id,
//     this.name,
//     this.shortDescription,
//     this.globalSku,
//     this.icon,
//     this.image,
//     this.status,
//   });

//   factory TreatmentListData.fromJson(Map<String, dynamic> json) {
//     return TreatmentListData(
//       id: json['id'] as int?,
//       name: json['patient_display_name'],
//       shortDescription: json['short_description'] ?? json['shortDescription'],
//       globalSku: json['global_sku'] ?? json['globalSku'],
//       icon: json['icon'],
//       image: json['image'],
//       status: json['status'],
//     );
//   }

//   Map<String, dynamic> toJson() => {
//         'id': id,
//         'name': name,
//         'short_description': shortDescription,
//         'global_sku': globalSku,
//         'icon': icon,
//         'image': image,
//         'status': status,
//       };
// }
