import 'base_response_model.dart';

class ManufacturersListResponse extends BaseApiResponseModel<List<ManufacturersModel>> {
  const ManufacturersListResponse({
    required super.isSuccess,
    required super.message,
    super.data,
  });

  factory ManufacturersListResponse.fromJson(Map<String, dynamic> json) {
    return ManufacturersListResponse(
      isSuccess: json['is_success'] as bool? ?? false,
      message: json['message'] ?? '',
      data: json['data'] == null
          ? null
          : (json['data'] as List)
          .map((e) => ManufacturersModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}

class ManufacturersModel {
  final int id;
  final String name;

  const ManufacturersModel({
    required this.id,
    required this.name,
  });

  factory ManufacturersModel.fromJson(Map<String, dynamic> json) {
    return ManufacturersModel(
      id: json['id'] as int? ?? 0,
      name: json['name'] ?? '',
    );
  }

}