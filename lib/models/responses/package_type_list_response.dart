import 'base_response_model.dart';

class PackageTypeListResponse extends BaseApiResponseModel<List<PackageTypeModel>> {
  const PackageTypeListResponse({
    required super.isSuccess,
    required super.message,
    super.data,
  });

  factory PackageTypeListResponse.fromJson(Map<String, dynamic> json) {
    return PackageTypeListResponse(
      isSuccess: json['is_success'] as bool? ?? false,
      message: json['message'] ?? '',
      data: json['data'] == null
          ? null
          : (json['data'] as List)
          .map((e) => PackageTypeModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}

class PackageTypeModel {
  final int id;
  final String name;

  const PackageTypeModel({
    required this.id,
    required this.name,
  });

  factory PackageTypeModel.fromJson(Map<String, dynamic> json) {
    return PackageTypeModel(
      id: json['id'] as int? ?? 0,
      name: json['name'] ?? '',
    );
  }

}