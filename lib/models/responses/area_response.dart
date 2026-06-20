import 'package:skinsync_admin/models/responses/area_list_response.dart';

import 'base_response_model.dart';

class AreaResponse extends BaseApiResponseModel<AreaModel> {
  const AreaResponse({
    required super.isSuccess,
    required super.message,
    super.data,
  });

  factory AreaResponse.fromJson(Map<String, dynamic> json) =>
      AreaResponse(
        isSuccess: (json['is_success'] as bool?) ?? false,
        message: json['message'] ?? '',
        data: json['data'] == null
            ? null
            : AreaModel.fromJson(json['data'] as Map<String, dynamic>),
      );

 
}

