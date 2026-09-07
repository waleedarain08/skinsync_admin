import 'package:skinsync_admin/models/responses/base_response_model.dart';
import 'package:skinsync_admin/models/treatment_data_models.dart';

class ProtocolFieldsResponse extends BaseApiResponseModel<List<ProtocolItem>> {
  final int? totalPages;

  ProtocolFieldsResponse({
    super.data,
    required super.isSuccess,
    required super.message,
    this.totalPages,
  });

  factory ProtocolFieldsResponse.fromJson(Map<String, dynamic> json) =>
      ProtocolFieldsResponse(
        data: json['data'] == null
            ? <ProtocolItem>[]
            : List<ProtocolItem>.from(
                (json['data'] as List).map((x) => ProtocolItem.fromJson(x)),
              ),
        isSuccess: json['is_success'] ?? false,
        message: json['message'] ?? '',
        totalPages: json['total_pages'],
      );

  Map<String, dynamic> toJson() => {
    'data': data == null
        ? <dynamic>[]
        : List<dynamic>.from(data!.map((x) => x.toJson())),
    'is_success': isSuccess,
    'message': message,
    'total_pages': totalPages,
  };
}
