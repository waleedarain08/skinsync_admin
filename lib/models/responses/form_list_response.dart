import 'package:skinsync_admin/models/form_model.dart';
import 'package:skinsync_admin/models/responses/base_response_model.dart';

class FormListResponse extends BaseApiResponseModel<List<FormModel>> {
  final int totalPages;

  FormListResponse({
    required super.isSuccess,
    required super.message,
    super.data,
    required this.totalPages,
  });

  factory FormListResponse.fromJson(Map<String, dynamic> json) {
    final rawData = json['data'];
    List<FormModel>? listData;
    if (rawData is List) {
      listData = rawData
          .map((e) => FormModel.fromJson(e as Map<String, dynamic>))
          .toList();
    } else if (rawData is Map<String, dynamic>) {
      listData = [FormModel.fromJson(rawData)];
    }

    return FormListResponse(
      isSuccess: (json['is_success'] as bool?) ?? false,
      message: json['message'] ?? '',
      data: listData,
      totalPages: json['total_pages'] ?? 1,
    );
  }

  Map<String, dynamic> toJson() => {
    'is_success': isSuccess,
    'message': message,
    'data': data?.map((e) => e.toJson()).toList(),
    'total_pages': totalPages,
  };
}
