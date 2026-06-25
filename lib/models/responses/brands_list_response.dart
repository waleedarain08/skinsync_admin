import 'base_response_model.dart';

class BrandListResponse extends BaseApiResponseModel<List<BrandModel>> {
  const BrandListResponse({
    required super.isSuccess,
    required super.message,
    super.data,
  });

  factory BrandListResponse.fromJson(Map<String, dynamic> json) {
    return BrandListResponse(
      isSuccess: json['is_success'] as bool? ?? false,
      message: json['message'] ?? '',
      data: json['data'] == null
          ? null
          : (json['data'] as List)
          .map((e) => BrandModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}

class BrandModel {
  final int id;
  final String name;

  const BrandModel({
    required this.id,
    required this.name,
  });

  factory BrandModel.fromJson(Map<String, dynamic> json) {
    return BrandModel(
      id: json['id'] as int? ?? 0,
      name: json['name'] ?? '',
    );
  }

}