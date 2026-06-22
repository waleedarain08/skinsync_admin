import 'base_response_model.dart';

class UsageTypeListResponse extends BaseApiResponseModel<List<UsageTypeModel>> {
  const UsageTypeListResponse({
    required super.isSuccess,
    required super.message,
    super.data,
  });

  factory UsageTypeListResponse.fromJson(Map<String, dynamic> json) {
    return UsageTypeListResponse(
      isSuccess: json['status'] as bool? ?? false,
      message: json['message'] ?? '',
      data: json['data'] == null
          ? null
          : (json['data'] as List)
          .map((e) => UsageTypeModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}

class UsageTypeModel {
  final int id;
  final String name;

  const UsageTypeModel({
    required this.id,
    required this.name,
  });

  factory UsageTypeModel.fromJson(Map<String, dynamic> json) {
    return UsageTypeModel(
      id: json['id'] as int? ?? 0,
      name: json['name'] ?? '',
    );
  }

}