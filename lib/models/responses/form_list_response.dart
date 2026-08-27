import 'package:skinsync_admin/models/form_model.dart';
import 'package:skinsync_admin/models/responses/base_response_model.dart';

class FormListResponse extends BaseApiResponseModel<List<FormModel>> {
  FormListResponse({
    required super.isSuccess,
    required super.message,
    super.data,
  });

  factory FormListResponse.fromJson(Map<String, dynamic> json) {
    return FormListResponse(
      isSuccess: json['is_success'] as bool? ?? false,
      message: json['message'] as String? ?? '',
      data: json['data'] != null
          ? (json['data'] as List)
              .map((e) => FormModel.fromJson(e as Map<String, dynamic>))
              .toList()
          : null,
    );
  }
}
